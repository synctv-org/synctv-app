// This is a generated file - do not edit.
//
// Generated from proto/providers/common_service.proto.

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
import 'common.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> ProviderCommonServiceBase$json = {
  '1': 'ProviderCommonService',
  '2': [
    {
      '1': 'PrepareDirectUrl',
      '2': '.synctv.provider.common.PrepareDirectUrlRequest',
      '3': '.synctv.provider.common.PreparedMediaSource'
    },
    {
      '1': 'PrepareLiveProxy',
      '2': '.synctv.provider.common.PrepareLiveProxyRequest',
      '3': '.synctv.provider.common.PreparedMediaSource'
    },
    {
      '1': 'PrepareRtmp',
      '2': '.synctv.provider.common.PrepareRtmpRequest',
      '3': '.synctv.provider.common.PreparedMediaSource'
    },
    {
      '1': 'ResolvePlaybackProxyPolicy',
      '2': '.synctv.provider.common.ResolvePlaybackProxyPolicyRequest',
      '3': '.synctv.provider.common.PlaybackProxyPolicy'
    },
    {
      '1': 'ListAvailableProviderInstances',
      '2': '.synctv.provider.common.ListAvailableProviderInstancesRequest',
      '3': '.synctv.provider.common.ProviderInstancesResponse'
    },
    {
      '1': 'ListProviderBackends',
      '2': '.synctv.provider.common.ListProviderBackendsRequest',
      '3': '.synctv.provider.common.ProviderBackendsResponse'
    },
    {
      '1': 'ListProviderInstances',
      '2': '.synctv.provider.common.ListProviderInstancesRequest',
      '3': '.synctv.provider.common.ListProviderInstancesResponse'
    },
    {
      '1': 'AddProviderInstance',
      '2': '.synctv.provider.common.AddProviderInstanceRequest',
      '3': '.synctv.provider.common.AddProviderInstanceResponse'
    },
    {
      '1': 'UpdateProviderInstance',
      '2': '.synctv.provider.common.UpdateProviderInstanceRequest',
      '3': '.synctv.provider.common.UpdateProviderInstanceResponse'
    },
    {
      '1': 'DeleteProviderInstance',
      '2': '.synctv.provider.common.DeleteProviderInstanceRequest',
      '3': '.synctv.provider.common.DeleteProviderInstanceResponse'
    },
    {
      '1': 'ReconnectProviderInstance',
      '2': '.synctv.provider.common.ReconnectProviderInstanceRequest',
      '3': '.synctv.provider.common.ReconnectProviderInstanceResponse'
    },
    {
      '1': 'EnableProviderInstance',
      '2': '.synctv.provider.common.EnableProviderInstanceRequest',
      '3': '.synctv.provider.common.EnableProviderInstanceResponse'
    },
    {
      '1': 'DisableProviderInstance',
      '2': '.synctv.provider.common.DisableProviderInstanceRequest',
      '3': '.synctv.provider.common.DisableProviderInstanceResponse'
    },
  ],
};

