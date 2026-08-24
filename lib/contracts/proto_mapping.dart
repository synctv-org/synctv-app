import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as pb;
import 'package:protobuf/well_known_types/google/protobuf/field_mask.pb.dart'
    as field_mask;
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
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
    'voiceChatEnabled': settings.voiceChatEnabled,
    'p2pMediaEnabled': settings.p2pMediaEnabled,
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
    voiceChatEnabled: json['voiceChatEnabled'] != false,
    p2pMediaEnabled: json['p2pMediaEnabled'] != false,
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
  setBool('voiceChatEnabled', (value) => patch.voiceChatEnabled = value);
  setBool('p2pMediaEnabled', (value) => patch.p2pMediaEnabled = value);
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
              libraryGuid: json['libraryGuid']?.toString(),
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
        if (target.fnos.mediaItem.hasLibraryGuid())
          'libraryGuid': target.fnos.mediaItem.libraryGuid,
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
  final result = <String, dynamic>{
    if (metadata.hasSource()) 'source': metadata.source,
  };
  if (metadata.hasProvider()) {
    result['provider'] = protoMessageToJsonMap(metadata.provider);
  }
  return result;
}

typedef ResourceLiveState = ({bool isLive, bool? isCurrentlyLive});

/// Reads provider-owned live semantics directly from the protobuf oneof.
ResourceLiveState resourceMetadataLiveState(client.ResourceMetadata? metadata) {
  if (metadata == null || !metadata.hasProvider()) {
    return (isLive: false, isCurrentlyLive: null);
  }

  final provider = metadata.provider;
  return switch (provider.whichMetadata()) {
    client.PlaybackMetadata_Metadata.bilibili => (
      isLive: provider.bilibili.isLive,
      isCurrentlyLive: provider.bilibili.hasIsCurrentlyLive()
          ? provider.bilibili.isCurrentlyLive
          : null,
    ),
    client.PlaybackMetadata_Metadata.twitch => (
      isLive: provider.twitch.isLive,
      isCurrentlyLive: provider.twitch.hasIsCurrentlyLive()
          ? provider.twitch.isCurrentlyLive
          : null,
    ),
    client.PlaybackMetadata_Metadata.youtube => (
      isLive: provider.youtube.isLive,
      isCurrentlyLive: provider.youtube.hasIsCurrentlyLive()
          ? provider.youtube.isCurrentlyLive
          : null,
    ),
    client.PlaybackMetadata_Metadata.douyin => (
      isLive: provider.douyin.isLive,
      isCurrentlyLive: provider.douyin.hasIsCurrentlyLive()
          ? provider.douyin.isCurrentlyLive
          : null,
    ),
    client.PlaybackMetadata_Metadata.tiktok => (
      isLive: provider.tiktok.isLive,
      isCurrentlyLive: provider.tiktok.hasIsCurrentlyLive()
          ? provider.tiktok.isCurrentlyLive
          : null,
    ),
    client.PlaybackMetadata_Metadata.huya => (
      isLive: provider.huya.isLive,
      isCurrentlyLive: provider.huya.hasIsCurrentlyLive()
          ? provider.huya.isCurrentlyLive
          : null,
    ),
    client.PlaybackMetadata_Metadata.douyu => (
      isLive: provider.douyu.isLive,
      isCurrentlyLive: provider.douyu.hasIsCurrentlyLive()
          ? provider.douyu.isCurrentlyLive
          : null,
    ),
    client.PlaybackMetadata_Metadata.acFun => (
      isLive: provider.acFun.isLive,
      isCurrentlyLive: provider.acFun.hasIsCurrentlyLive()
          ? provider.acFun.isCurrentlyLive
          : null,
    ),
    client.PlaybackMetadata_Metadata.live => (
      isLive: true,
      isCurrentlyLive: switch (provider.live.availability) {
        client_enum.LiveStreamAvailability.LIVE_STREAM_AVAILABILITY_LIVE =>
          true,
        client_enum.LiveStreamAvailability.LIVE_STREAM_AVAILABILITY_OFFLINE =>
          false,
        _ => null,
      },
    ),
    _ => (isLive: false, isCurrentlyLive: null),
  };
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
    'server' =>
      settings.hasServer()
          ? _runtimeSettingsWithDefaults(settings.server, {
              'name': settings.server.name,
            })
          : <String, dynamic>{},
    'roomDefaults' =>
      settings.hasRoomDefaults()
          ? _runtimeSettingsWithDefaults(settings.roomDefaults, {
              'defaultMaxMembers': settings.roomDefaults.defaultMaxMembers
                  .toString(),
              'defaultMaxChatMessages': settings
                  .roomDefaults
                  .defaultMaxChatMessages
                  .toString(),
            })
          : <String, dynamic>{},
    'permissions' =>
      settings.hasPermissions()
          ? _runtimeSettingsWithDefaults(settings.permissions, {
              'adminDefaultPermissions': settings
                  .permissions
                  .adminDefaultPermissions
                  .toString(),
              'memberDefaultPermissions': settings
                  .permissions
                  .memberDefaultPermissions
                  .toString(),
              'guestDefaultPermissions': settings
                  .permissions
                  .guestDefaultPermissions
                  .toString(),
            })
          : <String, dynamic>{},
    'roomCreation' =>
      settings.hasRoomCreation()
          ? _runtimeSettingsWithDefaults(settings.roomCreation, {
              'enabled': settings.roomCreation.enabled,
              'approvalRequired': settings.roomCreation.approvalRequired,
              'passwordPolicy':
                  settings.roomCreation.passwordPolicy ==
                      common_enum
                          .RoomPasswordPolicy
                          .ROOM_PASSWORD_POLICY_UNSPECIFIED
                  ? common_enum
                        .RoomPasswordPolicy
                        .ROOM_PASSWORD_POLICY_OPTIONAL
                        .name
                  : settings.roomCreation.passwordPolicy.name,
              'maxRoomsPerUser': settings.roomCreation.maxRoomsPerUser
                  .toString(),
            })
          : <String, dynamic>{},
    'user' =>
      settings.hasUser()
          ? _runtimeSettingsWithDefaults(settings.user, {
              'enablePasswordSignup': settings.user.enablePasswordSignup,
              'passwordSignupNeedReview':
                  settings.user.passwordSignupNeedReview,
              'enableEmailSignup': settings.user.enableEmailSignup,
              'emailSignupNeedReview': settings.user.emailSignupNeedReview,
              'enableWebauthnSignup': settings.user.enableWebauthnSignup,
              'webauthnSignupNeedReview':
                  settings.user.webauthnSignupNeedReview,
              'enableGuest': settings.user.enableGuest,
            })
          : <String, dynamic>{},
    'oauth2' =>
      settings.hasOauth2()
          ? _oauth2RuntimeSettingsToJson(settings.oauth2)
          : <String, dynamic>{},
    'rtmp' => _rtmpRuntimeSettingsToJson(settings),
    'email' => _emailRuntimeSettingsToJson(settings),
    'webrtc' =>
      settings.hasWebrtc()
          ? _runtimeSettingsWithDefaults(settings.webrtc, {
              'externalIceServers': [
                for (final server in settings.webrtc.externalIceServers)
                  protoMessageToJsonMap(server),
              ],
              'maxVoiceParticipantsPerRoom':
                  settings.webrtc.maxVoiceParticipantsPerRoom,
            })
          : <String, dynamic>{},
    'chat' =>
      settings.hasChat()
          ? _runtimeSettingsWithDefaults(settings.chat, {
              'maxMessagesPerRoom': settings.chat.maxMessagesPerRoom.toString(),
              'maxPinnedMessagesPerRoom': settings.chat.maxPinnedMessagesPerRoom
                  .toString(),
              'messageRetentionDays': settings.chat.messageRetentionDays
                  .toString(),
            })
          : <String, dynamic>{},
    'playbackHistory' =>
      settings.hasPlaybackHistory()
          ? _runtimeSettingsWithDefaults(settings.playbackHistory, {
              'retentionDays': settings.playbackHistory.retentionDays,
              'maxEntriesPerRoom': settings.playbackHistory.maxEntriesPerRoom
                  .toString(),
            })
          : <String, dynamic>{},
    'cors' =>
      settings.hasCors()
          ? _runtimeSettingsWithDefaults(settings.cors, {
              'allowedOrigins': List<String>.from(settings.cors.allowedOrigins),
            })
          : <String, dynamic>{},
    _ => <String, dynamic>{},
  };
}

