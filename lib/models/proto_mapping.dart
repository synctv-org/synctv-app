import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as pb;
import 'package:protobuf/well_known_types/google/protobuf/field_mask.pb.dart'
    as field_mask;
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart'
    as oauth2_enum;
import 'package:synctv_app/src/generated/proto/passkey.pb.dart' as passkey;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

Map<String, dynamic> protoMessageToJsonMap(pb.GeneratedMessage message) {
  final json = message.toProto3Json();
  if (json is Map) {
    return Map<String, dynamic>.from(json);
  }
  return const {};
}

Map<String, dynamic> protoMessageToIntegerEnumJsonMap(
  pb.GeneratedMessage message,
) {
  final result = <String, dynamic>{};
  for (final field in message.info_.sortedByTag) {
    if (!message.hasField(field.tagNumber)) continue;
    result[field.name] = _protoJsonValue(
      message.getField(field.tagNumber),
      isBytes: pb.PbFieldType.isBytes(field.type),
    );
  }
  return result;
}

dynamic _protoJsonValue(Object? value, {bool isBytes = false}) {
  if (value == null) return null;
  if (isBytes && value is List<int>) return base64Encode(value);
  if (isBytes && value is Iterable) {
    return value
        .map((entry) => entry is List<int> ? base64Encode(entry) : entry)
        .toList();
  }
  if (value is pb.GeneratedMessage) {
    return protoMessageToIntegerEnumJsonMap(value);
  }
  if (value is pb.ProtobufEnum) return value.value;
  if (value is Int64) return value.toString();
  if (value is Iterable) return value.map(_protoJsonValue).toList();
  if (value is Map) {
    return value.map(
      (key, entryValue) =>
          MapEntry(key.toString(), _protoJsonValue(entryValue)),
    );
  }
  return value;
}

Map<String, dynamic> roomSettingsToJson(client.RoomSettings settings) {
  return {
    'allowGuestJoin': settings.allowGuestJoin,
    'maxMembers': settings.maxMembers.toInt(),
    'requireApproval': settings.requireApproval,
    'allowAutoJoin': settings.allowAutoJoin,
    'chatEnabled': settings.chatEnabled,
    'autoPlay': {
      'enabled': settings.hasAutoPlay() && settings.autoPlay.enabled,
      'mode': settings.hasAutoPlay() ? settings.autoPlay.mode.value : 0,
      'delay': settings.hasAutoPlay() ? settings.autoPlay.delay : 0,
    },
    'adminAddedPermissions': settings.adminAddedPermissions.toInt(),
    'adminRemovedPermissions': settings.adminRemovedPermissions.toInt(),
    'memberAddedPermissions': settings.memberAddedPermissions.toInt(),
    'memberRemovedPermissions': settings.memberRemovedPermissions.toInt(),
    'guestAddedPermissions': settings.guestAddedPermissions.toInt(),
    'guestRemovedPermissions': settings.guestRemovedPermissions.toInt(),
  };
}

client.RoomSettings roomSettingsFromJson(Map<String, dynamic> json) {
  final autoPlay = json['autoPlay'];
  final settings = client.RoomSettings(
    allowGuestJoin: json['allowGuestJoin'] == true,
    maxMembers: Int64(_intValue(json['maxMembers'])),
    requireApproval: json['requireApproval'] == true,
    allowAutoJoin: json['allowAutoJoin'] == true,
    chatEnabled: json['chatEnabled'] != false,
    adminAddedPermissions: Int64(_intValue(json['adminAddedPermissions'])),
    adminRemovedPermissions: Int64(_intValue(json['adminRemovedPermissions'])),
    memberAddedPermissions: Int64(_intValue(json['memberAddedPermissions'])),
    memberRemovedPermissions: Int64(
      _intValue(json['memberRemovedPermissions']),
    ),
    guestAddedPermissions: Int64(_intValue(json['guestAddedPermissions'])),
    guestRemovedPermissions: Int64(_intValue(json['guestRemovedPermissions'])),
  );
  if (autoPlay is Map) {
    settings.autoPlay = client.AutoPlaySettings(
      enabled: autoPlay['enabled'] == true,
      mode:
          client.PlayMode.valueOf(_intValue(autoPlay['mode'])) ??
          client.PlayMode.PLAY_MODE_UNSPECIFIED,
      delay: _intValue(autoPlay['delay']),
    );
  }
  return settings;
}

