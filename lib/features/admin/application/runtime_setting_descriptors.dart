import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/l10n/l10n.dart';

enum SettingEditorKind {
  boolean,
  number,
  text,
  optionalText,
  enumChoice,
  stringList,
  permissionList,
  oauth2Providers,
  iceServers,
  smtpCredentials,
  smtpProxy,
  map,
  list,
}

class SettingDescriptor {
  final String group;
  final String key;
  final String title;
  final String description;
  final IconData icon;
  final SettingEditorKind kind;
  final List<SettingChoice> choices;
  final List<String>? permissions;
  final String? warning;
  final bool secret;

  const SettingDescriptor({
    required this.group,
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.kind,
    this.choices = const [],
    this.permissions,
    this.warning,
    this.secret = false,
  });
}

class SettingChoice {
  final String value;
  final String label;
  final String description;

  const SettingChoice(this.value, this.label, this.description);
}

List<SettingChoice> _roomPasswordChoices(AppLocalizations l10n) => [
  SettingChoice(
    'ROOM_PASSWORD_POLICY_OPTIONAL',
    l10n.optional,
    l10n.roomPasswordOptionalDescription,
  ),
  SettingChoice(
    'ROOM_PASSWORD_POLICY_REQUIRED',
    l10n.required,
    l10n.roomPasswordRequiredDescription,
  ),
  SettingChoice(
    'ROOM_PASSWORD_POLICY_FORBIDDEN',
    l10n.disabled,
    l10n.roomPasswordDisabledDescription,
  ),
];

const List<String> oauth2ProviderTypes = [
  'qq',
  'github',
  'google',
  'microsoft',
  'discord',
  'casdoor',
  'logto',
  'oidc',
  'feishu',
  'gitee',
  'apple',
];

const Map<String, String> oauth2ProviderTypeLabels = {
  'qq': 'QQ',
  'github': 'GitHub',
  'google': 'Google',
  'microsoft': 'Microsoft',
  'discord': 'Discord',
  'casdoor': 'Casdoor',
  'logto': 'Logto',
  'oidc': 'OIDC',
  'feishu': 'Feishu',
  'gitee': 'Gitee',
  'apple': 'Apple',
};

const List<String> knownSettingPermissions = [
  'send_chat_messages',
  'manage_own_media',
  'browse_library',
  'view_members',
  'view_chat_history',
  'use_voice_chat',
  'use_p2p_media',
  'delete_media',
  'reorder_media',
  'clear_media',
  'manage_live_streams',
  'control_playback_state',
  'navigate_playback',
  'review_join_requests',
  'remove_members',
  'manage_member_permissions',
  'add_members',
  'manage_room_settings',
  'delete_chat_messages',
  'delete_room',
  'view_playback_history',
];

const List<String> _guestPermissions = [
  'view_members',
  'view_chat_history',
  'use_voice_chat',
  'use_p2p_media',
];

String settingPermissionLabel(AppLocalizations l10n, String permission) =>
    switch (permission) {
      'send_chat_messages' => l10n.sendChat,
      'manage_own_media' => l10n.roomPermissionManageOwnMedia,
      'browse_library' => l10n.browseLibrary,
      'view_members' => l10n.viewMembers,
      'view_chat_history' => l10n.viewChatHistory,
      'use_voice_chat' => l10n.voiceChat,
      'use_p2p_media' => l10n.p2pMedia,
      'delete_media' => l10n.deleteMedia,
      'reorder_media' => l10n.roomPermissionReorderMedia,
      'clear_media' => l10n.roomPermissionClearMedia,
      'manage_live_streams' => l10n.roomPermissionManageLiveStreams,
      'control_playback_state' => l10n.playbackControl,
      'navigate_playback' => l10n.roomPermissionNavigatePlayback,
      'review_join_requests' => l10n.roomPermissionReviewJoinRequests,
      'remove_members' => l10n.roomPermissionRemoveMembers,
      'manage_member_permissions' => l10n.roomPermissionManageMemberPermissions,
      'add_members' => l10n.roomPermissionAddMembers,
      'manage_room_settings' => l10n.roomPermissionManageRoomSettings,
      'delete_chat_messages' => l10n.roomPermissionDeleteChatMessages,
      'delete_room' => l10n.deleteRoom,
      'view_playback_history' => l10n.viewPlaybackHistory,
      _ => permission,
    };