Map<String, dynamic> _runtimeSettingsWithDefaults(
  pb.GeneratedMessage message,
  Map<String, dynamic> defaults,
) {
  final json = protoMessageToJsonMap(message);
  for (final entry in defaults.entries) {
    json.putIfAbsent(entry.key, () => entry.value);
  }
  return json;
}

Map<String, dynamic> _oauth2RuntimeSettingsToJson(
  admin.OAuth2Settings settings,
) {
  final json = _runtimeSettingsWithDefaults(settings, {
    'allowedRedirectUrls': List<String>.from(settings.allowedRedirectUrls),
  });
  json['providers'] = [
    for (final provider in settings.providers)
      _runtimeSettingsWithDefaults(provider, {
        'enableSignup': provider.enableSignup,
        'signupNeedReview': provider.signupNeedReview,
      }),
  ];
  return json;
}

Map<String, dynamic> _rtmpRuntimeSettingsToJson(
  admin.RuntimeSettings settings,
) {
  final rtmp = settings.hasRtmp() ? settings.rtmp : admin.RtmpSettings();
  final defaults = <String, dynamic>{
    'advertiseAddress': rtmp.hasAdvertiseAddress()
        ? rtmp.advertiseAddress
        : null,
    'tsDisguisedAsPng': rtmp.tsDisguisedAsPng,
  };
  if (!settings.hasRtmp()) return defaults;
  return _runtimeSettingsWithDefaults(rtmp, defaults);
}

