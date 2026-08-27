// This is a generated file - do not edit.
//
// Generated from proto/providers/synology_service.proto.

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
import 'synology.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> SynologyProviderServiceBase$json =
    {
  '1': 'SynologyProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.synology.LoginRequest',
      '3': '.synctv.provider.synology.LoginResponse'
    },
    {
      '1': 'ListFiles',
      '2': '.synctv.provider.synology.ListFilesRequest',
      '3': '.synctv.provider.synology.ListFilesResponse'
    },
    {
      '1': 'ListLibraries',
      '2': '.synctv.provider.synology.ListLibrariesRequest',
      '3': '.synctv.provider.synology.ListLibrariesResponse'
    },
    {
      '1': 'ListMovies',
      '2': '.synctv.provider.synology.ListMoviesRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'ListTvShows',
      '2': '.synctv.provider.synology.ListTvShowsRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'ListEpisodes',
      '2': '.synctv.provider.synology.ListEpisodesRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'ListHomeVideos',
      '2': '.synctv.provider.synology.ListHomeVideosRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'ListTvRecordings',
      '2': '.synctv.provider.synology.ListTvRecordingsRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.synology.LogoutRequest',
      '3': '.synctv.provider.synology.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.synology.GetBindsRequest',
      '3': '.synctv.provider.synology.GetBindsResponse'
    },
    {
      '1': 'GetImage',
      '2': '.synctv.provider.synology.GetImageRequest',
      '3': '.synctv.provider.common.ResourceResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use synologyProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SynologyProviderServiceBase$messageJson = {
  '.synctv.provider.synology.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.synology.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.synology.ListFilesRequest': $0.ListFilesRequest$json,
  '.synctv.provider.synology.ListFilesResponse': $0.ListFilesResponse$json,
  '.synctv.provider.synology.FileItem': $0.FileItem$json,
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
  '.synctv.provider.synology.ListLibrariesRequest':
      $0.ListLibrariesRequest$json,
  '.synctv.provider.synology.ListLibrariesResponse':
      $0.ListLibrariesResponse$json,
  '.synctv.provider.synology.VideoLibrary': $0.VideoLibrary$json,
  '.synctv.provider.synology.ListMoviesRequest': $0.ListMoviesRequest$json,
  '.synctv.provider.synology.ListVideoItemsResponse':
      $0.ListVideoItemsResponse$json,
  '.synctv.provider.synology.VideoItem': $0.VideoItem$json,
  '.synctv.provider.synology.VideoFile': $0.VideoFile$json,
  '.synctv.provider.synology.ListTvShowsRequest': $0.ListTvShowsRequest$json,
  '.synctv.provider.synology.ListEpisodesRequest': $0.ListEpisodesRequest$json,
  '.synctv.provider.synology.ListHomeVideosRequest':
      $0.ListHomeVideosRequest$json,
  '.synctv.provider.synology.ListTvRecordingsRequest':
      $0.ListTvRecordingsRequest$json,
  '.synctv.provider.synology.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.synology.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.synology.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.synology.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.synology.BindInfo': $0.BindInfo$json,
  '.synctv.provider.synology.GetImageRequest': $0.GetImageRequest$json,
  '.synctv.provider.synology.FileImageRequest': $0.FileImageRequest$json,
  '.synctv.provider.synology.PosterImageRequest': $0.PosterImageRequest$json,
  '.synctv.provider.common.ResourceResponse': $1.ResourceResponse$json,
  '.synctv.provider.common.ResourceChunk': $1.ResourceChunk$json,
};

/// Descriptor for `SynologyProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List synologyProviderServiceDescriptor = $convert.base64Decode(
    'ChdTeW5vbG9neVByb3ZpZGVyU2VydmljZRJYCgVMb2dpbhImLnN5bmN0di5wcm92aWRlci5zeW'
    '5vbG9neS5Mb2dpblJlcXVlc3QaJy5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTG9naW5SZXNw'
    'b25zZRJkCglMaXN0RmlsZXMSKi5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTGlzdEZpbGVzUm'
    'VxdWVzdBorLnN5bmN0di5wcm92aWRlci5zeW5vbG9neS5MaXN0RmlsZXNSZXNwb25zZRJwCg1M'
    'aXN0TGlicmFyaWVzEi4uc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RMaWJyYXJpZXNSZX'
    'F1ZXN0Gi8uc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RMaWJyYXJpZXNSZXNwb25zZRJr'
    'CgpMaXN0TW92aWVzEisuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RNb3ZpZXNSZXF1ZX'
    'N0GjAuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RWaWRlb0l0ZW1zUmVzcG9uc2USbQoL'
    'TGlzdFR2U2hvd3MSLC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTGlzdFR2U2hvd3NSZXF1ZX'
    'N0GjAuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RWaWRlb0l0ZW1zUmVzcG9uc2USbwoM'
    'TGlzdEVwaXNvZGVzEi0uc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RFcGlzb2Rlc1JlcX'
    'Vlc3QaMC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTGlzdFZpZGVvSXRlbXNSZXNwb25zZRJz'
    'Cg5MaXN0SG9tZVZpZGVvcxIvLnN5bmN0di5wcm92aWRlci5zeW5vbG9neS5MaXN0SG9tZVZpZG'
    'Vvc1JlcXVlc3QaMC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTGlzdFZpZGVvSXRlbXNSZXNw'
    'b25zZRJ3ChBMaXN0VHZSZWNvcmRpbmdzEjEuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3'
    'RUdlJlY29yZGluZ3NSZXF1ZXN0GjAuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RWaWRl'
    'b0l0ZW1zUmVzcG9uc2USWwoGTG9nb3V0Eicuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5LkxvZ2'
    '91dFJlcXVlc3QaKC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTG9nb3V0UmVzcG9uc2USYQoI'
    'R2V0QmluZHMSKS5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuR2V0QmluZHNSZXF1ZXN0Giouc3'
    'luY3R2LnByb3ZpZGVyLnN5bm9sb2d5LkdldEJpbmRzUmVzcG9uc2USYQoIR2V0SW1hZ2USKS5z'
    'eW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuR2V0SW1hZ2VSZXF1ZXN0Giguc3luY3R2LnByb3ZpZG'
    'VyLmNvbW1vbi5SZXNvdXJjZVJlc3BvbnNlMAE=');
