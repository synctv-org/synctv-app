// This is a generated file - do not edit.
//
// Generated from proto/providers/bilibili.proto.

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

@$core.Deprecated('Use playlistListModeDescriptor instead')
const PlaylistListMode$json = {
  '1': 'PlaylistListMode',
  '2': [
    {'1': 'PLAYLIST_LIST_MODE_POPULAR', '2': 0},
    {'1': 'PLAYLIST_LIST_MODE_RECOMMENDED', '2': 1},
    {'1': 'PLAYLIST_LIST_MODE_VIDEO_PARTS', '2': 2},
    {'1': 'PLAYLIST_LIST_MODE_UP_VIDEOS', '2': 3},
    {'1': 'PLAYLIST_LIST_MODE_FAVORITE_VIDEOS', '2': 4},
    {'1': 'PLAYLIST_LIST_MODE_COLLECTION_VIDEOS', '2': 5},
    {'1': 'PLAYLIST_LIST_MODE_SERIES_VIDEOS', '2': 6},
    {'1': 'PLAYLIST_LIST_MODE_WATCH_LATER', '2': 7},
    {'1': 'PLAYLIST_LIST_MODE_PGC_SEASON', '2': 8},
    {'1': 'PLAYLIST_LIST_MODE_LIVE_RECOMMENDED', '2': 9},
    {'1': 'PLAYLIST_LIST_MODE_LIVE_FOLLOWED', '2': 10},
    {'1': 'PLAYLIST_LIST_MODE_LIVE_AREA', '2': 11},
    {'1': 'PLAYLIST_LIST_MODE_HISTORY', '2': 12},
    {'1': 'PLAYLIST_LIST_MODE_PGC_TIMELINE', '2': 13},
  ],
};

/// Descriptor for `PlaylistListMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playlistListModeDescriptor = $convert.base64Decode(
    'ChBQbGF5bGlzdExpc3RNb2RlEh4KGlBMQVlMSVNUX0xJU1RfTU9ERV9QT1BVTEFSEAASIgoeUE'
    'xBWUxJU1RfTElTVF9NT0RFX1JFQ09NTUVOREVEEAESIgoeUExBWUxJU1RfTElTVF9NT0RFX1ZJ'
    'REVPX1BBUlRTEAISIAocUExBWUxJU1RfTElTVF9NT0RFX1VQX1ZJREVPUxADEiYKIlBMQVlMSV'
    'NUX0xJU1RfTU9ERV9GQVZPUklURV9WSURFT1MQBBIoCiRQTEFZTElTVF9MSVNUX01PREVfQ09M'
    'TEVDVElPTl9WSURFT1MQBRIkCiBQTEFZTElTVF9MSVNUX01PREVfU0VSSUVTX1ZJREVPUxAGEi'
    'IKHlBMQVlMSVNUX0xJU1RfTU9ERV9XQVRDSF9MQVRFUhAHEiEKHVBMQVlMSVNUX0xJU1RfTU9E'
    'RV9QR0NfU0VBU09OEAgSJwojUExBWUxJU1RfTElTVF9NT0RFX0xJVkVfUkVDT01NRU5ERUQQCR'
    'IkCiBQTEFZTElTVF9MSVNUX01PREVfTElWRV9GT0xMT1dFRBAKEiAKHFBMQVlMSVNUX0xJU1Rf'
    'TU9ERV9MSVZFX0FSRUEQCxIeChpQTEFZTElTVF9MSVNUX01PREVfSElTVE9SWRAMEiMKH1BMQV'
    'lMSVNUX0xJU1RfTU9ERV9QR0NfVElNRUxJTkUQDQ==');

@$core.Deprecated('Use pgcFollowTypeDescriptor instead')
const PgcFollowType$json = {
  '1': 'PgcFollowType',
  '2': [
    {'1': 'PGC_FOLLOW_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PGC_FOLLOW_TYPE_ANIME', '2': 1},
    {'1': 'PGC_FOLLOW_TYPE_CINEMA', '2': 2},
  ],
};

/// Descriptor for `PgcFollowType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pgcFollowTypeDescriptor = $convert.base64Decode(
    'Cg1QZ2NGb2xsb3dUeXBlEh8KG1BHQ19GT0xMT1dfVFlQRV9VTlNQRUNJRklFRBAAEhkKFVBHQ1'
    '9GT0xMT1dfVFlQRV9BTklNRRABEhoKFlBHQ19GT0xMT1dfVFlQRV9DSU5FTUEQAg==');

@$core.Deprecated('Use pgcSeasonTypeDescriptor instead')
const PgcSeasonType$json = {
  '1': 'PgcSeasonType',
  '2': [
    {'1': 'PGC_SEASON_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PGC_SEASON_TYPE_ANIME', '2': 1},
    {'1': 'PGC_SEASON_TYPE_MOVIE', '2': 2},
    {'1': 'PGC_SEASON_TYPE_DOCUMENTARY', '2': 3},
    {'1': 'PGC_SEASON_TYPE_GUOCHUANG', '2': 4},
    {'1': 'PGC_SEASON_TYPE_TV', '2': 5},
    {'1': 'PGC_SEASON_TYPE_VARIETY', '2': 7},
  ],
};

/// Descriptor for `PgcSeasonType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pgcSeasonTypeDescriptor = $convert.base64Decode(
    'Cg1QZ2NTZWFzb25UeXBlEh8KG1BHQ19TRUFTT05fVFlQRV9VTlNQRUNJRklFRBAAEhkKFVBHQ1'
    '9TRUFTT05fVFlQRV9BTklNRRABEhkKFVBHQ19TRUFTT05fVFlQRV9NT1ZJRRACEh8KG1BHQ19T'
    'RUFTT05fVFlQRV9ET0NVTUVOVEFSWRADEh0KGVBHQ19TRUFTT05fVFlQRV9HVU9DSFVBTkcQBB'
    'IWChJQR0NfU0VBU09OX1RZUEVfVFYQBRIbChdQR0NfU0VBU09OX1RZUEVfVkFSSUVUWRAH');

