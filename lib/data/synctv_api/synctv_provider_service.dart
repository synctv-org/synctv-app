import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/providers/alist.pb.dart'
    as alist;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pb.dart'
    as bilibili;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/cloudreve.pb.dart'
    as cloudreve;
import 'package:synctv_app/src/generated/proto/providers/emby.pb.dart' as emby;
import 'package:synctv_app/src/generated/proto/providers/fnos.pb.dart' as fnos;
import 'package:synctv_app/src/generated/proto/providers/fnos.pbenum.dart'
    as fnos_enum;
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;
import 'package:synctv_app/src/generated/proto/providers/douyu.pb.dart'
    as douyu;
import 'package:synctv_app/src/generated/proto/providers/acfun.pb.dart'
    as acfun;
import 'package:synctv_app/src/generated/proto/providers/cctv.pb.dart' as cctv;
import 'package:synctv_app/src/generated/proto/providers/nextcloud.pb.dart'
    as nextcloud;
import 'package:synctv_app/src/generated/proto/providers/qnap.pb.dart' as qnap;
import 'package:synctv_app/src/generated/proto/providers/seafile.pb.dart'
    as seafile;
import 'package:synctv_app/src/generated/proto/providers/synology.pb.dart'
    as synology;
import 'package:synctv_app/src/generated/proto/providers/synology.pbenum.dart'
    as synology_enum;
import 'package:synctv_app/src/generated/proto/providers/truenas.pb.dart'
    as truenas;
import 'package:synctv_app/src/generated/proto/providers/twitch.pb.dart'
    as twitch;
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/src/generated/proto/providers/douyin.pb.dart'
    as douyin;
import 'package:synctv_app/src/generated/proto/providers/tiktok.pb.dart'
    as tiktok;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

class SyncTvProviderDomainService {
  SyncTvProviderDomainService(this._api);

  final SyncTvApiClient _api;

  Future<provider_common.PreparedMediaSource> prepareDirectUrl(
    provider_common.PrepareDirectUrlRequest intent,
  ) => _api.providerCommon.prepareDirectUrl(intent);

  Future<provider_common.PreparedMediaSource> prepareLiveProxy(
    provider_common.PrepareLiveProxyRequest intent,
  ) => _api.providerCommon.prepareLiveProxy(intent);

  Future<provider_common.PreparedMediaSource> prepareRtmp(
    source_enum.RtmpStreamMode mode,
  ) => _api.providerCommon.prepareRtmp(
    provider_common.PrepareRtmpRequest(mode: mode),
  );