Map<String, dynamic> _emailRuntimeSettingsToJson(
  admin.RuntimeSettings settings,
) {
  final email = settings.hasEmail() ? settings.email : admin.EmailSettings();
  final defaults = <String, dynamic>{
    'enabled': email.enabled,
    'smtpHost': email.hasSmtpHost() ? email.smtpHost : null,
    'smtpPort': email.smtpPort,
    'smtpCredentials': email.hasSmtpCredentials()
        ? protoMessageToJsonMap(email.smtpCredentials)
        : null,
    'smtpProxy': email.hasSmtpProxy()
        ? protoMessageToJsonMap(email.smtpProxy)
        : null,
    'useTls': email.useTls,
    'fromEmail': email.hasFromEmail() ? email.fromEmail : null,
    'fromName': email.fromName,
    'whitelistEnabled': email.whitelistEnabled,
    'whitelistDomains': List<String>.from(email.whitelistDomains),
  };
  if (!settings.hasEmail()) return defaults;
  return _runtimeSettingsWithDefaults(email, defaults);
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
    oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_APPLE => 'apple',
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
    'apple' => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_APPLE,
    _ => oauth2_enum.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_UNSPECIFIED,
  };
}

Map<String, dynamic> passkeyChallengeToJson(pb.GeneratedMessage challenge) {
  return switch (challenge) {
    passkey.PasskeyCreationChallenge() => _passkeyCreationOptionsToJson(
      challenge.publicKey,
    ),
    passkey.PasskeyRequestChallenge() => {
      ..._passkeyRequestOptionsToJson(challenge.publicKey),
      'mediation': ?_passkeyMediation(challenge.mediation),
    },
    _ => throw ArgumentError.value(
      challenge,
      'challenge',
      'Unsupported Passkey challenge type',
    ),
  };
}

