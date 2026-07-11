class AlistBindInfo {
  final String id;
  final String serverId;
  final String host;
  final String username;
  final int createdAt;
  final String providerInstanceName;

  const AlistBindInfo({
    required this.id,
    required this.serverId,
    required this.host,
    required this.username,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class EmbyBindInfo {
  final String id;
  final String serverId;
  final String host;
  final String userId;
  final int createdAt;
  final String providerInstanceName;

  const EmbyBindInfo({
    required this.id,
    required this.serverId,
    required this.host,
    required this.userId,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class BilibiliBindInfo {
  final String id;
  final String serverId;
  final int createdAt;
  final String providerInstanceName;

  const BilibiliBindInfo({
    required this.id,
    required this.serverId,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class CloudreveBindInfo {
  final String id;
  final String serverId;
  final String host;
  final String email;
  final int createdAt;
  final String providerInstanceName;

  const CloudreveBindInfo({
    required this.id,
    required this.serverId,
    required this.host,
    required this.email,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class CloudreveAccountInfo {
  final String id;
  final String email;
  final String nickname;

  const CloudreveAccountInfo({
    required this.id,
    required this.email,
    required this.nickname,
  });
}

class CloudreveItemInfo {
  final String id;
  final String name;
  final String path;
  final int size;
  final bool isDir;
  final int modified;
  final String thumbnail;

  const CloudreveItemInfo({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.isDir,
    required this.modified,
    required this.thumbnail,
  });
}

class CloudreveListPage {
  final String serverId;
  final String providerInstanceName;
  final List<CloudreveItemInfo> items;
  final int total;
  final bool usesCursor;
  final String nextCursor;

  const CloudreveListPage({
    required this.serverId,
    required this.providerInstanceName,
    required this.items,
    required this.total,
    required this.usesCursor,
    required this.nextCursor,
  });
}

class AlistAccountInfo {
  final String username;
  final String basePath;

  const AlistAccountInfo({required this.username, required this.basePath});
}

class AlistLoginInfo {
  final String token;
  final String serverId;

  const AlistLoginInfo({required this.token, required this.serverId});
}

class EmbyAccountInfo {
  final String id;
  final String name;

  const EmbyAccountInfo({required this.id, required this.name});
}

class BilibiliAccountInfo {
  final bool isLogin;
  final String username;
  final String face;
  final bool isVip;

  const BilibiliAccountInfo({
    required this.isLogin,
    required this.username,
    required this.face,
    required this.isVip,
  });
}

class BilibiliQrLoginInfo {
  final String url;
  final String key;

  const BilibiliQrLoginInfo({required this.url, required this.key});
}

class BilibiliSmsLoginInfo {
  final String sessionToken;
  final String gt;
  final String challenge;
  final int expiresAt;

  const BilibiliSmsLoginInfo({
    required this.sessionToken,
    required this.gt,
    required this.challenge,
    required this.expiresAt,
  });

  BilibiliSmsLoginInfo copyWith({
    String? sessionToken,
    String? gt,
    String? challenge,
    int? expiresAt,
  }) {
    return BilibiliSmsLoginInfo(
      sessionToken: sessionToken ?? this.sessionToken,
      gt: gt ?? this.gt,
      challenge: challenge ?? this.challenge,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class BilibiliVideoItemInfo {
  final String bvid;
  final int cid;
  final int epid;
  final String name;
  final String cover;
  final bool isLive;

  const BilibiliVideoItemInfo({
    required this.bvid,
    required this.cid,
    required this.epid,
    required this.name,
    required this.cover,
    required this.isLive,
  });
}

class BilibiliParseInfo {
  final String title;
  final List<String> actors;
  final List<BilibiliVideoItemInfo> videos;

  const BilibiliParseInfo({
    required this.title,
    required this.actors,
    required this.videos,
  });
}

class AlistItemInfo {
  final String name;
  final String path;
  final int size;
  final bool isDir;
  final int modified;
  final String thumb;
  final int type;
  final String sign;

  const AlistItemInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.isDir,
    required this.modified,
    required this.thumb,
    required this.type,
    this.sign = '',
  });
}

class AlistListPage {
  final String serverId;
  final String providerInstanceName;
  final List<AlistItemInfo> items;
  final int total;

  const AlistListPage({
    required this.serverId,
    required this.providerInstanceName,
    required this.items,
    required this.total,
  });
}

class EmbyLoginInfo {
  final String userId;
  final String username;
  final bool isAdmin;
  final String serverId;

  const EmbyLoginInfo({
    required this.userId,
    required this.username,
    required this.isAdmin,
    required this.serverId,
  });
}

class EmbyItemInfo {
  final String id;
  final String name;
  final String type;
  final bool isDir;
  final String parentId;
  final String seriesName;
  final String seriesId;
  final String seasonName;
  final String thumbnail;
  final String description;

  const EmbyItemInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.isDir,
    required this.parentId,
    required this.seriesName,
    required this.seriesId,
    required this.seasonName,
    required this.thumbnail,
    this.description = '',
  });
}

class EmbyListPage {
  final String serverId;
  final String providerInstanceName;
  final List<EmbyItemInfo> items;
  final int total;

  const EmbyListPage({
    required this.serverId,
    required this.providerInstanceName,
    required this.items,
    required this.total,
  });
}
