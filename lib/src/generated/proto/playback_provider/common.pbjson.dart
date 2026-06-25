// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/common.proto.

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

@$core.Deprecated('Use streamChunkDescriptor instead')
const StreamChunk$json = {
  '1': 'StreamChunk',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'status', '3': 2, '4': 1, '5': 13, '10': 'status'},
    {
      '1': 'content_type',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'contentType',
      '17': true
    },
    {
      '1': 'content_length',
      '3': 4,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'contentLength',
      '17': true
    },
    {
      '1': 'content_range',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'contentRange',
      '17': true
    },
    {
      '1': 'accept_ranges',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'acceptRanges',
      '17': true
    },
    {
      '1': 'cache_control',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'cacheControl',
      '17': true
    },
    {'1': 'etag', '3': 8, '4': 1, '5': 9, '9': 5, '10': 'etag', '17': true},
    {
      '1': 'last_modified',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'lastModified',
      '17': true
    },
    {
      '1': 'expires',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 7,
      '10': 'expires',
      '17': true
    },
    {
      '1': 'content_disposition',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 8,
      '10': 'contentDisposition',
      '17': true
    },
    {
      '1': 'location',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 9,
      '10': 'location',
      '17': true
    },
  ],
  '8': [
    {'1': '_content_type'},
    {'1': '_content_length'},
    {'1': '_content_range'},
    {'1': '_accept_ranges'},
    {'1': '_cache_control'},
    {'1': '_etag'},
    {'1': '_last_modified'},
    {'1': '_expires'},
    {'1': '_content_disposition'},
    {'1': '_location'},
  ],
};

/// Descriptor for `StreamChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamChunkDescriptor = $convert.base64Decode(
    'CgtTdHJlYW1DaHVuaxISCgRkYXRhGAEgASgMUgRkYXRhEhYKBnN0YXR1cxgCIAEoDVIGc3RhdH'
    'VzEiYKDGNvbnRlbnRfdHlwZRgDIAEoCUgAUgtjb250ZW50VHlwZYgBARIqCg5jb250ZW50X2xl'
    'bmd0aBgEIAEoBEgBUg1jb250ZW50TGVuZ3RoiAEBEigKDWNvbnRlbnRfcmFuZ2UYBSABKAlIAl'
    'IMY29udGVudFJhbmdliAEBEigKDWFjY2VwdF9yYW5nZXMYBiABKAlIA1IMYWNjZXB0UmFuZ2Vz'
    'iAEBEigKDWNhY2hlX2NvbnRyb2wYByABKAlIBFIMY2FjaGVDb250cm9siAEBEhcKBGV0YWcYCC'
    'ABKAlIBVIEZXRhZ4gBARIoCg1sYXN0X21vZGlmaWVkGAkgASgJSAZSDGxhc3RNb2RpZmllZIgB'
    'ARIdCgdleHBpcmVzGAogASgJSAdSB2V4cGlyZXOIAQESNAoTY29udGVudF9kaXNwb3NpdGlvbh'
    'gLIAEoCUgIUhJjb250ZW50RGlzcG9zaXRpb26IAQESHwoIbG9jYXRpb24YDCABKAlICVIIbG9j'
    'YXRpb26IAQFCDwoNX2NvbnRlbnRfdHlwZUIRCg9fY29udGVudF9sZW5ndGhCEAoOX2NvbnRlbn'
    'RfcmFuZ2VCEAoOX2FjY2VwdF9yYW5nZXNCEAoOX2NhY2hlX2NvbnRyb2xCBwoFX2V0YWdCEAoO'
    'X2xhc3RfbW9kaWZpZWRCCgoIX2V4cGlyZXNCFgoUX2NvbnRlbnRfZGlzcG9zaXRpb25CCwoJX2'
    'xvY2F0aW9u');
