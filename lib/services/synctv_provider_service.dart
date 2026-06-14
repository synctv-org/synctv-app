import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/models/provider_models.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/providers/alist.pb.dart'
    as alist;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pb.dart'
    as bilibili;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/emby.pb.dart' as emby;

class SyncTvProviderDomainService {
  SyncTvProviderDomainService(this._api);

  final SyncTvApiClient _api;

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

  Future<void> logoutAList(
    String serverId, {
    String instanceName = '',
  }) {
    return _api.alistProvider.logout(
        alist.LogoutRequest(serverId: serverId, instanceName: instanceName));
  }

  Future<void> logoutEmby(
    String serverId, {
    String instanceName = '',
  }) {
    return _api.embyProvider.logout(
        emby.LogoutRequest(serverId: serverId, instanceName: instanceName));
  }

  Future<void> logoutBilibili({String instanceName = ''}) async {
    await _api.bilibiliProvider.logout(
      bilibili.LogoutRequest(instanceName: instanceName),
    );
  }

  Future<BilibiliAccountInfo> getBilibiliAccount({
    String instanceName = '',
  }) async {
    final response = await _api.bilibiliProvider.getUserInfo(
      bilibili.UserInfoRequest(instanceName: instanceName),
    );
    return BilibiliAccountInfo(
      isLogin: response.isLogin,
      username: response.username,
      face: response.face,
      isVip: response.isVip,
    );
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
      bilibili.LoginSMSRequest(
        sessionToken: sessionToken,
        code: code,
      ),
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
    return EmbyAccountInfo(
      id: response.id,
      name: response.name,
    );
  }

  Future<BilibiliParseInfo> parseBilibiliInfo(
    String url, {
    String instanceName = '',
  }) async {
    final response = await _api.bilibiliProvider.parse(
      bilibili.ParseRequest(url: url, instanceName: instanceName),
    );
    return _bilibiliParseFromProto(response);
  }

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
    );
  }

  Future<EmbyLoginInfo> loginEmbyInfo(
    String host,
    String username,
    String password, {
    String apiKey = '',
    String instanceName = '',
  }) async {
    final request = emby.LoginRequest(
      host: host,
      username: username,
      instanceName: instanceName,
    );
    if (apiKey.trim().isNotEmpty) {
      request.apiKey = apiKey;
    } else {
      request.password = password;
    }
    final response = await _api.embyProvider.login(request);
    return EmbyLoginInfo(
      userId: response.userId,
      username: response.username,
      isAdmin: response.isAdmin,
      serverId: response.serverId,
    );
  }

  Future<EmbyListPage> listEmbyPage(
    String path, {
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
        path: path,
        startIndex: Int64((page - 1) * max),
        limit: Int64(max),
        searchTerm: keyword ?? '',
        instanceName: instanceName,
      ),
    );
    return EmbyListPage(
      serverId: resolvedServerId,
      providerInstanceName: instanceName,
      items: response.items.map(_embyItemFromProto).toList(),
      total: response.total.toInt(),
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

  BilibiliParseInfo _bilibiliParseFromProto(
    bilibili.ParseResponse response,
  ) {
    return BilibiliParseInfo(
      title: response.title,
      actors: response.actors.toList(),
      videos: response.videos.map((video) {
        return BilibiliVideoItemInfo(
          bvid: video.bvid,
          cid: video.cid.toInt(),
          epid: video.epid.toInt(),
          name: video.name,
          cover: video.cover,
          isLive: video.isLive,
        );
      }).toList(),
    );
  }

  AlistItemInfo _alistItemFromProto(
    alist.FileItem item, {
    required String parentPath,
  }) {
    final normalizedParent =
        parentPath.isEmpty || parentPath == '/' ? '' : parentPath;
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
    );
  }

  AlistItemInfo _alistSearchItemFromProto(alist.SearchItem item) {
    final normalizedParent =
        item.parent.isEmpty || item.parent == '/' ? '' : item.parent;
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
    );
  }

  EmbyItemInfo _embyItemFromProto(emby.MediaItem item) {
    final type = item.type.toLowerCase();
    return EmbyItemInfo(
      id: item.id,
      name: item.name,
      type: item.type,
      isDir: type == 'folder' || type == 'series' || type == 'season',
      parentId: item.parentId,
      seriesName: item.seriesName,
      seriesId: item.seriesId,
      seasonName: item.seasonName,
      thumbnail:
          item.thumbnail.isEmpty ? '' : _api.resolveResourceUrl(item.thumbnail),
    );
  }

  Future<List<String>> _availableInstanceNames(String providerType) async {
    final response = await _api.providerCommon.listAvailableProviderInstances(
      provider_common.ListAvailableProviderInstancesRequest(
        providerType: providerType,
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
