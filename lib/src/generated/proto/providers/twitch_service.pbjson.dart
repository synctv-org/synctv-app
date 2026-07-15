// This is a generated file - do not edit.
//
// Generated from proto/providers/twitch_service.proto.

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

import '../source_config.pbjson.dart' as $1;
import 'twitch.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> TwitchProviderServiceBase$json = {
  '1': 'TwitchProviderService',
  '2': [
    {
      '1': 'Bind',
      '2': '.synctv.provider.twitch.BindRequest',
      '3': '.synctv.provider.twitch.BindResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.twitch.GetBindsRequest',
      '3': '.synctv.provider.twitch.GetBindsResponse'
    },
    {
      '1': 'Unbind',
      '2': '.synctv.provider.twitch.UnbindRequest',
      '3': '.synctv.provider.twitch.UnbindResponse'
    },
    {
      '1': 'Resolve',
      '2': '.synctv.provider.twitch.ResolveRequest',
      '3': '.synctv.provider.twitch.ResolveResponse'
    },
    {
      '1': 'ListChannelItems',
      '2': '.synctv.provider.twitch.ListChannelItemsRequest',
      '3': '.synctv.provider.twitch.ListChannelItemsResponse'
    },
    {
      '1': 'ListFollowedLive',
      '2': '.synctv.provider.twitch.ListFollowedLiveRequest',
      '3': '.synctv.provider.twitch.ListFollowedLiveResponse'
    },
    {
      '1': 'ListCategoryStreams',
      '2': '.synctv.provider.twitch.ListCategoryStreamsRequest',
      '3': '.synctv.provider.twitch.ListCategoryStreamsResponse'
    },
    {
      '1': 'ListTopCategories',
      '2': '.synctv.provider.twitch.ListTopCategoriesRequest',
      '3': '.synctv.provider.twitch.ListTopCategoriesResponse'
    },
    {
      '1': 'SearchLiveChannels',
      '2': '.synctv.provider.twitch.SearchLiveChannelsRequest',
      '3': '.synctv.provider.twitch.SearchLiveChannelsResponse'
    },
    {
      '1': 'ListSchedule',
      '2': '.synctv.provider.twitch.ListScheduleRequest',
      '3': '.synctv.provider.twitch.ListScheduleResponse'
    },
  ],
};

@$core.Deprecated('Use twitchProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TwitchProviderServiceBase$messageJson = {
  '.synctv.provider.twitch.BindRequest': $0.BindRequest$json,
  '.synctv.provider.twitch.BindResponse': $0.BindResponse$json,
  '.synctv.provider.twitch.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.twitch.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.twitch.BindInfo': $0.BindInfo$json,
  '.synctv.provider.twitch.UnbindRequest': $0.UnbindRequest$json,
  '.synctv.provider.twitch.UnbindResponse': $0.UnbindResponse$json,
  '.synctv.provider.twitch.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.twitch.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.twitch.Metadata': $0.Metadata$json,
  '.synctv.provider.twitch.Chapter': $0.Chapter$json,
  '.synctv.provider.twitch.Quality': $0.Quality$json,
  '.synctv.source_config.TwitchMediaSourceConfig':
      $1.TwitchMediaSourceConfig$json,
  '.synctv.source_config.TwitchLiveSourceConfig':
      $1.TwitchLiveSourceConfig$json,
  '.synctv.source_config.TwitchVideoSourceConfig':
      $1.TwitchVideoSourceConfig$json,
  '.synctv.source_config.TwitchClipSourceConfig':
      $1.TwitchClipSourceConfig$json,
  '.synctv.provider.twitch.ListChannelItemsRequest':
      $0.ListChannelItemsRequest$json,
  '.synctv.provider.twitch.ListChannelItemsResponse':
      $0.ListChannelItemsResponse$json,
  '.synctv.provider.twitch.ListItem': $0.ListItem$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig':
      $1.TwitchPlaylistSourceConfig$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig.Channel':
      $1.TwitchPlaylistSourceConfig_Channel$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig.FollowedLive':
      $1.TwitchPlaylistSourceConfig_FollowedLive$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig.CategoryLive':
      $1.TwitchPlaylistSourceConfig_CategoryLive$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig.SearchLive':
      $1.TwitchPlaylistSourceConfig_SearchLive$json,
  '.synctv.provider.twitch.ListFollowedLiveRequest':
      $0.ListFollowedLiveRequest$json,
  '.synctv.provider.twitch.ListFollowedLiveResponse':
      $0.ListFollowedLiveResponse$json,
  '.synctv.provider.twitch.StreamItem': $0.StreamItem$json,
  '.synctv.provider.twitch.ListCategoryStreamsRequest':
      $0.ListCategoryStreamsRequest$json,
  '.synctv.provider.twitch.ListCategoryStreamsResponse':
      $0.ListCategoryStreamsResponse$json,
  '.synctv.provider.twitch.ListTopCategoriesRequest':
      $0.ListTopCategoriesRequest$json,
  '.synctv.provider.twitch.ListTopCategoriesResponse':
      $0.ListTopCategoriesResponse$json,
  '.synctv.provider.twitch.CategoryItem': $0.CategoryItem$json,
  '.synctv.provider.twitch.SearchLiveChannelsRequest':
      $0.SearchLiveChannelsRequest$json,
  '.synctv.provider.twitch.SearchLiveChannelsResponse':
      $0.SearchLiveChannelsResponse$json,
  '.synctv.provider.twitch.SearchChannelItem': $0.SearchChannelItem$json,
  '.synctv.provider.twitch.ListScheduleRequest': $0.ListScheduleRequest$json,
  '.synctv.provider.twitch.ListScheduleResponse': $0.ListScheduleResponse$json,
  '.synctv.provider.twitch.ScheduleSegment': $0.ScheduleSegment$json,
};

