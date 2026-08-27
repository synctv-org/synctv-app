// This is a generated file - do not edit.
//
// Generated from proto/providers/youtube_service.proto.

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

import '../source_config.pbjson.dart' as $2;
import 'common.pbjson.dart' as $1;
import 'youtube.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> YoutubeProviderServiceBase$json = {
  '1': 'YoutubeProviderService',
  '2': [
    {
      '1': 'Bind',
      '2': '.synctv.provider.youtube.BindRequest',
      '3': '.synctv.provider.youtube.BindResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.youtube.GetBindsRequest',
      '3': '.synctv.provider.youtube.GetBindsResponse'
    },
    {
      '1': 'Unbind',
      '2': '.synctv.provider.youtube.UnbindRequest',
      '3': '.synctv.provider.youtube.UnbindResponse'
    },
    {
      '1': 'Resolve',
      '2': '.synctv.provider.youtube.ResolveRequest',
      '3': '.synctv.provider.youtube.ResolveResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.youtube.ListRequest',
      '3': '.synctv.provider.youtube.ListResponse'
    },
  ],
};

@$core.Deprecated('Use youtubeProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    YoutubeProviderServiceBase$messageJson = {
  '.synctv.provider.youtube.BindRequest': $0.BindRequest$json,
  '.synctv.provider.youtube.BindResponse': $0.BindResponse$json,
  '.synctv.provider.youtube.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.youtube.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.youtube.BindInfo': $0.BindInfo$json,
  '.synctv.provider.youtube.UnbindRequest': $0.UnbindRequest$json,
  '.synctv.provider.youtube.UnbindResponse': $0.UnbindResponse$json,
  '.synctv.provider.youtube.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.youtube.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.youtube.Metadata': $0.Metadata$json,
  '.synctv.provider.youtube.Format': $0.Format$json,
  '.synctv.provider.common.DiscoveredSource': $1.DiscoveredSource$json,
  '.synctv.source_config.MediaSourceConfig': $2.MediaSourceConfig$json,
  '.synctv.source_config.DirectUrlMediaSourceConfig':
      $2.DirectUrlMediaSourceConfig$json,
  '.synctv.source_config.DirectUrlMediaResourceConfig':
      $2.DirectUrlMediaResourceConfig$json,
  '.synctv.source_config.DirectUrlMediaResourceConfig.HeadersEntry':
      $2.DirectUrlMediaResourceConfig_HeadersEntry$json,
  '.synctv.source_config.DirectUrlSubtitleSourceConfig':
      $2.DirectUrlSubtitleSourceConfig$json,
  '.synctv.source_config.DirectUrlSubtitleSourceConfig.HeadersEntry':
      $2.DirectUrlSubtitleSourceConfig_HeadersEntry$json,
  '.synctv.source_config.DirectUrlDanmakuSourceConfig':
      $2.DirectUrlDanmakuSourceConfig$json,
  '.synctv.source_config.DirectUrlDanmakuSourceConfig.HeadersEntry':
      $2.DirectUrlDanmakuSourceConfig_HeadersEntry$json,
  '.synctv.source_config.BilibiliMediaSourceConfig':
      $2.BilibiliMediaSourceConfig$json,
  '.synctv.source_config.BilibiliVideoSourceConfig':
      $2.BilibiliVideoSourceConfig$json,
  '.synctv.source_config.BilibiliPgcSourceConfig':
      $2.BilibiliPgcSourceConfig$json,
  '.synctv.source_config.BilibiliLiveSourceConfig':
      $2.BilibiliLiveSourceConfig$json,
  '.synctv.source_config.AlistMediaSourceConfig':
      $2.AlistMediaSourceConfig$json,
  '.synctv.source_config.EmbyMediaSourceConfig': $2.EmbyMediaSourceConfig$json,
  '.synctv.source_config.RtmpMediaSourceConfig': $2.RtmpMediaSourceConfig$json,
  '.synctv.source_config.LiveProxyMediaSourceConfig':
      $2.LiveProxyMediaSourceConfig$json,
  '.synctv.source_config.RtmpPullSourceConfig': $2.RtmpPullSourceConfig$json,
  '.synctv.source_config.RtspPullSourceConfig': $2.RtspPullSourceConfig$json,
  '.synctv.source_config.RtspTrackSelection': $2.RtspTrackSelection$json,
  '.synctv.source_config.HttpFlvPullSourceConfig':
      $2.HttpFlvPullSourceConfig$json,
  '.synctv.source_config.WhepPullSourceConfig': $2.WhepPullSourceConfig$json,
  '.synctv.source_config.CloudreveMediaSourceConfig':
      $2.CloudreveMediaSourceConfig$json,
  '.synctv.source_config.TwitchMediaSourceConfig':
      $2.TwitchMediaSourceConfig$json,
  '.synctv.source_config.TwitchLiveSourceConfig':
      $2.TwitchLiveSourceConfig$json,
  '.synctv.source_config.TwitchVideoSourceConfig':
      $2.TwitchVideoSourceConfig$json,
  '.synctv.source_config.TwitchClipSourceConfig':
      $2.TwitchClipSourceConfig$json,
  '.synctv.source_config.HuyaMediaSourceConfig': $2.HuyaMediaSourceConfig$json,
  '.synctv.source_config.HuyaLiveSourceConfig': $2.HuyaLiveSourceConfig$json,
  '.synctv.source_config.HuyaVideoSourceConfig': $2.HuyaVideoSourceConfig$json,
  '.synctv.source_config.DouyuMediaSourceConfig':
      $2.DouyuMediaSourceConfig$json,
  '.synctv.source_config.DouyinMediaSourceConfig':
      $2.DouyinMediaSourceConfig$json,
  '.synctv.source_config.DouyinVideoSourceConfig':
      $2.DouyinVideoSourceConfig$json,
  '.synctv.source_config.DouyinLiveSourceConfig':
      $2.DouyinLiveSourceConfig$json,
  '.synctv.source_config.AcFunMediaSourceConfig':
      $2.AcFunMediaSourceConfig$json,
  '.synctv.source_config.AcFunVideoSourceConfig':
      $2.AcFunVideoSourceConfig$json,
  '.synctv.source_config.AcFunBangumiSourceConfig':
      $2.AcFunBangumiSourceConfig$json,
  '.synctv.source_config.AcFunLiveSourceConfig': $2.AcFunLiveSourceConfig$json,
  '.synctv.source_config.CctvMediaSourceConfig': $2.CctvMediaSourceConfig$json,
  '.synctv.source_config.FnosMediaSourceConfig': $2.FnosMediaSourceConfig$json,
  '.synctv.source_config.FnosFileSourceConfig': $2.FnosFileSourceConfig$json,
  '.synctv.source_config.FnosLibraryItemSourceConfig':
      $2.FnosLibraryItemSourceConfig$json,
  '.synctv.source_config.QnapMediaSourceConfig': $2.QnapMediaSourceConfig$json,
  '.synctv.source_config.SynologyMediaSourceConfig':
      $2.SynologyMediaSourceConfig$json,
  '.synctv.source_config.SynologyFileSourceConfig':
      $2.SynologyFileSourceConfig$json,
  '.synctv.source_config.SynologyLibraryItemSourceConfig':
      $2.SynologyLibraryItemSourceConfig$json,
  '.synctv.source_config.NextcloudMediaSourceConfig':
      $2.NextcloudMediaSourceConfig$json,
  '.synctv.source_config.SeafileMediaSourceConfig':
      $2.SeafileMediaSourceConfig$json,
  '.synctv.source_config.TrueNasMediaSourceConfig':
      $2.TrueNasMediaSourceConfig$json,
  '.synctv.source_config.YoutubeMediaSourceConfig':
      $2.YoutubeMediaSourceConfig$json,
  '.synctv.source_config.TikTokMediaSourceConfig':
      $2.TikTokMediaSourceConfig$json,
  '.synctv.source_config.TikTokVideoSourceConfig':
      $2.TikTokVideoSourceConfig$json,
  '.synctv.source_config.TikTokLiveSourceConfig':
      $2.TikTokLiveSourceConfig$json,
  '.synctv.source_config.PlaylistSourceConfig': $2.PlaylistSourceConfig$json,
  '.synctv.source_config.BilibiliPlaylistSourceConfig':
      $2.BilibiliPlaylistSourceConfig$json,
  '.synctv.source_config.BilibiliVideoPartsPlaylistSource':
      $2.BilibiliVideoPartsPlaylistSource$json,
  '.synctv.source_config.BilibiliPopularPlaylistSource':
      $2.BilibiliPopularPlaylistSource$json,
  '.synctv.source_config.BilibiliRecommendedPlaylistSource':
      $2.BilibiliRecommendedPlaylistSource$json,
  '.synctv.source_config.BilibiliUpVideosPlaylistSource':
      $2.BilibiliUpVideosPlaylistSource$json,
  '.synctv.source_config.BilibiliFavoriteVideosPlaylistSource':
      $2.BilibiliFavoriteVideosPlaylistSource$json,
  '.synctv.source_config.BilibiliCollectionVideosPlaylistSource':
      $2.BilibiliCollectionVideosPlaylistSource$json,
  '.synctv.source_config.BilibiliSeriesVideosPlaylistSource':
      $2.BilibiliSeriesVideosPlaylistSource$json,
  '.synctv.source_config.BilibiliWatchLaterPlaylistSource':
      $2.BilibiliWatchLaterPlaylistSource$json,
  '.synctv.source_config.BilibiliPgcSeasonPlaylistSource':
      $2.BilibiliPgcSeasonPlaylistSource$json,
  '.synctv.source_config.BilibiliLiveRecommendedPlaylistSource':
      $2.BilibiliLiveRecommendedPlaylistSource$json,
  '.synctv.source_config.BilibiliLiveFollowedPlaylistSource':
      $2.BilibiliLiveFollowedPlaylistSource$json,
  '.synctv.source_config.BilibiliLiveAreaPlaylistSource':
      $2.BilibiliLiveAreaPlaylistSource$json,
  '.synctv.source_config.BilibiliHistoryPlaylistSource':
      $2.BilibiliHistoryPlaylistSource$json,
  '.synctv.source_config.BilibiliPgcTimelinePlaylistSource':
      $2.BilibiliPgcTimelinePlaylistSource$json,
  '.synctv.source_config.AlistPlaylistSourceConfig':
      $2.AlistPlaylistSourceConfig$json,
  '.synctv.source_config.EmbyPlaylistSourceConfig':
      $2.EmbyPlaylistSourceConfig$json,
  '.synctv.source_config.EmbyFolderPlaylistSource':
      $2.EmbyFolderPlaylistSource$json,
  '.synctv.source_config.EmbyFavoriteItemsPlaylistSource':
      $2.EmbyFavoriteItemsPlaylistSource$json,
  '.synctv.source_config.EmbyFavoritePeoplePlaylistSource':
      $2.EmbyFavoritePeoplePlaylistSource$json,
  '.synctv.source_config.EmbyPersonItemsPlaylistSource':
      $2.EmbyPersonItemsPlaylistSource$json,
  '.synctv.source_config.EmbyContinueWatchingPlaylistSource':
      $2.EmbyContinueWatchingPlaylistSource$json,
  '.synctv.source_config.EmbyNextUpPlaylistSource':
      $2.EmbyNextUpPlaylistSource$json,
  '.synctv.source_config.EmbyRecentlyAddedPlaylistSource':
      $2.EmbyRecentlyAddedPlaylistSource$json,
  '.synctv.source_config.EmbyPlaylistsPlaylistSource':
      $2.EmbyPlaylistsPlaylistSource$json,
  '.synctv.source_config.EmbyCollectionsPlaylistSource':
      $2.EmbyCollectionsPlaylistSource$json,
  '.synctv.source_config.EmbyGenresPlaylistSource':
      $2.EmbyGenresPlaylistSource$json,
  '.synctv.source_config.EmbyGenreItemsPlaylistSource':
      $2.EmbyGenreItemsPlaylistSource$json,
  '.synctv.source_config.CloudrevePlaylistSourceConfig':
      $2.CloudrevePlaylistSourceConfig$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig':
      $2.TwitchPlaylistSourceConfig$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig.Channel':
      $2.TwitchPlaylistSourceConfig_Channel$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig.FollowedLive':
      $2.TwitchPlaylistSourceConfig_FollowedLive$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig.CategoryLive':
      $2.TwitchPlaylistSourceConfig_CategoryLive$json,
  '.synctv.source_config.TwitchPlaylistSourceConfig.SearchLive':
      $2.TwitchPlaylistSourceConfig_SearchLive$json,
  '.synctv.source_config.DouyinPlaylistSourceConfig':
      $2.DouyinPlaylistSourceConfig$json,
  '.synctv.source_config.FnosPlaylistSourceConfig':
      $2.FnosPlaylistSourceConfig$json,
  '.synctv.source_config.FnosFilesPlaylistSourceConfig':
      $2.FnosFilesPlaylistSourceConfig$json,
  '.synctv.source_config.FnosMediaLibraryPlaylistSourceConfig':
      $2.FnosMediaLibraryPlaylistSourceConfig$json,
  '.synctv.source_config.FnosFavoritesPlaylistSourceConfig':
      $2.FnosFavoritesPlaylistSourceConfig$json,
  '.synctv.source_config.FnosHistoryPlaylistSourceConfig':
      $2.FnosHistoryPlaylistSourceConfig$json,
  '.synctv.source_config.QnapPlaylistSourceConfig':
      $2.QnapPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyPlaylistSourceConfig':
      $2.SynologyPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyFilesPlaylistSourceConfig':
      $2.SynologyFilesPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyMoviesPlaylistSourceConfig':
      $2.SynologyMoviesPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyTvShowsPlaylistSourceConfig':
      $2.SynologyTvShowsPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyEpisodesPlaylistSourceConfig':
      $2.SynologyEpisodesPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyHomeVideosPlaylistSourceConfig':
      $2.SynologyHomeVideosPlaylistSourceConfig$json,
  '.synctv.source_config.SynologyTvRecordingsPlaylistSourceConfig':
      $2.SynologyTvRecordingsPlaylistSourceConfig$json,
  '.synctv.source_config.NextcloudPlaylistSourceConfig':
      $2.NextcloudPlaylistSourceConfig$json,
  '.synctv.source_config.NextcloudFolderPlaylistSourceConfig':
      $2.NextcloudFolderPlaylistSourceConfig$json,
  '.synctv.source_config.NextcloudFavoritesPlaylistSourceConfig':
      $2.NextcloudFavoritesPlaylistSourceConfig$json,
  '.synctv.source_config.NextcloudSearchPlaylistSourceConfig':
      $2.NextcloudSearchPlaylistSourceConfig$json,
  '.synctv.source_config.SeafilePlaylistSourceConfig':
      $2.SeafilePlaylistSourceConfig$json,
  '.synctv.source_config.SeafileFolderPlaylistSourceConfig':
      $2.SeafileFolderPlaylistSourceConfig$json,
  '.synctv.source_config.SeafileStarredPlaylistSourceConfig':
      $2.SeafileStarredPlaylistSourceConfig$json,
  '.synctv.source_config.SeafileSearchPlaylistSourceConfig':
      $2.SeafileSearchPlaylistSourceConfig$json,
  '.synctv.source_config.TrueNasPlaylistSourceConfig':
      $2.TrueNasPlaylistSourceConfig$json,
  '.synctv.source_config.TrueNasFolderPlaylistSourceConfig':
      $2.TrueNasFolderPlaylistSourceConfig$json,
  '.synctv.source_config.TrueNasSearchPlaylistSourceConfig':
      $2.TrueNasSearchPlaylistSourceConfig$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig':
      $2.YoutubePlaylistSourceConfig$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.Playlist':
      $2.YoutubePlaylistSourceConfig_Playlist$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.Channel':
      $2.YoutubePlaylistSourceConfig_Channel$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.Search':
      $2.YoutubePlaylistSourceConfig_Search$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.Subscriptions':
      $2.YoutubePlaylistSourceConfig_Subscriptions$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.LikedVideos':
      $2.YoutubePlaylistSourceConfig_LikedVideos$json,
  '.synctv.source_config.YoutubePlaylistSourceConfig.WatchLater':
      $2.YoutubePlaylistSourceConfig_WatchLater$json,
  '.synctv.source_config.TikTokPlaylistSourceConfig':
      $2.TikTokPlaylistSourceConfig$json,
  '.synctv.provider.youtube.ListRequest': $0.ListRequest$json,
  '.synctv.provider.youtube.ListRequest.Playlist': $0.ListRequest_Playlist$json,
  '.synctv.provider.youtube.ListRequest.Channel': $0.ListRequest_Channel$json,
  '.synctv.provider.youtube.ListRequest.Search': $0.ListRequest_Search$json,
  '.synctv.provider.youtube.ListRequest.Subscriptions':
      $0.ListRequest_Subscriptions$json,
  '.synctv.provider.youtube.ListRequest.LikedVideos':
      $0.ListRequest_LikedVideos$json,
  '.synctv.provider.youtube.ListRequest.WatchLater':
      $0.ListRequest_WatchLater$json,
  '.synctv.provider.youtube.ListResponse': $0.ListResponse$json,
  '.synctv.provider.youtube.ListItem': $0.ListItem$json,
};