const Map<String, int> runtimePermissionBits = {
  'send_chat_messages': RoomEffectivePermissions.sendChatMessages,
  'manage_own_media': RoomEffectivePermissions.manageOwnMedia,
  'browse_library': RoomEffectivePermissions.browseLibrary,
  'view_members': RoomEffectivePermissions.viewMembers,
  'view_chat_history': RoomEffectivePermissions.viewChatHistory,
  'use_voice_chat': RoomEffectivePermissions.useVoiceChat,
  'use_p2p_media': RoomEffectivePermissions.useP2pMedia,
  'delete_media': RoomEffectivePermissions.deleteMedia,
  'reorder_media': RoomEffectivePermissions.reorderMedia,
  'clear_media': RoomEffectivePermissions.clearMedia,
  'manage_live_streams': RoomEffectivePermissions.manageLiveStreams,
  'control_playback_state': RoomEffectivePermissions.controlPlaybackState,
  'navigate_playback': RoomEffectivePermissions.navigatePlayback,
  'review_join_requests': RoomEffectivePermissions.reviewJoinRequests,
  'remove_members': RoomEffectivePermissions.removeMembers,
  'manage_member_permissions': RoomEffectivePermissions.manageMemberPermissions,
  'add_members': RoomEffectivePermissions.addMembers,
  'manage_room_settings': RoomEffectivePermissions.manageRoomSettings,
  'delete_chat_messages': RoomEffectivePermissions.deleteChatMessages,
  'delete_room': RoomEffectivePermissions.deleteRoom,
  'view_playback_history': RoomEffectivePermissions.viewPlaybackHistory,
};

String settingsSectionLabel(AppLocalizations l10n, String section) =>
    switch (section) {
      'roomDefaults' => l10n.roomDefaults,
      'roomCreation' => l10n.roomCreation,
      'server' => l10n.server,
      'room' => l10n.rooms,
      'user' => l10n.users,
      'oauth2' => 'OAuth2',
      'rtmp' => l10n.streaming,
      'email' => l10n.email,
      'webrtc' => 'WebRTC',
      'chat' => l10n.chat,
      'playbackHistory' => l10n.playbackHistory,
      'cors' => l10n.cors,
      'permissions' => l10n.permissions,
      _ => section,
    };