client.UpdateRoomSettingsRequest roomSettingsUpdateRequestFromJson(
  Map<String, dynamic> json,
) {
  final patch = client.RoomSettingsPatch();
  final paths = <String>[];
  void setBool(String key, void Function(bool) set) {
    if (json.containsKey(key)) {
      set(json[key] == true);
      paths.add(_protoFieldName(key));
    }
  }

  void setInt64(String key, void Function(Int64) set) {
    if (json.containsKey(key)) {
      set(Int64(_intValue(json[key])));
      paths.add(_protoFieldName(key));
    }
  }

  setBool('allowGuestJoin', (value) => patch.allowGuestJoin = value);
  setInt64('maxMembers', (value) => patch.maxMembers = value);
  setBool('requireApproval', (value) => patch.requireApproval = value);
  setBool('allowAutoJoin', (value) => patch.allowAutoJoin = value);
  setBool('chatEnabled', (value) => patch.chatEnabled = value);
  final autoPlay = json['autoPlay'];
  if (autoPlay is Map) {
    final autoPlayPatch = client.AutoPlaySettingsPatch();
    if (autoPlay.containsKey('enabled')) {
      autoPlayPatch.enabled = autoPlay['enabled'] == true;
      paths.add('auto_play.enabled');
    }
    if (autoPlay.containsKey('mode')) {
      autoPlayPatch.mode =
          client.PlayMode.valueOf(_intValue(autoPlay['mode'])) ??
          client.PlayMode.PLAY_MODE_UNSPECIFIED;
      paths.add('auto_play.mode');
    }
    if (autoPlay.containsKey('delay')) {
      autoPlayPatch.delay = _intValue(autoPlay['delay']);
      paths.add('auto_play.delay');
    }
    patch.autoPlay = autoPlayPatch;
  }
  setInt64(
    'adminAddedPermissions',
    (value) => patch.adminAddedPermissions = value,
  );
  setInt64(
    'adminRemovedPermissions',
    (value) => patch.adminRemovedPermissions = value,
  );
  setInt64(
    'memberAddedPermissions',
    (value) => patch.memberAddedPermissions = value,
  );
  setInt64(
    'memberRemovedPermissions',
    (value) => patch.memberRemovedPermissions = value,
  );
  setInt64(
    'guestAddedPermissions',
    (value) => patch.guestAddedPermissions = value,
  );
  setInt64(
    'guestRemovedPermissions',
    (value) => patch.guestRemovedPermissions = value,
  );
  return client.UpdateRoomSettingsRequest(
    settings: patch,
    updateMask: field_mask.FieldMask(paths: paths),
  );
}

String _protoFieldName(String value) {
  return value.replaceAllMapped(
    RegExp('[A-Z]'),
    (match) => '_${match[0]!.toLowerCase()}',
  );
}

client.ProviderTarget providerTargetFromBase64(String? encoded) {
  if (encoded == null || encoded.isEmpty) return client.ProviderTarget();
  final decoded = utf8.decode(base64Url.decode(base64Url.normalize(encoded)));
  final json = jsonDecode(decoded);
  if (json is! Map) return client.ProviderTarget();
  return providerTargetFromJson(Map<String, dynamic>.from(json));
}