  Future<provider_common.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
    provider_common.DiscoveredSource source,
  ) => _api.providerCommon.resolvePlaybackProxyPolicy(source);

  Future<AlistLoginInfo> loginAList(
    String host,
    String username,
    String hashedPassword, {
    String otpCode = '',
    String otpSecret = '',
    String instanceName = '',
  }) async {
    final trimmedHashedPassword = hashedPassword.trim();
    if (trimmedHashedPassword.isEmpty) {
      throw ArgumentError.value(hashedPassword, 'hashedPassword', '不能为空');
    }
    final request = alist.LoginRequest(
      host: host,
      username: username,
      hashedPassword: trimmedHashedPassword,
      otpCode: otpCode,
      otpSecret: otpSecret,
      instanceName: instanceName,
    );
    final response = await _api.alistProvider.login(request);
    return AlistLoginInfo(token: response.token, serverId: response.serverId);
  }

  Future<void> logoutAList(String serverId) {
    return _api.alistProvider.logout(alist.LogoutRequest(serverId: serverId));
  }

  Future<String> loginCloudreve(
    String host,
    String email,
    String password, {
    String instanceName = '',
  }) async {
    final response = await _api.cloudreveProvider.login(
      cloudreve.LoginRequest(
        host: host,
        email: email,
        password: password,
        instanceName: instanceName,
      ),
    );
    return response.serverId;
  }

  Future<void> logoutCloudreve(String serverId) async {
    await _api.cloudreveProvider.logout(
      cloudreve.LogoutRequest(serverId: serverId),
    );
  }

  Future<TwitchBindInfo> bindTwitch({
    required String authToken,
    String deviceId = '',
    String clientIntegrity = '',
    String instanceName = '',
  }) async {
    final response = await _api.twitchProvider.bind(
      twitch.BindRequest(
        authToken: authToken.trim(),
        deviceId: deviceId.trim().isEmpty ? null : deviceId.trim(),
        clientIntegrity: clientIntegrity.trim().isEmpty
            ? null
            : clientIntegrity.trim(),
        instanceName: instanceName,
      ),
    );
    return TwitchBindInfo(
      id: '',
      serverId: response.serverId,
      login: response.login,
      twitchUserId: response.twitchUserId,
      clientId: response.clientId,
      scopes: response.scopes,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<void> unbindTwitch(String serverId) async {
    await _api.twitchProvider.unbind(twitch.UnbindRequest(serverId: serverId));
  }

  Future<twitch.ResolveResponse> resolveTwitch(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) => _api.twitchProvider.resolve(
    twitch.ResolveRequest(
      resource: resource.trim(),
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<twitch.ListChannelItemsResponse> listTwitchChannelItems(
    String resource, {
    required source_enum.TwitchPlaylistContent content,
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _api.twitchProvider.listChannelItems(
    twitch.ListChannelItemsRequest(
      resource: resource.trim(),
      content: content,
      cursor: cursor,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<twitch.ListFollowedLiveResponse> listTwitchFollowedLive({
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _api.twitchProvider.listFollowedLive(
    twitch.ListFollowedLiveRequest(
      cursor: cursor,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<twitch.ListCategoryStreamsResponse> listTwitchCategoryStreams({
    required String categoryId,
    required String categoryName,
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _api.twitchProvider.listCategoryStreams(
    twitch.ListCategoryStreamsRequest(
      categoryId: categoryId,
      categoryName: categoryName,
      cursor: cursor,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<twitch.ListTopCategoriesResponse> listTwitchTopCategories({
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _api.twitchProvider.listTopCategories(
    twitch.ListTopCategoriesRequest(
      cursor: cursor,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<twitch.SearchLiveChannelsResponse> searchTwitchLiveChannels(
    String query, {
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _api.twitchProvider.searchLiveChannels(
    twitch.SearchLiveChannelsRequest(
      query: query.trim(),
      cursor: cursor,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<twitch.ListScheduleResponse> listTwitchSchedule(
    String broadcasterId, {
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _api.twitchProvider.listSchedule(
    twitch.ListScheduleRequest(
      broadcasterId: broadcasterId,
      cursor: cursor,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<huya.ResolveResponse> resolveHuya(
    String resource, {
    String instanceName = '',
  }) => _api.huyaProvider.resolve(
    huya.ResolveRequest(resource: resource.trim(), instanceName: instanceName),
  );

  Future<douyu.ResolveResponse> resolveDouyu(
    String resource, {
    String instanceName = '',
  }) => _api.douyuProvider.resolve(
    douyu.ResolveRequest(resource: resource.trim(), instanceName: instanceName),
  );

  Future<acfun.ResolveResponse> resolveAcFun(
    String resource, {
    String instanceName = '',
  }) => _api.acFunProvider.resolve(
    acfun.ResolveRequest(resource: resource.trim(), instanceName: instanceName),
  );

  Future<cctv.ResolveResponse> resolveCctv(
    String resource, {
    String instanceName = '',
  }) => _api.cctvProvider.resolve(
    cctv.ResolveRequest(resource: resource.trim(), instanceName: instanceName),
  );

  Future<YoutubeBindInfo> bindYoutube({
    required String label,
    String visitorData = '',
    String poToken = '',
    String cookie = '',
    String instanceName = '',
  }) async {
    final response = await _api.youtubeProvider.bind(
      youtube.BindRequest(
        label: label.trim(),
        visitorData: visitorData.trim().isEmpty ? null : visitorData.trim(),
        poToken: poToken.trim().isEmpty ? null : poToken.trim(),
        cookie: cookie.trim().isEmpty ? null : cookie.trim(),
        instanceName: instanceName,
      ),
    );
    return YoutubeBindInfo(
      id: '',
      serverId: response.serverId,
      label: label.trim(),
      hasVisitorData: visitorData.trim().isNotEmpty,
      hasPoToken: poToken.trim().isNotEmpty,
      hasCookie: cookie.trim().isNotEmpty,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<void> unbindYoutube(String serverId) async {
    await _api.youtubeProvider.unbind(
      youtube.UnbindRequest(serverId: serverId),
    );
  }

  Future<youtube.ResolveResponse> resolveYoutube(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) {
    final request = youtube.ResolveRequest(
      resource: resource.trim(),
      instanceName: instanceName,
    );
    if (shared) request.shared = true;
    return _api.youtubeProvider.resolve(request);
  }

  Future<youtube.ListResponse> listYoutube(youtube.ListRequest request) =>
      _api.youtubeProvider.list(request);

  Future<DouyinBindInfo> bindDouyin({
    required String label,
    required String cookie,
    String instanceName = '',
  }) async {
    final response = await _api.douyinProvider.bind(
      douyin.BindRequest(
        label: label.trim(),
        cookie: cookie.trim(),
        instanceName: instanceName,
      ),
    );
    return DouyinBindInfo(
      id: '',
      serverId: response.serverId,
      label: label.trim(),
      hasCookie: true,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<void> unbindDouyin(String serverId) async {
    await _api.douyinProvider.unbind(douyin.UnbindRequest(serverId: serverId));
  }

  Future<douyin.ResolveResponse> resolveDouyin(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) {
    return _api.douyinProvider.resolve(
      douyin.ResolveRequest(
        resource: resource.trim(),
        instanceName: instanceName,
        shared: shared,
      ),
    );
  }

  Future<douyin.ListUserPostsResponse> listDouyinUserPosts(
    String secUid, {
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) {
    return _api.douyinProvider.listUserPosts(
      douyin.ListUserPostsRequest(
        secUid: secUid.trim(),
        cursor: cursor,
        pageSize: pageSize,
        instanceName: instanceName,
        shared: shared,
      ),
    );
  }

  Future<TikTokBindInfo> bindTikTok({
    required String label,
    required String cookie,
    String instanceName = '',
  }) async {
    final response = await _api.tiktokProvider.bind(
      tiktok.BindRequest(
        label: label.trim(),
        cookie: cookie.trim(),
        instanceName: instanceName,
      ),
    );
    return TikTokBindInfo(
      id: '',
      serverId: response.serverId,
      label: label.trim(),
      hasCookie: true,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<void> unbindTikTok(String serverId) async {
    await _api.tiktokProvider.unbind(tiktok.UnbindRequest(serverId: serverId));
  }

  Future<tiktok.ResolveResponse> resolveTikTok(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) => _api.tiktokProvider.resolve(
    tiktok.ResolveRequest(
      resource: resource.trim(),
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<tiktok.GetUserResponse> getTikTokUser(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) => _api.tiktokProvider.getUser(
    tiktok.GetUserRequest(
      resource: resource.trim(),
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<tiktok.ListUserPostsResponse> listTikTokUserPosts(
    String secUid, {
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _api.tiktokProvider.listUserPosts(
    tiktok.ListUserPostsRequest(
      secUid: secUid.trim(),
      cursor: cursor,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<FnosLoginInfo> loginFnos({
    required String endpoint,
    required String username,
    required String password,
    String webdavEndpoint = '',
    String mediaEndpoint = '',
    String twoFactorCode = '',
    bool trustDevice = true,
    String instanceName = '',
  }) async {
    final response = await _api.fnosProvider.login(
      fnos.LoginRequest(
        endpoint: endpoint.trim(),
        webdavEndpoint: webdavEndpoint.trim().isEmpty
            ? null
            : webdavEndpoint.trim(),
        mediaEndpoint: mediaEndpoint.trim().isEmpty
            ? null
            : mediaEndpoint.trim(),
        username: username.trim(),
        password: password,
        twofaCode: twoFactorCode.trim().isEmpty ? null : twoFactorCode.trim(),
        trustDevice: trustDevice,
        instanceName: instanceName,
      ),
    );
    return switch (response.whichResult()) {
      fnos.LoginResponse_Result.authenticated => FnosAuthenticatedInfo(
        serverId: response.authenticated.serverId,
        hostName: response.authenticated.hostName,
        version: response.authenticated.version,
        mediaAvailable: response.authenticated.mediaAvailable,
      ),
      fnos.LoginResponse_Result.twoFactorRequired => FnosTwoFactorRequiredInfo(
        setupRequired: response.twoFactorRequired.setupRequired,
      ),
      fnos.LoginResponse_Result.notSet => throw StateError('FNOS 登录响应缺少结果'),
    };
  }

  Future<void> logoutFnos(String serverId) async {
    await _api.fnosProvider.logout(fnos.LogoutRequest(serverId: serverId));
  }

  Future<List<FnosBindInfo>> getFnosBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.fnosProvider.getBinds(
      fnos.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds.map(_fnosBindFromProto).toList();
  }

  Future<List<FnosBindInfo>> getAllFnosBindInfos() async {
    final instances = await _availableInstanceNames('fnos');
    final lists = await Future.wait(
      _withDefaultInstance(instances)
          .map((instanceName) => getFnosBindInfos(instanceName: instanceName)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<FnosFileListPage> listFnosFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) async {
    final response = await _api.fnosProvider.list(
      fnos.ListRequest(
        serverId: serverId,
        path: path,
        page: page,
        pageSize: pageSize,
        search: search.trim().isEmpty ? null : search.trim(),
        instanceName: instanceName,
      ),
    );
    return FnosFileListPage(
      items: response.content
          .map(
            (item) => FnosFileItemInfo(
              name: item.name,
              path: item.path,
              size: item.hasSize() ? item.size.toInt() : null,
              modifiedAt: item.hasModifiedAt() ? item.modifiedAt.toInt() : null,
              createdAt: item.hasCreatedAt() ? item.createdAt.toInt() : null,
              isDir: item.isDir,
              storageId: item.hasStorageId() ? item.storageId.toInt() : null,
              source: item.source.deepCopy(),
            ),
          )
          .toList(),
      total: response.total.toInt(),
      page: response.page,
      hasMore: response.hasMore,
      source: response.hasSource() ? response.source.deepCopy() : null,
    );
  }

  Future<List<FnosMediaLibraryInfo>> listFnosMediaLibraries(
    String serverId, {
    String instanceName = '',
  }) async {
    final response = await _api.fnosProvider.listMediaLibraries(
      fnos.ListMediaLibrariesRequest(
        serverId: serverId,
        instanceName: instanceName,
      ),
    );
    return response.libraries
        .map(
          (library) => FnosMediaLibraryInfo(
            guid: library.guid,
            title: library.title,
            poster: library.poster.isEmpty
                ? ''
                : _api.resolveResourceUrl(library.poster),
            posters: library.posters.map(_api.resolveResourceUrl).toList(),
            category: library.category,
            viewType: library.viewType,
            posterType: library.posterType,
          ),
        )
        .toList();
  }

  Future<FnosMediaListPage> listFnosMediaItems(
    String serverId, {
    FnosMediaCollection collection = FnosMediaCollection.library,
    String libraryGuid = '',
    String parentGuid = '',
    int page = 1,
    int pageSize = 50,
    List<String> mediaTypes = const [],
    String search = '',
    String instanceName = '',
  }) async {
    final response = await _api.fnosProvider.listMediaItems(
      fnos.ListMediaItemsRequest(
        serverId: serverId,
        collection: switch (collection) {
          FnosMediaCollection.library =>
            fnos_enum.MediaCollection.MEDIA_COLLECTION_LIBRARY,
          FnosMediaCollection.favorites =>
            fnos_enum.MediaCollection.MEDIA_COLLECTION_FAVORITES,
          FnosMediaCollection.history =>
            fnos_enum.MediaCollection.MEDIA_COLLECTION_HISTORY,
        },
        libraryGuid: libraryGuid.isEmpty ? null : libraryGuid,
        parentGuid: parentGuid.isEmpty ? null : parentGuid,
        page: page,
        pageSize: pageSize,
        mediaTypes: mediaTypes,
        search: search.trim().isEmpty ? null : search.trim(),
        instanceName: instanceName,
      ),
    );
    return FnosMediaListPage(
      items: response.items
          .map(
            (item) => FnosMediaItemInfo(
              guid: item.guid,
              title: item.title,
              itemType: item.itemType,
              poster: item.poster.isEmpty
                  ? ''
                  : _api.resolveResourceUrl(item.poster),
              mediaGuid: item.mediaGuid,
              parentGuid: item.parentGuid,
              libraryGuid: item.libraryGuid,
              overview: item.overview,
              durationSeconds: item.durationSeconds.toInt(),
              progressSeconds: item.progressSeconds.toInt(),
              watched: item.watched,
              seasonNumber: item.seasonNumber,
              episodeNumber: item.episodeNumber,
              isFolder: item.isFolder,
              isPlayable: item.isPlayable,
              favorite: item.favorite,
              source: item.source.deepCopy(),
            ),
          )
          .toList(),
      total: response.total.toInt(),
      page: response.page,
      hasMore: response.hasMore,
      source: response.hasSource() ? response.source.deepCopy() : null,
    );
  }

  Future<bool> setFnosFavorite(
    String serverId,
    String itemGuid,
    bool favorite, {
    String instanceName = '',
  }) async {
    final response = await _api.fnosProvider.setFavorite(
      fnos.SetFavoriteRequest(
        serverId: serverId,
        itemGuid: itemGuid,
        favorite: favorite,
        instanceName: instanceName,
      ),
    );
    return response.success;
  }

  Future<bool> setFnosWatched(
    String serverId,
    String itemGuid,
    bool watched, {
    String instanceName = '',
  }) async {
    final response = await _api.fnosProvider.setWatched(
      fnos.SetWatchedRequest(
        serverId: serverId,
        itemGuid: itemGuid,
        watched: watched,
        instanceName: instanceName,
      ),
    );
    return response.success;
  }

  Future<QnapBindInfo> loginQnap({
    required String endpoint,
    required String username,
    required String password,
    String instanceName = '',
  }) async {
    final response = await _api.qnapProvider.login(
      qnap.LoginRequest(
        endpoint: endpoint.trim(),
        username: username.trim(),
        password: password,
        instanceName: instanceName,
      ),
    );
    return QnapBindInfo(
      id: '',
      serverId: response.serverId,
      endpoint: endpoint.trim(),
      username: username.trim(),
      serverName: response.serverName,
      version: response.version,
      supportRtt: response.supportRtt,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<void> logoutQnap(String serverId) async {
    await _api.qnapProvider.logout(qnap.LogoutRequest(serverId: serverId));
  }

  Future<List<QnapBindInfo>> getQnapBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.qnapProvider.getBinds(
      qnap.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds.map(_qnapBindFromProto).toList();
  }

  Future<List<QnapBindInfo>> getAllQnapBindInfos() async {
    final instances = await _availableInstanceNames('qnap');
    final lists = await Future.wait(
      _withDefaultInstance(instances)
          .map((instanceName) => getQnapBindInfos(instanceName: instanceName)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<QnapCapabilitiesInfo> getQnapCapabilities(
    String serverId, {
    String instanceName = '',
  }) async {
    final response = await _api.qnapProvider.getCapabilities(
      qnap.GetCapabilitiesRequest(
        serverId: serverId,
        instanceName: instanceName,
      ),
    );
    return QnapCapabilitiesInfo(
      supportRtt: response.supportRtt,
      hardwareTranscode: response.hardwareTranscode,
      qtranscode: response.qtranscode,
      multimediaCodec: response.multimediaCodec,
      hdStationSupport: response.hdStationSupport,
    );
  }

  Future<QnapFileListPage> listQnapFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) async {
    final response = await _api.qnapProvider.list(
      qnap.ListRequest(
        serverId: serverId,
        path: path,
        page: Int64(page),
        pageSize: pageSize,
        search: search.trim().isEmpty ? null : search.trim(),
        instanceName: instanceName,
      ),
    );
    return QnapFileListPage(
      items: response.content
          .map(
            (item) => QnapFileItemInfo(
              name: item.name,
              path: item.path,
              isDir: item.isDir,
              size: item.size.toInt(),
              modifiedAt: item.modifiedAt.toInt(),
              fileType: item.fileType.toInt(),
              preTranscodedHeights: item.preTranscodedHeights.toList(),
              thumbnailUrl: item.isDir
                  ? ''
                  : _qnapThumbnailUrl(serverId, item.path),
              source: item.source.deepCopy(),
            ),
          )
          .toList(),
      total: response.total.toInt(),
      page: response.page.toInt(),
      hasMore: response.hasMore,
      realtimeTranscode: response.realtimeTranscode,
      source: response.hasSource() ? response.source.deepCopy() : null,
    );
  }

  Future<SynologyBindInfo> loginSynology({
    required String endpoint,
    required String username,
    required String password,
    String otpCode = '',
    String deviceName = '',
    String instanceName = '',
  }) async {
    final response = await _api.synologyProvider.login(
      synology.LoginRequest(
        endpoint: endpoint.trim(),
        username: username.trim(),
        password: password,
        otpCode: otpCode.trim().isEmpty ? null : otpCode.trim(),
        deviceName: deviceName.trim().isEmpty ? null : deviceName.trim(),
        instanceName: instanceName,
      ),
    );
    return SynologyBindInfo(
      id: '',
      serverId: response.serverId,
      endpoint: endpoint.trim(),
      username: username.trim(),
      videoStationAvailable: response.videoStationAvailable,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<NextcloudBindInfo> loginNextcloud({
    required String endpoint,
    required String username,
    required String appPassword,
    String instanceName = '',
  }) async {
    final response = await _api.nextcloudProvider.login(
      nextcloud.LoginRequest(
        endpoint: endpoint.trim(),
        username: username.trim(),
        appPassword: appPassword,
        instanceName: instanceName,
      ),
    );
    return NextcloudBindInfo(
      id: '',
      serverId: response.serverId,
      endpoint: endpoint.trim(),
      username: username.trim(),
      userId: response.userId,
      displayName: response.displayName,
      version: response.version,
      edition: response.edition,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<NextcloudLoginFlowInfo> startNextcloudLoginFlow(
    String endpoint,
  ) async {
    final response = await _api.nextcloudProvider.startLoginFlow(
      nextcloud.StartLoginFlowRequest(endpoint: endpoint.trim()),
    );
    return NextcloudLoginFlowInfo(
      loginUrl: response.loginUrl,
      pollEndpoint: response.pollEndpoint,
      pollToken: response.pollToken,
    );
  }

  Future<NextcloudBindInfo> pollNextcloudLoginFlow({
    required String endpoint,
    required NextcloudLoginFlowInfo flow,
    String instanceName = '',
  }) async {
    final response = await _api.nextcloudProvider.pollLoginFlow(
      nextcloud.PollLoginFlowRequest(
        endpoint: endpoint.trim(),
        pollEndpoint: flow.pollEndpoint,
        pollToken: flow.pollToken,
        instanceName: instanceName,
      ),
    );
    return NextcloudBindInfo(
      id: '',
      serverId: response.serverId,
      endpoint: endpoint.trim(),
      username: '',
      userId: response.userId,
      displayName: response.displayName,
      version: response.version,
      edition: response.edition,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<void> logoutNextcloud(String serverId) async {
    await _api.nextcloudProvider.logout(
      nextcloud.LogoutRequest(serverId: serverId),
    );
  }

  Future<List<NextcloudBindInfo>> getNextcloudBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.nextcloudProvider.getBinds(
      nextcloud.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds
        .map(
          (bind) => NextcloudBindInfo(
            id: bind.id,
            serverId: bind.serverId,
            endpoint: bind.endpoint,
            username: bind.username,
            userId: bind.userId,
            displayName: '',
            version: bind.version,
            edition: bind.edition,
            createdAt: bind.createdAt.toInt(),
            providerInstanceName: bind.providerInstanceName,
          ),
        )
        .toList();
  }

  Future<List<NextcloudBindInfo>> getAllNextcloudBindInfos() async {
    final instances = await _availableInstanceNames('nextcloud');
    final lists = await Future.wait(
      _withDefaultInstance(instances).map(
        (instanceName) => getNextcloudBindInfos(instanceName: instanceName),
      ),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<NextcloudFileListPage> listNextcloudFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) async {
    final response = await _api.nextcloudProvider.list(
      nextcloud.ListRequest(
        serverId: serverId,
        path: path,
        page: Int64(page),
        pageSize: pageSize,
        search: search.trim().isEmpty ? null : search.trim(),
        instanceName: instanceName,
      ),
    );
    return _nextcloudPage(serverId, response);
  }

  Future<NextcloudFileListPage> listNextcloudFavorites(
    String serverId, {
    int page = 1,
    int pageSize = 50,
    String instanceName = '',
  }) async {
    final response = await _api.nextcloudProvider.listFavorites(
      nextcloud.ListFavoritesRequest(
        serverId: serverId,
        page: Int64(page),
        pageSize: pageSize,
        instanceName: instanceName,
      ),
    );
    return _nextcloudPage(serverId, response);
  }

  NextcloudFileListPage _nextcloudPage(
    String serverId,
    nextcloud.ListResponse response,
  ) => NextcloudFileListPage(
    items: response.content
        .map(
          (item) => NextcloudFileItemInfo(
            name: item.name,
            path: item.path,
            fileId: item.fileId.toInt(),
            isDir: item.isDir,
            size: item.size.toInt(),
            modifiedAt: item.modifiedAt,
            contentType: item.contentType,
            etag: item.etag,
            permissions: item.permissions,
            ownerId: item.ownerId,
            ownerDisplayName: item.ownerDisplayName,
            favorite: item.favorite,
            hasPreview: item.hasPreview,
            blurhash: item.blurhash,
            width: item.hasWidth() ? item.width : null,
            height: item.hasHeight() ? item.height : null,
            durationMillis: item.hasDurationMillis()
                ? item.durationMillis.toInt()
                : null,
            previewUrl: item.hasPreview
                ? _nextcloudPreviewUrl(serverId, item.fileId.toInt())
                : '',
            source: item.source.deepCopy(),
          ),
        )
        .toList(),
    total: response.hasTotal() ? response.total.toInt() : null,
    page: response.page.toInt(),
    hasMore: response.hasMore,
    source: response.hasSource() ? response.source.deepCopy() : null,
  );

  String _nextcloudPreviewUrl(String serverId, int fileId) {
    final query = Uri(
      queryParameters: {
        'serverId': serverId,
        'fileId': '$fileId',
        'width': '640',
        'height': '360',
        'crop': 'true',
      },
    ).query;
    return _api.resolveResourceUrl('/api/providers/nextcloud/preview?$query');
  }

  Future<SeafileBindInfo> loginSeafile({
    required String endpoint,
    required String username,
    required String password,
    String instanceName = '',
  }) async {
    final response = await _api.seafileProvider.login(
      seafile.LoginRequest(
        endpoint: endpoint.trim(),
        username: username.trim(),
        password: password,
        instanceName: instanceName,
      ),
    );
    return SeafileBindInfo(
      id: '',
      serverId: response.serverId,
      endpoint: endpoint.trim(),
      username: response.email,
      version: response.version,
      features: response.features,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<void> unlockSeafileLibrary(
    String serverId,
    String repositoryId,
    String password, {
    String instanceName = '',
  }) async {
    await _api.seafileProvider.unlockLibrary(
      seafile.UnlockLibraryRequest(
        serverId: serverId,
        repositoryId: repositoryId,
        password: password,
        instanceName: instanceName,
      ),
    );
  }

  Future<void> logoutSeafile(String serverId) async {
    await _api.seafileProvider.logout(
      seafile.LogoutRequest(serverId: serverId),
    );
  }

  Future<List<SeafileBindInfo>> getSeafileBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.seafileProvider.getBinds(
      seafile.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds
        .map(
          (bind) => SeafileBindInfo(
            id: bind.id,
            serverId: bind.serverId,
            endpoint: bind.endpoint,
            username: bind.username,
            version: bind.version,
            features: bind.features,
            createdAt: bind.createdAt.toInt(),
            providerInstanceName: bind.providerInstanceName,
          ),
        )
        .toList();
  }

  Future<List<SeafileBindInfo>> getAllSeafileBindInfos() async {
    final instances = await _availableInstanceNames('seafile');
    final lists = await Future.wait(
      _withDefaultInstance(
        instances,
      ).map((instanceName) => getSeafileBindInfos(instanceName: instanceName)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<SeafileFileListPage> listSeafileRepositories(
    String serverId, {
    int page = 1,
    int pageSize = 50,
    String instanceName = '',
  }) async => _seafilePage(
    serverId,
    await _api.seafileProvider.listRepositories(
      seafile.ListRepositoriesRequest(
        serverId: serverId,
        page: Int64(page),
        pageSize: pageSize,
        instanceName: instanceName,
      ),
    ),
  );

  Future<SeafileFileListPage> listSeafileFiles(
    String serverId,
    String repositoryId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) async => _seafilePage(
    serverId,
    await _api.seafileProvider.list(
      seafile.ListRequest(
        serverId: serverId,
        repositoryId: repositoryId,
        path: path,
        page: Int64(page),
        pageSize: pageSize,
        search: search.trim().isEmpty ? null : search.trim(),
        instanceName: instanceName,
      ),
    ),
  );

  Future<SeafileFileListPage> listSeafileStarred(
    String serverId, {
    int page = 1,
    int pageSize = 50,
    String instanceName = '',
  }) async => _seafilePage(
    serverId,
    await _api.seafileProvider.listStarred(
      seafile.ListStarredRequest(
        serverId: serverId,
        page: Int64(page),
        pageSize: pageSize,
        instanceName: instanceName,
      ),
    ),
  );

  SeafileFileListPage _seafilePage(
    String serverId,
    seafile.ListResponse response,
  ) => SeafileFileListPage(
    items: response.content.map((item) {
      final thumbnailUrl = item.hasThumbnail
          ? _seafileThumbnailUrl(serverId, item.repositoryId, item.path)
          : '';
      return SeafileFileItemInfo(
        repositoryId: item.repositoryId,
        repositoryName: item.repositoryName,
        path: item.path,
        name: item.name,
        objectId: item.objectId,
        isDir: item.isDir,
        size: item.size.toInt(),
        modifiedAt: item.modifiedAt,
        permission: item.permission,
        modifierName: item.modifierName,
        starred: item.starred,
        hasThumbnail: item.hasThumbnail,
        repositoryEncrypted: item.repositoryEncrypted,
        passwordRequired: item.passwordRequired,
        thumbnailUrl: thumbnailUrl,
        source: item.source.deepCopy(),
      );
    }).toList(),
    total: response.total.toInt(),
    page: response.page.toInt(),
    hasMore: response.hasMore,
    source: response.hasSource() ? response.source.deepCopy() : null,
  );

  String _seafileThumbnailUrl(
    String serverId,
    String repositoryId,
    String path,
  ) {
    final query = Uri(
      queryParameters: {
        'serverId': serverId,
        'repositoryId': repositoryId,
        'path': path,
        'size': '640',
      },
    ).query;
    return _api.resolveResourceUrl('/api/providers/seafile/thumbnail?$query');
  }

  Future<TrueNasBindInfo> loginTrueNas({
    required String endpoint,
    required String apiKey,
    String instanceName = '',
  }) async {
    final response = await _api.trueNasProvider.login(
      truenas.LoginRequest(
        endpoint: endpoint.trim(),
        apiKey: apiKey.trim(),
        instanceName: instanceName,
      ),
    );
    return TrueNasBindInfo(
      id: '',
      serverId: response.serverId,
      endpoint: endpoint.trim(),
      hostname: response.hostname,
      version: response.version,
      systemProduct: response.systemProduct,
      createdAt: 0,
      providerInstanceName: instanceName,
    );
  }

  Future<void> logoutTrueNas(String serverId) async {
    await _api.trueNasProvider.logout(
      truenas.LogoutRequest(serverId: serverId),
    );
  }

  Future<List<TrueNasBindInfo>> getTrueNasBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.trueNasProvider.getBinds(
      truenas.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds
        .map(
          (bind) => TrueNasBindInfo(
            id: bind.id,
            serverId: bind.serverId,
            endpoint: bind.endpoint,
            hostname: bind.hostname,
            version: bind.version,
            systemProduct: bind.systemProduct,
            createdAt: bind.createdAt.toInt(),
            providerInstanceName: bind.providerInstanceName,
          ),
        )
        .toList();
  }

  Future<List<TrueNasBindInfo>> getAllTrueNasBindInfos() async {
    final instances = await _availableInstanceNames('truenas');
    final lists = await Future.wait(
      _withDefaultInstance(instances)
          .map((name) => getTrueNasBindInfos(instanceName: name)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<TrueNasFileListPage> listTrueNasFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) async {
    final response = await _api.trueNasProvider.list(
      truenas.ListRequest(
        serverId: serverId,
        path: path,
        page: Int64(page),
        pageSize: pageSize,
        search: search.trim().isEmpty ? null : search.trim(),
        instanceName: instanceName,
      ),
    );
    return TrueNasFileListPage(
      items: response.content
          .map(
            (item) => TrueNasFileItemInfo(
              name: item.name,
              path: item.path,
              realpath: item.realpath,
              isDir: item.isDir,
              size: item.size.toInt(),
              allocationSize: item.allocationSize.toInt(),
              mode: item.mode,
              uid: item.uid,
              gid: item.gid,
              mountId: item.mountId.toInt(),
              acl: item.acl,
              isMountpoint: item.isMountpoint,
              isControlDirectory: item.isCtldir,
              attributes: List.unmodifiable(item.attributes),
              extendedAttributes: List.unmodifiable(item.xattrs),
              zfsAttributes: List.unmodifiable(item.zfsAttributes),
              source: item.source.deepCopy(),
            ),
          )
          .toList(),
      total: response.total.toInt(),
      page: response.page.toInt(),
      hasMore: response.hasMore,
      source: response.hasSource() ? response.source.deepCopy() : null,
    );
  }

  Future<void> logoutSynology(String serverId) async {
    await _api.synologyProvider.logout(
      synology.LogoutRequest(serverId: serverId),
    );
  }

  Future<List<SynologyBindInfo>> getSynologyBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.synologyProvider.getBinds(
      synology.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds.map(_synologyBindFromProto).toList();
  }

  Future<List<SynologyBindInfo>> getAllSynologyBindInfos() async {
    final instances = await _availableInstanceNames('synology');
    final lists = await Future.wait(
      _withDefaultInstance(
        instances,
      ).map((instanceName) => getSynologyBindInfos(instanceName: instanceName)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<SynologyFileListPage> listSynologyFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) async {
    final response = await _api.synologyProvider.listFiles(
      synology.ListFilesRequest(
        serverId: serverId,
        path: path,
        page: Int64(page),
        pageSize: pageSize,
        search: search.trim().isEmpty ? null : search.trim(),
        instanceName: instanceName,
      ),
    );
    return SynologyFileListPage(
      items: response.items
          .map(
            (item) => SynologyFileItemInfo(
              name: item.name,
              path: item.path,
              isDir: item.isDir,
              size: item.size.toInt(),
              modifiedAt: item.modifiedAt.toInt(),
              createdAt: item.createdAt.toInt(),
              fileType: item.fileType,
              thumbnailUrl: item.isDir
                  ? ''
                  : _synologyFileImageUrl(serverId, item.path),
              source: item.source.deepCopy(),
            ),
          )
          .toList(),
      total: response.total.toInt(),
      page: response.page.toInt(),
      hasMore: response.hasMore,
      source: response.hasSource() ? response.source.deepCopy() : null,
    );
  }

  Future<List<SynologyVideoLibraryInfo>> listSynologyLibraries(
    String serverId, {
    String instanceName = '',
  }) async {
    final response = await _api.synologyProvider.listLibraries(
      synology.ListLibrariesRequest(
        serverId: serverId,
        instanceName: instanceName,
      ),
    );
    return response.libraries
        .map(
          (library) => SynologyVideoLibraryInfo(
            id: library.id.toInt(),
            title: library.title,
            type: library.libraryType,
            isPublic: library.isPublic,
            visible: library.visible,
          ),
        )
        .toList();
  }

  Future<SynologyVideoListPage> listSynologyVideos(
    String serverId, {
    required SynologyVideoCollection collection,
    required int libraryId,
    int? tvShowId,
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) async {
    final normalizedSearch = search.trim().isEmpty ? null : search.trim();
    final response = switch (collection) {
      SynologyVideoCollection.movies => _api.synologyProvider.listMovies(
        synology.ListMoviesRequest(
          serverId: serverId,
          libraryId: Int64(libraryId),
          page: Int64(page),
          pageSize: pageSize,
          search: normalizedSearch,
          instanceName: instanceName,
        ),
      ),
      SynologyVideoCollection.tvShows => _api.synologyProvider.listTvShows(
        synology.ListTvShowsRequest(
          serverId: serverId,
          libraryId: Int64(libraryId),
          page: Int64(page),
          pageSize: pageSize,
          search: normalizedSearch,
          instanceName: instanceName,
        ),
      ),
      SynologyVideoCollection.episodes => _api.synologyProvider.listEpisodes(
        synology.ListEpisodesRequest(
          serverId: serverId,
          libraryId: Int64(libraryId),
          tvShowId: Int64(tvShowId ?? 0),
          page: Int64(page),
          pageSize: pageSize,
          search: normalizedSearch,
          instanceName: instanceName,
        ),
      ),
      SynologyVideoCollection.homeVideos =>
        _api.synologyProvider.listHomeVideos(
          synology.ListHomeVideosRequest(
            serverId: serverId,
            libraryId: Int64(libraryId),
            page: Int64(page),
            pageSize: pageSize,
            search: normalizedSearch,
            instanceName: instanceName,
          ),
        ),
      SynologyVideoCollection.tvRecordings =>
        _api.synologyProvider.listTvRecordings(
          synology.ListTvRecordingsRequest(
            serverId: serverId,
            libraryId: Int64(libraryId),
            page: Int64(page),
            pageSize: pageSize,
            search: normalizedSearch,
            instanceName: instanceName,
          ),
        ),
    };
    final result = await response;
    return SynologyVideoListPage(
      items: result.items
          .map((item) => _synologyVideoFromProto(serverId, item))
          .toList(),
      total: result.total.toInt(),
      page: result.page.toInt(),
      hasMore: result.hasMore,
      source: result.hasSource() ? result.source.deepCopy() : null,
    );
  }

  String _synologyFileImageUrl(String serverId, String path) {
    final query = Uri(
      queryParameters: {
        'kind': 'file',
        'serverId': serverId,
        'path': path,
        'size': 'medium',
      },
    ).query;
    return _api.resolveResourceUrl('/api/providers/synology/image?$query');
  }

  String _synologyPosterUrl(
    String serverId,
    synology.VideoItem item,
    String mediaType,
  ) {
    final query = Uri(
      queryParameters: {
        'kind': 'poster',
        'serverId': serverId,
        'itemId': item.id.toString(),
        'mediaType': mediaType,
        if (item.hasPosterMtime()) 'posterMtime': item.posterMtime,
      },
    ).query;
    return _api.resolveResourceUrl('/api/providers/synology/image?$query');
  }

  String _qnapThumbnailUrl(String serverId, String path) {
    final query = Uri(
      queryParameters: {'serverId': serverId, 'path': path, 'size': '320'},
    ).query;
    return _api.resolveResourceUrl('/api/providers/qnap/thumbnail?$query');
  }

  Future<List<TwitchBindInfo>> getTwitchBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.twitchProvider.getBinds(
      twitch.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds
        .map(
          (bind) => TwitchBindInfo(
            id: bind.id,
            serverId: bind.serverId,
            login: bind.login,
            twitchUserId: bind.twitchUserId,
            clientId: bind.clientId,
            scopes: bind.scopes,
            createdAt: bind.createdAt.toInt(),
            providerInstanceName: bind.providerInstanceName,
          ),
        )
        .toList();
  }

  Future<List<TwitchBindInfo>> getAllTwitchBindInfos() async {
    final instances = await _availableInstanceNames('twitch');
    final lists = await Future.wait(
      _withDefaultInstance(
        instances,
      ).map((instanceName) => getTwitchBindInfos(instanceName: instanceName)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<List<YoutubeBindInfo>> getYoutubeBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.youtubeProvider.getBinds(
      youtube.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds
        .map(
          (bind) => YoutubeBindInfo(
            id: bind.id,
            serverId: bind.serverId,
            label: bind.label,
            hasVisitorData: bind.hasVisitorData,
            hasPoToken: bind.hasPoToken,
            hasCookie: bind.hasCookie,
            createdAt: bind.createdAt.toInt(),
            providerInstanceName: bind.providerInstanceName,
          ),
        )
        .toList();
  }

  Future<List<YoutubeBindInfo>> getAllYoutubeBindInfos() async {
    final instances = await _availableInstanceNames('youtube');
    final lists = await Future.wait(
      _withDefaultInstance(
        instances,
      ).map((instanceName) => getYoutubeBindInfos(instanceName: instanceName)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<List<DouyinBindInfo>> getDouyinBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.douyinProvider.getBinds(
      douyin.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds
        .map(
          (bind) => DouyinBindInfo(
            id: bind.id,
            serverId: bind.serverId,
            label: bind.label,
            hasCookie: bind.hasCookie,
            createdAt: bind.createdAt.toInt(),
            providerInstanceName: bind.providerInstanceName,
          ),
        )
        .toList();
  }

  Future<List<DouyinBindInfo>> getAllDouyinBindInfos() async {
    final instances = await _availableInstanceNames('douyin');
    final lists = await Future.wait(
      _withDefaultInstance(
        instances,
      ).map((instanceName) => getDouyinBindInfos(instanceName: instanceName)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<List<TikTokBindInfo>> getTikTokBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.tiktokProvider.getBinds(
      tiktok.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds
        .map(
          (bind) => TikTokBindInfo(
            id: bind.id,
            serverId: bind.serverId,
            label: bind.label,
            hasCookie: bind.hasCookie,
            createdAt: bind.createdAt.toInt(),
            providerInstanceName: bind.providerInstanceName,
          ),
        )
        .toList();
  }

  Future<List<TikTokBindInfo>> getAllTikTokBindInfos() async {
    final instances = await _availableInstanceNames('tiktok');
    final lists = await Future.wait(
      _withDefaultInstance(
        instances,
      ).map((instanceName) => getTikTokBindInfos(instanceName: instanceName)),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<void> logoutEmby(String serverId) {
    return _api.embyProvider.logout(emby.LogoutRequest(serverId: serverId));
  }

  Future<void> logoutBilibili() async {
    await _api.bilibiliProvider.logout(bilibili.LogoutRequest());
  }

  Future<BilibiliAccountInfo> getBilibiliAccount({
    String instanceName = '',
  }) async {
    final response = await _api.bilibiliProvider.getUserInfo(
      bilibili.UserInfoRequest(instanceName: instanceName),
    );
    return BilibiliAccountInfo(
      isLogin: response.isLogin,
      userId: response.userId.toInt(),
      username: response.username,
      face: response.face,
      isVip: response.isVip,
    );
  }

  Future<List<BilibiliFavoriteFolderInfo>> listBilibiliFavoriteFolders({
    String instanceName = '',
    bool shared = false,
  }) async {
    final response = await _api.bilibiliProvider.listFavoriteFolders(
      bilibili.ListFavoriteFoldersRequest(
        instanceName: instanceName,
        shared: shared,
      ),
    );
    return response.folders
        .where((folder) => folder.hasSource())
        .map(
          (folder) => BilibiliFavoriteFolderInfo(
            mediaId: folder.mediaId.toInt(),
            title: folder.title,
            mediaCount: folder.mediaCount.toInt(),
            isPrivate: folder.private,
            isDefault: folder.defaultFolder,
            source: folder.source.deepCopy(),
          ),
        )
        .toList();
  }

  Future<BilibiliFollowedPgcPage> listBilibiliFollowedPgc({
    required bool cinema,
    int page = 1,
    int pageSize = 30,
    String instanceName = '',
    bool shared = false,
  }) async {
    final response = await _api.bilibiliProvider.listFollowedPgc(
      bilibili.ListFollowedPgcRequest(
        instanceName: instanceName,
        type: cinema
            ? bilibili_enum.PgcFollowType.PGC_FOLLOW_TYPE_CINEMA
            : bilibili_enum.PgcFollowType.PGC_FOLLOW_TYPE_ANIME,
        page: Int64(page),
        pageSize: pageSize,
        shared: shared,
      ),
    );
    return BilibiliFollowedPgcPage(
      items: response.seasons
          .where((season) => season.hasSource())
          .map(
            (season) => BilibiliFollowedPgcInfo(
              seasonId: season.seasonId.toInt(),
              title: season.title,
              cover: season.cover,
              description: season.description,
              latestEpisode: season.latestEpisode,
              source: season.source.deepCopy(),
            ),
          )
          .toList(),
      total: response.total.toInt(),
      hasMore: response.hasMore,
    );
  }

  Future<bilibili.ListHistoryResponse> listBilibiliHistory({
    source_enum.BilibiliHistoryType type =
        source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_ALL,
    String? cursor,
    int pageSize = 30,
    String instanceName = '',
    bool shared = false,
  }) => _api.bilibiliProvider.listHistory(
    bilibili.ListHistoryRequest(
      type: type,
      cursor: cursor,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    ),
  );

  Future<BilibiliPgcTimelineInfo> listBilibiliPgcTimeline({
    required BilibiliPgcTimelineKind type,
    int beforeDays = 3,
    int afterDays = 7,
    String instanceName = '',
    bool shared = false,
  }) async {
    final response = await _api.bilibiliProvider.listPgcTimeline(
      bilibili.ListPgcTimelineRequest(
        type: switch (type) {
          BilibiliPgcTimelineKind.anime =>
            source_enum
                .BilibiliPgcTimelineType
                .BILIBILI_PGC_TIMELINE_TYPE_ANIME,
          BilibiliPgcTimelineKind.cinema =>
            source_enum
                .BilibiliPgcTimelineType
                .BILIBILI_PGC_TIMELINE_TYPE_CINEMA,
          BilibiliPgcTimelineKind.guochuang =>
            source_enum
                .BilibiliPgcTimelineType
                .BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG,
        },
        beforeDays: beforeDays,
        afterDays: afterDays,
        instanceName: instanceName,
        shared: shared,
      ),
    );
    return BilibiliPgcTimelineInfo(
      items: response.items
          .map(
            (item) => BilibiliPgcTimelineItemInfo(
              episodeId: item.episodeId.toInt(),
              seasonId: item.seasonId.toInt(),
              title: item.title,
              episodeTitle: item.episodeTitle,
              cover: item.cover,
              episodeCover: item.episodeCover,
              publishAt: item.publishAt.toInt(),
              published: item.published,
              date: item.date,
              dayOfWeek: item.dayOfWeek,
              delayed: item.delayed,
              delayReason: item.delayReason,
              source: item.hasSource() ? item.source.deepCopy() : null,
            ),
          )
          .toList(),
      source: response.source.deepCopy(),
    );
  }

  Future<BilibiliPgcSeasonPage> listBilibiliPgcSeasons({
    required BilibiliPgcSeasonKind type,
    int page = 1,
    int pageSize = 30,
    BilibiliPgcSeasonOrder order = BilibiliPgcSeasonOrder.updated,
    bool ascending = false,
    bool? finished,
    String? area,
    String? year,
    int? styleId,
    String instanceName = '',
    bool shared = false,
  }) async {
    final response = await _api.bilibiliProvider.listPgcSeasons(
      bilibili.ListPgcSeasonsRequest(
        type: switch (type) {
          BilibiliPgcSeasonKind.anime =>
            bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_ANIME,
          BilibiliPgcSeasonKind.movie =>
            bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_MOVIE,
          BilibiliPgcSeasonKind.documentary =>
            bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_DOCUMENTARY,
          BilibiliPgcSeasonKind.guochuang =>
            bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_GUOCHUANG,
          BilibiliPgcSeasonKind.tv =>
            bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_TV,
          BilibiliPgcSeasonKind.variety =>
            bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_VARIETY,
        },
        page: Int64(page),
        pageSize: pageSize,
        order: switch (order) {
          BilibiliPgcSeasonOrder.updated =>
            bilibili_enum.PgcSeasonOrder.PGC_SEASON_ORDER_UPDATED,
          BilibiliPgcSeasonOrder.danmaku =>
            bilibili_enum.PgcSeasonOrder.PGC_SEASON_ORDER_DANMAKU,
          BilibiliPgcSeasonOrder.play =>
            bilibili_enum.PgcSeasonOrder.PGC_SEASON_ORDER_PLAY,
          BilibiliPgcSeasonOrder.follow =>
            bilibili_enum.PgcSeasonOrder.PGC_SEASON_ORDER_FOLLOW,
          BilibiliPgcSeasonOrder.score =>
            bilibili_enum.PgcSeasonOrder.PGC_SEASON_ORDER_SCORE,
          BilibiliPgcSeasonOrder.started =>
            bilibili_enum.PgcSeasonOrder.PGC_SEASON_ORDER_STARTED,
          BilibiliPgcSeasonOrder.released =>
            bilibili_enum.PgcSeasonOrder.PGC_SEASON_ORDER_RELEASED,
        },
        ascending: ascending,
        finished: finished,
        area: area,
        year: year,
        styleId: styleId == null ? null : Int64(styleId),
        instanceName: instanceName,
        shared: shared,
      ),
    );
    return BilibiliPgcSeasonPage(
      items: response.seasons
          .where((season) => season.hasSource())
          .map(
            (season) => BilibiliPgcSeasonInfo(
              seasonId: season.seasonId.toInt(),
              mediaId: season.mediaId.toInt(),
              firstEpisodeId: season.firstEpisodeId.toInt(),
              title: season.title,
              subtitle: season.subtitle,
              cover: season.cover,
              firstEpisodeCover: season.firstEpisodeCover,
              badge: season.badge,
              progress: season.progress,
              score: season.score,
              finished: season.finished,
              type: switch (season.type) {
                bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_MOVIE =>
                  BilibiliPgcSeasonKind.movie,
                bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_DOCUMENTARY =>
                  BilibiliPgcSeasonKind.documentary,
                bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_GUOCHUANG =>
                  BilibiliPgcSeasonKind.guochuang,
                bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_TV =>
                  BilibiliPgcSeasonKind.tv,
                bilibili_enum.PgcSeasonType.PGC_SEASON_TYPE_VARIETY =>
                  BilibiliPgcSeasonKind.variety,
                _ => BilibiliPgcSeasonKind.anime,
              },
              source: season.source.deepCopy(),
            ),
          )
          .toList(),
      total: response.total.toInt(),
      hasMore: response.hasMore,
    );
  }

  Future<List<BilibiliLiveAreaInfo>> listBilibiliLiveAreas({
    String instanceName = '',
    bool shared = false,
  }) async {
    final response = await _api.bilibiliProvider.listLiveAreas(
      bilibili.ListLiveAreasRequest(instanceName: instanceName, shared: shared),
    );
    return response.areas
        .map(
          (area) => BilibiliLiveAreaInfo(
            id: area.id.toInt(),
            parentId: area.parentId.toInt(),
            name: area.name,
            parentName: area.parentName,
            picture: area.picture,
            hot: area.hot,
            source: area.source.deepCopy(),
          ),
        )
        .toList();
  }

  Future<BilibiliQrLoginInfo> startBilibiliQrLogin({
    String instanceName = '',
  }) async {
    final response = await _api.bilibiliProvider.loginQR(
      bilibili.LoginQRRequest(instanceName: instanceName),
    );
    return BilibiliQrLoginInfo(url: response.url, key: response.key);
  }

  Future<bilibili_enum.QRLoginStatus> checkBilibiliQrLogin(
    String key, {
    String instanceName = '',
  }) async {
    final response = await _api.bilibiliProvider.checkQR(
      bilibili.CheckQRRequest(key: key, instanceName: instanceName),
    );
    return response.status;
  }

  Future<BilibiliSmsLoginInfo> startBilibiliSmsLogin({
    String instanceName = '',
  }) async {
    final response = await _api.bilibiliProvider.startSMSLogin(
      bilibili.StartSMSLoginRequest(instanceName: instanceName),
    );
    return BilibiliSmsLoginInfo(
      sessionToken: response.sessionToken,
      gt: response.gt,
      challenge: response.challenge,
      expiresAt: response.expiresAt.toInt(),
    );
  }

  Future<BilibiliSmsLoginInfo> sendBilibiliSms({
    required BilibiliSmsLoginInfo session,
    required String phone,
    required String validate,
  }) async {
    final response = await _api.bilibiliProvider.sendSMS(
      bilibili.SendSMSRequest(
        sessionToken: session.sessionToken,
        phone: phone,
        validate: validate,
      ),
    );
    return session.copyWith(
      sessionToken: response.sessionToken,
      expiresAt: response.expiresAt.toInt(),
    );
  }

  Future<void> loginBilibiliSms({
    required String sessionToken,
    required String code,
  }) async {
    await _api.bilibiliProvider.loginSMS(
      bilibili.LoginSMSRequest(sessionToken: sessionToken, code: code),
    );
  }

  Future<List<AlistBindInfo>> getAlistBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.alistProvider.getBinds(
      alist.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds.map(_alistBindFromProto).toList();
  }

  Future<List<AlistBindInfo>> getAllAlistBindInfos() async {
    final instances = await _availableInstanceNames('alist');
    final lists = await Future.wait(
      _withDefaultInstance(instances).map((instanceName) {
        return getAlistBindInfos(instanceName: instanceName);
      }),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<List<EmbyBindInfo>> getEmbyBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.embyProvider.getBinds(
      emby.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds.map(_embyBindFromProto).toList();
  }

  Future<List<CloudreveBindInfo>> getCloudreveBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.cloudreveProvider.getBinds(
      cloudreve.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds
        .map(
          (bind) => CloudreveBindInfo(
            id: bind.id,
            serverId: bind.serverId,
            host: bind.host,
            email: bind.email,
            createdAt: bind.createdAt.toInt(),
            providerInstanceName: bind.providerInstanceName,
          ),
        )
        .toList();
  }

  Future<List<CloudreveBindInfo>> getAllCloudreveBindInfos() async {
    final instances = await _availableInstanceNames('cloudreve');
    final lists = await Future.wait(
      _withDefaultInstance(instances).map(
        (instanceName) => getCloudreveBindInfos(instanceName: instanceName),
      ),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<List<EmbyBindInfo>> getAllEmbyBindInfos() async {
    final instances = await _availableInstanceNames('emby');
    final lists = await Future.wait(
      _withDefaultInstance(instances).map((instanceName) {
        return getEmbyBindInfos(instanceName: instanceName);
      }),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<List<BilibiliBindInfo>> getBilibiliBindInfos({
    String instanceName = '',
  }) async {
    final response = await _api.bilibiliProvider.getBinds(
      bilibili.GetBindsRequest(instanceName: instanceName),
    );
    return response.binds.map(_bilibiliBindFromProto).toList();
  }

  Future<List<BilibiliBindInfo>> getAllBilibiliBindInfos() async {
    final instances = await _availableInstanceNames('bilibili');
    final lists = await Future.wait(
      _withDefaultInstance(instances).map((instanceName) {
        return getBilibiliBindInfos(instanceName: instanceName);
      }),
    );
    return _dedupeBy(
      lists.expand((list) => list),
      (bind) => '${bind.providerInstanceName}\u0000${bind.serverId}',
    );
  }

  Future<AlistAccountInfo> getAlistAccount(
    String serverId, {
    String instanceName = '',
  }) async {
    final response = await _api.alistProvider.getMe(
      alist.GetMeRequest(serverId: serverId, instanceName: instanceName),
    );
    return AlistAccountInfo(
      username: response.username,
      basePath: response.basePath,
    );
  }

  Future<EmbyAccountInfo> getEmbyAccount(
    String serverId, {
    String instanceName = '',
  }) async {
    final response = await _api.embyProvider.getMe(
      emby.GetMeRequest(serverId: serverId, instanceName: instanceName),
    );
    return EmbyAccountInfo(id: response.id, name: response.name);
  }

  Future<CloudreveAccountInfo> getCloudreveAccount(
    String serverId, {
    String instanceName = '',
  }) async {
    final response = await _api.cloudreveProvider.getMe(
      cloudreve.GetMeRequest(serverId: serverId, instanceName: instanceName),
    );
    return CloudreveAccountInfo(
      id: response.id,
      email: response.email,
      nickname: response.nickname,
    );
  }

  Future<BilibiliParseInfo> parseBilibiliInfo(
    String url, {
    String instanceName = '',
    bool shared = false,
  }) async {
    final request = bilibili.ParseRequest(url: url, instanceName: instanceName);
    if (shared) request.shared = true;
    final response = await _api.bilibiliProvider.parse(request);
    return _bilibiliParseFromProto(response);
  }

  Future<BilibiliPlaylistListPage> listBilibiliPlaylist(
    BilibiliPlaylistListIntent intent, {
    int page = 1,
    int pageSize = 30,
    String? cursor,
    String search = '',
    String instanceName = '',
    bool shared = false,
  }) async {
    final response = await _api.bilibiliProvider.listPlaylist(
      bilibili.ListPlaylistRequest(
        intent: _bilibiliPlaylistIntentToProto(intent),
        page: Int64(page),
        pageSize: pageSize,
        cursor: cursor,
        search: search,
        instanceName: instanceName,
        shared: shared,
      ),
    );
    return BilibiliPlaylistListPage(
      items: [
        for (final item in response.items)
          BilibiliPlaylistListItemInfo(
            id: item.id,
            title: item.title,
            description: item.description,
            cover: item.cover,
            isContainer: item.isContainer,
            source: item.source.deepCopy(),
            browse: item.hasBrowse()
                ? _bilibiliPlaylistIntentFromProto(item.browse)
                : null,
          ),
      ],
      hasMore: response.hasMore,
      page: response.page.toInt(),
      cursor: response.hasCursor() ? response.cursor : null,
      source: response.source.deepCopy(),
    );
  }

  bilibili.PlaylistListIntent _bilibiliPlaylistIntentToProto(
    BilibiliPlaylistListIntent intent,
  ) => bilibili.PlaylistListIntent(
    mode: switch (intent.mode) {
      BilibiliPlaylistListMode.popular =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_POPULAR,
      BilibiliPlaylistListMode.recommended =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_RECOMMENDED,
      BilibiliPlaylistListMode.videoParts =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_VIDEO_PARTS,
      BilibiliPlaylistListMode.upVideos =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_UP_VIDEOS,
      BilibiliPlaylistListMode.favoriteVideos =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_FAVORITE_VIDEOS,
      BilibiliPlaylistListMode.collectionVideos =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_COLLECTION_VIDEOS,
      BilibiliPlaylistListMode.seriesVideos =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_SERIES_VIDEOS,
      BilibiliPlaylistListMode.watchLater =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_WATCH_LATER,
      BilibiliPlaylistListMode.pgcSeason =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_PGC_SEASON,
      BilibiliPlaylistListMode.liveRecommended =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_LIVE_RECOMMENDED,
      BilibiliPlaylistListMode.liveFollowed =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_LIVE_FOLLOWED,
      BilibiliPlaylistListMode.liveArea =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_LIVE_AREA,
      BilibiliPlaylistListMode.history =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_HISTORY,
      BilibiliPlaylistListMode.pgcTimeline =>
        bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_PGC_TIMELINE,
    },
    bvid: intent.bvid,
    aid: intent.aid == null ? null : Int64(intent.aid!),
    mid: Int64(intent.mid),
    keyword: intent.keyword,
    mediaId: Int64(intent.mediaId),
    seasonId: Int64(intent.seasonId),
    seriesId: Int64(intent.seriesId),
    parentAreaId: Int64(intent.parentAreaId),
    areaId: Int64(intent.areaId),
    historyType: switch (intent.historyType) {
      BilibiliPlaylistHistoryType.all =>
        source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_ALL,
      BilibiliPlaylistHistoryType.archive =>
        source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_ARCHIVE,
      BilibiliPlaylistHistoryType.live =>
        source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_LIVE,
    },
    timelineType: switch (intent.timelineType) {
      BilibiliPgcTimelineKind.anime =>
        source_enum.BilibiliPgcTimelineType.BILIBILI_PGC_TIMELINE_TYPE_ANIME,
      BilibiliPgcTimelineKind.cinema =>
        source_enum.BilibiliPgcTimelineType.BILIBILI_PGC_TIMELINE_TYPE_CINEMA,
      BilibiliPgcTimelineKind.guochuang =>
        source_enum
            .BilibiliPgcTimelineType
            .BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG,
    },
    beforeDays: intent.beforeDays,
    afterDays: intent.afterDays,
  );

  BilibiliPlaylistListIntent _bilibiliPlaylistIntentFromProto(
    bilibili.PlaylistListIntent intent,
  ) => BilibiliPlaylistListIntent(
    mode: switch (intent.mode) {
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_POPULAR =>
        BilibiliPlaylistListMode.popular,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_RECOMMENDED =>
        BilibiliPlaylistListMode.recommended,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_VIDEO_PARTS =>
        BilibiliPlaylistListMode.videoParts,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_UP_VIDEOS =>
        BilibiliPlaylistListMode.upVideos,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_FAVORITE_VIDEOS =>
        BilibiliPlaylistListMode.favoriteVideos,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_COLLECTION_VIDEOS =>
        BilibiliPlaylistListMode.collectionVideos,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_SERIES_VIDEOS =>
        BilibiliPlaylistListMode.seriesVideos,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_WATCH_LATER =>
        BilibiliPlaylistListMode.watchLater,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_PGC_SEASON =>
        BilibiliPlaylistListMode.pgcSeason,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_LIVE_RECOMMENDED =>
        BilibiliPlaylistListMode.liveRecommended,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_LIVE_FOLLOWED =>
        BilibiliPlaylistListMode.liveFollowed,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_LIVE_AREA =>
        BilibiliPlaylistListMode.liveArea,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_HISTORY =>
        BilibiliPlaylistListMode.history,
      bilibili_enum.PlaylistListMode.PLAYLIST_LIST_MODE_PGC_TIMELINE =>
        BilibiliPlaylistListMode.pgcTimeline,
      _ => BilibiliPlaylistListMode.popular,
    },
    bvid: intent.bvid,
    aid: intent.hasAid() ? intent.aid.toInt() : null,
    mid: intent.mid.toInt(),
    keyword: intent.keyword,
    mediaId: intent.mediaId.toInt(),
    seasonId: intent.seasonId.toInt(),
    seriesId: intent.seriesId.toInt(),
    parentAreaId: intent.parentAreaId.toInt(),
    areaId: intent.areaId.toInt(),
    historyType: switch (intent.historyType) {
      source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_ARCHIVE =>
        BilibiliPlaylistHistoryType.archive,
      source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_LIVE =>
        BilibiliPlaylistHistoryType.live,
      _ => BilibiliPlaylistHistoryType.all,
    },
    timelineType: switch (intent.timelineType) {
      source_enum.BilibiliPgcTimelineType.BILIBILI_PGC_TIMELINE_TYPE_CINEMA =>
        BilibiliPgcTimelineKind.cinema,
      source_enum
          .BilibiliPgcTimelineType
          .BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG =>
        BilibiliPgcTimelineKind.guochuang,
      _ => BilibiliPgcTimelineKind.anime,
    },
    beforeDays: intent.beforeDays,
    afterDays: intent.afterDays,
  );

  Future<AlistListPage> listAlistPage(
    String path, {
    String? keyword,
    int page = 1,
    int max = 20,
    String password = '',
    String serverId = '',
    String instanceName = '',
  }) async {
    final resolvedServerId = serverId.trim();
    if (resolvedServerId.isEmpty) {
      throw StateError('请选择已绑定的 AList 账号');
    }
    final normalizedKeyword = keyword?.trim() ?? '';
    if (normalizedKeyword.isNotEmpty) {
      final response = await _api.alistProvider.search(
        alist.SearchRequest(
          serverId: resolvedServerId,
          parent: path,
          keywords: normalizedKeyword,
          page: Int64(page),
          perPage: Int64(max),
          password: password,
          instanceName: instanceName,
        ),
      );
      return AlistListPage(
        serverId: resolvedServerId,
        providerInstanceName: instanceName,
        items: response.content.map(_alistSearchItemFromProto).toList(),
        total: response.total.toInt(),
        source: null,
      );
    }

    final response = await _api.alistProvider.list(
      alist.ListRequest(
        serverId: resolvedServerId,
        path: path,
        page: Int64(page),
        perPage: Int64(max),
        password: password,
        instanceName: instanceName,
      ),
    );
    return AlistListPage(
      serverId: resolvedServerId,
      providerInstanceName: instanceName,
      items: response.content
          .map((item) => _alistItemFromProto(item, parentPath: path))
          .toList(),
      total: response.total.toInt(),
      source: response.hasSource() ? response.source.deepCopy() : null,
    );
  }

  Future<EmbyLoginInfo> loginEmbyInfo(
    String host,
    String username,
    String password, {
    String apiKey = '',
    bool passwordless = false,
    String instanceName = '',
  }) async {
    final hasApiKey = apiKey.trim().isNotEmpty;
    if (hasApiKey && passwordless) {
      throw ArgumentError('API Key 和无密码登录不能同时启用');
    }
    if (!hasApiKey && !passwordless && password.isEmpty) {
      throw ArgumentError.value(password, 'password', '不能为空');
    }
    final request = emby.LoginRequest(
      host: host,
      username: username,
      instanceName: instanceName,
    );
    if (hasApiKey) {
      request.apiKey = apiKey;
    } else {
      request.password = passwordless ? '' : password;
    }
    final response = await _api.embyProvider.login(request);
    return EmbyLoginInfo(
      userId: response.userId,
      username: response.username,
      isAdmin: response.isAdmin,
      serverId: response.serverId,
    );
  }

  Future<CloudreveListPage> listCloudrevePage(
    String path, {
    String? keyword,
    int page = 1,
    int max = 20,
    int? offset,
    String? cursor,
    String serverId = '',
    String instanceName = '',
  }) async {
    final resolvedServerId = serverId.trim();
    if (resolvedServerId.isEmpty) {
      throw StateError('请选择已绑定的 Cloudreve 账号');
    }
    final normalizedKeyword = keyword?.trim() ?? '';
    final Iterable<cloudreve.FileItem> items;
    final int total;
    provider_common.DiscoveredSource? source;
    var usesCursor = false;
    var nextCursor = '';
    if (normalizedKeyword.isNotEmpty) {
      final response = await _api.cloudreveProvider.search(
        cloudreve.SearchRequest(
          serverId: resolvedServerId,
          keywords: normalizedKeyword,
          offset: Int64(offset ?? (page - 1) * max),
          instanceName: instanceName,
        ),
      );
      items = response.content;
      total = response.total.toInt();
      source = null;
    } else {
      final response = await _api.cloudreveProvider.list(
        cloudreve.ListRequest(
          serverId: resolvedServerId,
          path: path,
          perPage: max,
          instanceName: instanceName,
          page: cursor == null ? cloudreve.PagePagination(page: page) : null,
          cursor: cursor == null
              ? null
              : cloudreve.CursorPagination(cursor: cursor),
        ),
      );
      items = response.content;
      source = response.hasSource() ? response.source.deepCopy() : null;
      usesCursor =
          response.whichPagination() ==
          cloudreve.ListResponse_Pagination.cursor;
      if (usesCursor) {
        nextCursor = response.cursor.cursor;
        total = -1;
      } else {
        total = response.page.total.toInt();
      }
    }
    return CloudreveListPage(
      serverId: resolvedServerId,
      providerInstanceName: instanceName,
      items: items
          .map(
            (item) => CloudreveItemInfo(
              id: item.id,
              name: item.name,
              path: item.path,
              size: item.size.toInt(),
              isDir: item.isDir,
              modified: item.modified.toInt(),
              thumbnail: item.thumbnail,
              source: item.source.deepCopy(),
            ),
          )
          .toList(),
      total: total,
      usesCursor: usesCursor,
      nextCursor: nextCursor,
      source: source,
    );
  }

  Future<EmbyListPage> listEmbyPage(
    EmbyListMode mode, {
    String targetId = '',
    List<String> itemTypes = const [],
    String? keyword,
    int page = 1,
    int max = 20,
    String serverId = '',
    String instanceName = '',
  }) async {
    final resolvedServerId = serverId.trim();
    if (resolvedServerId.isEmpty) {
      throw StateError('请选择已绑定的 Emby 账号');
    }
    final response = await _api.embyProvider.list(
      emby.ListRequest(
        serverId: resolvedServerId,
        mode: switch (mode) {
          EmbyListMode.folder => emby.ListMode.LIST_MODE_FOLDER,
          EmbyListMode.favoriteItems => emby.ListMode.LIST_MODE_FAVORITE_ITEMS,
          EmbyListMode.favoritePeople =>
            emby.ListMode.LIST_MODE_FAVORITE_PEOPLE,
          EmbyListMode.personItems => emby.ListMode.LIST_MODE_PERSON_ITEMS,
          EmbyListMode.continueWatching =>
            emby.ListMode.LIST_MODE_CONTINUE_WATCHING,
          EmbyListMode.nextUp => emby.ListMode.LIST_MODE_NEXT_UP,
          EmbyListMode.recentlyAdded => emby.ListMode.LIST_MODE_RECENTLY_ADDED,
          EmbyListMode.playlists => emby.ListMode.LIST_MODE_PLAYLISTS,
          EmbyListMode.collections => emby.ListMode.LIST_MODE_COLLECTIONS,
          EmbyListMode.genres => emby.ListMode.LIST_MODE_GENRES,
          EmbyListMode.genreItems => emby.ListMode.LIST_MODE_GENRE_ITEMS,
        },
        startIndex: Int64((page - 1) * max),
        limit: Int64(max),
        searchTerm: keyword ?? '',
        instanceName: instanceName,
        targetId: targetId,
        itemTypes: itemTypes,
      ),
    );
    return EmbyListPage(
      serverId: resolvedServerId,
      providerInstanceName: instanceName,
      items: response.items.map(_embyItemFromProto).toList(),
      total: response.total.toInt(),
      source: response.hasSource() ? response.source.deepCopy() : null,
    );
  }

  AlistBindInfo _alistBindFromProto(alist.BindInfo bind) {
    return AlistBindInfo(
      id: bind.id,
      serverId: bind.serverId,
      host: bind.host,
      username: bind.username,
      createdAt: bind.createdAt.toInt(),
      providerInstanceName: bind.providerInstanceName,
    );
  }

  EmbyBindInfo _embyBindFromProto(emby.BindInfo bind) {
    return EmbyBindInfo(
      id: bind.id,
      serverId: bind.serverId,
      host: bind.host,
      userId: bind.userId,
      createdAt: bind.createdAt.toInt(),
      providerInstanceName: bind.providerInstanceName,
    );
  }

  BilibiliBindInfo _bilibiliBindFromProto(bilibili.BindInfo bind) {
    return BilibiliBindInfo(
      id: bind.id,
      serverId: bind.serverId,
      createdAt: bind.createdAt.toInt(),
      providerInstanceName: bind.providerInstanceName,
    );
  }

  FnosBindInfo _fnosBindFromProto(fnos.BindInfo bind) {
    return FnosBindInfo(
      id: bind.id,
      serverId: bind.serverId,
      endpoint: bind.endpoint,
      webdavEndpoint: bind.webdavEndpoint,
      mediaEndpoint: bind.mediaEndpoint,
      username: bind.username,
      createdAt: bind.createdAt.toInt(),
      providerInstanceName: bind.providerInstanceName,
      mediaAvailable: bind.mediaAvailable,
    );
  }

  QnapBindInfo _qnapBindFromProto(qnap.BindInfo bind) {
    return QnapBindInfo(
      id: bind.id,
      serverId: bind.serverId,
      endpoint: bind.endpoint,
      username: bind.username,
      serverName: bind.serverName,
      version: bind.version,
      supportRtt: bind.supportRtt,
      createdAt: bind.createdAt.toInt(),
      providerInstanceName: bind.providerInstanceName,
    );
  }

  SynologyBindInfo _synologyBindFromProto(synology.BindInfo bind) {
    return SynologyBindInfo(
      id: bind.id,
      serverId: bind.serverId,
      endpoint: bind.endpoint,
      username: bind.username,
      videoStationAvailable: bind.videoStationAvailable,
      createdAt: bind.createdAt.toInt(),
      providerInstanceName: bind.providerInstanceName,
    );
  }

  SynologyVideoItemInfo _synologyVideoFromProto(
    String serverId,
    synology.VideoItem item,
  ) {
    final (type, mediaType) = switch (item.kind) {
      synology_enum.SynologyVideoEntryKind.SYNOLOGY_VIDEO_ENTRY_KIND_TV_SHOW =>
        (SynologyVideoEntryType.tvShow, 'tvshow'),
      synology_enum.SynologyVideoEntryKind.SYNOLOGY_VIDEO_ENTRY_KIND_EPISODE =>
        (SynologyVideoEntryType.episode, 'tvshow_episode'),
      synology_enum
          .SynologyVideoEntryKind
          .SYNOLOGY_VIDEO_ENTRY_KIND_HOME_VIDEO =>
        (SynologyVideoEntryType.homeVideo, 'home_video'),
      synology_enum
          .SynologyVideoEntryKind
          .SYNOLOGY_VIDEO_ENTRY_KIND_TV_RECORDING =>
        (SynologyVideoEntryType.tvRecording, 'tv_record'),
      _ => (SynologyVideoEntryType.movie, 'movie'),
    };
    return SynologyVideoItemInfo(
      id: item.id.toInt(),
      libraryId: item.libraryId.toInt(),
      type: type,
      title: item.title,
      sortTitle: item.sortTitle,
      tagline: item.tagline,
      summary: item.summary,
      certificate: item.certificate,
      rating: item.rating,
      actors: item.actors.toList(),
      directors: item.directors.toList(),
      writers: item.writers.toList(),
      genres: item.genres.toList(),
      originalAvailable: item.hasOriginalAvailable()
          ? item.originalAvailable
          : '',
      createTime: item.createTime.toInt(),
      lastWatched: item.lastWatched.toInt(),
      watchedRatio: item.watchedRatio,
      parentalControlled: item.parentalControlled,
      season: item.hasSeason() ? item.season : null,
      episode: item.hasEpisode() ? item.episode : null,
      tvShowId: item.hasTvShowId() ? item.tvShowId.toInt() : null,
      files: item.files
          .map(
            (file) => SynologyVideoFileInfo(
              id: file.id.toInt(),
              path: file.path,
              size: file.size.toInt(),
              durationSeconds: file.durationSeconds.toInt(),
              progressSeconds: file.progressSeconds.toInt(),
              width: file.width,
              height: file.height,
              videoCodec: file.videoCodec,
              audioCodec: file.audioCodec,
              container: file.container,
              videoBitrate: file.videoBitrate.toInt(),
              audioBitrate: file.audioBitrate.toInt(),
              frameRateNumerator: file.frameRateNumerator.toInt(),
              frameRateDenominator: file.frameRateDenominator.toInt(),
              audioChannels: file.audioChannels,
              audioFrequencyHz: file.audioFrequencyHz,
              conversionProduced: file.conversionProduced,
            ),
          )
          .toList(),
      posterUrl: _synologyPosterUrl(serverId, item, mediaType),
      source: item.source.deepCopy(),
    );
  }

  BilibiliParseInfo _bilibiliParseFromProto(bilibili.ParseResponse response) {
    return BilibiliParseInfo(
      normalizedUrl: response.normalizedUrl,
      candidates: response.candidates.map((candidate) {
        return BilibiliParseCandidateInfo(
          title: candidate.title,
          description: candidate.description,
          cover: candidate.cover,
          actors: candidate.actors.toList(),
          durationSeconds: candidate.hasDurationSeconds()
              ? candidate.durationSeconds.toInt()
              : null,
          partNumber: candidate.hasPartNumber() ? candidate.partNumber : null,
          width: candidate.hasWidth() ? candidate.width.toInt() : null,
          height: candidate.hasHeight() ? candidate.height.toInt() : null,
          source: candidate.source.deepCopy(),
          browse: candidate.hasBrowse()
              ? _bilibiliPlaylistIntentFromProto(candidate.browse)
              : null,
        );
      }).toList(),
    );
  }

  AlistItemInfo _alistItemFromProto(
    alist.FileItem item, {
    required String parentPath,
  }) {
    final normalizedParent = parentPath.isEmpty || parentPath == '/'
        ? ''
        : parentPath;
    final path = item.name.isEmpty
        ? normalizedParent
        : '$normalizedParent/${item.name}'.replaceFirst(RegExp(r'^//+'), '/');
    return AlistItemInfo(
      name: item.name,
      path: path.isEmpty ? '/' : path,
      size: item.size.toInt(),
      isDir: item.isDir,
      modified: item.modified.toInt(),
      thumb: item.thumb,
      type: item.type.toInt(),
      sign: item.sign,
      source: item.source.deepCopy(),
    );
  }

  AlistItemInfo _alistSearchItemFromProto(alist.SearchItem item) {
    final normalizedParent = item.parent.isEmpty || item.parent == '/'
        ? ''
        : item.parent;
    final path = item.name.isEmpty
        ? normalizedParent
        : '$normalizedParent/${item.name}'.replaceFirst(RegExp(r'^//+'), '/');
    return AlistItemInfo(
      name: item.name,
      path: path.isEmpty ? '/' : path,
      size: item.size.toInt(),
      isDir: item.isDir,
      modified: 0,
      thumb: '',
      type: item.type.toInt(),
      sign: '',
      source: item.source.deepCopy(),
    );
  }

  EmbyItemInfo _embyItemFromProto(emby.MediaItem item) {
    return EmbyItemInfo(
      id: item.id,
      name: item.name,
      type: item.type,
      isDir: item.isContainer,
      parentId: item.parentId,
      seriesName: item.seriesName,
      seriesId: item.seriesId,
      seasonName: item.seasonName,
      thumbnail: item.thumbnail.isEmpty
          ? ''
          : _api.resolveResourceUrl(item.thumbnail),
      description: item.description,
      source: item.source.deepCopy(),
    );
  }

  Future<List<String>> _availableInstanceNames(String providerType) async {
    final response = await _api.providerCommon.listAvailableProviderInstances(
      provider_common.ListAvailableProviderInstancesRequest(
        providerType: SourceConfigCodec.providerFromString(providerType),
      ),
    );
    final names = <String>[];
    for (final instance in response.instances) {
      final trimmed = instance.trim();
      if (!names.contains(trimmed)) {
        names.add(trimmed);
      }
    }
    return names;
  }

  List<String> _withDefaultInstance(List<String> instances) {
    final names = <String>[''];
    for (final instance in instances) {
      if (!names.contains(instance)) names.add(instance);
    }
    return names;
  }

  List<T> _dedupeBy<T>(Iterable<T> values, String Function(T value) keyOf) {
    final seen = <String>{};
    final result = <T>[];
    for (final value in values) {
      if (seen.add(keyOf(value))) result.add(value);
    }
    return result;
  }
}