@$core.Deprecated('Use providerCommonServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ProviderCommonServiceBase$messageJson = {
  '.synctv.provider.common.PrepareDirectUrlRequest':
      $0.PrepareDirectUrlRequest$json,
  '.synctv.provider.common.PrepareDirectUrlRequest.HeadersEntry':
      $0.PrepareDirectUrlRequest_HeadersEntry$json,
  '.synctv.provider.common.PreparedMediaSource': $0.PreparedMediaSource$json,
  '.synctv.provider.common.DiscoveredSource': $0.DiscoveredSource$json,
  '.synctv.source_config.MediaSourceConfig': $1.MediaSourceConfig$json,
  '.synctv.source_config.DirectUrlMediaSourceConfig':
      $1.DirectUrlMediaSourceConfig$json,
  '.synctv.source_config.DirectUrlMediaResourceConfig':
      $1.DirectUrlMediaResourceConfig$json,
  '.synctv.source_config.DirectUrlMediaResourceConfig.HeadersEntry':
      $1.DirectUrlMediaResourceConfig_HeadersEntry$json,
  '.synctv.source_config.DirectUrlSubtitleSourceConfig':
      $1.DirectUrlSubtitleSourceConfig$json,
  '.synctv.source_config.DirectUrlSubtitleSourceConfig.HeadersEntry':
      $1.DirectUrlSubtitleSourceConfig_HeadersEntry$json,
  '.synctv.source_config.DirectUrlDanmakuSourceConfig':
      $1.DirectUrlDanmakuSourceConfig$json,
  '.synctv.source_config.DirectUrlDanmakuSourceConfig.HeadersEntry':
      $1.DirectUrlDanmakuSourceConfig_HeadersEntry$json,
  '.synctv.source_config.BilibiliMediaSourceConfig':
      $1.BilibiliMediaSourceConfig$json,
  '.synctv.source_config.BilibiliVideoSourceConfig':
      $1.BilibiliVideoSourceConfig$json,
  '.synctv.source_config.BilibiliPgcSourceConfig':
      $1.BilibiliPgcSourceConfig$json,
  '.synctv.source_config.BilibiliLiveSourceConfig':
      $1.BilibiliLiveSourceConfig$json,
  '.synctv.source_config.AlistMediaSourceConfig':
      $1.AlistMediaSourceConfig$json,
  '.synctv.source_config.EmbyMediaSourceConfig': $1.EmbyMediaSourceConfig$json,
  '.synctv.source_config.RtmpMediaSourceConfig': $1.RtmpMediaSourceConfig$json,
  '.synctv.source_config.LiveProxyMediaSourceConfig':
      $1.LiveProxyMediaSourceConfig$json,
  '.synctv.source_config.RtmpPullSourceConfig': $1.RtmpPullSourceConfig$json,
  '.synctv.source_config.RtspPullSourceConfig': $1.RtspPullSourceConfig$json,
  '.synctv.source_config.RtspTrackSelection': $1.RtspTrackSelection$json,
  '.synctv.source_config.HttpFlvPullSourceConfig':
      $1.HttpFlvPullSourceConfig$json,
  '.synctv.source_config.WhepPullSourceConfig': $1.WhepPullSourceConfig$json,
  '.synctv.source_config.CloudreveMediaSourceConfig':
      $1.CloudreveMediaSourceConfig$json,
  '.synctv.source_config.TwitchMediaSourceConfig':
      $1.TwitchMediaSourceConfig$json,
  '.synctv.source_config.TwitchLiveSourceConfig':
      $1.TwitchLiveSourceConfig$json,
  '.synctv.source_config.TwitchVideoSourceConfig':
      $1.TwitchVideoSourceConfig$json,
  '.synctv.source_config.TwitchClipSourceConfig':
      $1.TwitchClipSourceConfig$json,
  '.synctv.source_config.HuyaMediaSourceConfig': $1.HuyaMediaSourceConfig$json,
  '.synctv.source_config.HuyaLiveSourceConfig': $1.HuyaLiveSourceConfig$json,
  '.synctv.source_config.HuyaVideoSourceConfig': $1.HuyaVideoSourceConfig$json,
  '.synctv.source_config.DouyuMediaSourceConfig':
      $1.DouyuMediaSourceConfig$json,
  '.synctv.source_config.DouyinMediaSourceConfig':
      $1.DouyinMediaSourceConfig$json,
  '.synctv.source_config.DouyinVideoSourceConfig':
      $1.DouyinVideoSourceConfig$json,
  '.synctv.source_config.DouyinLiveSourceConfig':
      $1.DouyinLiveSourceConfig$json,
  '.synctv.source_config.AcFunMediaSourceConfig':
      $1.AcFunMediaSourceConfig$json,
  '.synctv.source_config.AcFunVideoSourceConfig':
      $1.AcFunVideoSourceConfig$json,
  '.synctv.source_config.AcFunBangumiSourceConfig':
      $1.AcFunBangumiSourceConfig$json,
  '.synctv.source_config.AcFunLiveSourceConfig': $1.AcFunLiveSourceConfig$json,
  '.synctv.source_config.CctvMediaSourceConfig': $1.CctvMediaSourceConfig$json,
  '.synctv.source_config.FnosMediaSourceConfig': $1.FnosMediaSourceConfig$json,
  '.synctv.source_config.FnosFileSourceConfig': $1.FnosFileSourceConfig$json,
  '.synctv.source_config.FnosLibraryItemSourceConfig':
      $1.FnosLibraryItemSourceConfig$json,
  '.synctv.source_config.QnapMediaSourceConfig': $1.QnapMediaSourceConfig$json,
  '.synctv.source_config.SynologyMediaSourceConfig':
      $1.SynologyMediaSourceConfig$json,
  '.synctv.source_config.SynologyFileSourceConfig':
      $1.SynologyFileSourceConfig$json,
  '.synctv.source_config.SynologyLibraryItemSourceConfig':
      $1.SynologyLibraryItemSourceConfig$json,
  '.synctv.source_config.NextcloudMediaSourceConfig':
      $1.NextcloudMediaSourceConfig$json,
  '.synctv.source_config.SeafileMediaSourceConfig':
      $1.SeafileMediaSourceConfig$json,
  '.synctv.source_config.TrueNasMediaSourceConfig':
      $1.TrueNasMediaSourceConfig$json,
  '.synctv.source_config.YoutubeMediaSourceConfig':
      $1.YoutubeMediaSourceConfig$json,
  '.synctv.source_config.TikTokMediaSourceConfig':
      $1.TikTokMediaSourceConfig$json,
  '.synctv.source_config.TikTokVideoSourceConfig':
      $1.TikTokVideoSourceConfig$json,
  '.synctv.source_config.TikTokLiveSourceConfig':
      $1.TikTokLiveSourceConfig$json,
  '.synctv.source_config.PlaylistSourceConfig': $1.PlaylistSourceConfig$json,
  '.synctv.source_config.BilibiliPlaylistSourceConfig':
      $1.BilibiliPlaylistSourceConfig$json,
  '.synctv.source_config.BilibiliVideoPartsPlaylistSource':
      $1.BilibiliVideoPartsPlaylistSource$json,
  '.synctv.source_config.BilibiliPopularPlaylistSource':
      $1.BilibiliPopularPlaylistSource$json,
  '.synctv.source_config.BilibiliRecommendedPlaylistSource':
      $1.BilibiliRecommendedPlaylistSource$json,
  '.synctv.source_config.BilibiliUpVideosPlaylistSource':
      $1.BilibiliUpVideosPlaylistSource$json,
  '.synctv.source_config.BilibiliFavoriteVideosPlaylistSource':
      $1.BilibiliFavoriteVideosPlaylistSource$json,
  '.synctv.source_config.BilibiliCollectionVideosPlaylistSource':
      $1.BilibiliCollectionVideosPlaylistSource$json,
  '.synctv.source_config.BilibiliSeriesVideosPlaylistSource':
      $1.BilibiliSeriesVideosPlaylistSource$json,
  '.synctv.source_config.BilibiliWatchLaterPlaylistSource':
      $1.BilibiliWatchLaterPlaylistSource$json,
  '.synctv.source_config.BilibiliPgcSeasonPlaylistSource':
      $1.BilibiliPgcSeasonPlaylistSource$json,
  '.synctv.source_config.BilibiliLiveRecommendedPlaylistSource':
      $1.BilibiliLiveRecommendedPlaylistSource$json,
  '.synctv.source_config.BilibiliLiveFollowedPlaylistSource':
      $1.BilibiliLiveFollowedPlaylistSource$json,
  '.synctv.source_config.BilibiliLiveAreaPlaylistSource':
      $1.BilibiliLiveAreaPlaylistSource$json,
  '.synctv.source_config.BilibiliHistoryPlaylistSource':
      $1.BilibiliHistoryPlaylistSource$json,
  '.synctv.source_config.BilibiliPgcTimelinePlaylistSource':
      $1.BilibiliPgcTimelinePlaylistSource$json,
  '.synctv.source_config.AlistPlaylistSourceConfig':
      $1.AlistPlaylistSourceConfig$json,
  '.synctv.source_config.EmbyPlaylistSourceConfig':
      $1.EmbyPlaylistSourceConfig$json,
  '.synctv.source_config.EmbyFolderPlaylistSource':
      $1.EmbyFolderPlaylistSource$json,
  '.synctv.source_config.EmbyFavoriteItemsPlaylistSource':
      $1.EmbyFavoriteItemsPlaylistSource$json,
  '.synctv.source_config.EmbyFavoritePeoplePlaylistSource':
      $1.EmbyFavoritePeoplePlaylistSource$json,
  '.synctv.source_config.EmbyPersonItemsPlaylistSource':
      $1.EmbyPersonItemsPlaylistSource$json,
  '.synctv.source_config.EmbyContinueWatchingPlaylistSource':
      $1.EmbyContinueWatchingPlaylistSource$json,
  '.synctv.source_config.EmbyNextUpPlaylistSource':
      $1.EmbyNextUpPlaylistSource$json,
  '.synctv.source_config.EmbyRecentlyAddedPlaylistSource':
      $1.EmbyRecentlyAddedPlaylistSource$json,
  '.synctv.source_config.EmbyPlaylistsPlaylistSource':
      $1.EmbyPlaylistsPlaylistSource$json,
  '.synctv.source_config.EmbyCollectionsPlaylistSource':
      $1.EmbyCollectionsPlaylistSource$json,
  '.synctv.source_config.EmbyGenresPlaylistSource':
      $1.EmbyGenresPlaylistSource$json,
  '.synctv.source_config.EmbyGenreItemsPlaylistSource':
      $1.EmbyGenreItemsPlaylistSource$json,
  '.synctv.source_config.CloudrevePlaylistSourceConfig':
      $1.CloudrevePlaylistSourceConfig$json,
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
  '.synctv.source_config.DouyinPlaylistSourceConfig':
      $1.DouyinPlaylistSourceConfig$json,
  '.synctv.source_config.FnosPlaylistSourceConfig':
      $1.FnosPlaylistSourceConfig$json,
  '.synctv.source_config.FnosFilesPlaylistSourceConfig':
      $1.FnosFilesPlaylistSourceConfig$json,
  '.synctv.source_config.FnosMediaLibraryPlaylistSourceConfig':
      $1.FnosMediaLibraryPlaylistSourceConfig$json,
  '.synctv.source_config.FnosFavoritesPlaylistSourceConfig':
      $1.FnosFavoritesPlaylistSourceConfig$json,
  '.synctv.source_config.FnosHistoryPlaylistSourceConfig':
      $1.FnosHistoryPlaylistSourceConfig$json,
  '.synctv.source_config.QnapPlaylistSourceConfig':
      $1.QnapPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyPlaylistSourceConfig':
      $1.SynologyPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyFilesPlaylistSourceConfig':
      $1.SynologyFilesPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyMoviesPlaylistSourceConfig':
      $1.SynologyMoviesPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyTvShowsPlaylistSourceConfig':
      $1.SynologyTvShowsPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyEpisodesPlaylistSourceConfig':
      $1.SynologyEpisodesPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyHomeVideosPlaylistSourceConfig':
      $1.SynologyHomeVideosPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyTvRecordingsPlaylistSourceConfig':
      $1.SynologyTvRecordingsPlaylistSourceConfig$json,
  '.synctv.source_config.NextcloudPlaylistSourceConfig':
      $1.NextcloudPlaylistSourceConfig$json,
  '.synctv.source_config.NextcloudFolderPlaylistSourceConfig':
      $1.NextcloudFolderPlaylistSourceConfig$json,
  '.synctv.source_config.NextcloudFavoritesPlaylistSourceConfig':
      $1.NextcloudFavoritesPlaylistSourceConfig$json,
  '.synctv.source_config.NextcloudSearchPlaylistSourceConfig':
      $1.NextcloudSearchPlaylistSourceConfig$json,
  '.synctv.source_config.SeafilePlaylistSourceConfig':
      $1.SeafilePlaylistSourceConfig$json,
  '.synctv.source_config.SeafileFolderPlaylistSourceConfig':
      $1.SeafileFolderPlaylistSourceConfig$json,
  '.synctv.source_config.SeafileStarredPlaylistSourceConfig':
      $1.SeafileStarredPlaylistSourceConfig$json,
  '.synctv.source_config.SeafileSearchPlaylistSourceConfig':
      $1.SeafileSearchPlaylistSourceConfig$json,
  '.synctv.source_config.TrueNasPlaylistSourceConfig':
      $1.TrueNasPlaylistSourceConfig$json,
  '.synctv.source_config.TrueNasFolderPlaylistSourceConfig':
      $1.TrueNasFolderPlaylistSourceConfig$json,
  '.synctv.source_config.TrueNasSearchPlaylistSourceConfig':
      $1.TrueNasSearchPlaylistSourceConfig$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig':
      $1.YoutubePlaylistSourceConfig$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.Playlist':
      $1.YoutubePlaylistSourceConfig_Playlist$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.Channel':
      $1.YoutubePlaylistSourceConfig_Channel$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.Search':
      $1.YoutubePlaylistSourceConfig_Search$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.Subscriptions':
      $1.YoutubePlaylistSourceConfig_Subscriptions$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.LikedVideos':
      $1.YoutubePlaylistSourceConfig_LikedVideos$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.WatchLater':
      $1.YoutubePlaylistSourceConfig_WatchLater$json,
  '.synctv.source_config.TikTokPlaylistSourceConfig':
      $1.TikTokPlaylistSourceConfig$json,
  '.synctv.provider.common.PrepareLiveProxyRequest':
      $0.PrepareLiveProxyRequest$json,
  '.synctv.provider.common.PrepareRtmpPullIntent':
      $0.PrepareRtmpPullIntent$json,
  '.synctv.provider.common.PrepareRtspPullIntent':
      $0.PrepareRtspPullIntent$json,
  '.synctv.provider.common.PrepareRtspTrackIntent':
      $0.PrepareRtspTrackIntent$json,
  '.synctv.provider.common.PrepareHttpFlvPullIntent':
      $0.PrepareHttpFlvPullIntent$json,
  '.synctv.provider.common.PrepareWhepPullIntent':
      $0.PrepareWhepPullIntent$json,
  '.synctv.provider.common.PrepareRtmpRequest': $0.PrepareRtmpRequest$json,
  '.synctv.provider.common.ResolvePlaybackProxyPolicyRequest':
      $0.ResolvePlaybackProxyPolicyRequest$json,
  '.synctv.provider.common.PlaybackProxyPolicy': $0.PlaybackProxyPolicy$json,
  '.synctv.provider.common.PlaybackProxyAutoPolicy':
      $0.PlaybackProxyAutoPolicy$json,
  '.synctv.provider.common.ListAvailableProviderInstancesRequest':
      $0.ListAvailableProviderInstancesRequest$json,
  '.synctv.provider.common.ProviderInstancesResponse':
      $0.ProviderInstancesResponse$json,
  '.synctv.provider.common.ListProviderBackendsRequest':
      $0.ListProviderBackendsRequest$json,
  '.synctv.provider.common.ProviderBackendsResponse':
      $0.ProviderBackendsResponse$json,
  '.synctv.provider.common.ListProviderInstancesRequest':
      $0.ListProviderInstancesRequest$json,
  '.synctv.provider.common.ListProviderInstancesResponse':
      $0.ListProviderInstancesResponse$json,
  '.synctv.provider.common.ProviderInstance': $0.ProviderInstance$json,
  '.synctv.provider.common.AddProviderInstanceRequest':
      $0.AddProviderInstanceRequest$json,
  '.synctv.provider.common.AddProviderInstanceResponse':
      $0.AddProviderInstanceResponse$json,
  '.synctv.provider.common.UpdateProviderInstanceRequest':
      $0.UpdateProviderInstanceRequest$json,
  '.synctv.provider.common.UpdateProviderInstanceResponse':
      $0.UpdateProviderInstanceResponse$json,
  '.synctv.provider.common.DeleteProviderInstanceRequest':
      $0.DeleteProviderInstanceRequest$json,
  '.synctv.provider.common.DeleteProviderInstanceResponse':
      $0.DeleteProviderInstanceResponse$json,
  '.synctv.provider.common.ReconnectProviderInstanceRequest':
      $0.ReconnectProviderInstanceRequest$json,
  '.synctv.provider.common.ReconnectProviderInstanceResponse':
      $0.ReconnectProviderInstanceResponse$json,
  '.synctv.provider.common.EnableProviderInstanceRequest':
      $0.EnableProviderInstanceRequest$json,
  '.synctv.provider.common.EnableProviderInstanceResponse':
      $0.EnableProviderInstanceResponse$json,
  '.synctv.provider.common.DisableProviderInstanceRequest':
      $0.DisableProviderInstanceRequest$json,
  '.synctv.provider.common.DisableProviderInstanceResponse':
      $0.DisableProviderInstanceResponse$json,
};