Map<String, dynamic> _passkeyCreationOptionsToJson(
  passkey.PasskeyPublicKeyCredentialCreationOptions options,
) {
  final selection = options.hasAuthenticatorSelection()
      ? options.authenticatorSelection
      : null;
  return {
    'rp': {'id': options.rp.id, 'name': options.rp.name},
    'user': {
      'id': _passkeyBytesToBase64Url(options.user.id),
      'name': options.user.name,
      'displayName': options.user.displayName,
    },
    'challenge': _passkeyBytesToBase64Url(options.challenge),
    'pubKeyCredParams': options.pubKeyCredParams
        .map(
          (parameter) => {
            'type': _passkeyCredentialType(parameter.type),
            'alg': parameter.alg.toInt(),
          },
        )
        .toList(growable: false),
    if (options.hasTimeout()) 'timeout': options.timeout,
    if (options.excludeCredentials.isNotEmpty)
      'excludeCredentials': options.excludeCredentials
          .map(_passkeyCredentialDescriptorToJson)
          .toList(growable: false),
    if (selection != null)
      'authenticatorSelection': {
        'authenticatorAttachment': ?_passkeyAuthenticatorAttachment(
          selection.authenticatorAttachment,
        ),
        'residentKey': ?_passkeyResidentKey(selection.residentKey),
        'requireResidentKey': selection.requireResidentKey,
        'userVerification': ?_passkeyUserVerification(
          selection.userVerification,
        ),
      },
    if (options.hints.isNotEmpty)
      'hints': options.hints
          .map(_passkeyHint)
          .whereType<String>()
          .toList(growable: false),
    'attestation': ?_passkeyAttestation(options.attestation),
    if (options.attestationFormats.isNotEmpty)
      'attestationFormats': options.attestationFormats
          .map(_passkeyAttestationFormat)
          .whereType<String>()
          .toList(growable: false),
    if (options.hasExtensions())
      'extensions': _passkeyRegistrationExtensionsToJson(options.extensions),
  };
}

Map<String, dynamic> _passkeyRequestOptionsToJson(
  passkey.PasskeyPublicKeyCredentialRequestOptions options,
) {
  return {
    'challenge': _passkeyBytesToBase64Url(options.challenge),
    'rpId': options.rpId,
    if (options.hasTimeout()) 'timeout': options.timeout,
    if (options.allowCredentials.isNotEmpty)
      'allowCredentials': options.allowCredentials
          .map(_passkeyCredentialDescriptorToJson)
          .toList(growable: false),
    'userVerification': ?_passkeyUserVerification(options.userVerification),
    if (options.hints.isNotEmpty)
      'hints': options.hints
          .map(_passkeyHint)
          .whereType<String>()
          .toList(growable: false),
    if (options.hasExtensions())
      'extensions': _passkeyAuthenticationExtensionsToJson(options.extensions),
  };
}

Map<String, dynamic> _passkeyRegistrationExtensionsToJson(
  passkey.PasskeyRegistrationExtensionsInput extensions,
) {
  return {
    if (extensions.hasCredProtect())
      'credProtect': {
        'credentialProtectionPolicy': ?_passkeyCredentialProtectionPolicy(
          extensions.credProtect.credentialProtectionPolicy,
        ),
        if (extensions.credProtect.hasEnforceCredentialProtectionPolicy())
          'enforceCredentialProtectionPolicy':
              extensions.credProtect.enforceCredentialProtectionPolicy,
      },
    if (extensions.hasUvm()) 'uvm': extensions.uvm,
    if (extensions.hasCredProps()) 'credProps': extensions.credProps,
    if (extensions.hasMinPinLength()) 'minPinLength': extensions.minPinLength,
    if (extensions.hasHmacCreateSecret())
      'hmacCreateSecret': extensions.hmacCreateSecret,
  };
}