@$core.Deprecated('Use pgcSeasonOrderDescriptor instead')
const PgcSeasonOrder$json = {
  '1': 'PgcSeasonOrder',
  '2': [
    {'1': 'PGC_SEASON_ORDER_UPDATED', '2': 0},
    {'1': 'PGC_SEASON_ORDER_DANMAKU', '2': 1},
    {'1': 'PGC_SEASON_ORDER_PLAY', '2': 2},
    {'1': 'PGC_SEASON_ORDER_FOLLOW', '2': 3},
    {'1': 'PGC_SEASON_ORDER_SCORE', '2': 4},
    {'1': 'PGC_SEASON_ORDER_STARTED', '2': 5},
    {'1': 'PGC_SEASON_ORDER_RELEASED', '2': 6},
  ],
};

/// Descriptor for `PgcSeasonOrder`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pgcSeasonOrderDescriptor = $convert.base64Decode(
    'Cg5QZ2NTZWFzb25PcmRlchIcChhQR0NfU0VBU09OX09SREVSX1VQREFURUQQABIcChhQR0NfU0'
    'VBU09OX09SREVSX0RBTk1BS1UQARIZChVQR0NfU0VBU09OX09SREVSX1BMQVkQAhIbChdQR0Nf'
    'U0VBU09OX09SREVSX0ZPTExPVxADEhoKFlBHQ19TRUFTT05fT1JERVJfU0NPUkUQBBIcChhQR0'
    'NfU0VBU09OX09SREVSX1NUQVJURUQQBRIdChlQR0NfU0VBU09OX09SREVSX1JFTEVBU0VEEAY=');

@$core.Deprecated('Use qRLoginStatusDescriptor instead')
const QRLoginStatus$json = {
  '1': 'QRLoginStatus',
  '2': [
    {'1': 'QR_LOGIN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'QR_LOGIN_STATUS_EXPIRED', '2': 1},
    {'1': 'QR_LOGIN_STATUS_NOT_SCANNED', '2': 2},
    {'1': 'QR_LOGIN_STATUS_SCANNED', '2': 3},
    {'1': 'QR_LOGIN_STATUS_SUCCESS', '2': 4},
  ],
};

/// Descriptor for `QRLoginStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List qRLoginStatusDescriptor = $convert.base64Decode(
    'Cg1RUkxvZ2luU3RhdHVzEh8KG1FSX0xPR0lOX1NUQVRVU19VTlNQRUNJRklFRBAAEhsKF1FSX0'
    'xPR0lOX1NUQVRVU19FWFBJUkVEEAESHwobUVJfTE9HSU5fU1RBVFVTX05PVF9TQ0FOTkVEEAIS'
    'GwoXUVJfTE9HSU5fU1RBVFVTX1NDQU5ORUQQAxIbChdRUl9MT0dJTl9TVEFUVVNfU1VDQ0VTUx'
    'AE');

@$core.Deprecated('Use parseRequestDescriptor instead')
const ParseRequest$json = {
  '1': 'ParseRequest',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'url'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 3, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `ParseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parseRequestDescriptor = $convert.base64Decode(
    'CgxQYXJzZVJlcXVlc3QSGQoDdXJsGAEgASgJQge6SARyAhABUgN1cmwSIwoNaW5zdGFuY2Vfbm'
    'FtZRgCIAEoCVIMaW5zdGFuY2VOYW1lEhYKBnNoYXJlZBgDIAEoCFIGc2hhcmVk');

@$core.Deprecated('Use parseResponseDescriptor instead')
const ParseResponse$json = {
  '1': 'ParseResponse',
  '2': [
    {'1': 'normalized_url', '3': 1, '4': 1, '5': 9, '10': 'normalizedUrl'},
    {
      '1': 'candidates',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.ParseCandidate',
      '10': 'candidates'
    },
  ],
};

/// Descriptor for `ParseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parseResponseDescriptor = $convert.base64Decode(
    'Cg1QYXJzZVJlc3BvbnNlEiUKDm5vcm1hbGl6ZWRfdXJsGAEgASgJUg1ub3JtYWxpemVkVXJsEk'
    'gKCmNhbmRpZGF0ZXMYAiADKAsyKC5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuUGFyc2VDYW5k'
    'aWRhdGVSCmNhbmRpZGF0ZXM=');

@$core.Deprecated('Use parseCandidateDescriptor instead')
const ParseCandidate$json = {
  '1': 'ParseCandidate',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'cover', '3': 3, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'actors', '3': 4, '4': 3, '5': 9, '10': 'actors'},
    {
      '1': 'duration_seconds',
      '3': 5,
      '4': 1,
      '5': 4,
      '9': 0,
      '10': 'durationSeconds',
      '17': true
    },
    {
      '1': 'part_number',
      '3': 6,
      '4': 1,
      '5': 13,
      '9': 1,
      '10': 'partNumber',
      '17': true
    },
    {'1': 'width', '3': 7, '4': 1, '5': 4, '9': 2, '10': 'width', '17': true},
    {'1': 'height', '3': 8, '4': 1, '5': 4, '9': 3, '10': 'height', '17': true},
    {
      '1': 'source',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
    {
      '1': 'browse',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.bilibili.PlaylistListIntent',
      '9': 4,
      '10': 'browse',
      '17': true
    },
  ],
  '8': [
    {'1': '_duration_seconds'},
    {'1': '_part_number'},
    {'1': '_width'},
    {'1': '_height'},
    {'1': '_browse'},
  ],
};

/// Descriptor for `ParseCandidate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parseCandidateDescriptor = $convert.base64Decode(
    'Cg5QYXJzZUNhbmRpZGF0ZRIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSIAoLZGVzY3JpcHRpb24YAi'
    'ABKAlSC2Rlc2NyaXB0aW9uEhQKBWNvdmVyGAMgASgJUgVjb3ZlchIWCgZhY3RvcnMYBCADKAlS'
    'BmFjdG9ycxIuChBkdXJhdGlvbl9zZWNvbmRzGAUgASgESABSD2R1cmF0aW9uU2Vjb25kc4gBAR'
    'IkCgtwYXJ0X251bWJlchgGIAEoDUgBUgpwYXJ0TnVtYmVyiAEBEhkKBXdpZHRoGAcgASgESAJS'
    'BXdpZHRoiAEBEhsKBmhlaWdodBgIIAEoBEgDUgZoZWlnaHSIAQESQAoGc291cmNlGAkgASgLMi'
    'guc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2USSQoGYnJv'
    'd3NlGAogASgLMiwuc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLlBsYXlsaXN0TGlzdEludGVudE'
    'gEUgZicm93c2WIAQFCEwoRX2R1cmF0aW9uX3NlY29uZHNCDgoMX3BhcnRfbnVtYmVyQggKBl93'
    'aWR0aEIJCgdfaGVpZ2h0QgkKB19icm93c2U=');