/// Descriptor for `YoutubeProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List youtubeProviderServiceDescriptor = $convert.base64Decode(
    'ChZZb3V0dWJlUHJvdmlkZXJTZXJ2aWNlElMKBEJpbmQSJC5zeW5jdHYucHJvdmlkZXIueW91dH'
    'ViZS5CaW5kUmVxdWVzdBolLnN5bmN0di5wcm92aWRlci55b3V0dWJlLkJpbmRSZXNwb25zZRJf'
    'CghHZXRCaW5kcxIoLnN5bmN0di5wcm92aWRlci55b3V0dWJlLkdldEJpbmRzUmVxdWVzdBopLn'
    'N5bmN0di5wcm92aWRlci55b3V0dWJlLkdldEJpbmRzUmVzcG9uc2USWQoGVW5iaW5kEiYuc3lu'
    'Y3R2LnByb3ZpZGVyLnlvdXR1YmUuVW5iaW5kUmVxdWVzdBonLnN5bmN0di5wcm92aWRlci55b3'
    'V0dWJlLlVuYmluZFJlc3BvbnNlElwKB1Jlc29sdmUSJy5zeW5jdHYucHJvdmlkZXIueW91dHVi'
    'ZS5SZXNvbHZlUmVxdWVzdBooLnN5bmN0di5wcm92aWRlci55b3V0dWJlLlJlc29sdmVSZXNwb2'
    '5zZRJTCgRMaXN0EiQuc3luY3R2LnByb3ZpZGVyLnlvdXR1YmUuTGlzdFJlcXVlc3QaJS5zeW5j'
    'dHYucHJvdmlkZXIueW91dHViZS5MaXN0UmVzcG9uc2U=');