Map<String, dynamic> _passkeyAuthenticationExtensionsToJson(
  passkey.PasskeyAuthenticationExtensionsInput extensions,
) {
  return {
    if (extensions.appid.isNotEmpty) 'appid': extensions.appid,
    if (extensions.hasUvm()) 'uvm': extensions.uvm,
    if (extensions.hasHmacGetSecret())
      'hmacGetSecret': {
        'output1': _passkeyBytesToBase64Url(extensions.hmacGetSecret.output1),
        if (extensions.hmacGetSecret.output2.isNotEmpty)
          'output2': _passkeyBytesToBase64Url(extensions.hmacGetSecret.output2),
      },
  };
}

Map<String, dynamic> _passkeyCredentialDescriptorToJson(
  passkey.PasskeyCredentialDescriptor credential,
) {
  return {
    'type': _passkeyCredentialType(credential.type),
    'id': _passkeyBytesToBase64Url(credential.id),
    'transports': credential.transports
        .map(_passkeyTransport)
        .whereType<String>()
        .toList(growable: false),
  };
}

String _passkeyBytesToBase64Url(List<int> bytes) =>
    base64UrlEncode(bytes).replaceAll('=', '');

String _passkeyCredentialType(passkey.PasskeyPublicKeyCredentialType value) {
  return switch (value) {
    passkey
        .PasskeyPublicKeyCredentialType
        .PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_PUBLIC_KEY =>
      'public-key',
    _ => throw FormatException('Unsupported Passkey credential type: $value'),
  };
}

String? _passkeyTransport(passkey.PasskeyAuthenticatorTransport value) {
  return switch (value) {
    passkey.PasskeyAuthenticatorTransport.PASSKEY_AUTHENTICATOR_TRANSPORT_USB =>
      'usb',
    passkey.PasskeyAuthenticatorTransport.PASSKEY_AUTHENTICATOR_TRANSPORT_NFC =>
      'nfc',
    passkey.PasskeyAuthenticatorTransport.PASSKEY_AUTHENTICATOR_TRANSPORT_BLE =>
      'ble',
    passkey
        .PasskeyAuthenticatorTransport
        .PASSKEY_AUTHENTICATOR_TRANSPORT_INTERNAL =>
      'internal',
    passkey
        .PasskeyAuthenticatorTransport
        .PASSKEY_AUTHENTICATOR_TRANSPORT_HYBRID =>
      'hybrid',
    passkey
        .PasskeyAuthenticatorTransport
        .PASSKEY_AUTHENTICATOR_TRANSPORT_TEST =>
      'test',
    passkey
        .PasskeyAuthenticatorTransport
        .PASSKEY_AUTHENTICATOR_TRANSPORT_UNKNOWN =>
      'unknown',
    _ => null,
  };
}

String? _passkeyAuthenticatorAttachment(
  passkey.PasskeyAuthenticatorAttachment value,
) {
  return switch (value) {
    passkey
        .PasskeyAuthenticatorAttachment
        .PASSKEY_AUTHENTICATOR_ATTACHMENT_PLATFORM =>
      'platform',
    passkey
        .PasskeyAuthenticatorAttachment
        .PASSKEY_AUTHENTICATOR_ATTACHMENT_CROSS_PLATFORM =>
      'cross-platform',
    _ => null,
  };
}

String? _passkeyResidentKey(passkey.PasskeyResidentKeyRequirement value) {
  return switch (value) {
    passkey
        .PasskeyResidentKeyRequirement
        .PASSKEY_RESIDENT_KEY_REQUIREMENT_DISCOURAGED =>
      'discouraged',
    passkey
        .PasskeyResidentKeyRequirement
        .PASSKEY_RESIDENT_KEY_REQUIREMENT_PREFERRED =>
      'preferred',
    passkey
        .PasskeyResidentKeyRequirement
        .PASSKEY_RESIDENT_KEY_REQUIREMENT_REQUIRED =>
      'required',
    _ => null,
  };
}

