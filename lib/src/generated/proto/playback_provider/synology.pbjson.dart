// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/synology.proto.

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

@$core.Deprecated('Use getSynologyResourceRequestDescriptor instead')
const GetSynologyResourceRequest$json = {
  '1': 'GetSynologyResourceRequest',
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

/// Descriptor for `GetSynologyResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSynologyResourceRequestDescriptor = $convert.base64Decode(
    'ChpHZXRTeW5vbG9neVJlc291cmNlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUg'
    'd2ZXJzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSHwoLbWVkaWFf'
    'aW5kZXgYAyABKA1SCm1lZGlhSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaWcSGQoDdW'
    'lkGAUgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQSEAoDZXhw'
    'GAcgASgDUgNleHASGQoFcmFuZ2UYCCABKAlIAFIFcmFuZ2WIAQESEgoEaGVhZBgJIAEoCFIEaG'
    'VhZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use synologyResourceResponseDescriptor instead')
const SynologyResourceResponse$json = {
  '1': 'SynologyResourceResponse',
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

/// Descriptor for `SynologyResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyResourceResponseDescriptor =
    $convert.base64Decode(
        'ChhTeW5vbG9neVJlc291cmNlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheW'
        'JhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getSynologySegmentRequestDescriptor instead')
const GetSynologySegmentRequest$json = {
  '1': 'GetSynologySegmentRequest',
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

/// Descriptor for `GetSynologySegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSynologySegmentRequestDescriptor = $convert.base64Decode(
    'ChlHZXRTeW5vbG9neVNlZ21lbnRSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJgoKdGFyZ2V0X3VybBgCIAEoCUIHukgEcgIQAVIJdGFyZ2V0VXJsEhkKA3NpZxgD'
    'IAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgEIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgFIA'
    'EoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgGIAEoA1IDZXhwEhkKBXJhbmdlGAcgASgJSABSBXJh'
    'bmdliAEBEhIKBGhlYWQYCCABKAhSBGhlYWRCCAoGX3Jhbmdl');

@$core.Deprecated('Use synologySegmentResponseDescriptor instead')
const SynologySegmentResponse$json = {
  '1': 'SynologySegmentResponse',
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

/// Descriptor for `SynologySegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologySegmentResponseDescriptor =
    $convert.base64Decode(
        'ChdTeW5vbG9neVNlZ21lbnRSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getSynologySubtitleRequestDescriptor instead')
const GetSynologySubtitleRequest$json = {
  '1': 'GetSynologySubtitleRequest',
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

/// Descriptor for `GetSynologySubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSynologySubtitleRequestDescriptor = $convert.base64Decode(
    'ChpHZXRTeW5vbG9neVN1YnRpdGxlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUg'
    'd2ZXJzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSJQoOc3VidGl0'
    'bGVfaW5kZXgYAyABKA1SDXN1YnRpdGxlSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaW'
    'cSGQoDdWlkGAUgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQS'
    'EAoDZXhwGAcgASgDUgNleHA=');

@$core.Deprecated('Use synologySubtitleResponseDescriptor instead')
const SynologySubtitleResponse$json = {
  '1': 'SynologySubtitleResponse',
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

/// Descriptor for `SynologySubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologySubtitleResponseDescriptor =
    $convert.base64Decode(
        'ChhTeW5vbG9neVN1YnRpdGxlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheW'
        'JhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

const $core.Map<$core.String, $core.dynamic>
    SynologyPlaybackProviderServiceBase$json = {
  '1': 'SynologyPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.synology.GetSynologyResourceRequest',
      '3': '.synctv.playback_provider.synology.SynologyResourceResponse',
      '6': true
    },
    {
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.synology.GetSynologySegmentRequest',
      '3': '.synctv.playback_provider.synology.SynologySegmentResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.synology.GetSynologySubtitleRequest',
      '3': '.synctv.playback_provider.synology.SynologySubtitleResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use synologyPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SynologyPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.synology.GetSynologyResourceRequest':
      GetSynologyResourceRequest$json,
  '.synctv.playback_provider.synology.SynologyResourceResponse':
      SynologyResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.synology.GetSynologySegmentRequest':
      GetSynologySegmentRequest$json,
  '.synctv.playback_provider.synology.SynologySegmentResponse':
      SynologySegmentResponse$json,
  '.synctv.playback_provider.synology.GetSynologySubtitleRequest':
      GetSynologySubtitleRequest$json,
  '.synctv.playback_provider.synology.SynologySubtitleResponse':
      SynologySubtitleResponse$json,
};

/// Descriptor for `SynologyPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List synologyPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'Ch9TeW5vbG9neVBsYXliYWNrUHJvdmlkZXJTZXJ2aWNlEosBCgtHZXRSZXNvdXJjZRI9LnN5bm'
    'N0di5wbGF5YmFja19wcm92aWRlci5zeW5vbG9neS5HZXRTeW5vbG9neVJlc291cmNlUmVxdWVz'
    'dBo7LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5zeW5vbG9neS5TeW5vbG9neVJlc291cmNlUm'
    'VzcG9uc2UwARKIAQoKR2V0U2VnbWVudBI8LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5zeW5v'
    'bG9neS5HZXRTeW5vbG9neVNlZ21lbnRSZXF1ZXN0Gjouc3luY3R2LnBsYXliYWNrX3Byb3ZpZG'
    'VyLnN5bm9sb2d5LlN5bm9sb2d5U2VnbWVudFJlc3BvbnNlMAESiwEKC0dldFN1YnRpdGxlEj0u'
    'c3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnN5bm9sb2d5LkdldFN5bm9sb2d5U3VidGl0bGVSZX'
    'F1ZXN0Gjsuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnN5bm9sb2d5LlN5bm9sb2d5U3VidGl0'
    'bGVSZXNwb25zZTAB');
