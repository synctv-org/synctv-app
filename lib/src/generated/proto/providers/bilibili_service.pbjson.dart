// This is a generated file - do not edit.
//
// Generated from proto/providers/bilibili_service.proto.

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
import 'bilibili.pbjson.dart' as $0;
import 'common.pbjson.dart' as $1;

const $core.Map<$core.String, $core.dynamic> BilibiliProviderServiceBase$json =
    {
  '1': 'BilibiliProviderService',
  '2': [
    {
      '1': 'Parse',
      '2': '.synctv.provider.bilibili.ParseRequest',
      '3': '.synctv.provider.bilibili.ParseResponse'
    },
    {
      '1': 'ListPlaylist',
      '2': '.synctv.provider.bilibili.ListPlaylistRequest',
      '3': '.synctv.provider.bilibili.ListPlaylistResponse'
    },
    {
      '1': 'ListLiveAreas',
      '2': '.synctv.provider.bilibili.ListLiveAreasRequest',
      '3': '.synctv.provider.bilibili.ListLiveAreasResponse'
    },
    {
      '1': 'ListFavoriteFolders',
      '2': '.synctv.provider.bilibili.ListFavoriteFoldersRequest',
      '3': '.synctv.provider.bilibili.ListFavoriteFoldersResponse'
    },
    {
      '1': 'ListFollowedPgc',
      '2': '.synctv.provider.bilibili.ListFollowedPgcRequest',
      '3': '.synctv.provider.bilibili.ListFollowedPgcResponse'
    },
    {
      '1': 'ListHistory',
      '2': '.synctv.provider.bilibili.ListHistoryRequest',
      '3': '.synctv.provider.bilibili.ListHistoryResponse'
    },
    {
      '1': 'ListPgcTimeline',
      '2': '.synctv.provider.bilibili.ListPgcTimelineRequest',
      '3': '.synctv.provider.bilibili.ListPgcTimelineResponse'
    },
    {
      '1': 'ListPgcSeasons',
      '2': '.synctv.provider.bilibili.ListPgcSeasonsRequest',
      '3': '.synctv.provider.bilibili.ListPgcSeasonsResponse'
    },
    {
      '1': 'LoginQR',
      '2': '.synctv.provider.bilibili.LoginQRRequest',
      '3': '.synctv.provider.bilibili.QRCodeResponse'
    },
    {
      '1': 'CheckQR',
      '2': '.synctv.provider.bilibili.CheckQRRequest',
      '3': '.synctv.provider.bilibili.QRStatusResponse'
    },
    {
      '1': 'StartSMSLogin',
      '2': '.synctv.provider.bilibili.StartSMSLoginRequest',
      '3': '.synctv.provider.bilibili.StartSMSLoginResponse'
    },
    {
      '1': 'SendSMS',
      '2': '.synctv.provider.bilibili.SendSMSRequest',
      '3': '.synctv.provider.bilibili.SendSMSResponse'
    },
    {
      '1': 'LoginSMS',
      '2': '.synctv.provider.bilibili.LoginSMSRequest',
      '3': '.synctv.provider.bilibili.LoginSMSResponse'
    },
    {
      '1': 'GetUserInfo',
      '2': '.synctv.provider.bilibili.UserInfoRequest',
      '3': '.synctv.provider.bilibili.UserInfoResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.bilibili.LogoutRequest',
      '3': '.synctv.provider.bilibili.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.bilibili.GetBindsRequest',
      '3': '.synctv.provider.bilibili.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use bilibiliProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    BilibiliProviderServiceBase$messageJson = {
  '.synctv.provider.bilibili.ParseRequest': $0.ParseRequest$json,
  '.synctv.provider.bilibili.ParseResponse': $0.ParseResponse$json,
  '.synctv.provider.bilibili.ParseCandidate': $0.ParseCandidate$json,
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
  '.synctv.provider.bilibili.PlaylistListIntent': $0.PlaylistListIntent$json,
  '.synctv.provider.bilibili.ListPlaylistRequest': $0.ListPlaylistRequest$json,
  '.synctv.provider.bilibili.ListPlaylistResponse':
      $0.ListPlaylistResponse$json,
  '.synctv.provider.bilibili.PlaylistListItem': $0.PlaylistListItem$json,
  '.synctv.provider.bilibili.ListLiveAreasRequest':
      $0.ListLiveAreasRequest$json,
  '.synctv.provider.bilibili.ListLiveAreasResponse':
      $0.ListLiveAreasResponse$json,
  '.synctv.provider.bilibili.LiveArea': $0.LiveArea$json,
  '.synctv.provider.bilibili.ListFavoriteFoldersRequest':
      $0.ListFavoriteFoldersRequest$json,
  '.synctv.provider.bilibili.ListFavoriteFoldersResponse':
      $0.ListFavoriteFoldersResponse$json,
  '.synctv.provider.bilibili.FavoriteFolder': $0.FavoriteFolder$json,
  '.synctv.provider.bilibili.ListFollowedPgcRequest':
      $0.ListFollowedPgcRequest$json,
  '.synctv.provider.bilibili.ListFollowedPgcResponse':
      $0.ListFollowedPgcResponse$json,
  '.synctv.provider.bilibili.FollowedPgcSeason': $0.FollowedPgcSeason$json,
  '.synctv.provider.bilibili.ListHistoryRequest': $0.ListHistoryRequest$json,
  '.synctv.provider.bilibili.ListHistoryResponse': $0.ListHistoryResponse$json,
  '.synctv.provider.bilibili.HistoryItem': $0.HistoryItem$json,
  '.synctv.provider.bilibili.ListPgcTimelineRequest':
      $0.ListPgcTimelineRequest$json,
  '.synctv.provider.bilibili.ListPgcTimelineResponse':
      $0.ListPgcTimelineResponse$json,
  '.synctv.provider.bilibili.PgcTimelineItem': $0.PgcTimelineItem$json,
  '.synctv.provider.bilibili.ListPgcSeasonsRequest':
      $0.ListPgcSeasonsRequest$json,
  '.synctv.provider.bilibili.ListPgcSeasonsResponse':
      $0.ListPgcSeasonsResponse$json,
  '.synctv.provider.bilibili.PgcSeason': $0.PgcSeason$json,
  '.synctv.provider.bilibili.LoginQRRequest': $0.LoginQRRequest$json,
  '.synctv.provider.bilibili.QRCodeResponse': $0.QRCodeResponse$json,
  '.synctv.provider.bilibili.CheckQRRequest': $0.CheckQRRequest$json,
  '.synctv.provider.bilibili.QRStatusResponse': $0.QRStatusResponse$json,
  '.synctv.provider.bilibili.StartSMSLoginRequest':
      $0.StartSMSLoginRequest$json,
  '.synctv.provider.bilibili.StartSMSLoginResponse':
      $0.StartSMSLoginResponse$json,
  '.synctv.provider.bilibili.SendSMSRequest': $0.SendSMSRequest$json,
  '.synctv.provider.bilibili.SendSMSResponse': $0.SendSMSResponse$json,
  '.synctv.provider.bilibili.LoginSMSRequest': $0.LoginSMSRequest$json,
  '.synctv.provider.bilibili.LoginSMSResponse': $0.LoginSMSResponse$json,
  '.synctv.provider.bilibili.UserInfoRequest': $0.UserInfoRequest$json,
  '.synctv.provider.bilibili.UserInfoResponse': $0.UserInfoResponse$json,
  '.synctv.provider.bilibili.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.bilibili.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.bilibili.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.bilibili.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.bilibili.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `BilibiliProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List bilibiliProviderServiceDescriptor = $convert.base64Decode(
    'ChdCaWxpYmlsaVByb3ZpZGVyU2VydmljZRJYCgVQYXJzZRImLnN5bmN0di5wcm92aWRlci5iaW'
    'xpYmlsaS5QYXJzZVJlcXVlc3QaJy5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuUGFyc2VSZXNw'
    'b25zZRJtCgxMaXN0UGxheWxpc3QSLS5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuTGlzdFBsYX'
    'lsaXN0UmVxdWVzdBouLnN5bmN0di5wcm92aWRlci5iaWxpYmlsaS5MaXN0UGxheWxpc3RSZXNw'
    'b25zZRJwCg1MaXN0TGl2ZUFyZWFzEi4uc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLkxpc3RMaX'
    'ZlQXJlYXNSZXF1ZXN0Gi8uc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLkxpc3RMaXZlQXJlYXNS'
    'ZXNwb25zZRKCAQoTTGlzdEZhdm9yaXRlRm9sZGVycxI0LnN5bmN0di5wcm92aWRlci5iaWxpYm'
    'lsaS5MaXN0RmF2b3JpdGVGb2xkZXJzUmVxdWVzdBo1LnN5bmN0di5wcm92aWRlci5iaWxpYmls'
    'aS5MaXN0RmF2b3JpdGVGb2xkZXJzUmVzcG9uc2USdgoPTGlzdEZvbGxvd2VkUGdjEjAuc3luY3'
    'R2LnByb3ZpZGVyLmJpbGliaWxpLkxpc3RGb2xsb3dlZFBnY1JlcXVlc3QaMS5zeW5jdHYucHJv'
    'dmlkZXIuYmlsaWJpbGkuTGlzdEZvbGxvd2VkUGdjUmVzcG9uc2USagoLTGlzdEhpc3RvcnkSLC'
    '5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuTGlzdEhpc3RvcnlSZXF1ZXN0Gi0uc3luY3R2LnBy'
    'b3ZpZGVyLmJpbGliaWxpLkxpc3RIaXN0b3J5UmVzcG9uc2USdgoPTGlzdFBnY1RpbWVsaW5lEj'
    'Auc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLkxpc3RQZ2NUaW1lbGluZVJlcXVlc3QaMS5zeW5j'
    'dHYucHJvdmlkZXIuYmlsaWJpbGkuTGlzdFBnY1RpbWVsaW5lUmVzcG9uc2UScwoOTGlzdFBnY1'
    'NlYXNvbnMSLy5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuTGlzdFBnY1NlYXNvbnNSZXF1ZXN0'
    'GjAuc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLkxpc3RQZ2NTZWFzb25zUmVzcG9uc2USXQoHTG'
    '9naW5RUhIoLnN5bmN0di5wcm92aWRlci5iaWxpYmlsaS5Mb2dpblFSUmVxdWVzdBooLnN5bmN0'
    'di5wcm92aWRlci5iaWxpYmlsaS5RUkNvZGVSZXNwb25zZRJfCgdDaGVja1FSEiguc3luY3R2Ln'
    'Byb3ZpZGVyLmJpbGliaWxpLkNoZWNrUVJSZXF1ZXN0Giouc3luY3R2LnByb3ZpZGVyLmJpbGli'
    'aWxpLlFSU3RhdHVzUmVzcG9uc2UScAoNU3RhcnRTTVNMb2dpbhIuLnN5bmN0di5wcm92aWRlci'
    '5iaWxpYmlsaS5TdGFydFNNU0xvZ2luUmVxdWVzdBovLnN5bmN0di5wcm92aWRlci5iaWxpYmls'
    'aS5TdGFydFNNU0xvZ2luUmVzcG9uc2USXgoHU2VuZFNNUxIoLnN5bmN0di5wcm92aWRlci5iaW'
    'xpYmlsaS5TZW5kU01TUmVxdWVzdBopLnN5bmN0di5wcm92aWRlci5iaWxpYmlsaS5TZW5kU01T'
    'UmVzcG9uc2USYQoITG9naW5TTVMSKS5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuTG9naW5TTV'
    'NSZXF1ZXN0Giouc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLkxvZ2luU01TUmVzcG9uc2USZAoL'
    'R2V0VXNlckluZm8SKS5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuVXNlckluZm9SZXF1ZXN0Gi'
    'ouc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLlVzZXJJbmZvUmVzcG9uc2USWwoGTG9nb3V0Eicu'
    'c3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLkxvZ291dFJlcXVlc3QaKC5zeW5jdHYucHJvdmlkZX'
    'IuYmlsaWJpbGkuTG9nb3V0UmVzcG9uc2USYQoIR2V0QmluZHMSKS5zeW5jdHYucHJvdmlkZXIu'
    'YmlsaWJpbGkuR2V0QmluZHNSZXF1ZXN0Giouc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLkdldE'
    'JpbmRzUmVzcG9uc2U=');