String? _passkeyUserVerification(
  passkey.PasskeyUserVerificationRequirement value,
) {
  return switch (value) {
    passkey
        .PasskeyUserVerificationRequirement
        .PASSKEY_USER_VERIFICATION_REQUIREMENT_REQUIRED =>
      'required',
    passkey
        .PasskeyUserVerificationRequirement
        .PASSKEY_USER_VERIFICATION_REQUIREMENT_PREFERRED =>
      'preferred',
    passkey
        .PasskeyUserVerificationRequirement
        .PASSKEY_USER_VERIFICATION_REQUIREMENT_DISCOURAGED =>
      'discouraged',
    _ => null,
  };
}

String? _passkeyAttestation(
  passkey.PasskeyAttestationConveyancePreference value,
) {
  return switch (value) {
    passkey
        .PasskeyAttestationConveyancePreference
        .PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_NONE =>
      'none',
    passkey
        .PasskeyAttestationConveyancePreference
        .PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_INDIRECT =>
      'indirect',
    passkey
        .PasskeyAttestationConveyancePreference
        .PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_DIRECT =>
      'direct',
    _ => null,
  };
}

String? _passkeyHint(passkey.PasskeyPublicKeyCredentialHint value) {
  return switch (value) {
    passkey
        .PasskeyPublicKeyCredentialHint
        .PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_SECURITY_KEY =>
      'security-key',
    passkey
        .PasskeyPublicKeyCredentialHint
        .PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_CLIENT_DEVICE =>
      'client-device',
    passkey
        .PasskeyPublicKeyCredentialHint
        .PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_HYBRID =>
      'hybrid',
    _ => null,
  };
}

String? _passkeyAttestationFormat(passkey.PasskeyAttestationFormat value) {
  return switch (value) {
    passkey.PasskeyAttestationFormat.PASSKEY_ATTESTATION_FORMAT_PACKED =>
      'packed',
    passkey.PasskeyAttestationFormat.PASSKEY_ATTESTATION_FORMAT_TPM => 'tpm',
    passkey.PasskeyAttestationFormat.PASSKEY_ATTESTATION_FORMAT_ANDROID_KEY =>
      'android-key',
    passkey
        .PasskeyAttestationFormat
        .PASSKEY_ATTESTATION_FORMAT_ANDROID_SAFETYNET =>
      'android-safetynet',
    passkey.PasskeyAttestationFormat.PASSKEY_ATTESTATION_FORMAT_FIDO_U2F =>
      'fido-u2f',
    passkey.PasskeyAttestationFormat.PASSKEY_ATTESTATION_FORMAT_APPLE =>
      'apple',
    passkey.PasskeyAttestationFormat.PASSKEY_ATTESTATION_FORMAT_NONE => 'none',
    _ => null,
  };
}

String? _passkeyCredentialProtectionPolicy(
  passkey.PasskeyCredentialProtectionPolicy value,
) {
  return switch (value) {
    passkey
        .PasskeyCredentialProtectionPolicy
        .PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL =>
      'userVerificationOptional',
    passkey
        .PasskeyCredentialProtectionPolicy
        .PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL_WITH_CREDENTIAL_ID_LIST =>
      'userVerificationOptionalWithCredentialIDList',
    passkey
        .PasskeyCredentialProtectionPolicy
        .PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_REQUIRED =>
      'userVerificationRequired',
    _ => null,
  };
}

String? _passkeyMediation(passkey.PasskeyMediationRequirement value) {
  return switch (value) {
    passkey
        .PasskeyMediationRequirement
        .PASSKEY_MEDIATION_REQUIREMENT_CONDITIONAL =>
      'conditional',
    _ => null,
  };
}