@$core.Deprecated('Use playlistListIntentDescriptor instead')
const PlaylistListIntent$json = {
  '1': 'PlaylistListIntent',
  '2': [
    {
      '1': 'mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.bilibili.PlaylistListMode',
      '10': 'mode'
    },
    {'1': 'bvid', '3': 2, '4': 1, '5': 9, '10': 'bvid'},
    {'1': 'aid', '3': 3, '4': 1, '5': 4, '9': 0, '10': 'aid', '17': true},
    {'1': 'mid', '3': 4, '4': 1, '5': 4, '10': 'mid'},
    {'1': 'keyword', '3': 5, '4': 1, '5': 9, '10': 'keyword'},
    {'1': 'media_id', '3': 6, '4': 1, '5': 4, '10': 'mediaId'},
    {'1': 'season_id', '3': 7, '4': 1, '5': 4, '10': 'seasonId'},
    {'1': 'series_id', '3': 8, '4': 1, '5': 4, '10': 'seriesId'},
    {'1': 'parent_area_id', '3': 9, '4': 1, '5': 4, '10': 'parentAreaId'},
    {'1': 'area_id', '3': 10, '4': 1, '5': 4, '10': 'areaId'},
    {
      '1': 'history_type',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.BilibiliHistoryType',
      '10': 'historyType'
    },
    {
      '1': 'timeline_type',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.BilibiliPgcTimelineType',
      '10': 'timelineType'
    },
    {'1': 'before_days', '3': 13, '4': 1, '5': 13, '10': 'beforeDays'},
    {'1': 'after_days', '3': 14, '4': 1, '5': 13, '10': 'afterDays'},
  ],
  '8': [
    {'1': '_aid'},
  ],
};

/// Descriptor for `PlaylistListIntent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistListIntentDescriptor = $convert.base64Decode(
    'ChJQbGF5bGlzdExpc3RJbnRlbnQSPgoEbW9kZRgBIAEoDjIqLnN5bmN0di5wcm92aWRlci5iaW'
    'xpYmlsaS5QbGF5bGlzdExpc3RNb2RlUgRtb2RlEhIKBGJ2aWQYAiABKAlSBGJ2aWQSFQoDYWlk'
    'GAMgASgESABSA2FpZIgBARIQCgNtaWQYBCABKARSA21pZBIYCgdrZXl3b3JkGAUgASgJUgdrZX'
    'l3b3JkEhkKCG1lZGlhX2lkGAYgASgEUgdtZWRpYUlkEhsKCXNlYXNvbl9pZBgHIAEoBFIIc2Vh'
    'c29uSWQSGwoJc2VyaWVzX2lkGAggASgEUghzZXJpZXNJZBIkCg5wYXJlbnRfYXJlYV9pZBgJIA'
    'EoBFIMcGFyZW50QXJlYUlkEhcKB2FyZWFfaWQYCiABKARSBmFyZWFJZBJMCgxoaXN0b3J5X3R5'
    'cGUYCyABKA4yKS5zeW5jdHYuc291cmNlX2NvbmZpZy5CaWxpYmlsaUhpc3RvcnlUeXBlUgtoaX'
    'N0b3J5VHlwZRJSCg10aW1lbGluZV90eXBlGAwgASgOMi0uc3luY3R2LnNvdXJjZV9jb25maWcu'
    'QmlsaWJpbGlQZ2NUaW1lbGluZVR5cGVSDHRpbWVsaW5lVHlwZRIfCgtiZWZvcmVfZGF5cxgNIA'
    'EoDVIKYmVmb3JlRGF5cxIdCgphZnRlcl9kYXlzGA4gASgNUglhZnRlckRheXNCBgoEX2FpZA==');

@$core.Deprecated('Use listPlaylistRequestDescriptor instead')
const ListPlaylistRequest$json = {
  '1': 'ListPlaylistRequest',
  '2': [
    {
      '1': 'intent',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.bilibili.PlaylistListIntent',
      '8': {},
      '10': 'intent'
    },
    {'1': 'page', '3': 2, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '10': 'search'},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 7, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListPlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlaylistRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UGxheWxpc3RSZXF1ZXN0EkwKBmludGVudBgBIAEoCzIsLnN5bmN0di5wcm92aWRlci'
    '5iaWxpYmlsaS5QbGF5bGlzdExpc3RJbnRlbnRCBrpIA8gBAVIGaW50ZW50EhsKBHBhZ2UYAiAB'
    'KARCB7pIBDICKAFSBHBhZ2USJgoJcGFnZV9zaXplGAMgASgNQgm6SAYqBBgyKAFSCHBhZ2VTaX'
    'plEhsKBmN1cnNvchgEIAEoCUgAUgZjdXJzb3KIAQESFgoGc2VhcmNoGAUgASgJUgZzZWFyY2gS'
    'IwoNaW5zdGFuY2VfbmFtZRgGIAEoCVIMaW5zdGFuY2VOYW1lEhYKBnNoYXJlZBgHIAEoCFIGc2'
    'hhcmVkQgkKB19jdXJzb3I=');

@$core.Deprecated('Use playlistListItemDescriptor instead')
const PlaylistListItem$json = {
  '1': 'PlaylistListItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'cover', '3': 4, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'is_container', '3': 5, '4': 1, '5': 8, '10': 'isContainer'},
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
    {
      '1': 'browse',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.bilibili.PlaylistListIntent',
      '9': 0,
      '10': 'browse',
      '17': true
    },
  ],
  '8': [
    {'1': '_browse'},
  ],
};