client.ProviderTarget providerTargetFromJson(Map<String, dynamic> json) {
  final target = client.ProviderTarget();
  if (json['provider']?.toString().toLowerCase() == 'bilibili') {
    final bvid = json['bvid']?.toString() ?? '';
    final aid = int.tryParse(json['aid']?.toString() ?? '') ?? 0;
    final cid = int.tryParse(json['cid']?.toString() ?? '') ?? 0;
    switch (json['type']?.toString()) {
      case 'video':
        target.bilibili = client.BilibiliTarget(
          video: client.BilibiliVideoTarget(bvid: bvid, aid: Int64(aid)),
        );
      case 'videoPart':
        target.bilibili = client.BilibiliTarget(
          videoPart: client.BilibiliVideoPartTarget(
            bvid: bvid,
            aid: Int64(aid),
            cid: Int64(cid),
            page: int.tryParse(json['page']?.toString() ?? '') ?? 0,
          ),
        );
      case 'pgcEpisode':
        target.bilibili = client.BilibiliTarget(
          pgcEpisode: client.BilibiliPgcEpisodeTarget(
            epid: Int64(int.tryParse(json['epid']?.toString() ?? '') ?? 0),
            cid: Int64(cid),
          ),
        );
      case 'live':
        target.bilibili = client.BilibiliTarget(
          live: client.BilibiliLiveTarget(
            roomId: Int64(int.tryParse(json['roomId']?.toString() ?? '') ?? 0),
          ),
        );
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'emby') {
    final itemId = json['itemId']?.toString() ?? '';
    final personId = json['personId']?.toString() ?? '';
    target.emby = switch (json['type']?.toString()) {
      'person' => client.EmbyTarget(
        person: client.EmbyPersonTarget(personId: personId),
      ),
      'personItem' => client.EmbyTarget(
        personItem: client.EmbyPersonItemTarget(
          personId: personId,
          itemId: itemId,
        ),
      ),
      _ => client.EmbyTarget(item: client.EmbyItemTarget(itemId: itemId)),
    };
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'synology') {
    switch (json['type']?.toString()) {
      case 'file':
        final relativePath = json['relativePath']?.toString() ?? '';
        if (relativePath.isNotEmpty) {
          target.synology = client.SynologyTarget(
            file: client.SynologyFileTarget(relativePath: relativePath),
          );
        }
      case 'libraryItem':
        final itemId = int.tryParse(json['itemId']?.toString() ?? '');
        final fileId = int.tryParse(json['fileId']?.toString() ?? '');
        if (itemId != null && fileId != null) {
          target.synology = client.SynologyTarget(
            libraryItem: client.SynologyLibraryItemTarget(
              kind: _synologyTargetKind(json['kind']),
              itemId: Int64(itemId),
              fileId: Int64(fileId),
              parentId: _optionalTargetInt64(json['parentId']),
            ),
          );
        }
      case 'tvShow':
        final libraryId = int.tryParse(json['libraryId']?.toString() ?? '');
        final tvShowId = int.tryParse(json['tvShowId']?.toString() ?? '');
        if (libraryId != null && tvShowId != null) {
          target.synology = client.SynologyTarget(
            tvShow: client.SynologyTvShowTarget(
              libraryId: Int64(libraryId),
              tvShowId: Int64(tvShowId),
            ),
          );
        }
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'qnap') {
    final relativePath = json['relativePath']?.toString() ?? '';
    if (relativePath.isNotEmpty) {
      target.qnap = client.QnapTarget(relativePath: relativePath);
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'nextcloud') {
    final path = json['path']?.toString() ?? '';
    final fileId = int.tryParse(json['fileId']?.toString() ?? '');
    if (path.isNotEmpty && fileId != null && fileId > 0) {
      target.nextcloud = client.NextcloudTarget(
        path: path,
        fileId: Int64(fileId),
      );
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'seafile') {
    final repositoryId = json['repositoryId']?.toString() ?? '';
    final path = json['path']?.toString() ?? '';
    if (repositoryId.isNotEmpty && path.isNotEmpty) {
      target.seafile = client.SeafileTarget(
        repositoryId: repositoryId,
        path: path,
        objectId: json['objectId']?.toString() ?? '',
        hasThumbnail: json['hasThumbnail'] == true,
      );
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'truenas') {
    final path = json['path']?.toString() ?? '';
    if (path.isNotEmpty) {
      target.truenas = client.TrueNasTarget(path: path);
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'youtube') {
    final videoId = json['videoId']?.toString() ?? '';
    if (videoId.isNotEmpty) {
      target.youtube = client.YoutubeTarget(videoId: videoId);
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'douyin') {
    final awemeId = json['awemeId']?.toString() ?? '';
    if (awemeId.isNotEmpty) {
      target.douyin = client.DouyinTarget(awemeId: awemeId);
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'tiktok') {
    final videoId = json['videoId']?.toString() ?? '';
    if (videoId.isNotEmpty) {
      target.tiktok = client.TikTokTarget(videoId: videoId);
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'fnos') {
    switch (json['type']?.toString()) {
      case 'file':
        final relativePath = json['relativePath']?.toString() ?? '';
        if (relativePath.isNotEmpty) {
          target.fnos = client.FnosTarget(
            file: client.FnosFileTarget(relativePath: relativePath),
          );
        }
      case 'mediaItem':
        final itemGuid = json['itemGuid']?.toString() ?? '';
        if (itemGuid.isNotEmpty) {
          target.fnos = client.FnosTarget(
            mediaItem: client.FnosMediaItemTarget(
              itemGuid: itemGuid,
              mediaGuid: json['mediaGuid']?.toString(),
            ),
          );
        }
    }
    return target;
  }
  if (json['provider']?.toString().toLowerCase() == 'twitch') {
    final id = json['id']?.toString() ?? '';
    final kind = switch (json['kind']?.toString().toLowerCase()) {
      'video' => client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_VIDEO,
      'clip' => client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_CLIP,
      'live' => client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_LIVE,
      _ => client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_UNSPECIFIED,
    };
    if (id.isNotEmpty &&
        kind != client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_UNSPECIFIED) {
      target.twitch = client.TwitchTarget(kind: kind, id: id);
    }
    return target;
  }
  final alistPath = json['relativePath'] ?? json['path'];
  if (alistPath != null) {
    if (json['provider']?.toString().toLowerCase() == 'cloudreve') {
      target.cloudreve = client.CloudreveTarget(
        relativePath: alistPath.toString(),
      );
    } else {
      target.alist = client.AlistTarget(relativePath: alistPath.toString());
    }
    return target;
  }
  final embyItemId = json['itemId'];
  if (embyItemId != null) {
    target.emby = client.EmbyTarget(
      item: client.EmbyItemTarget(itemId: embyItemId.toString()),
    );
  }
  return target;
}

bool providerTargetIsEmpty(client.ProviderTarget target) {
  return target.whichTarget() == client.ProviderTarget_Target.notSet;
}

String providerTargetToBase64(client.ProviderTarget target) {
  if (providerTargetIsEmpty(target)) return '';
  return base64Url.encode(
    utf8.encode(jsonEncode(providerTargetToJson(target))),
  );
}

Map<String, dynamic> providerTargetToJson(client.ProviderTarget target) {
  return switch (target.whichTarget()) {
    client.ProviderTarget_Target.alist => {
      'relativePath': target.alist.relativePath,
    },
    client.ProviderTarget_Target.emby => switch (target.emby.whichTarget()) {
      client.EmbyTarget_Target.item => {
        'provider': 'emby',
        'type': 'item',
        'itemId': target.emby.item.itemId,
      },
      client.EmbyTarget_Target.person => {
        'provider': 'emby',
        'type': 'person',
        'personId': target.emby.person.personId,
      },
      client.EmbyTarget_Target.personItem => {
        'provider': 'emby',
        'type': 'personItem',
        'personId': target.emby.personItem.personId,
        'itemId': target.emby.personItem.itemId,
      },
      client.EmbyTarget_Target.notSet => <String, dynamic>{},
    },
    client.ProviderTarget_Target.cloudreve => {
      'provider': 'cloudreve',
      'relativePath': target.cloudreve.relativePath,
    },
    client.ProviderTarget_Target.bilibili => switch (target.bilibili
        .whichTarget()) {
      client.BilibiliTarget_Target.video => {
        'provider': 'bilibili',
        'type': 'video',
        'bvid': target.bilibili.video.bvid,
        'aid': target.bilibili.video.aid.toInt(),
      },
      client.BilibiliTarget_Target.videoPart => {
        'provider': 'bilibili',
        'type': 'videoPart',
        'bvid': target.bilibili.videoPart.bvid,
        'aid': target.bilibili.videoPart.aid.toInt(),
        'cid': target.bilibili.videoPart.cid.toInt(),
        'page': target.bilibili.videoPart.page,
      },
      client.BilibiliTarget_Target.pgcEpisode => {
        'provider': 'bilibili',
        'type': 'pgcEpisode',
        'epid': target.bilibili.pgcEpisode.epid.toInt(),
        'cid': target.bilibili.pgcEpisode.cid.toInt(),
      },
      client.BilibiliTarget_Target.live => {
        'provider': 'bilibili',
        'type': 'live',
        'roomId': target.bilibili.live.roomId.toInt(),
      },
      client.BilibiliTarget_Target.notSet => <String, dynamic>{},
    },
    client.ProviderTarget_Target.twitch => {
      'provider': 'twitch',
      'kind': switch (target.twitch.kind) {
        client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_VIDEO => 'video',
        client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_CLIP => 'clip',
        client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_LIVE => 'live',
        _ => '',
      },
      'id': target.twitch.id,
    },
    client.ProviderTarget_Target.fnos => switch (target.fnos.whichTarget()) {
      client.FnosTarget_Target.file => {
        'provider': 'fnos',
        'type': 'file',
        'relativePath': target.fnos.file.relativePath,
      },
      client.FnosTarget_Target.mediaItem => {
        'provider': 'fnos',
        'type': 'mediaItem',
        'itemGuid': target.fnos.mediaItem.itemGuid,
        if (target.fnos.mediaItem.hasMediaGuid())
          'mediaGuid': target.fnos.mediaItem.mediaGuid,
      },
      client.FnosTarget_Target.notSet => <String, dynamic>{},
    },
    client.ProviderTarget_Target.qnap => {
      'provider': 'qnap',
      'relativePath': target.qnap.relativePath,
    },
    client.ProviderTarget_Target.synology => switch (target.synology
        .whichTarget()) {
      client.SynologyTarget_Target.file => {
        'provider': 'synology',
        'type': 'file',
        'relativePath': target.synology.file.relativePath,
      },
      client.SynologyTarget_Target.libraryItem => {
        'provider': 'synology',
        'type': 'libraryItem',
        'kind': _synologyTargetKindName(target.synology.libraryItem.kind),
        'itemId': target.synology.libraryItem.itemId.toInt(),
        'fileId': target.synology.libraryItem.fileId.toInt(),
        if (target.synology.libraryItem.hasParentId())
          'parentId': target.synology.libraryItem.parentId.toInt(),
      },
      client.SynologyTarget_Target.tvShow => {
        'provider': 'synology',
        'type': 'tvShow',
        'libraryId': target.synology.tvShow.libraryId.toInt(),
        'tvShowId': target.synology.tvShow.tvShowId.toInt(),
      },
      client.SynologyTarget_Target.notSet => <String, dynamic>{},
    },
    client.ProviderTarget_Target.nextcloud => {
      'provider': 'nextcloud',
      'path': target.nextcloud.path,
      'fileId': target.nextcloud.fileId.toInt(),
    },
    client.ProviderTarget_Target.seafile => {
      'provider': 'seafile',
      'repositoryId': target.seafile.repositoryId,
      'path': target.seafile.path,
      'objectId': target.seafile.objectId,
      'hasThumbnail': target.seafile.hasThumbnail,
    },
    client.ProviderTarget_Target.truenas => {
      'provider': 'truenas',
      'path': target.truenas.path,
    },
    client.ProviderTarget_Target.youtube => {
      'provider': 'youtube',
      'videoId': target.youtube.videoId,
    },
    client.ProviderTarget_Target.douyin => {
      'provider': 'douyin',
      'awemeId': target.douyin.awemeId,
    },
    client.ProviderTarget_Target.tiktok => {
      'provider': 'tiktok',
      'videoId': target.tiktok.videoId,
    },
    client.ProviderTarget_Target.notSet => <String, dynamic>{},
  };
}

source_enum.SynologyLibraryItemKind _synologyTargetKind(Object? value) {
  return switch (value?.toString()) {
    'episode' =>
      source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE,
    'homeVideo' =>
      source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_HOME_VIDEO,
    'tvRecording' =>
      source_enum
          .SynologyLibraryItemKind
          .SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING,
    _ => source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_MOVIE,
  };
}

String _synologyTargetKindName(source_enum.SynologyLibraryItemKind value) {
  return switch (value) {
    source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE =>
      'episode',
    source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_HOME_VIDEO =>
      'homeVideo',
    source_enum
        .SynologyLibraryItemKind
        .SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING =>
      'tvRecording',
    _ => 'movie',
  };
}

Int64? _optionalTargetInt64(Object? value) {
  final parsed = int.tryParse(value?.toString() ?? '');
  return parsed == null ? null : Int64(parsed);
}

Map<String, dynamic> resourceMetadataToJson(client.ResourceMetadata metadata) {
  return {if (metadata.hasSource()) 'source': metadata.source};
}

Map<String, dynamic> fileMetadataToJson(client.FileMetadata metadata) {
  return {
    if (metadata.hasWidth()) 'width': metadata.width,
    if (metadata.hasHeight()) 'height': metadata.height,
    if (metadata.hasDurationSeconds())
      'durationSeconds': metadata.durationSeconds,
    if (metadata.hasBitrateBps()) 'bitrateBps': metadata.bitrateBps,
    if (metadata.hasBlurhash()) 'blurhash': metadata.blurhash,
  };
}

client.FileMetadata fileMetadataFromBytes(List<int> bytes) {
  if (bytes.isEmpty) return client.FileMetadata();
  final decoded = jsonDecode(utf8.decode(bytes));
  if (decoded is! Map) return client.FileMetadata();
  final json = Map<String, dynamic>.from(decoded);
  return client.FileMetadata(
    width: _optionalInt(json['width']),
    height: _optionalInt(json['height']),
    durationSeconds: _optionalInt(json['durationSeconds']),
    bitrateBps: _optionalInt(json['bitrateBps']),
    blurhash: json['blurhash']?.toString(),
  );
}

Map<String, dynamic> notificationDataToJson(client.NotificationData data) {
  return protoMessageToJsonMap(data);
}

Map<String, dynamic> runtimeSettingsSectionToJson(
  admin.RuntimeSettings settings,
  String section,
) {
  return switch (section) {
    'roomDefaults' =>
      settings.hasRoomDefaults()
          ? protoMessageToJsonMap(settings.roomDefaults)
          : <String, dynamic>{},
    'permissions' =>
      settings.hasPermissions()
          ? protoMessageToJsonMap(settings.permissions)
          : <String, dynamic>{},
    'roomCreation' =>
      settings.hasRoomCreation()
          ? protoMessageToJsonMap(settings.roomCreation)
          : <String, dynamic>{},
    'user' =>
      settings.hasUser()
          ? protoMessageToJsonMap(settings.user)
          : <String, dynamic>{},
    'oauth2' =>
      settings.hasOauth2()
          ? protoMessageToJsonMap(settings.oauth2)
          : <String, dynamic>{},
    'proxy' =>
      settings.hasProxy()
          ? protoMessageToJsonMap(settings.proxy)
          : <String, dynamic>{},
    'rtmp' => _rtmpRuntimeSettingsToJson(settings),
    'email' => _emailRuntimeSettingsToJson(settings),
    'webrtc' =>
      settings.hasWebrtc()
          ? protoMessageToJsonMap(settings.webrtc)
          : <String, dynamic>{},
    'chat' =>
      settings.hasChat()
          ? protoMessageToJsonMap(settings.chat)
          : <String, dynamic>{},
    'cors' =>
      settings.hasCors()
          ? protoMessageToJsonMap(settings.cors)
          : <String, dynamic>{},
    _ => <String, dynamic>{},
  };
}

Map<String, dynamic> _rtmpRuntimeSettingsToJson(
  admin.RuntimeSettings settings,
) {
  final json = settings.hasRtmp()
      ? protoMessageToJsonMap(settings.rtmp)
      : <String, dynamic>{};
  json.putIfAbsent('customPublishHost', () => null);
  return json;
}

Map<String, dynamic> _emailRuntimeSettingsToJson(
  admin.RuntimeSettings settings,
) {
  final json = settings.hasEmail()
      ? protoMessageToJsonMap(settings.email)
      : <String, dynamic>{};
  json.putIfAbsent('smtpHost', () => null);
  json.putIfAbsent('smtpCredentials', () => null);
  json.putIfAbsent('smtpProxy', () => null);
  json.putIfAbsent('fromEmail', () => null);
  return json;
}

String oauth2ProviderTypeToString(oauth2_enum.OAuth2ProviderType provider) {
  return switch (provider) {
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_QQ => 'qq',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GITHUB => 'github',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GOOGLE => 'google',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_MICROSOFT =>
      'microsoft',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_DISCORD => 'discord',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_CASDOOR => 'casdoor',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_LOGTO => 'logto',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_OIDC => 'oidc',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_FEISHU => 'feishu',
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GITEE => 'gitee',
    _ => '',
  };
}

oauth2_enum.OAuth2ProviderType oauth2ProviderTypeFromString(String value) {
  return switch (value.trim().toLowerCase()) {
    'qq' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_QQ,
    'github' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GITHUB,
    'google' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GOOGLE,
    'microsoft' =>
      oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_MICROSOFT,
    'discord' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_DISCORD,
    'casdoor' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_CASDOOR,
    'logto' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_LOGTO,
    'oidc' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_OIDC,
    'feishu' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_FEISHU,
    'gitee' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GITEE,
    _ => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_UNSPECIFIED,
  };
}

Map<String, dynamic> passkeyChallengeToJson(pb.GeneratedMessage challenge) {
  return protoMessageToJsonMap(challenge);
}

passkey.PasskeyRegistrationCredential passkeyRegistrationCredentialFromJson(
  Object credential,
) {
  return _decodePasskeyCredential(
    credential,
    passkey.PasskeyRegistrationCredential(),
  );
}

passkey.PasskeyAuthenticationCredential passkeyAuthenticationCredentialFromJson(
  Object credential,
) {
  return _decodePasskeyCredential(
    credential,
    passkey.PasskeyAuthenticationCredential(),
  );
}

T _decodePasskeyCredential<T extends pb.GeneratedMessage>(
  Object credential,
  T message,
) {
  final decoded = credential is String ? jsonDecode(credential) : credential;
  message.mergeFromProto3Json(
    decoded,
    ignoreUnknownFields: true,
    supportNamesWithUnderscores: false,
    permissiveEnums: true,
  );
  return message;
}

int _intValue(Object? value) {
  if (value is Int64) return value.toInt();
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _optionalInt(Object? value) {
  if (value == null) return null;
  return _intValue(value);
}