/// Descriptor for `TwitchProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List twitchProviderServiceDescriptor = $convert.base64Decode(
    'ChVUd2l0Y2hQcm92aWRlclNlcnZpY2USUQoEQmluZBIjLnN5bmN0di5wcm92aWRlci50d2l0Y2'
    'guQmluZFJlcXVlc3QaJC5zeW5jdHYucHJvdmlkZXIudHdpdGNoLkJpbmRSZXNwb25zZRJdCghH'
    'ZXRCaW5kcxInLnN5bmN0di5wcm92aWRlci50d2l0Y2guR2V0QmluZHNSZXF1ZXN0Giguc3luY3'
    'R2LnByb3ZpZGVyLnR3aXRjaC5HZXRCaW5kc1Jlc3BvbnNlElcKBlVuYmluZBIlLnN5bmN0di5w'
    'cm92aWRlci50d2l0Y2guVW5iaW5kUmVxdWVzdBomLnN5bmN0di5wcm92aWRlci50d2l0Y2guVW'
    '5iaW5kUmVzcG9uc2USWgoHUmVzb2x2ZRImLnN5bmN0di5wcm92aWRlci50d2l0Y2guUmVzb2x2'
    'ZVJlcXVlc3QaJy5zeW5jdHYucHJvdmlkZXIudHdpdGNoLlJlc29sdmVSZXNwb25zZRJ1ChBMaX'
    'N0Q2hhbm5lbEl0ZW1zEi8uc3luY3R2LnByb3ZpZGVyLnR3aXRjaC5MaXN0Q2hhbm5lbEl0ZW1z'
    'UmVxdWVzdBowLnN5bmN0di5wcm92aWRlci50d2l0Y2guTGlzdENoYW5uZWxJdGVtc1Jlc3Bvbn'
    'NlEnUKEExpc3RGb2xsb3dlZExpdmUSLy5zeW5jdHYucHJvdmlkZXIudHdpdGNoLkxpc3RGb2xs'
    'b3dlZExpdmVSZXF1ZXN0GjAuc3luY3R2LnByb3ZpZGVyLnR3aXRjaC5MaXN0Rm9sbG93ZWRMaX'
    'ZlUmVzcG9uc2USfgoTTGlzdENhdGVnb3J5U3RyZWFtcxIyLnN5bmN0di5wcm92aWRlci50d2l0'
    'Y2guTGlzdENhdGVnb3J5U3RyZWFtc1JlcXVlc3QaMy5zeW5jdHYucHJvdmlkZXIudHdpdGNoLk'
    'xpc3RDYXRlZ29yeVN0cmVhbXNSZXNwb25zZRJ4ChFMaXN0VG9wQ2F0ZWdvcmllcxIwLnN5bmN0'
    'di5wcm92aWRlci50d2l0Y2guTGlzdFRvcENhdGVnb3JpZXNSZXF1ZXN0GjEuc3luY3R2LnByb3'
    'ZpZGVyLnR3aXRjaC5MaXN0VG9wQ2F0ZWdvcmllc1Jlc3BvbnNlEnsKElNlYXJjaExpdmVDaGFu'
    'bmVscxIxLnN5bmN0di5wcm92aWRlci50d2l0Y2guU2VhcmNoTGl2ZUNoYW5uZWxzUmVxdWVzdB'
    'oyLnN5bmN0di5wcm92aWRlci50d2l0Y2guU2VhcmNoTGl2ZUNoYW5uZWxzUmVzcG9uc2USaQoM'
    'TGlzdFNjaGVkdWxlEisuc3luY3R2LnByb3ZpZGVyLnR3aXRjaC5MaXN0U2NoZWR1bGVSZXF1ZX'
    'N0Giwuc3luY3R2LnByb3ZpZGVyLnR3aXRjaC5MaXN0U2NoZWR1bGVSZXNwb25zZQ==');
