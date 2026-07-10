import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as pb;
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart'
    as oauth2_enum;
import 'package:synctv_app/src/generated/proto/passkey.pb.dart' as passkey;

Map<String, dynamic> protoMessageToJsonMap(pb.GeneratedMessage message) {
  final json = message.toProto3Json();
  if (json is Map) {
    return Map<String, dynamic>.from(json);
  }
  return const {};
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

client.UpdateRoomSettingsRequest roomSettingsPatchFromJson(
  Map<String, dynamic> json,
) {
  final patch = client.UpdateRoomSettingsRequest();
  void setBool(String key, void Function(bool) set) {
    if (json.containsKey(key)) set(json[key] == true);
  }

  void setInt64(String key, void Function(Int64) set) {
    if (json.containsKey(key)) set(Int64(_intValue(json[key])));
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
    }
    if (autoPlay.containsKey('mode')) {
      autoPlayPatch.mode =
          client.PlayMode.valueOf(_intValue(autoPlay['mode'])) ??
          client.PlayMode.PLAY_MODE_UNSPECIFIED;
    }
    if (autoPlay.containsKey('delay')) {
      autoPlayPatch.delay = _intValue(autoPlay['delay']);
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
  return patch;
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
  final alistPath = json['relativePath'] ?? json['path'];
  if (alistPath != null) {
    target.alist = client.AlistTarget(relativePath: alistPath.toString());
    return target;
  }
  final embyItemId = json['itemId'];
  if (embyItemId != null) {
    target.emby = client.EmbyTarget(itemId: embyItemId.toString());
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
    client.ProviderTarget_Target.emby => {'itemId': target.emby.itemId},
    client.ProviderTarget_Target.notSet => <String, dynamic>{},
  };
}

Map<String, dynamic> resourceMetadataToJson(client.ResourceMetadata metadata) {
  return {
    if (metadata.hasSource()) 'source': metadata.source,
    if (metadata.hasSource()) 'url': metadata.source,
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