/// Descriptor for `PlaylistListItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistListItemDescriptor = $convert.base64Decode(
    'ChBQbGF5bGlzdExpc3RJdGVtEg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bG'
    'USIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEhQKBWNvdmVyGAQgASgJUgVjb3Zl'
    'chIhCgxpc19jb250YWluZXIYBSABKAhSC2lzQ29udGFpbmVyEkAKBnNvdXJjZRgGIAEoCzIoLn'
    'N5bmN0di5wcm92aWRlci5jb21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNlEkkKBmJyb3dz'
    'ZRgHIAEoCzIsLnN5bmN0di5wcm92aWRlci5iaWxpYmlsaS5QbGF5bGlzdExpc3RJbnRlbnRIAF'
    'IGYnJvd3NliAEBQgkKB19icm93c2U=');

@$core.Deprecated('Use listPlaylistResponseDescriptor instead')
const ListPlaylistResponse$json = {
  '1': 'ListPlaylistResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.PlaylistListItem',
      '10': 'items'
    },
    {'1': 'has_more', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '10': 'page'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListPlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlaylistResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UGxheWxpc3RSZXNwb25zZRJACgVpdGVtcxgBIAMoCzIqLnN5bmN0di5wcm92aWRlci'
    '5iaWxpYmlsaS5QbGF5bGlzdExpc3RJdGVtUgVpdGVtcxIZCghoYXNfbW9yZRgCIAEoCFIHaGFz'
    'TW9yZRISCgRwYWdlGAMgASgEUgRwYWdlEhsKBmN1cnNvchgEIAEoCUgAUgZjdXJzb3KIAQESQA'
    'oGc291cmNlGAUgASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNl'
    'UgZzb3VyY2VCCQoHX2N1cnNvcg==');

@$core.Deprecated('Use listLiveAreasRequestDescriptor instead')
const ListLiveAreasRequest$json = {
  '1': 'ListLiveAreasRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `ListLiveAreasRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLiveAreasRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0TGl2ZUFyZWFzUmVxdWVzdBIjCg1pbnN0YW5jZV9uYW1lGAEgASgJUgxpbnN0YW5jZU'
    '5hbWUSFgoGc2hhcmVkGAIgASgIUgZzaGFyZWQ=');