passkey.PasskeyRegistrationCredential passkeyRegistrationCredentialFromJson(
  Object credential,
) {
  final decoded = _passkeyCredentialJson(credential);
  final response = _passkeyCredentialResponse(decoded);
  return passkey.PasskeyRegistrationCredential(
    id: _passkeyRequiredString(decoded, 'id'),
    rawId: _passkeyDecodeBytes(decoded['rawId'], 'rawId'),
    type: _passkeyCredentialTypeFromJson(decoded['type']),
    response: passkey.PasskeyAuthenticatorAttestationResponse(
      attestationObject: _passkeyDecodeBytes(
        response['attestationObject'],
        'response.attestationObject',
      ),
      clientDataJson: _passkeyDecodeBytes(
        response['clientDataJSON'],
        'response.clientDataJSON',
      ),
      transports: _passkeyTransportsFromJson(response['transports']),
    ),
    extensions: _passkeyRegistrationExtensionOutputsFromJson(
      decoded['clientExtensionResults'],
    ),
  );
}

passkey.PasskeyAuthenticationCredential passkeyAuthenticationCredentialFromJson(
  Object credential,
) {
  final decoded = _passkeyCredentialJson(credential);
  final response = _passkeyCredentialResponse(decoded);
  return passkey.PasskeyAuthenticationCredential(
    id: _passkeyRequiredString(decoded, 'id'),
    rawId: _passkeyDecodeBytes(decoded['rawId'], 'rawId'),
    type: _passkeyCredentialTypeFromJson(decoded['type']),
    response: passkey.PasskeyAuthenticatorAssertionResponse(
      authenticatorData: _passkeyDecodeBytes(
        response['authenticatorData'],
        'response.authenticatorData',
      ),
      clientDataJson: _passkeyDecodeBytes(
        response['clientDataJSON'],
        'response.clientDataJSON',
      ),
      signature: _passkeyDecodeBytes(
        response['signature'],
        'response.signature',
      ),
      userHandle: _passkeyOptionalBytes(
        response['userHandle'],
        'response.userHandle',
      ),
    ),
    extensions: _passkeyAuthenticationExtensionOutputsFromJson(
      decoded['clientExtensionResults'],
    ),
  );
}

passkey.PasskeyRegistrationExtensionsClientOutputs?
_passkeyRegistrationExtensionOutputsFromJson(Object? value) {
  final extensions = _passkeyStringMap(value);
  if (extensions == null || extensions.isEmpty) return null;
  final credProps = _passkeyStringMap(extensions['credProps']);
  final appid = extensions['appid'];
  final hmacSecret = extensions['hmacSecret'];
  final minPinLength = extensions['minPinLength'];
  final credProtect = _passkeyCredentialProtectionPolicyFromJson(
    extensions['credProtect'],
  );
  final hasKnownOutput =
      appid is bool ||
      credProps?['rk'] is bool ||
      hmacSecret is bool ||
      minPinLength is int ||
      credProtect != null;
  if (!hasKnownOutput) return null;
  return passkey.PasskeyRegistrationExtensionsClientOutputs(
    appid: appid is bool ? appid : null,
    credProps: credProps?['rk'] is bool
        ? passkey.PasskeyRegistrationCredProps(rk: credProps!['rk'] as bool)
        : null,
    hmacSecret: hmacSecret is bool ? hmacSecret : null,
    credProtect:
        credProtect ??
        passkey
            .PasskeyCredentialProtectionPolicy
            .PASSKEY_CREDENTIAL_PROTECTION_POLICY_UNSPECIFIED,
    minPinLength: minPinLength is int ? minPinLength : null,
  );
}

passkey.PasskeyAuthenticationExtensionsClientOutputs?
_passkeyAuthenticationExtensionOutputsFromJson(Object? value) {
  final extensions = _passkeyStringMap(value);
  if (extensions == null || extensions.isEmpty) return null;
  final appid = extensions['appid'];
  final hmac = _passkeyStringMap(extensions['hmacGetSecret']);
  final output1 = hmac?['output1'];
  if (appid is! bool && output1 is! String) return null;
  return passkey.PasskeyAuthenticationExtensionsClientOutputs(
    appid: appid is bool ? appid : null,
    hmacGetSecret: output1 is String
        ? passkey.PasskeyHmacGetSecretInput(
            output1: _passkeyDecodeBytes(
              output1,
              'clientExtensionResults.hmacGetSecret.output1',
            ),
            output2: _passkeyOptionalBytes(
              hmac?['output2'],
              'clientExtensionResults.hmacGetSecret.output2',
            ),
          )
        : null,
  );
}