String humanizeSettingKey(String key) {
  return key
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

bool isSecretKey(String key) {
  final lower = key.toLowerCase();
  return lower.contains('secret') ||
      lower.contains('password') ||
      lower.contains('credential') ||
      lower.contains('token') ||
      lower.contains('key');
}

SettingDescriptor settingDescriptor(
  AppLocalizations l10n,
  String section,
  String key,
  dynamic value,
) {
  final id = '$section.$key';
  final known = <String, SettingDescriptor>{
    'server.name': SettingDescriptor(
      group: 'server',
      key: 'name',
      title: l10n.runtimeServerName,
      description: l10n.runtimeServerNameDescription,
      icon: Icons.dns_outlined,
      kind: SettingEditorKind.text,
    ),
    'roomDefaults.defaultMaxMembers': SettingDescriptor(
      group: 'roomDefaults',
      key: 'defaultMaxMembers',
      title: l10n.defaultRoomMemberLimit,
      description: l10n.defaultRoomMemberLimitDescription,
      icon: Icons.groups_2_outlined,
      kind: SettingEditorKind.number,
    ),
    'roomDefaults.defaultMaxChatMessages': SettingDescriptor(
      group: 'roomDefaults',
      key: 'defaultMaxChatMessages',
      title: l10n.roomChatSnapshotLimit,
      description: l10n.roomChatSnapshotLimitDescription,
      icon: Icons.forum_outlined,
      kind: SettingEditorKind.number,
    ),
    'roomCreation.enabled': SettingDescriptor(
      group: 'roomCreation',
      key: 'enabled',
      title: l10n.allowRoomCreation,
      description: l10n.allowRoomCreationDescription,
      icon: Icons.add_home_work_outlined,
      kind: SettingEditorKind.boolean,
    ),
    'roomCreation.approvalRequired': SettingDescriptor(
      group: 'roomCreation',
      key: 'approvalRequired',
      title: l10n.roomCreationRequiresReview,
      description: l10n.roomCreationRequiresReviewDescription,
      icon: Icons.fact_check_outlined,
      kind: SettingEditorKind.boolean,
    ),
    'roomCreation.passwordPolicy': SettingDescriptor(
      group: 'roomCreation',
      key: 'passwordPolicy',
      title: l10n.roomPasswordPolicy,
      description: l10n.roomPasswordPolicyDescription,
      icon: Icons.password_rounded,
      kind: SettingEditorKind.enumChoice,
      choices: _roomPasswordChoices(l10n),
    ),
    'roomCreation.maxRoomsPerUser': SettingDescriptor(
      group: 'roomCreation',
      key: 'maxRoomsPerUser',
      title: l10n.maximumRoomsPerUser,
      description: l10n.maximumRoomsPerUserDescription,
      icon: Icons.meeting_room_outlined,
      kind: SettingEditorKind.number,
    ),
    'user.enablePasswordSignup': SettingDescriptor(
      group: 'user',
      key: 'enablePasswordSignup',
      title: l10n.allowPasswordSignup,
      description: l10n.allowPasswordSignupDescription,
      icon: Icons.person_add_alt_1_outlined,
      kind: SettingEditorKind.boolean,
    ),
    'user.passwordSignupNeedReview': SettingDescriptor(
      group: 'user',
      key: 'passwordSignupNeedReview',
      title: l10n.passwordSignupRequiresReview,
      description: l10n.passwordSignupRequiresReviewDescription,
      icon: Icons.how_to_reg_outlined,
      kind: SettingEditorKind.boolean,
    ),
    'user.enableEmailSignup': SettingDescriptor(
      group: 'user',
      key: 'enableEmailSignup',
      title: l10n.allowEmailSignup,
      description: l10n.allowEmailSignupDescription,
      icon: Icons.alternate_email_rounded,
      kind: SettingEditorKind.boolean,
    ),
    'user.emailSignupNeedReview': SettingDescriptor(
      group: 'user',
      key: 'emailSignupNeedReview',
      title: l10n.emailSignupRequiresReview,
      description: l10n.emailSignupRequiresReviewDescription,
      icon: Icons.mark_email_read_outlined,
      kind: SettingEditorKind.boolean,
    ),
    'user.enableWebauthnSignup': SettingDescriptor(
      group: 'user',
      key: 'enableWebauthnSignup',
      title: l10n.allowPasskeySignup,
      description: l10n.allowPasskeySignupDescription,
      icon: Icons.fingerprint_rounded,
      kind: SettingEditorKind.boolean,
    ),
    'user.webauthnSignupNeedReview': SettingDescriptor(
      group: 'user',
      key: 'webauthnSignupNeedReview',
      title: l10n.passkeySignupRequiresReview,
      description: l10n.passkeySignupRequiresReviewDescription,
      icon: Icons.verified_user_outlined,
      kind: SettingEditorKind.boolean,
    ),
    'user.enableGuest': SettingDescriptor(
      group: 'user',
      key: 'enableGuest',
      title: l10n.allowGuests,
      description: l10n.allowGuestsDescription,
      icon: Icons.person_outline_rounded,
      kind: SettingEditorKind.boolean,
      warning: l10n.allowGuestsWarning,
    ),
    'oauth2.providers': SettingDescriptor(
      group: 'oauth2',
      key: 'providers',
      title: l10n.externalLogin,
      description: l10n.externalLoginDescription,
      icon: Icons.account_tree_outlined,
      kind: SettingEditorKind.oauth2Providers,
      warning: l10n.externalLoginWarning,
    ),
    'oauth2.allowedRedirectUrls': SettingDescriptor(
      group: 'oauth2',
      key: 'allowedRedirectUrls',
      title: l10n.callbackUrl,
      description: l10n.externalLoginDescription,
      icon: Icons.link_rounded,
      kind: SettingEditorKind.stringList,
    ),
    'rtmp.advertiseAddress': SettingDescriptor(
      group: 'rtmp',
      key: 'advertiseAddress',
      title: l10n.rtmpAdvertiseAddress,
      description: l10n.rtmpAdvertiseAddressDescription,
      icon: Icons.podcasts_outlined,
      kind: SettingEditorKind.optionalText,
    ),
    'rtmp.tsDisguisedAsPng': SettingDescriptor(
      group: 'rtmp',
      key: 'tsDisguisedAsPng',
      title: l10n.tsSegmentsAsPng,
      description: l10n.tsSegmentsAsPngDescription,
      icon: Icons.image_outlined,
      kind: SettingEditorKind.boolean,
    ),
    'email.enabled': SettingDescriptor(
      group: 'email',
      key: 'enabled',
      title: l10n.enableEmailService,
      description: l10n.enableEmailServiceDescription,
      icon: Icons.outgoing_mail,
      kind: SettingEditorKind.boolean,
      warning: l10n.enableEmailServiceWarning,
    ),
    'email.smtpHost': SettingDescriptor(
      group: 'email',
      key: 'smtpHost',
      title: l10n.smtpHost,
      description: l10n.smtpHostDescription,
      icon: Icons.dns_outlined,
      kind: SettingEditorKind.optionalText,
    ),
    'email.smtpPort': SettingDescriptor(
      group: 'email',
      key: 'smtpPort',
      title: l10n.smtpPort,
      description: l10n.smtpPortDescription,
      icon: Icons.numbers_rounded,
      kind: SettingEditorKind.number,
    ),
    'email.smtpCredentials': SettingDescriptor(
      group: 'email',
      key: 'smtpCredentials',
      title: l10n.smtpAuthentication,
      description: l10n.smtpAuthenticationDescription,
      icon: Icons.password_rounded,
      kind: SettingEditorKind.smtpCredentials,
      warning: l10n.smtpAuthenticationWarning,
    ),
    'email.smtpProxy': SettingDescriptor(
      group: 'email',
      key: 'smtpProxy',
      title: l10n.smtpProxy,
      description: l10n.smtpProxyDescription,
      icon: Icons.route_outlined,
      kind: SettingEditorKind.smtpProxy,
      warning: l10n.smtpProxyWarning,
    ),
    'email.useTls': SettingDescriptor(
      group: 'email',
      key: 'useTls',
      title: l10n.useTls,
      description: l10n.useTlsDescription,
      icon: Icons.enhanced_encryption_outlined,
      kind: SettingEditorKind.boolean,
      warning: l10n.useTlsWarning,
    ),
    'email.fromEmail': SettingDescriptor(
      group: 'email',
      key: 'fromEmail',
      title: l10n.senderEmail,
      description: l10n.senderEmailDescription,
      icon: Icons.alternate_email_rounded,
      kind: SettingEditorKind.optionalText,
    ),
    'email.fromName': SettingDescriptor(
      group: 'email',
      key: 'fromName',
      title: l10n.senderDisplayName,
      description: l10n.senderDisplayNameDescription,
      icon: Icons.badge_outlined,
      kind: SettingEditorKind.text,
    ),
    'email.whitelistEnabled': SettingDescriptor(
      group: 'email',
      key: 'whitelistEnabled',
      title: l10n.enableEmailWhitelist,
      description: l10n.enableEmailWhitelistDescription,
      icon: Icons.mark_email_unread_outlined,
      kind: SettingEditorKind.boolean,
    ),
    'email.whitelistDomains': SettingDescriptor(
      group: 'email',
      key: 'whitelistDomains',
      title: l10n.emailWhitelist,
      description: l10n.emailWhitelistDescription,
      icon: Icons.playlist_add_check_rounded,
      kind: SettingEditorKind.stringList,
    ),
    'webrtc.externalIceServers': SettingDescriptor(
      group: 'webrtc',
      key: 'externalIceServers',
      title: l10n.externalIceServers,
      description: l10n.externalIceServersDescription,
      icon: Icons.settings_input_antenna_rounded,
      kind: SettingEditorKind.iceServers,
      warning: l10n.externalIceServersWarning,
    ),
    'webrtc.maxVoiceParticipantsPerRoom': SettingDescriptor(
      group: 'webrtc',
      key: 'maxVoiceParticipantsPerRoom',
      title: l10n.maxVoiceParticipantsPerRoom,
      description: l10n.maxVoiceParticipantsPerRoomDescription,
      icon: Icons.groups_2_outlined,
      kind: SettingEditorKind.number,
    ),
    'chat.maxMessagesPerRoom': SettingDescriptor(
      group: 'chat',
      key: 'maxMessagesPerRoom',
      title: l10n.chatMessagesPerRoom,
      description: l10n.chatMessagesPerRoomDescription,
      icon: Icons.chat_bubble_outline_rounded,
      kind: SettingEditorKind.number,
    ),
    'chat.maxPinnedMessagesPerRoom': SettingDescriptor(
      group: 'chat',
      key: 'maxPinnedMessagesPerRoom',
      title: l10n.maxPinnedMessagesPerRoom,
      description: l10n.maxPinnedMessagesPerRoomDescription,
      icon: Icons.push_pin_outlined,
      kind: SettingEditorKind.number,
    ),
    'chat.messageRetentionDays': SettingDescriptor(
      group: 'chat',
      key: 'messageRetentionDays',
      title: l10n.chatRetentionDays,
      description: l10n.chatRetentionDaysDescription,
      icon: Icons.history_toggle_off_rounded,
      kind: SettingEditorKind.number,
    ),
    'playbackHistory.retentionDays': SettingDescriptor(
      group: 'playbackHistory',
      key: 'retentionDays',
      title: l10n.playbackHistoryRetentionDays,
      description: l10n.playbackHistoryRetentionDaysDescription,
      icon: Icons.history_toggle_off_rounded,
      kind: SettingEditorKind.number,
    ),
    'playbackHistory.maxEntriesPerRoom': SettingDescriptor(
      group: 'playbackHistory',
      key: 'maxEntriesPerRoom',
      title: l10n.playbackHistoryMaxEntries,
      description: l10n.playbackHistoryMaxEntriesDescription,
      icon: Icons.format_list_numbered_rounded,
      kind: SettingEditorKind.number,
    ),
    'cors.allowedOrigins': SettingDescriptor(
      group: 'cors',
      key: 'allowedOrigins',
      title: l10n.allowedCorsOrigins,
      description: l10n.allowedCorsOriginsDescription,
      icon: Icons.public_rounded,
      kind: SettingEditorKind.stringList,
      warning: l10n.allowedCorsOriginsWarning,
    ),
    'permissions.adminDefaultPermissions': SettingDescriptor(
      group: 'permissions',
      key: 'adminDefaultPermissions',
      title: l10n.adminDefaultPermissions,
      description: l10n.adminDefaultPermissionsDescription,
      icon: Icons.admin_panel_settings_outlined,
      kind: SettingEditorKind.permissionList,
    ),
    'permissions.memberDefaultPermissions': SettingDescriptor(
      group: 'permissions',
      key: 'memberDefaultPermissions',
      title: l10n.memberDefaultPermissions,
      description: l10n.memberDefaultPermissionsDescription,
      icon: Icons.group_outlined,
      kind: SettingEditorKind.permissionList,
    ),
    'permissions.guestDefaultPermissions': SettingDescriptor(
      group: 'permissions',
      key: 'guestDefaultPermissions',
      title: l10n.guestDefaultPermissions,
      description: l10n.guestDefaultPermissionsDescription,
      icon: Icons.person_pin_circle_outlined,
      kind: SettingEditorKind.permissionList,
      permissions: _guestPermissions,
      warning: l10n.guestDefaultPermissionsWarning,
    ),
  };
  final descriptor = known[id];
  if (descriptor != null) return descriptor;

  final kind = switch (value) {
    bool _ => SettingEditorKind.boolean,
    int _ || double _ || num _ => SettingEditorKind.number,
    Map _ => SettingEditorKind.map,
    List _ => SettingEditorKind.list,
    _ => SettingEditorKind.text,
  };
  return SettingDescriptor(
    group: section,
    key: key,
    title: humanizeSettingKey(key),
    description: l10n.runtimeSectionDescription(
      settingsSectionLabel(l10n, section),
    ),
    icon: Icons.tune_rounded,
    kind: kind,
    secret: isSecretKey(key),
  );
}