@$core.Deprecated('Use liveAreaDescriptor instead')
const LiveArea$json = {
  '1': 'LiveArea',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'parent_id', '3': 2, '4': 1, '5': 4, '10': 'parentId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'parent_name', '3': 4, '4': 1, '5': 9, '10': 'parentName'},
    {'1': 'picture', '3': 5, '4': 1, '5': 9, '10': 'picture'},
    {'1': 'hot', '3': 6, '4': 1, '5': 8, '10': 'hot'},
    {
      '1': 'source',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `LiveArea`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveAreaDescriptor = $convert.base64Decode(
    'CghMaXZlQXJlYRIOCgJpZBgBIAEoBFICaWQSGwoJcGFyZW50X2lkGAIgASgEUghwYXJlbnRJZB'
    'ISCgRuYW1lGAMgASgJUgRuYW1lEh8KC3BhcmVudF9uYW1lGAQgASgJUgpwYXJlbnROYW1lEhgK'
    'B3BpY3R1cmUYBSABKAlSB3BpY3R1cmUSEAoDaG90GAYgASgIUgNob3QSQAoGc291cmNlGAcgAS'
    'gLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use listLiveAreasResponseDescriptor instead')
const ListLiveAreasResponse$json = {
  '1': 'ListLiveAreasResponse',
  '2': [
    {
      '1': 'areas',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.LiveArea',
      '10': 'areas'
    },
  ],
};

/// Descriptor for `ListLiveAreasResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLiveAreasResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0TGl2ZUFyZWFzUmVzcG9uc2USOAoFYXJlYXMYASADKAsyIi5zeW5jdHYucHJvdmlkZX'
    'IuYmlsaWJpbGkuTGl2ZUFyZWFSBWFyZWFz');

@$core.Deprecated('Use listFavoriteFoldersRequestDescriptor instead')
const ListFavoriteFoldersRequest$json = {
  '1': 'ListFavoriteFoldersRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `ListFavoriteFoldersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFavoriteFoldersRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0RmF2b3JpdGVGb2xkZXJzUmVxdWVzdBIjCg1pbnN0YW5jZV9uYW1lGAEgASgJUgxpbn'
        'N0YW5jZU5hbWUSFgoGc2hhcmVkGAIgASgIUgZzaGFyZWQ=');

@$core.Deprecated('Use favoriteFolderDescriptor instead')
const FavoriteFolder$json = {
  '1': 'FavoriteFolder',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 4, '10': 'mediaId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'media_count', '3': 3, '4': 1, '5': 4, '10': 'mediaCount'},
    {'1': 'private', '3': 4, '4': 1, '5': 8, '10': 'private'},
    {'1': 'default_folder', '3': 5, '4': 1, '5': 8, '10': 'defaultFolder'},
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `FavoriteFolder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favoriteFolderDescriptor = $convert.base64Decode(
    'Cg5GYXZvcml0ZUZvbGRlchIZCghtZWRpYV9pZBgBIAEoBFIHbWVkaWFJZBIUCgV0aXRsZRgCIA'
    'EoCVIFdGl0bGUSHwoLbWVkaWFfY291bnQYAyABKARSCm1lZGlhQ291bnQSGAoHcHJpdmF0ZRgE'
    'IAEoCFIHcHJpdmF0ZRIlCg5kZWZhdWx0X2ZvbGRlchgFIAEoCFINZGVmYXVsdEZvbGRlchJACg'
    'Zzb3VyY2UYBiABKAsyKC5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VS'
    'BnNvdXJjZQ==');

@$core.Deprecated('Use listFavoriteFoldersResponseDescriptor instead')
const ListFavoriteFoldersResponse$json = {
  '1': 'ListFavoriteFoldersResponse',
  '2': [
    {
      '1': 'folders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.FavoriteFolder',
      '10': 'folders'
    },
  ],
};

/// Descriptor for `ListFavoriteFoldersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFavoriteFoldersResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0RmF2b3JpdGVGb2xkZXJzUmVzcG9uc2USQgoHZm9sZGVycxgBIAMoCzIoLnN5bmN0di'
        '5wcm92aWRlci5iaWxpYmlsaS5GYXZvcml0ZUZvbGRlclIHZm9sZGVycw==');

@$core.Deprecated('Use listFollowedPgcRequestDescriptor instead')
const ListFollowedPgcRequest$json = {
  '1': 'ListFollowedPgcRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.bilibili.PgcFollowType',
      '8': {},
      '10': 'type'
    },
    {'1': 'page', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'shared', '3': 5, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `ListFollowedPgcRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFollowedPgcRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0Rm9sbG93ZWRQZ2NSZXF1ZXN0EiMKDWluc3RhbmNlX25hbWUYASABKAlSDGluc3Rhbm'
    'NlTmFtZRJFCgR0eXBlGAIgASgOMicuc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLlBnY0ZvbGxv'
    'd1R5cGVCCLpIBYIBAhABUgR0eXBlEhsKBHBhZ2UYAyABKARCB7pIBDICKAFSBHBhZ2USJgoJcG'
    'FnZV9zaXplGAQgASgNQgm6SAYqBBgeKAFSCHBhZ2VTaXplEhYKBnNoYXJlZBgFIAEoCFIGc2hh'
    'cmVk');

@$core.Deprecated('Use followedPgcSeasonDescriptor instead')
const FollowedPgcSeason$json = {
  '1': 'FollowedPgcSeason',
  '2': [
    {'1': 'season_id', '3': 1, '4': 1, '5': 4, '10': 'seasonId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover', '3': 3, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'latest_episode', '3': 5, '4': 1, '5': 9, '10': 'latestEpisode'},
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `FollowedPgcSeason`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followedPgcSeasonDescriptor = $convert.base64Decode(
    'ChFGb2xsb3dlZFBnY1NlYXNvbhIbCglzZWFzb25faWQYASABKARSCHNlYXNvbklkEhQKBXRpdG'
    'xlGAIgASgJUgV0aXRsZRIUCgVjb3ZlchgDIAEoCVIFY292ZXISIAoLZGVzY3JpcHRpb24YBCAB'
    'KAlSC2Rlc2NyaXB0aW9uEiUKDmxhdGVzdF9lcGlzb2RlGAUgASgJUg1sYXRlc3RFcGlzb2RlEk'
    'AKBnNvdXJjZRgGIAEoCzIoLnN5bmN0di5wcm92aWRlci5jb21tb24uRGlzY292ZXJlZFNvdXJj'
    'ZVIGc291cmNl');

@$core.Deprecated('Use listFollowedPgcResponseDescriptor instead')
const ListFollowedPgcResponse$json = {
  '1': 'ListFollowedPgcResponse',
  '2': [
    {
      '1': 'seasons',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.FollowedPgcSeason',
      '10': 'seasons'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListFollowedPgcResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFollowedPgcResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0Rm9sbG93ZWRQZ2NSZXNwb25zZRJFCgdzZWFzb25zGAEgAygLMisuc3luY3R2LnByb3'
    'ZpZGVyLmJpbGliaWxpLkZvbGxvd2VkUGdjU2Vhc29uUgdzZWFzb25zEhQKBXRvdGFsGAIgASgE'
    'UgV0b3RhbBIZCghoYXNfbW9yZRgDIAEoCFIHaGFzTW9yZQ==');

@$core.Deprecated('Use listHistoryRequestDescriptor instead')
const ListHistoryRequest$json = {
  '1': 'ListHistoryRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.BilibiliHistoryType',
      '10': 'type'
    },
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 5, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHistoryRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0SGlzdG9yeVJlcXVlc3QSPQoEdHlwZRgBIAEoDjIpLnN5bmN0di5zb3VyY2VfY29uZm'
    'lnLkJpbGliaWxpSGlzdG9yeVR5cGVSBHR5cGUSGwoGY3Vyc29yGAIgASgJSABSBmN1cnNvcogB'
    'ARIkCglwYWdlX3NpemUYAyABKA1CB7pIBCoCGB5SCHBhZ2VTaXplEiMKDWluc3RhbmNlX25hbW'
    'UYBCABKAlSDGluc3RhbmNlTmFtZRIWCgZzaGFyZWQYBSABKAhSBnNoYXJlZEIJCgdfY3Vyc29y');

@$core.Deprecated('Use historyItemDescriptor instead')
const HistoryItem$json = {
  '1': 'HistoryItem',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'subtitle', '3': 2, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'cover', '3': 3, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'author', '3': 4, '4': 1, '5': 9, '10': 'author'},
    {'1': 'viewed_at', '3': 5, '4': 1, '5': 3, '10': 'viewedAt'},
    {'1': 'progress_seconds', '3': 6, '4': 1, '5': 3, '10': 'progressSeconds'},
    {'1': 'duration_seconds', '3': 7, '4': 1, '5': 4, '10': 'durationSeconds'},
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

/// Descriptor for `HistoryItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyItemDescriptor = $convert.base64Decode(
    'CgtIaXN0b3J5SXRlbRIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSGgoIc3VidGl0bGUYAiABKAlSCH'
    'N1YnRpdGxlEhQKBWNvdmVyGAMgASgJUgVjb3ZlchIWCgZhdXRob3IYBCABKAlSBmF1dGhvchIb'
    'Cgl2aWV3ZWRfYXQYBSABKANSCHZpZXdlZEF0EikKEHByb2dyZXNzX3NlY29uZHMYBiABKANSD3'
    'Byb2dyZXNzU2Vjb25kcxIpChBkdXJhdGlvbl9zZWNvbmRzGAcgASgEUg9kdXJhdGlvblNlY29u'
    'ZHMSQAoGc291cmNlGAggASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU2'
    '91cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use listHistoryResponseDescriptor instead')
const ListHistoryResponse$json = {
  '1': 'ListHistoryResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.HistoryItem',
      '10': 'items'
    },
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'source',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHistoryResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0SGlzdG9yeVJlc3BvbnNlEjsKBWl0ZW1zGAEgAygLMiUuc3luY3R2LnByb3ZpZGVyLm'
    'JpbGliaWxpLkhpc3RvcnlJdGVtUgVpdGVtcxIbCgZjdXJzb3IYAiABKAlIAFIGY3Vyc29yiAEB'
    'EhkKCGhhc19tb3JlGAMgASgIUgdoYXNNb3JlEkAKBnNvdXJjZRgEIAEoCzIoLnN5bmN0di5wcm'
    '92aWRlci5jb21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNlQgkKB19jdXJzb3I=');

@$core.Deprecated('Use listPgcTimelineRequestDescriptor instead')
const ListPgcTimelineRequest$json = {
  '1': 'ListPgcTimelineRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.BilibiliPgcTimelineType',
      '10': 'type'
    },
    {'1': 'before_days', '3': 2, '4': 1, '5': 13, '8': {}, '10': 'beforeDays'},
    {'1': 'after_days', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'afterDays'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 5, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `ListPgcTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPgcTimelineRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0UGdjVGltZWxpbmVSZXF1ZXN0EkEKBHR5cGUYASABKA4yLS5zeW5jdHYuc291cmNlX2'
    'NvbmZpZy5CaWxpYmlsaVBnY1RpbWVsaW5lVHlwZVIEdHlwZRIoCgtiZWZvcmVfZGF5cxgCIAEo'
    'DUIHukgEKgIYB1IKYmVmb3JlRGF5cxImCgphZnRlcl9kYXlzGAMgASgNQge6SAQqAhgHUglhZn'
    'RlckRheXMSIwoNaW5zdGFuY2VfbmFtZRgEIAEoCVIMaW5zdGFuY2VOYW1lEhYKBnNoYXJlZBgF'
    'IAEoCFIGc2hhcmVk');

@$core.Deprecated('Use pgcTimelineItemDescriptor instead')
const PgcTimelineItem$json = {
  '1': 'PgcTimelineItem',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 4, '10': 'episodeId'},
    {'1': 'season_id', '3': 2, '4': 1, '5': 4, '10': 'seasonId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'episode_title', '3': 4, '4': 1, '5': 9, '10': 'episodeTitle'},
    {'1': 'cover', '3': 5, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'episode_cover', '3': 6, '4': 1, '5': 9, '10': 'episodeCover'},
    {'1': 'publish_at', '3': 7, '4': 1, '5': 3, '10': 'publishAt'},
    {'1': 'published', '3': 8, '4': 1, '5': 8, '10': 'published'},
    {'1': 'date', '3': 9, '4': 1, '5': 9, '10': 'date'},
    {'1': 'day_of_week', '3': 10, '4': 1, '5': 13, '10': 'dayOfWeek'},
    {'1': 'delayed', '3': 11, '4': 1, '5': 8, '10': 'delayed'},
    {'1': 'delay_reason', '3': 12, '4': 1, '5': 9, '10': 'delayReason'},
    {
      '1': 'source',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `PgcTimelineItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pgcTimelineItemDescriptor = $convert.base64Decode(
    'Cg9QZ2NUaW1lbGluZUl0ZW0SHQoKZXBpc29kZV9pZBgBIAEoBFIJZXBpc29kZUlkEhsKCXNlYX'
    'Nvbl9pZBgCIAEoBFIIc2Vhc29uSWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEiMKDWVwaXNvZGVf'
    'dGl0bGUYBCABKAlSDGVwaXNvZGVUaXRsZRIUCgVjb3ZlchgFIAEoCVIFY292ZXISIwoNZXBpc2'
    '9kZV9jb3ZlchgGIAEoCVIMZXBpc29kZUNvdmVyEh0KCnB1Ymxpc2hfYXQYByABKANSCXB1Ymxp'
    'c2hBdBIcCglwdWJsaXNoZWQYCCABKAhSCXB1Ymxpc2hlZBISCgRkYXRlGAkgASgJUgRkYXRlEh'
    '4KC2RheV9vZl93ZWVrGAogASgNUglkYXlPZldlZWsSGAoHZGVsYXllZBgLIAEoCFIHZGVsYXll'
    'ZBIhCgxkZWxheV9yZWFzb24YDCABKAlSC2RlbGF5UmVhc29uEkAKBnNvdXJjZRgNIAEoCzIoLn'
    'N5bmN0di5wcm92aWRlci5jb21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNl');

@$core.Deprecated('Use listPgcTimelineResponseDescriptor instead')
const ListPgcTimelineResponse$json = {
  '1': 'ListPgcTimelineResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.PgcTimelineItem',
      '10': 'items'
    },
    {
      '1': 'source',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `ListPgcTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPgcTimelineResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0UGdjVGltZWxpbmVSZXNwb25zZRI/CgVpdGVtcxgBIAMoCzIpLnN5bmN0di5wcm92aW'
    'Rlci5iaWxpYmlsaS5QZ2NUaW1lbGluZUl0ZW1SBWl0ZW1zEkAKBnNvdXJjZRgCIAEoCzIoLnN5'
    'bmN0di5wcm92aWRlci5jb21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNl');

@$core.Deprecated('Use listPgcSeasonsRequestDescriptor instead')
const ListPgcSeasonsRequest$json = {
  '1': 'ListPgcSeasonsRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.bilibili.PgcSeasonType',
      '10': 'type'
    },
    {'1': 'page', '3': 2, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {
      '1': 'order',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.bilibili.PgcSeasonOrder',
      '10': 'order'
    },
    {'1': 'ascending', '3': 5, '4': 1, '5': 8, '10': 'ascending'},
    {
      '1': 'finished',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'finished',
      '17': true
    },
    {'1': 'area', '3': 7, '4': 1, '5': 9, '9': 1, '10': 'area', '17': true},
    {'1': 'year', '3': 8, '4': 1, '5': 9, '9': 2, '10': 'year', '17': true},
    {
      '1': 'style_id',
      '3': 9,
      '4': 1,
      '5': 4,
      '9': 3,
      '10': 'styleId',
      '17': true
    },
    {'1': 'instance_name', '3': 10, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 11, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_finished'},
    {'1': '_area'},
    {'1': '_year'},
    {'1': '_style_id'},
  ],
};

/// Descriptor for `ListPgcSeasonsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPgcSeasonsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0UGdjU2Vhc29uc1JlcXVlc3QSOwoEdHlwZRgBIAEoDjInLnN5bmN0di5wcm92aWRlci'
    '5iaWxpYmlsaS5QZ2NTZWFzb25UeXBlUgR0eXBlEhsKBHBhZ2UYAiABKARCB7pIBDICKAFSBHBh'
    'Z2USJAoJcGFnZV9zaXplGAMgASgNQge6SAQqAhgyUghwYWdlU2l6ZRI+CgVvcmRlchgEIAEoDj'
    'IoLnN5bmN0di5wcm92aWRlci5iaWxpYmlsaS5QZ2NTZWFzb25PcmRlclIFb3JkZXISHAoJYXNj'
    'ZW5kaW5nGAUgASgIUglhc2NlbmRpbmcSHwoIZmluaXNoZWQYBiABKAhIAFIIZmluaXNoZWSIAQ'
    'ESFwoEYXJlYRgHIAEoCUgBUgRhcmVhiAEBEhcKBHllYXIYCCABKAlIAlIEeWVhcogBARIeCghz'
    'dHlsZV9pZBgJIAEoBEgDUgdzdHlsZUlkiAEBEiMKDWluc3RhbmNlX25hbWUYCiABKAlSDGluc3'
    'RhbmNlTmFtZRIWCgZzaGFyZWQYCyABKAhSBnNoYXJlZEILCglfZmluaXNoZWRCBwoFX2FyZWFC'
    'BwoFX3llYXJCCwoJX3N0eWxlX2lk');

@$core.Deprecated('Use pgcSeasonDescriptor instead')
const PgcSeason$json = {
  '1': 'PgcSeason',
  '2': [
    {'1': 'season_id', '3': 1, '4': 1, '5': 4, '10': 'seasonId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 4, '10': 'mediaId'},
    {'1': 'first_episode_id', '3': 3, '4': 1, '5': 4, '10': 'firstEpisodeId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'subtitle', '3': 5, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'cover', '3': 6, '4': 1, '5': 9, '10': 'cover'},
    {
      '1': 'first_episode_cover',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'firstEpisodeCover'
    },
    {'1': 'badge', '3': 8, '4': 1, '5': 9, '10': 'badge'},
    {'1': 'progress', '3': 9, '4': 1, '5': 9, '10': 'progress'},
    {'1': 'score', '3': 10, '4': 1, '5': 9, '10': 'score'},
    {'1': 'finished', '3': 11, '4': 1, '5': 8, '10': 'finished'},
    {
      '1': 'type',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.bilibili.PgcSeasonType',
      '10': 'type'
    },
    {
      '1': 'source',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `PgcSeason`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pgcSeasonDescriptor = $convert.base64Decode(
    'CglQZ2NTZWFzb24SGwoJc2Vhc29uX2lkGAEgASgEUghzZWFzb25JZBIZCghtZWRpYV9pZBgCIA'
    'EoBFIHbWVkaWFJZBIoChBmaXJzdF9lcGlzb2RlX2lkGAMgASgEUg5maXJzdEVwaXNvZGVJZBIU'
    'CgV0aXRsZRgEIAEoCVIFdGl0bGUSGgoIc3VidGl0bGUYBSABKAlSCHN1YnRpdGxlEhQKBWNvdm'
    'VyGAYgASgJUgVjb3ZlchIuChNmaXJzdF9lcGlzb2RlX2NvdmVyGAcgASgJUhFmaXJzdEVwaXNv'
    'ZGVDb3ZlchIUCgViYWRnZRgIIAEoCVIFYmFkZ2USGgoIcHJvZ3Jlc3MYCSABKAlSCHByb2dyZX'
    'NzEhQKBXNjb3JlGAogASgJUgVzY29yZRIaCghmaW5pc2hlZBgLIAEoCFIIZmluaXNoZWQSOwoE'
    'dHlwZRgMIAEoDjInLnN5bmN0di5wcm92aWRlci5iaWxpYmlsaS5QZ2NTZWFzb25UeXBlUgR0eX'
    'BlEkAKBnNvdXJjZRgNIAEoCzIoLnN5bmN0di5wcm92aWRlci5jb21tb24uRGlzY292ZXJlZFNv'
    'dXJjZVIGc291cmNl');

@$core.Deprecated('Use listPgcSeasonsResponseDescriptor instead')
const ListPgcSeasonsResponse$json = {
  '1': 'ListPgcSeasonsResponse',
  '2': [
    {
      '1': 'seasons',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.PgcSeason',
      '10': 'seasons'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListPgcSeasonsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPgcSeasonsResponseDescriptor = $convert.base64Decode(
    'ChZMaXN0UGdjU2Vhc29uc1Jlc3BvbnNlEj0KB3NlYXNvbnMYASADKAsyIy5zeW5jdHYucHJvdm'
    'lkZXIuYmlsaWJpbGkuUGdjU2Vhc29uUgdzZWFzb25zEhQKBXRvdGFsGAIgASgEUgV0b3RhbBIZ'
    'CghoYXNfbW9yZRgDIAEoCFIHaGFzTW9yZQ==');

@$core.Deprecated('Use loginQRRequestDescriptor instead')
const LoginQRRequest$json = {
  '1': 'LoginQRRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `LoginQRRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginQRRequestDescriptor = $convert.base64Decode(
    'Cg5Mb2dpblFSUmVxdWVzdBIjCg1pbnN0YW5jZV9uYW1lGAEgASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use qRCodeResponseDescriptor instead')
const QRCodeResponse$json = {
  '1': 'QRCodeResponse',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'key', '3': 2, '4': 1, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `QRCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qRCodeResponseDescriptor = $convert.base64Decode(
    'Cg5RUkNvZGVSZXNwb25zZRIQCgN1cmwYASABKAlSA3VybBIQCgNrZXkYAiABKAlSA2tleQ==');

@$core.Deprecated('Use checkQRRequestDescriptor instead')
const CheckQRRequest$json = {
  '1': 'CheckQRRequest',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'key'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `CheckQRRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkQRRequestDescriptor = $convert.base64Decode(
    'Cg5DaGVja1FSUmVxdWVzdBIZCgNrZXkYASABKAlCB7pIBHICEAFSA2tleRIjCg1pbnN0YW5jZV'
    '9uYW1lGAIgASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use qRStatusResponseDescriptor instead')
const QRStatusResponse$json = {
  '1': 'QRStatusResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.bilibili.QRLoginStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `QRStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qRStatusResponseDescriptor = $convert.base64Decode(
    'ChBRUlN0YXR1c1Jlc3BvbnNlEj8KBnN0YXR1cxgBIAEoDjInLnN5bmN0di5wcm92aWRlci5iaW'
    'xpYmlsaS5RUkxvZ2luU3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use startSMSLoginRequestDescriptor instead')
const StartSMSLoginRequest$json = {
  '1': 'StartSMSLoginRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `StartSMSLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSMSLoginRequestDescriptor = $convert.base64Decode(
    'ChRTdGFydFNNU0xvZ2luUmVxdWVzdBIjCg1pbnN0YW5jZV9uYW1lGAEgASgJUgxpbnN0YW5jZU'
    '5hbWU=');

@$core.Deprecated('Use startSMSLoginResponseDescriptor instead')
const StartSMSLoginResponse$json = {
  '1': 'StartSMSLoginResponse',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'gt', '3': 2, '4': 1, '5': 9, '10': 'gt'},
    {'1': 'challenge', '3': 3, '4': 1, '5': 9, '10': 'challenge'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `StartSMSLoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSMSLoginResponseDescriptor = $convert.base64Decode(
    'ChVTdGFydFNNU0xvZ2luUmVzcG9uc2USIwoNc2Vzc2lvbl90b2tlbhgBIAEoCVIMc2Vzc2lvbl'
    'Rva2VuEg4KAmd0GAIgASgJUgJndBIcCgljaGFsbGVuZ2UYAyABKAlSCWNoYWxsZW5nZRIdCgpl'
    'eHBpcmVzX2F0GAQgASgDUglleHBpcmVzQXQ=');

@$core.Deprecated('Use sendSMSRequestDescriptor instead')
const SendSMSRequest$json = {
  '1': 'SendSMSRequest',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'phone', '3': 2, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'validate', '3': 3, '4': 1, '5': 9, '10': 'validate'},
  ],
};

/// Descriptor for `SendSMSRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendSMSRequestDescriptor = $convert.base64Decode(
    'Cg5TZW5kU01TUmVxdWVzdBIjCg1zZXNzaW9uX3Rva2VuGAEgASgJUgxzZXNzaW9uVG9rZW4SFA'
    'oFcGhvbmUYAiABKAlSBXBob25lEhoKCHZhbGlkYXRlGAMgASgJUgh2YWxpZGF0ZQ==');

@$core.Deprecated('Use sendSMSResponseDescriptor instead')
const SendSMSResponse$json = {
  '1': 'SendSMSResponse',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'expires_at', '3': 2, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `SendSMSResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendSMSResponseDescriptor = $convert.base64Decode(
    'Cg9TZW5kU01TUmVzcG9uc2USIwoNc2Vzc2lvbl90b2tlbhgBIAEoCVIMc2Vzc2lvblRva2VuEh'
    '0KCmV4cGlyZXNfYXQYAiABKANSCWV4cGlyZXNBdA==');

@$core.Deprecated('Use loginSMSRequestDescriptor instead')
const LoginSMSRequest$json = {
  '1': 'LoginSMSRequest',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `LoginSMSRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginSMSRequestDescriptor = $convert.base64Decode(
    'Cg9Mb2dpblNNU1JlcXVlc3QSIwoNc2Vzc2lvbl90b2tlbhgBIAEoCVIMc2Vzc2lvblRva2VuEh'
    'IKBGNvZGUYAiABKAlSBGNvZGU=');

@$core.Deprecated('Use loginSMSResponseDescriptor instead')
const LoginSMSResponse$json = {
  '1': 'LoginSMSResponse',
};

/// Descriptor for `LoginSMSResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginSMSResponseDescriptor =
    $convert.base64Decode('ChBMb2dpblNNU1Jlc3BvbnNl');

@$core.Deprecated('Use userInfoRequestDescriptor instead')
const UserInfoRequest$json = {
  '1': 'UserInfoRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `UserInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoRequestDescriptor = $convert.base64Decode(
    'Cg9Vc2VySW5mb1JlcXVlc3QSIwoNaW5zdGFuY2VfbmFtZRgBIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use userInfoResponseDescriptor instead')
const UserInfoResponse$json = {
  '1': 'UserInfoResponse',
  '2': [
    {'1': 'is_login', '3': 1, '4': 1, '5': 8, '10': 'isLogin'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'face', '3': 4, '4': 1, '5': 9, '10': 'face'},
    {'1': 'is_vip', '3': 5, '4': 1, '5': 8, '10': 'isVip'},
  ],
};

/// Descriptor for `UserInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoResponseDescriptor = $convert.base64Decode(
    'ChBVc2VySW5mb1Jlc3BvbnNlEhkKCGlzX2xvZ2luGAEgASgIUgdpc0xvZ2luEhcKB3VzZXJfaW'
    'QYAiABKARSBnVzZXJJZBIaCgh1c2VybmFtZRgDIAEoCVIIdXNlcm5hbWUSEgoEZmFjZRgEIAEo'
    'CVIEZmFjZRIVCgZpc192aXAYBSABKAhSBWlzVmlw');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor =
    $convert.base64Decode('Cg1Mb2dvdXRSZXF1ZXN0');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert
    .base64Decode('Cg5Mb2dvdXRSZXNwb25zZRIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

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
      '6': '.synctv.provider.bilibili.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjgKBWJpbmRzGAEgAygLMiIuc3luY3R2LnByb3ZpZGVyLmJpbG'
    'liaWxpLkJpbmRJbmZvUgViaW5kcw==');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'created_at', '3': 3, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IdCgpjcmVhdGVkX2F0GAMgASgDUgljcmVhdGVkQXQSNAoWcHJvdmlkZXJfaW5zdGFuY2VfbmFt'
    'ZRgEIAEoCVIUcHJvdmlkZXJJbnN0YW5jZU5hbWU=');