/// Descriptor for `ProviderCommonService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List providerCommonServiceDescriptor = $convert.base64Decode(
    'ChVQcm92aWRlckNvbW1vblNlcnZpY2UScAoQUHJlcGFyZURpcmVjdFVybBIvLnN5bmN0di5wcm'
    '92aWRlci5jb21tb24uUHJlcGFyZURpcmVjdFVybFJlcXVlc3QaKy5zeW5jdHYucHJvdmlkZXIu'
    'Y29tbW9uLlByZXBhcmVkTWVkaWFTb3VyY2UScAoQUHJlcGFyZUxpdmVQcm94eRIvLnN5bmN0di'
    '5wcm92aWRlci5jb21tb24uUHJlcGFyZUxpdmVQcm94eVJlcXVlc3QaKy5zeW5jdHYucHJvdmlk'
    'ZXIuY29tbW9uLlByZXBhcmVkTWVkaWFTb3VyY2USZgoLUHJlcGFyZVJ0bXASKi5zeW5jdHYucH'
    'JvdmlkZXIuY29tbW9uLlByZXBhcmVSdG1wUmVxdWVzdBorLnN5bmN0di5wcm92aWRlci5jb21t'
    'b24uUHJlcGFyZWRNZWRpYVNvdXJjZRKEAQoaUmVzb2x2ZVBsYXliYWNrUHJveHlQb2xpY3kSOS'
    '5zeW5jdHYucHJvdmlkZXIuY29tbW9uLlJlc29sdmVQbGF5YmFja1Byb3h5UG9saWN5UmVxdWVz'
    'dBorLnN5bmN0di5wcm92aWRlci5jb21tb24uUGxheWJhY2tQcm94eVBvbGljeRKSAQoeTGlzdE'
    'F2YWlsYWJsZVByb3ZpZGVySW5zdGFuY2VzEj0uc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5MaXN0'
    'QXZhaWxhYmxlUHJvdmlkZXJJbnN0YW5jZXNSZXF1ZXN0GjEuc3luY3R2LnByb3ZpZGVyLmNvbW'
    '1vbi5Qcm92aWRlckluc3RhbmNlc1Jlc3BvbnNlEn0KFExpc3RQcm92aWRlckJhY2tlbmRzEjMu'
    'c3luY3R2LnByb3ZpZGVyLmNvbW1vbi5MaXN0UHJvdmlkZXJCYWNrZW5kc1JlcXVlc3QaMC5zeW'
    '5jdHYucHJvdmlkZXIuY29tbW9uLlByb3ZpZGVyQmFja2VuZHNSZXNwb25zZRKEAQoVTGlzdFBy'
    'b3ZpZGVySW5zdGFuY2VzEjQuc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5MaXN0UHJvdmlkZXJJbn'
    'N0YW5jZXNSZXF1ZXN0GjUuc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5MaXN0UHJvdmlkZXJJbnN0'
    'YW5jZXNSZXNwb25zZRJ+ChNBZGRQcm92aWRlckluc3RhbmNlEjIuc3luY3R2LnByb3ZpZGVyLm'
    'NvbW1vbi5BZGRQcm92aWRlckluc3RhbmNlUmVxdWVzdBozLnN5bmN0di5wcm92aWRlci5jb21t'
    'b24uQWRkUHJvdmlkZXJJbnN0YW5jZVJlc3BvbnNlEocBChZVcGRhdGVQcm92aWRlckluc3Rhbm'
    'NlEjUuc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5VcGRhdGVQcm92aWRlckluc3RhbmNlUmVxdWVz'
    'dBo2LnN5bmN0di5wcm92aWRlci5jb21tb24uVXBkYXRlUHJvdmlkZXJJbnN0YW5jZVJlc3Bvbn'
    'NlEocBChZEZWxldGVQcm92aWRlckluc3RhbmNlEjUuc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5E'
    'ZWxldGVQcm92aWRlckluc3RhbmNlUmVxdWVzdBo2LnN5bmN0di5wcm92aWRlci5jb21tb24uRG'
    'VsZXRlUHJvdmlkZXJJbnN0YW5jZVJlc3BvbnNlEpABChlSZWNvbm5lY3RQcm92aWRlckluc3Rh'
    'bmNlEjguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5SZWNvbm5lY3RQcm92aWRlckluc3RhbmNlUm'
    'VxdWVzdBo5LnN5bmN0di5wcm92aWRlci5jb21tb24uUmVjb25uZWN0UHJvdmlkZXJJbnN0YW5j'
    'ZVJlc3BvbnNlEocBChZFbmFibGVQcm92aWRlckluc3RhbmNlEjUuc3luY3R2LnByb3ZpZGVyLm'
    'NvbW1vbi5FbmFibGVQcm92aWRlckluc3RhbmNlUmVxdWVzdBo2LnN5bmN0di5wcm92aWRlci5j'
    'b21tb24uRW5hYmxlUHJvdmlkZXJJbnN0YW5jZVJlc3BvbnNlEooBChdEaXNhYmxlUHJvdmlkZX'
    'JJbnN0YW5jZRI2LnN5bmN0di5wcm92aWRlci5jb21tb24uRGlzYWJsZVByb3ZpZGVySW5zdGFu'
    'Y2VSZXF1ZXN0Gjcuc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNhYmxlUHJvdmlkZXJJbnN0YW'
    '5jZVJlc3BvbnNl');