Map<String, dynamic>? _passkeyStringMap(Object? value) {
  if (value case final Map<Object?, Object?> values) {
    return values.map((key, entry) => MapEntry(key.toString(), entry));
  }
  return null;
}

passkey.PasskeyCredentialProtectionPolicy?
_passkeyCredentialProtectionPolicyFromJson(Object? value) {
  return switch (value) {
    'userVerificationOptional' || 1 =>
      passkey
          .PasskeyCredentialProtectionPolicy
          .PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL,
    'userVerificationOptionalWithCredentialIDList' || 2 =>
      passkey
          .PasskeyCredentialProtectionPolicy
          .PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL_WITH_CREDENTIAL_ID_LIST,
    'userVerificationRequired' || 3 =>
      passkey
          .PasskeyCredentialProtectionPolicy
          .PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_REQUIRED,
    _ => null,
  };
}

Map<String, dynamic> _passkeyCredentialJson(Object credential) {
  final decoded = credential is String ? jsonDecode(credential) : credential;
  if (decoded case final Map<Object?, Object?> values) {
    return values.map((key, value) => MapEntry(key.toString(), value));
  }
  throw const FormatException('Passkey credential is not a JSON object');
}

Map<String, dynamic> _passkeyCredentialResponse(
  Map<String, dynamic> credential,
) {
  final response = credential['response'];
  if (response case final Map<Object?, Object?> values) {
    return values.map((key, value) => MapEntry(key.toString(), value));
  }
  throw const FormatException('Passkey credential response is missing');
}

String _passkeyRequiredString(Map<String, dynamic> values, String field) {
  final value = values[field];
  if (value is String && value.isNotEmpty) return value;
  throw FormatException('Passkey credential $field is missing');
}

List<int> _passkeyDecodeBytes(Object? value, String field) {
  if (value is! String || value.isEmpty) {
    throw FormatException('Passkey credential $field is missing');
  }
  try {
    return base64Url.decode(base64Url.normalize(value));
  } on FormatException {
    throw FormatException('Passkey credential $field is not Base64URL');
  }
}

List<int> _passkeyOptionalBytes(Object? value, String field) {
  if (value == null || value == '') return const [];
  return _passkeyDecodeBytes(value, field);
}

passkey.PasskeyPublicKeyCredentialType _passkeyCredentialTypeFromJson(
  Object? value,
) {
  if (value == 'public-key' || value == 1) {
    return passkey
        .PasskeyPublicKeyCredentialType
        .PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_PUBLIC_KEY;
  }
  throw FormatException('Unsupported Passkey credential type: $value');
}

Iterable<passkey.PasskeyAuthenticatorTransport> _passkeyTransportsFromJson(
  Object? value,
) sync* {
  if (value == null) return;
  if (value is! List) {
    throw const FormatException('Passkey credential transports is not a list');
  }
  for (final transport in value) {
    yield switch (transport) {
      'usb' || 1 =>
        passkey
            .PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_USB,
      'nfc' || 2 =>
        passkey
            .PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_NFC,
      'ble' || 3 =>
        passkey
            .PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_BLE,
      'internal' || 4 =>
        passkey
            .PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_INTERNAL,
      'hybrid' || 5 =>
        passkey
            .PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_HYBRID,
      'test' || 6 =>
        passkey
            .PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_TEST,
      'unknown' || 7 =>
        passkey
            .PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_UNKNOWN,
      _ => throw FormatException(
        'Unsupported Passkey authenticator transport: $transport',
      ),
    };
  }
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
