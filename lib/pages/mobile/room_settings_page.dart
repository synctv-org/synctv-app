import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/realtime_event_log.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/pages/mobile/admin_settings_page.dart';
import 'package:synctv_app/services/realtime_event_log_preferences.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/local_image_picker.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/widgets/app_responsive_layout.dart';
import 'package:synctv_app/widgets/add_movie_dialog.dart';
import 'package:synctv_app/widgets/chat_read_receipts_dialog.dart';
import 'package:synctv_app/widgets/chat_reaction_users_dialog.dart';
import 'package:synctv_app/widgets/realtime_event_log_view.dart';

const Map<String, String> _mediaSourceLabels = {
  '': '全部来源',
  'directUrl': '直链',
  'bilibili': 'Bilibili',
  'alist': 'AList',
  'emby': 'Emby',
  'rtmp': 'RTMP',
};

const String _settingsObserveId = 'manage_room_settings';
const String _membersObserveId = 'manage_room_member_events';
const String _membersOnlineCountObserveId = 'manage_member_online_count';
const String _mediaObserveId = 'manage_playlist_items';
const String _chatObserveId = 'manage_chat_events';
const Set<String> _managementObserveIds = {
  _settingsObserveId,
  _membersObserveId,
  _membersOnlineCountObserveId,
  _mediaObserveId,
  _chatObserveId,
};

const Set<String> _mediaSourcesWithProviderInstances = {
  'alist',
  'emby',
  'bilibili',
};

String _providerInstanceLabel(String instanceName) {
  return instanceName.isEmpty ? '本地实例' : instanceName;
}

class _RoomSettingsSection {
  final String label;
  final IconData icon;
  final Widget Function(ThemeData theme, bool isDark) builder;

  const _RoomSettingsSection({
    required this.label,
    required this.icon,
    required this.builder,
  });
}

class _RealtimeWatchStats {
  int observed = 0;
  int changed = 0;
  int errors = 0;
  DateTime? lastSeenAt;
  String lastKind = '等待';
  String lastError = '';

  int get total => observed + changed + errors;

  void reset() {
    observed = 0;
    changed = 0;
    errors = 0;
    lastSeenAt = null;
    lastKind = '等待';
    lastError = '';
  }

  void record<T>(RoomResourceWatchEvent<T> event) {
    lastSeenAt = DateTime.now();
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        observed += 1;
        lastKind = event.changed ? '已观测，有变更' : '已观测，无变更';
        lastError = '';
        break;
      case RoomResourceWatchKind.changed:
        changed += 1;
        lastKind = '已推送快照';
        lastError = '';
        break;
      case RoomResourceWatchKind.error:
        errors += 1;
        lastKind = '异常';
        lastError = event.errorMessage;
        break;
    }
  }
}

class _RealtimeResourceDebugInfo {
  final String key;
  final String title;
  final IconData icon;
  final String observeId;
  final String version;
  final bool loading;
  final int localCount;
  final String summary;
  final Map<String, Object?> details;
  final _RealtimeWatchStats stats;

  const _RealtimeResourceDebugInfo({
    required this.key,
    required this.title,
    required this.icon,
    required this.observeId,
    required this.version,
    required this.loading,
    required this.localCount,
    required this.summary,
    required this.details,
    required this.stats,
  });
}

enum _RealtimeDiagnosticsPane { overview, resources, events }

class RoomSettingsPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String creatorId;
  final String currentUserId;
  final SyncTvRoomSettings currentSettings;
  final RoomRealtimeSession realtime;

  const RoomSettingsPage({
    super.key,
    required this.roomId,
    required this.roomName,
    this.creatorId = '',
    this.currentUserId = '',
    required this.currentSettings,
    required this.realtime,
  });

  @override
  State<RoomSettingsPage> createState() => _RoomSettingsPageState();
}

class _RoomSettingsPageState extends State<RoomSettingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _passwordController;
  late final TextEditingController _maxMembersController;
  late final TextEditingController _streamSearchController;
  late final TextEditingController _memberSearchController;
  late final TextEditingController _reviewUserController;
  late final TextEditingController _mediaSearchController;
  late final TextEditingController _chatSearchController;
  late SyncTvRoomSettings _settings;

  final List<RoomStreamEntryInfo> _streams = [];
  final List<RoomJoinReviewInfo> _reviews = [];
  final List<AdminRoomMember> _members = [];
  final List<RoomChatMessageInfo> _chatMessages = [];
  final Map<String, ChatMessageReadReceiptsInfo> _chatReceiptCache = {};
  final List<IceServerInfo> _iceServers = [];
  final List<RealtimeEventLogEntry> _realtimeEvents = [];
  final List<String> _mediaPlaylistStack = [];
  final List<SyncTvMovie> _mediaPlaylistEntryStack = [];
  final List<String> _mediaTargetStack = [];
  StreamSubscription<RoomRealtimeMessage>? _realtimeMessageSubscription;
  StreamSubscription<RealtimeEventLogEntry>? _realtimeEventSubscription;
  StreamSubscription<void>? _realtimeReconnectSubscription;
  RoomMediaLibraryPage? _mediaPage;
  final _RealtimeWatchStats _settingsWatchStats = _RealtimeWatchStats();
  final _RealtimeWatchStats _membersWatchStats = _RealtimeWatchStats();
  final _RealtimeWatchStats _mediaWatchStats = _RealtimeWatchStats();
  final _RealtimeWatchStats _chatWatchStats = _RealtimeWatchStats();
  String _chatCursor = '';
  String _chatSearchCursor = '';
  String _chatSearchQuery = '';
  bool _chatHistoryLoaded = false;
  String _settingsWatchVersion = '';
  String _membersWatchVersion = '';
  String _mediaWatchVersion = '';
  String _chatWatchVersion = '';
  client_enum.MediaListSortBy _mediaSortBy =
      client_enum.MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION;
  client_enum.SortDirection _mediaSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_ASC;
  client_enum.ResourceAvailabilityFilter _mediaAvailability =
      client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL;
  String _mediaSourceProvider = '';
  String _mediaProviderInstanceName = '';
  List<String> _mediaProviderInstances = const [''];
  client_enum.SortDirection _streamSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_ASC;
  int _streamsPage = 1;
  final int _streamsPageSize = 50;
  int _streamsTotal = 0;
  int _reviewsPage = 1;
  final int _reviewsPageSize = 50;
  int _reviewsTotal = 0;
  int _membersPage = 1;
  final int _membersPageSize = 50;
  int _membersTotal = 0;
  int _membersOnlineCount = 0;
  common_enum.RoomMemberRole? _memberRoleFilter;
  client_enum.RoomMemberListSortBy _memberSortBy =
      client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT;
  client_enum.SortDirection _memberSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_DESC;
  common_enum.ReviewStatus _reviewStatusFilter =
      common_enum.ReviewStatus.REVIEW_STATUS_PENDING;
  _RealtimeDiagnosticsPane _realtimePane = _RealtimeDiagnosticsPane.overview;

  bool _allowGuestJoin = false;
  bool _requireApproval = false;
  bool _allowAutoJoin = true;
  bool _chatEnabled = true;
  bool _danmakuEnabled = true;
  int _memberPermissions = RoomMemberPermissions.all;
  int _guestPermissions = 0;
  bool _isSaving = false;
  bool _streamsLoading = false;
  bool _reviewsLoading = false;
  bool _membersLoading = false;
  bool _mediaLoading = false;
  bool _mediaProviderInstancesLoading = false;
  bool _chatLoading = false;
  bool _reviewsLoaded = false;
  final Set<String> _chatReceiptLoadingIds = {};
  bool _iceLoading = false;
  bool _coverUpdating = false;
  bool _passwordUpdating = false;
  ChatReadStateInfo? _chatReadState;
  late String _currentUserId;
  SyncTvRoom? _roomInfo;

  String get _roomCoverUrl => _roomInfo?.coverUrl ?? '';

  bool get _canLeaveRoom =>
      _currentUserId.isNotEmpty &&
      (widget.creatorId.isEmpty || _currentUserId != widget.creatorId);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _sections.length, vsync: this);
    _tabController.addListener(_handleTabChanged);
    _settings = widget.currentSettings;
    _currentUserId = widget.currentUserId;
    _passwordController = TextEditingController();
    _maxMembersController = TextEditingController();
    _streamSearchController = TextEditingController();
    _memberSearchController = TextEditingController();
    _reviewUserController = TextEditingController();
    _mediaSearchController = TextEditingController();
    _chatSearchController = TextEditingController();
    RealtimeEventLogPreferences.maxEntries.addListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    RealtimeEventLogPreferences.load().then((_) {
      if (mounted) _handleRealtimeLogMaxEntriesChanged();
    });
    _applySettings(_settings);
    _loadStreams();
    _loadMembers();
    _loadMediaProviderInstances();
    _loadMediaLibrary();
    _loadRoomInfo();
    _loadChatHistory();
    _loadIceServers();
    _loadCurrentUserIfNeeded();
    _realtimeMessageSubscription =
        widget.realtime.messages.listen(_handleRealtimeMessage);
    _realtimeEventSubscription =
        widget.realtime.events.listen(_handleRealtimeEvent);
    _realtimeReconnectSubscription = widget.realtime.reconnects.listen((_) {
      if (!mounted) return;
      _chatHistoryLoaded = false;
      _loadChatHistory();
      _startResourceWatches();
    });
    _startResourceWatches();
  }

  @override
  void dispose() {
    RealtimeEventLogPreferences.maxEntries.removeListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    _sendRealtime(
        RoomRealtimeCodec.encodeUnobserveResource(_settingsObserveId));
    _sendRealtime(RoomRealtimeCodec.encodeUnobserveResource(_membersObserveId));
    _sendRealtime(RoomRealtimeCodec.encodeUnobserveResource(
        _membersOnlineCountObserveId));
    _sendRealtime(RoomRealtimeCodec.encodeUnobserveResource(_mediaObserveId));
    _sendRealtime(RoomRealtimeCodec.encodeUnobserveResource(_chatObserveId));
    _realtimeMessageSubscription?.cancel();
    _realtimeEventSubscription?.cancel();
    _realtimeReconnectSubscription?.cancel();
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    _passwordController.dispose();
    _maxMembersController.dispose();
    _streamSearchController.dispose();
    _memberSearchController.dispose();
    _reviewUserController.dispose();
    _mediaSearchController.dispose();
    _chatSearchController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging) return;
    final selected = _sections[_tabController.index].label;
    if (selected == '审核' && !_reviewsLoaded && !_reviewsLoading) {
      _loadReviews();
    }
  }

  void _applySettings(SyncTvRoomSettings settings) {
    _allowGuestJoin = settings.allowGuestJoin;
    _requireApproval = settings.requireApproval;
    _allowAutoJoin = settings.allowAutoJoin;
    _chatEnabled = settings.chatEnabled;
    _danmakuEnabled = settings.danmakuEnabled;
    _memberPermissions = settings.effectiveMemberPermissions;
    _guestPermissions = settings.effectiveGuestPermissions;
    _maxMembersController.text = settings.maxMembers.toString();
  }

  void _startResourceWatches() {
    _startSettingsWatch();
    _startMembersWatch();
    _startMediaWatch();
    _startChatWatch();
  }

  Future<void> _loadCurrentUserIfNeeded() async {
    if (_currentUserId.isNotEmpty) return;
    try {
      final user = await SyncTvService.getMe();
      if (!mounted) return;
      setState(() => _currentUserId = user.id);
    } catch (e) {
      debugPrint('Load room settings current user failed: $e');
    }
  }

  Future<void> _loadRoomInfo() async {
    try {
      final room = await SyncTvService.getRoomInfo(widget.roomId);
      if (!mounted) return;
      setState(() => _roomInfo = room);
    } catch (e) {
      debugPrint('Load room info failed: $e');
    }
  }

  Future<void> _updateRoomCover() async {
    if (_coverUpdating) return;
    try {
      final image = await pickLocalImageUpload(context, aspectRatio: 16 / 9);
      if (image == null || !mounted) return;
      setState(() => _coverUpdating = true);
      final room = await SyncTvService.updateRoomCover(
        widget.roomId,
        image.upload,
      );
      if (!mounted) return;
      setState(() => _roomInfo = room);
      MessageUtils.showSuccess(context, '房间封面已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新房间封面失败: $e');
    } finally {
      if (mounted) setState(() => _coverUpdating = false);
    }
  }

  Future<void> _clearRoomCover() async {
    if (_coverUpdating || _roomCoverUrl.isEmpty) return;
    try {
      setState(() => _coverUpdating = true);
      final room = await SyncTvService.clearRoomCover(widget.roomId);
      if (!mounted) return;
      setState(() => _roomInfo = room);
      MessageUtils.showSuccess(context, '房间封面已移除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移除房间封面失败: $e');
    } finally {
      if (mounted) setState(() => _coverUpdating = false);
    }
  }

  Future<void> _updateRoomPassword() async {
    if (_passwordUpdating) return;
    final password = _passwordController.text.trim();
    setState(() => _passwordUpdating = true);
    try {
      await SyncTvService.updateRoomPassword(
        widget.roomId,
        password.isEmpty ? null : password,
      );
      final freshSettings = await SyncTvService.getRoomSettings(widget.roomId);
      if (!mounted) return;
      setState(() {
        _settings = freshSettings;
        _passwordController.clear();
        _applySettings(freshSettings);
      });
      MessageUtils.showSuccess(
        context,
        password.isEmpty ? '房间密码已移除' : '房间密码已更新',
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新房间密码失败: $e');
    } finally {
      if (mounted) setState(() => _passwordUpdating = false);
    }
  }

  bool get _canSubmitPasswordChange {
    if (_passwordUpdating) return false;
    final password = _passwordController.text.trim();
    return password.isNotEmpty || _settings.requirePassword;
  }

  String get _passwordActionLabel {
    if (_passwordController.text.trim().isNotEmpty) return '保存密码';
    return _settings.requirePassword ? '移除密码' : '无需操作';
  }

  void _startSettingsWatch() {
    _sendRealtime(
      RoomRealtimeCodec.encodeRoomSettingsObservation(
        observeId: _settingsObserveId,
        version: _settingsWatchVersion,
      ),
    );
  }

  void _startMembersWatch() {
    _sendRealtime(
      RoomRealtimeCodec.encodeRoomMembersObservation(
        observeId: _membersObserveId,
        version: _membersWatchVersion,
        page: _membersPage,
        pageSize: _membersPageSize,
        search: _memberSearchController.text.trim(),
        role: _memberRoleFilter,
        sortBy: _memberSortBy,
        sortDirection: _memberSortDirection,
      ),
    );
    _startMembersOnlineWatches();
  }

  void _startMembersOnlineWatches() {
    final userIds = _members
        .map((member) => member.userId)
        .where((userId) => userId.isNotEmpty)
        .toSet();
    if (userIds.isEmpty) {
      _sendRealtime(
        RoomRealtimeCodec.encodeUnobserveResource(_membersOnlineCountObserveId),
      );
      return;
    }
    final roles = _memberRoleFilter == null
        ? const <common_enum.RoomMemberRole>[]
        : <common_enum.RoomMemberRole>[_memberRoleFilter!];
    _sendRealtime(
      RoomRealtimeCodec.encodeOnlineCountObservation(
        observeId: _membersOnlineCountObserveId,
        userIds: userIds,
        roles: roles,
      ),
    );
  }

  void _refreshMembersRealtimeQuery() {
    _membersWatchVersion = '';
    _startMembersWatch();
  }

  void _startMediaWatch() {
    _sendRealtime(
      RoomRealtimeCodec.encodePlaylistObservation(
        observeId: _mediaObserveId,
        version: _mediaWatchVersion,
        playlistId: _currentPlaylistId,
        target: _mediaTarget,
        page: 1,
        pageSize: 100,
        search: _mediaSearchController.text.trim(),
        sourceProvider: _mediaSourceProvider,
        providerInstanceName: _mediaProviderInstanceName,
        sortBy: _mediaSortBy,
        sortDirection: _mediaSortDirection,
        availability: _mediaAvailability,
      ),
    );
  }

  void _startChatWatch() {
    if (!_chatHistoryLoaded && _chatWatchVersion.isEmpty) return;
    _sendRealtime(
      RoomRealtimeCodec.encodeChatEventsObservation(
        observeId: _chatObserveId,
        version: _chatWatchVersion,
      ),
    );
  }

  void _sendRealtime(List<int> bytes) {
    if (bytes.isEmpty) return;
    widget.realtime.send(bytes);
  }

  void _handleRealtimeEvent(RealtimeEventLogEntry entry) {
    final payload = entry.payload;
    final observeId =
        payload is Map ? payload['observeId']?.toString() ?? '' : '';
    if (!_managementObserveIds.contains(observeId)) return;
    _appendRealtimeEvent(entry);
  }

  void _handleRealtimeMessage(RoomRealtimeMessage message) {
    switch (message.resourceObserveId) {
      case _settingsObserveId:
        _handleRealtimeSettingsMessage(message);
        break;
      case _membersObserveId:
        _handleRealtimeMembersMessage(message);
        break;
      case _membersOnlineCountObserveId:
        _handleRealtimeMembersOnlineMessage(message);
        break;
      case _mediaObserveId:
        _handleRealtimeMediaMessage(message);
        break;
      case _chatObserveId:
        _handleRealtimeChatMessage(message);
        break;
    }
  }

  void _handleRealtimeSettingsMessage(RoomRealtimeMessage message) {
    if (message.kind == RoomRealtimeMessageKind.checkStatus) {
      _handleSettingsWatchEvent(
        RoomResourceWatchEvent<SyncTvRoomSettings>.observed(
          version: message.resourceVersion,
          changed: message.resourceEvent,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.roomSettings) {
      _handleSettingsWatchEvent(
        RoomResourceWatchEvent<SyncTvRoomSettings>.changed(
          version: message.resourceVersion,
          snapshot: message.roomSettings,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.error) {
      _handleSettingsWatchEvent(
        RoomResourceWatchEvent<SyncTvRoomSettings>.error(
          message: message.error?.message ?? '',
          code: message.error?.code ?? 0,
        ),
      );
    }
  }

  void _handleRealtimeMembersMessage(RoomRealtimeMessage message) {
    if (message.kind == RoomRealtimeMessageKind.checkStatus) {
      _handleMembersWatchEvent(
        RoomResourceWatchEvent<List<AdminRoomMember>>.observed(
          version: message.resourceVersion,
          changed: message.resourceEvent,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.memberEvent) {
      _handleMembersWatchEvent(
        RoomResourceWatchEvent<List<AdminRoomMember>>.changed(
          version: message.resourceVersion,
        ),
      );
      _loadMembers();
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.error) {
      _handleMembersWatchEvent(
        RoomResourceWatchEvent<List<AdminRoomMember>>.error(
          message: message.error?.message ?? '',
          code: message.error?.code ?? 0,
        ),
      );
    }
  }

  void _handleRealtimeMembersOnlineMessage(RoomRealtimeMessage message) {
    if (message.kind == RoomRealtimeMessageKind.checkStatus) {
      _membersWatchStats.record(
        RoomResourceWatchEvent<void>.observed(
          version: message.resourceVersion,
          changed: message.resourceEvent,
        ),
      );
      if (mounted) setState(() {});
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.viewerCount) {
      _membersWatchStats.record(
        RoomResourceWatchEvent<void>.changed(
          version: message.resourceVersion,
        ),
      );
      if (mounted) {
        setState(() => _membersOnlineCount = message.resourceTotal);
      }
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.onlineEvent) {
      _membersWatchStats.record(
        RoomResourceWatchEvent<void>.changed(
          version: message.resourceVersion,
        ),
      );
      _applyMemberOnlineEvent(message.onlineEvent);
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.error) {
      _membersWatchStats.record(
        RoomResourceWatchEvent<void>.error(
          message: message.error?.message ?? '',
          code: message.error?.code ?? 0,
        ),
      );
      if (mounted) {
        MessageUtils.showError(
          context,
          message.error?.message.isNotEmpty == true
              ? message.error!.message
              : '成员在线状态监听失败',
        );
      }
    }
  }

  void _handleRealtimeMediaMessage(RoomRealtimeMessage message) {
    if (message.kind == RoomRealtimeMessageKind.checkStatus) {
      _handleMediaWatchEvent(
        RoomResourceWatchEvent<RoomMediaLibraryPage>.observed(
          version: message.resourceVersion,
          changed: message.resourceEvent,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.movies) {
      _handleMediaWatchEvent(
        RoomResourceWatchEvent<RoomMediaLibraryPage>.changed(
          version: message.resourceVersion,
          snapshot: message.mediaLibrary,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.error) {
      _handleMediaWatchEvent(
        RoomResourceWatchEvent<RoomMediaLibraryPage>.error(
          message: message.error?.message ?? '',
          code: message.error?.code ?? 0,
        ),
      );
    }
  }

  void _handleRealtimeChatMessage(RoomRealtimeMessage message) {
    if (message.kind == RoomRealtimeMessageKind.checkStatus) {
      _handleChatWatchEvent(
        RoomResourceWatchEvent<void>.observed(
          version: message.resourceVersion,
          changed: message.resourceEvent,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.chat) {
      _handleChatWatchEvent(
        RoomResourceWatchEvent<RoomRealtimeMessage>.changed(
          version: message.resourceVersion,
          snapshot: message,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.error) {
      _handleChatWatchEvent(
        RoomResourceWatchEvent<void>.error(
          message: message.error?.message ?? '',
          code: message.error?.code ?? 0,
        ),
      );
    }
  }

  void _handleSettingsWatchEvent(
    RoomResourceWatchEvent<SyncTvRoomSettings> event,
  ) {
    if (!mounted) return;
    _settingsWatchStats.record(event);
    if (event.version.isNotEmpty) _settingsWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        setState(() {});
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          MessageUtils.showError(context, '房间设置快照为空');
          return;
        }
        setState(() {
          _settings = snapshot;
          _applySettings(snapshot);
        });
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '房间设置监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _handleMembersWatchEvent(
    RoomResourceWatchEvent<List<AdminRoomMember>> event, {
    int? total,
  }) {
    if (!mounted) return;
    _membersWatchStats.record(event);
    if (event.version.isNotEmpty) _membersWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        setState(() {});
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          setState(() {});
          return;
        }
        setState(() {
          _members
            ..clear()
            ..addAll(snapshot);
          _membersTotal = total ?? snapshot.length;
          _membersOnlineCount =
              snapshot.where((member) => member.isOnline).length;
        });
        _startMembersOnlineWatches();
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '成员监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _applyMemberOnlineEvent(RoomRealtimeOnlineEvent? event) {
    if (!mounted || event == null || event.userId.isEmpty) return;
    final index =
        _members.indexWhere((member) => member.userId == event.userId);
    if (index < 0) return;
    final member = _members[index];
    final updated = member.copyWith(
      isOnline: event.isOnline,
      connectionCount: event.isOnline
          ? (member.connectionCount > 0 ? member.connectionCount : 1)
          : 0,
    );
    setState(() {
      _members[index] = updated;
      _membersOnlineCount = _members.where((member) => member.isOnline).length;
    });
  }

  void _handleMediaWatchEvent(
    RoomResourceWatchEvent<RoomMediaLibraryPage> event,
  ) {
    if (!mounted) return;
    _mediaWatchStats.record(event);
    if (event.version.isNotEmpty) _mediaWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        setState(() {});
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          MessageUtils.showError(context, '媒体列表快照为空');
          return;
        }
        setState(() => _mediaPage = snapshot);
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '媒体库监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _handleChatWatchEvent<T>(RoomResourceWatchEvent<T> event) {
    if (!mounted) return;
    _chatWatchStats.record(event);
    if (event.version.isNotEmpty) _chatWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        setState(() {});
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot is RoomRealtimeMessage) {
          setState(() => _applyChatRealtimeMessage(snapshot));
        } else {
          setState(() {});
        }
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '聊天事件监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _appendRealtimeEvent(RealtimeEventLogEntry entry) {
    if (!mounted) return;
    setState(() {
      _realtimeEvents.add(entry);
      _trimRealtimeEvents();
    });
  }

  void _handleRealtimeLogMaxEntriesChanged() {
    if (!mounted) return;
    setState(_trimRealtimeEvents);
  }

  void _trimRealtimeEvents() {
    final maxEntries = RealtimeEventLogPreferences.maxEntries.value;
    if (_realtimeEvents.length > maxEntries) {
      _realtimeEvents.removeRange(0, _realtimeEvents.length - maxEntries);
    }
  }

  bool _hasPermission(int permissions, int flag) => (permissions & flag) != 0;

  void _setMemberPermission(int flag, bool enabled) {
    setState(() {
      _memberPermissions =
          enabled ? (_memberPermissions | flag) : (_memberPermissions & ~flag);
    });
  }

  void _setGuestPermission(int flag, bool enabled) {
    setState(() {
      _guestPermissions =
          enabled ? (_guestPermissions | flag) : (_guestPermissions & ~flag);
    });
  }

  int _memberRemovedPermissions() =>
      RoomMemberPermissions.all & ~_memberPermissions;

  int _guestRemovedPermissions() =>
      RoomGuestPermissions.all & ~_guestPermissions;

  Future<void> _saveSettings() async {
    final maxMembers = int.tryParse(_maxMembersController.text.trim());
    if (maxMembers == null || maxMembers < 0 || maxMembers > 10000) {
      MessageUtils.showError(context, '最大成员数必须在 0 到 10000 之间');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final settings = SyncTvRoomSettings(
        requirePassword: _settings.requirePassword,
        allowGuestJoin: _allowGuestJoin,
        requireApproval: _requireApproval,
        allowAutoJoin: _allowAutoJoin,
        maxMembers: maxMembers,
        chatEnabled: _chatEnabled,
        danmakuEnabled: _danmakuEnabled,
        memberAddedPermissions: 0,
        memberRemovedPermissions: _memberRemovedPermissions(),
        guestAddedPermissions: _guestPermissions,
        guestRemovedPermissions: _guestRemovedPermissions(),
      );

      await SyncTvService.updateRoomSettings(
        widget.roomId,
        settings,
      );
      final freshSettings = await SyncTvService.getRoomSettings(widget.roomId);
      if (!mounted) return;
      setState(() {
        _settings = freshSettings;
        _applySettings(freshSettings);
      });
      MessageUtils.showSuccess(context, '设置已更新');
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, '更新失败: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _loadStreams() async {
    if (!mounted) return;
    setState(() => _streamsLoading = true);
    try {
      final page = await SyncTvService.listRoomStreamsPage(
        widget.roomId,
        page: _streamsPage,
        pageSize: _streamsPageSize,
        search: _streamSearchController.text.trim(),
        sortDirection: _streamSortDirection,
      );
      if (!mounted) return;
      setState(() {
        _streams
          ..clear()
          ..addAll(page.streams);
        _streamsTotal = page.total;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载活跃流失败: $e');
    } finally {
      if (mounted) setState(() => _streamsLoading = false);
    }
  }

  Future<void> _loadReviews() async {
    if (!mounted) return;
    _reviewsLoaded = true;
    setState(() => _reviewsLoading = true);
    try {
      final page = await SyncTvService.listRoomJoinReviewsPage(
        widget.roomId,
        page: _reviewsPage,
        pageSize: _reviewsPageSize,
        status: _reviewStatusFilter,
        userId: _reviewUserController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _reviews
          ..clear()
          ..addAll(page.reviews);
        _reviewsTotal = page.total;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载加入审核失败: $e');
    } finally {
      if (mounted) setState(() => _reviewsLoading = false);
    }
  }

  Future<void> _loadMembers() async {
    if (!mounted) return;
    setState(() => _membersLoading = true);
    try {
      final page = await SyncTvService.getRoomMemberDetailsPage(
        widget.roomId,
        page: _membersPage,
        pageSize: _membersPageSize,
        search: _memberSearchController.text.trim(),
        role: _memberRoleFilter,
        sortBy: _memberSortBy,
        sortDirection: _memberSortDirection,
      );
      if (!mounted) return;
      setState(() {
        _members
          ..clear()
          ..addAll(page.members);
        _membersTotal = page.total;
        _membersOnlineCount = page.onlineCount > 0
            ? page.onlineCount
            : _members.where((m) => m.isOnline).length;
        _membersWatchVersion = page.version;
      });
      _startMembersOnlineWatches();
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载成员失败: $e');
    } finally {
      if (mounted) setState(() => _membersLoading = false);
    }
  }

  Future<void> _loadMediaLibrary({bool refresh = false}) async {
    if (!mounted) return;
    setState(() => _mediaLoading = true);
    try {
      final page = await SyncTvService.listMediaLibrary(
        widget.roomId,
        playlistId: _currentPlaylistId,
        target: _mediaTarget,
        search: _mediaSearchController.text.trim(),
        sourceProvider: _mediaSourceProvider,
        providerInstanceName: _mediaProviderInstanceName,
        sortBy: _mediaSortBy,
        sortDirection: _mediaSortDirection,
        availability: _mediaAvailability,
        refresh: refresh,
      );
      if (!mounted) return;
      setState(() {
        _mediaPage = page;
        _mediaWatchVersion = page.version;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载媒体库失败: $e');
    } finally {
      if (mounted) setState(() => _mediaLoading = false);
    }
  }

  Future<void> _reloadMediaLibrary({bool refresh = false}) async {
    _mediaWatchVersion = '';
    _startMediaWatch();
    await _loadMediaLibrary(refresh: refresh);
  }

  void _resetRealtimeDiagnostics() {
    setState(() {
      _settingsWatchVersion = '';
      _membersWatchVersion = '';
      _mediaWatchVersion = '';
      _chatWatchVersion = '';
      _chatHistoryLoaded = false;
      _settingsWatchStats.reset();
      _membersWatchStats.reset();
      _mediaWatchStats.reset();
      _chatWatchStats.reset();
      _realtimeEvents.clear();
    });
    _loadChatHistory();
    _startResourceWatches();
  }

  Future<void> _refreshRealtimeDiagnostics() async {
    _resetRealtimeDiagnostics();
  }

  Future<void> _copyRealtimeDiagnostics() async {
    final payload = _realtimeDebugPayload();
    const encoder = JsonEncoder.withIndent('  ');
    await Clipboard.setData(ClipboardData(text: encoder.convert(payload)));
    if (mounted) MessageUtils.showSuccess(context, '实时诊断数据已复制');
  }

  Future<void> _loadMediaProviderInstances() async {
    if (!mounted) return;
    final provider = _mediaSourceProvider;
    if (!_mediaSourcesWithProviderInstances.contains(provider)) {
      setState(() {
        _mediaProviderInstanceName = '';
        _mediaProviderInstances = const [''];
        _mediaProviderInstancesLoading = false;
      });
      return;
    }

    setState(() => _mediaProviderInstancesLoading = true);
    try {
      final instances = await SyncTvService.listAvailableProviderInstances(
        providerType: provider,
      );
      if (!mounted || provider != _mediaSourceProvider) return;
      final normalized = _mergeMediaProviderInstances(instances);
      setState(() {
        _mediaProviderInstances = normalized;
        if (!_mediaProviderInstances.contains(_mediaProviderInstanceName)) {
          _mediaProviderInstanceName = '';
        }
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载媒体来源实例失败: $e');
    } finally {
      if (mounted && provider == _mediaSourceProvider) {
        setState(() => _mediaProviderInstancesLoading = false);
      }
    }
  }

  List<String> _mergeMediaProviderInstances(List<String> remoteInstances) {
    final names = <String>[''];
    for (final instance in remoteInstances) {
      final trimmed = instance.trim();
      if (trimmed.isNotEmpty && !names.contains(trimmed)) {
        names.add(trimmed);
      }
    }
    return names;
  }

  Future<void> _selectMediaSourceProvider(String provider) async {
    if (provider == _mediaSourceProvider) return;
    setState(() {
      _mediaSourceProvider = provider;
      _mediaProviderInstanceName = '';
      _mediaProviderInstances = const [''];
      _mediaWatchVersion = '';
    });
    await _loadMediaProviderInstances();
    await _reloadMediaLibrary();
  }

  Future<void> _selectMediaProviderInstance(String instanceName) async {
    if (instanceName == _mediaProviderInstanceName) return;
    setState(() {
      _mediaProviderInstanceName = instanceName;
      _mediaWatchVersion = '';
    });
    await _reloadMediaLibrary();
  }

  Future<void> _loadChatHistory({bool loadMore = false}) async {
    if (!mounted) return;
    if (_chatSearchQuery.isNotEmpty) {
      await _searchChatHistory(loadMore: loadMore);
      return;
    }
    if (loadMore && _chatCursor.isEmpty) return;
    setState(() => _chatLoading = true);
    try {
      final page = await SyncTvService.getChatHistory(
        widget.roomId,
        cursor: loadMore ? _chatCursor : '',
      );
      ChatReadStateInfo? readState;
      if (!loadMore && page.messages.isNotEmpty) {
        try {
          readState = await SyncTvService.markChatRead(
            widget.roomId,
            page.messages.first.id,
          );
        } catch (e) {
          debugPrint('Mark chat read failed: $e');
          try {
            readState = await SyncTvService.getChatReadState(
              widget.roomId,
            );
          } catch (_) {}
        }
      }
      if (!mounted) return;
      var shouldRestartChatWatch = false;
      setState(() {
        if (loadMore) {
          _appendChatHistoryPage(page.messages);
        } else {
          _replaceChatHistory(page.messages);
          _chatHistoryLoaded = true;
          shouldRestartChatWatch = true;
        }
        _chatCursor = page.nextCursor;
        if (!loadMore && page.eventCursor.isNotEmpty) {
          _chatWatchVersion = page.eventCursor;
        }
        if (readState != null) _chatReadState = readState;
      });
      if (shouldRestartChatWatch) _startChatWatch();
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载聊天历史失败: $e');
    } finally {
      if (mounted) setState(() => _chatLoading = false);
    }
  }

  void _replaceChatHistory(List<RoomChatMessageInfo> messages) {
    _chatMessages
      ..clear()
      ..addAll(messages);
  }

  void _appendChatHistoryPage(List<RoomChatMessageInfo> messages) {
    final existingIds = _chatMessages.map((message) => message.id).toSet();
    for (final message in messages) {
      if (message.id.isEmpty || existingIds.add(message.id)) {
        _chatMessages.add(message);
      }
    }
  }

  Future<void> _searchChatHistory({bool loadMore = false}) async {
    if (!mounted) return;
    final query = _chatSearchController.text.trim();
    if (query.isEmpty) {
      if (_chatSearchQuery.isEmpty) return;
      setState(() {
        _chatSearchQuery = '';
        _chatSearchCursor = '';
      });
      await _loadChatHistory();
      return;
    }
    if (loadMore && _chatSearchCursor.isEmpty) return;
    setState(() {
      _chatLoading = true;
      if (!loadMore) {
        _chatSearchQuery = query;
        _chatSearchCursor = '';
      }
    });
    try {
      final page = await SyncTvService.searchChatMessages(
        widget.roomId,
        query: query,
        cursor: loadMore ? _chatSearchCursor : '',
      );
      if (!mounted) return;
      setState(() {
        if (loadMore) {
          _appendChatHistoryPage(page.messages);
        } else {
          _replaceChatHistory(page.messages);
        }
        _chatSearchCursor = page.nextCursor;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '搜索聊天历史失败: $e');
    } finally {
      if (mounted) setState(() => _chatLoading = false);
    }
  }

  void _applyChatRealtimeMessage(RoomRealtimeMessage message) {
    final next = _chatInfoFromRealtime(message);
    final index = _chatMessages.indexWhere((item) => item.id == next.id);
    if (index >= 0) {
      _chatMessages[index] = next;
    } else {
      _chatMessages.insert(0, next);
    }
    if (_chatMessages.length > 200) {
      _chatMessages.removeRange(200, _chatMessages.length);
    }
    _chatReadState = null;
  }

  RoomChatMessageInfo _chatInfoFromRealtime(RoomRealtimeMessage message) {
    return RoomChatMessageInfo(
      id: message.chatId,
      roomId: widget.roomId,
      userId: message.senderUserId,
      username: message.senderUsername,
      content: message.chatContent,
      timestamp: (message.timestampMillis / 1000).round(),
      displayPosition: message.chatDisplayPosition,
      displayColor: message.chatDisplayColor,
      version: message.chatVersion,
      editedAt: message.chatEditedAt,
      deletedAt: message.chatDeletedAt,
      status: message.chatStatus,
      replyToMessageId: message.chatReplyToMessageId,
      images: message.images,
      reactions: message.reactions,
      reactionCount: message.reactionCount,
      pin: message.chatPinEvent?.pin,
    );
  }

  void _applyChatPinEvent(ChatPinEventInfo event) {
    final clearPin = event.kind ==
            client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_UNPINNED.value ||
        event.kind ==
            client_enum
                .ChatPinEventKind.CHAT_PIN_EVENT_KIND_MESSAGE_DELETED.value;
    final index =
        _chatMessages.indexWhere((item) => item.id == event.message.id);
    if (index >= 0) {
      _chatMessages[index] =
          _chatMessages[index].copyWith(pin: event.pin, clearPin: clearPin);
    }
  }

  Future<void> _loadIceServers() async {
    if (!mounted) return;
    setState(() => _iceLoading = true);
    try {
      final servers = await SyncTvService.getIceServers(widget.roomId);
      if (!mounted) return;
      setState(() {
        _iceServers
          ..clear()
          ..addAll(servers);
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载 ICE 配置失败: $e');
    } finally {
      if (mounted) setState(() => _iceLoading = false);
    }
  }

  int get _streamPageCount {
    if (_streamsTotal <= 0) return 1;
    return ((_streamsTotal + _streamsPageSize - 1) ~/ _streamsPageSize)
        .clamp(1, 1 << 31);
  }

  int get _reviewPageCount {
    if (_reviewsTotal <= 0) return 1;
    return ((_reviewsTotal + _reviewsPageSize - 1) ~/ _reviewsPageSize)
        .clamp(1, 1 << 31);
  }

  int get _memberPageCount {
    if (_membersTotal <= 0) return 1;
    return ((_membersTotal + _membersPageSize - 1) ~/ _membersPageSize)
        .clamp(1, 1 << 31);
  }

  List<_RoomSettingsSection> get _sections => [
        _RoomSettingsSection(
          label: '信息',
          icon: Icons.info_outline_rounded,
          builder: _buildRoomInfoTab,
        ),
        _RoomSettingsSection(
          label: '设置',
          icon: Icons.tune_rounded,
          builder: _buildSettingsTab,
        ),
        _RoomSettingsSection(
          label: '成员',
          icon: Icons.group_rounded,
          builder: _buildMembersTab,
        ),
        _RoomSettingsSection(
          label: '媒体',
          icon: Icons.video_library_rounded,
          builder: _buildMediaTab,
        ),
        _RoomSettingsSection(
          label: '实时',
          icon: Icons.sensors_rounded,
          builder: _buildRealtimeTab,
        ),
        _RoomSettingsSection(
          label: '聊天',
          icon: Icons.forum_rounded,
          builder: _buildChatHistoryTab,
        ),
        _RoomSettingsSection(
          label: '举报',
          icon: Icons.report_gmailerrorred_rounded,
          builder: _buildReportsTab,
        ),
        _RoomSettingsSection(
          label: '网络',
          icon: Icons.hub_rounded,
          builder: _buildNetworkTab,
        ),
        _RoomSettingsSection(
          label: '推流',
          icon: Icons.podcasts_rounded,
          builder: _buildStreamsTab,
        ),
        _RoomSettingsSection(
          label: '审核',
          icon: Icons.fact_check_rounded,
          builder: _buildReviewsTab,
        ),
      ];

  String get _currentPlaylistId =>
      _mediaPlaylistStack.isEmpty ? '' : _mediaPlaylistStack.last;

  String get _mediaTarget =>
      _mediaTargetStack.isEmpty ? '' : _mediaTargetStack.last;

  bool get _isInsideDynamicMediaPlaylist =>
      _mediaPlaylistEntryStack.any((entry) => entry.isDynamicPlaylist);

  bool get _canMutateCurrentMediaScope =>
      _mediaTarget.isEmpty && !_isInsideDynamicMediaPlaylist;

  Future<void> _openMediaEntry(SyncTvMovie entry) async {
    if (!entry.isFolder) return;
    final isPersistedPlaylist = entry.id.startsWith('pl_');
    final target = isPersistedPlaylist ? '' : entry.playbackTarget ?? '';
    if (!isPersistedPlaylist && target.isEmpty) return;
    setState(() {
      if (isPersistedPlaylist) {
        _mediaPlaylistStack.add(entry.id);
        _mediaPlaylistEntryStack.add(entry);
        _mediaTargetStack.clear();
      } else {
        _mediaTargetStack.add(target);
      }
      _mediaWatchVersion = '';
    });
    _startMediaWatch();
    await _loadMediaLibrary();
  }

  Future<bool> _handleMediaBack() async {
    if (_mediaTargetStack.isNotEmpty) {
      setState(() {
        _mediaTargetStack.removeLast();
        _mediaWatchVersion = '';
      });
      _startMediaWatch();
      await _loadMediaLibrary();
      return true;
    }
    if (_mediaPlaylistStack.isNotEmpty) {
      setState(() {
        _mediaPlaylistStack.removeLast();
        if (_mediaPlaylistEntryStack.isNotEmpty) {
          _mediaPlaylistEntryStack.removeLast();
        }
        _mediaWatchVersion = '';
      });
      _startMediaWatch();
      await _loadMediaLibrary();
      return true;
    }
    return false;
  }

  Future<void> _kickStream(RoomStreamEntryInfo stream) async {
    try {
      await SyncTvService.kickRoomStream(
        widget.roomId,
        stream.mediaId,
        reason: 'Kicked from room settings',
      );
      await _loadStreams();
      if (mounted) MessageUtils.showSuccess(context, '已断开推流');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '断开推流失败: $e');
    }
  }

  Future<void> _showStreamInfo(RoomStreamEntryInfo stream) async {
    try {
      final detail = await SyncTvService.getRoomStreamInfo(
        widget.roomId,
        stream.mediaId,
      );
      if (!mounted) return;
      await showAppBottomSheet<void>(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          return AppSafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        detail.active ? Icons.sensors : Icons.sensors_off,
                        color:
                            detail.active ? Colors.green : theme.disabledColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          detail.mediaId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailLine('状态', detail.active ? '活跃' : '未活跃'),
                  _buildDetailLine(
                    '发布者',
                    detail.publisherUserId.isEmpty
                        ? '未知发布者'
                        : detail.publisherUserId,
                  ),
                  _buildDetailLine(
                    '开始时间',
                    detail.startedAt <= 0
                        ? '-'
                        : _formatTimestamp(detail.startedAt),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppActionButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: detail.mediaId),
                          );
                          Navigator.pop(context);
                          MessageUtils.showSuccess(context, '媒体 ID 已复制');
                        },
                        icon: Icons.copy_rounded,
                        label: '复制 ID',
                        style: AppActionButtonStyle.text,
                      ),
                      const SizedBox(width: 8),
                      AppActionButton(
                        onPressed: detail.active
                            ? () {
                                Navigator.pop(context);
                                _kickStream(detail);
                              }
                            : null,
                        icon: Icons.link_off,
                        label: '断开推流',
                        style: AppActionButtonStyle.destructive,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载推流详情失败: $e');
    }
  }

  Future<void> _approveReview(RoomJoinReviewInfo review) async {
    try {
      await SyncTvService.approveRoomJoinReview(widget.roomId, review.id);
      await _loadReviews();
      if (mounted) MessageUtils.showSuccess(context, '已通过申请');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '审核失败: $e');
    }
  }

  Future<void> _rejectReview(RoomJoinReviewInfo review) async {
    final reason = await _showRejectReasonDialog();
    if (reason == null) return;
    try {
      await SyncTvService.rejectRoomJoinReview(
        widget.roomId,
        review.id,
        reason: reason,
      );
      await _loadReviews();
      if (mounted) MessageUtils.showSuccess(context, '已拒绝申请');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '审核失败: $e');
    }
  }

  Future<void> _addMember() async {
    final result = await _showMemberEditDialog();
    if (result == null) return;
    try {
      await SyncTvService.addRoomMember(
        widget.roomId,
        result.userId,
        role: result.role,
        notify: result.notify,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员已添加');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '添加成员失败: $e');
    }
  }

  Future<void> _setMemberRole(AdminRoomMember member) async {
    final result = await _showMemberRoleDialog(member.role);
    if (result == null || result == member.role) return;
    try {
      await SyncTvService.setRoomMemberRole(
        widget.roomId,
        member.userId,
        result,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员角色已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新角色失败: $e');
    }
  }

  Future<void> _editMemberPermissionOverrides(AdminRoomMember member) async {
    final result = await _showMemberPermissionOverrideDialog(member);
    if (result == null) return;
    try {
      await SyncTvService.updateRoomMemberPermissionOverrides(
        widget.roomId,
        member.userId,
        addedPermissions: result.addedPermissions,
        removedPermissions: result.removedPermissions,
        adminAddedPermissions: result.adminAddedPermissions,
        adminRemovedPermissions: result.adminRemovedPermissions,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员权限已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新权限失败: $e');
    }
  }

  Future<void> _transferOwnership(AdminRoomMember member) async {
    final confirmed = await _confirm(
      title: '转让房主',
      content: '确认将房间所有权转让给 ${member.username}？',
      action: '转让',
    );
    if (!confirmed) return;
    try {
      await SyncTvService.transferRoomOwnership(
        widget.roomId,
        member.userId,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '房主已转让');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '转让失败: $e');
    }
  }

  Future<void> _kickMember(AdminRoomMember member) async {
    final cooldown = await _askKickCooldownSeconds(member.username);
    if (cooldown == null) return;
    try {
      await SyncTvService.kickMember(
        widget.roomId,
        member.userId,
        kickCooldownSeconds: cooldown,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员已移出');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移出成员失败: $e');
    }
  }

  Future<void> _reportRoomMember(AdminRoomMember member) async {
    if (member.userId.isEmpty) return;
    await _showReportContentDialog(
      title: '举报成员',
      targetLabel: member.username.isEmpty ? member.userId : member.username,
      submit: (reasonCode, reason) => SyncTvService.reportRoomMember(
        widget.roomId,
        member.userId,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _reportUser(AdminRoomMember member) async {
    if (member.userId.isEmpty) return;
    await _showReportContentDialog(
      title: '举报用户',
      targetLabel: member.username.isEmpty ? member.userId : member.username,
      submit: (reasonCode, reason) => SyncTvService.reportUser(
        widget.roomId,
        member.userId,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _showReportContentDialog({
    required String title,
    String targetLabel = '',
    required Future<String> Function(String reasonCode, String reason) submit,
  }) async {
    const reasons = <String, String>{
      'spam': '垃圾广告',
      'abuse': '辱骂骚扰',
      'illegal': '违法违规',
      'sexual': '低俗色情',
      'other': '其他问题',
    };
    var selectedReason = 'spam';
    final detailController = TextEditingController();
    final submitted = await showAppDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: Text(title),
              icon: const Icon(Icons.flag_outlined),
              body: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (targetLabel.isNotEmpty) ...[
                      Text(
                        targetLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                    ],
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reasons.entries
                          .map(
                            (entry) => AppChip(
                              label: Text(entry.value),
                              selected: selectedReason == entry.key,
                              onSelected: (_) => setDialogState(
                                () => selectedReason = entry.key,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: detailController,
                      label: '补充说明',
                      hintText: '描述具体问题',
                      minLines: 3,
                      maxLines: 5,
                      maxLength: 2000,
                    ),
                  ],
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  label: '取消',
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  label: '提交',
                  icon: Icons.flag_outlined,
                ),
              ],
            );
          },
        );
      },
    );
    try {
      if (submitted != true) return;
      await submit(selectedReason, detailController.text);
      if (mounted) MessageUtils.showSuccess(context, '举报已提交');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '举报失败: $e');
    } finally {
      detailController.dispose();
    }
  }

  Future<int?> _askKickCooldownSeconds(String username) async {
    final controller = TextEditingController(text: '60');
    final value = await showAppDialog<int>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: const Text('移出成员'),
        icon: const Icon(Icons.logout_rounded),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确认将 $username 移出房间，并设置重新加入冷却时间。'),
            const SizedBox(height: 12),
            AppTextField(
              controller: controller,
              label: '冷却秒数',
              hintText: '1 - 2592000',
              prefixIcon: Icons.timer_outlined,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          AppActionButton(
            onPressed: () => Navigator.pop(dialogContext),
            label: '取消',
            style: AppActionButtonStyle.text,
          ),
          AppActionButton(
            onPressed: () {
              final seconds = int.tryParse(controller.text.trim());
              if (seconds == null || seconds < 1 || seconds > 2592000) {
                MessageUtils.showWarning(context, '请输入 1 到 2592000 之间的秒数');
                return;
              }
              Navigator.pop(dialogContext, seconds);
            },
            icon: Icons.logout_rounded,
            label: '移出',
            style: AppActionButtonStyle.destructive,
          ),
        ],
      ),
    );
    controller.dispose();
    return value;
  }

  Future<void> _resetSettings() async {
    final confirmed = await _confirm(
      title: '重置设置',
      content: '确认将访问控制、消息开关、成员权限和访客权限恢复为服务端默认策略？当前未保存的房间策略会被覆盖。',
      action: '重置',
    );
    if (!confirmed) return;
    try {
      await SyncTvService.resetRoomSettings(widget.roomId);
      final settings = await SyncTvService.getRoomSettings(
        widget.roomId,
        refresh: true,
      );
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _applySettings(settings);
      });
      MessageUtils.showSuccess(context, '设置已重置');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '重置失败: $e');
    }
  }

  Future<void> _leaveRoom() async {
    final confirmed = await _confirm(
      title: '退出房间',
      content: '确认退出 ${widget.roomName}？',
      action: '退出',
    );
    if (!confirmed) return;
    try {
      await SyncTvService.leaveRoom(widget.roomId);
      if (!mounted) return;
      Navigator.pop(context);
      MessageUtils.showSuccess(context, '已退出房间');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '退出房间失败: $e');
    }
  }

  Future<void> _deleteRoom() async {
    final confirmed = await _confirm(
      title: '删除房间',
      content: '确认永久删除 ${widget.roomName}？此操作会移除房间、播放列表和相关房间数据。',
      action: '删除',
    );
    if (!confirmed) return;
    try {
      await SyncTvService.deleteRoom(widget.roomId);
      if (!mounted) return;
      Navigator.pop(context, true);
      MessageUtils.showSuccess(context, '房间已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除房间失败: $e');
    }
  }

  Future<void> _createPlaylist() async {
    if (!_canMutateCurrentMediaScope) {
      MessageUtils.showInfo(context, '动态来源内容只支持查看和打开');
      return;
    }
    final input = await _showEntryEditDialog(title: '新建播放列表');
    if (input == null || input.name.isEmpty) return;
    try {
      await SyncTvService.createPlaylist(
        widget.roomId,
        name: input.name,
        parentId: _currentPlaylistId,
        description: input.description,
      );
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '播放列表已创建');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '创建播放列表失败: $e');
    }
  }

  Future<void> _addMediaToCurrentScope() async {
    if (!_canMutateCurrentMediaScope) {
      MessageUtils.showInfo(context, '动态来源内容只支持查看和打开');
      return;
    }
    await AddMovieDialog.show(
      context,
      widget.roomId,
      parentId: _currentPlaylistId.isEmpty ? null : _currentPlaylistId,
    );
    await _loadMediaLibrary();
  }

  Future<void> _clearCurrentMediaScope() async {
    if (!_canMutateCurrentMediaScope) {
      MessageUtils.showInfo(context, '动态来源内容只支持查看和打开');
      return;
    }
    final playlistId = _currentPlaylistId;
    final confirmed = await _confirm(
      title: playlistId.isEmpty ? '清空媒体库' : '清空播放列表',
      content: playlistId.isEmpty
          ? '确认清空根目录下的媒体和播放列表？'
          : '确认清空当前播放列表下的媒体和子播放列表？播放列表本身会保留。',
      action: '清空',
    );
    if (!confirmed) return;

    try {
      await SyncTvService.clearMovies(
        widget.roomId,
        parentId: playlistId.isEmpty ? null : playlistId,
      );
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '媒体库已清空');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '清空失败: $e');
    }
  }

  Future<void> _renameEntry(SyncTvMovie entry) async {
    if (!_canMutateCurrentMediaScope || entry.isProviderDynamicEntry) {
      MessageUtils.showInfo(context, '动态来源内容只支持查看和打开');
      return;
    }
    final input = await _showEntryEditDialog(
      title: entry.isFolder ? '编辑播放列表' : '编辑媒体',
      initialName: entry.name,
      initialDescription: entry.description,
    );
    if (input == null || input.name.isEmpty) return;
    if (input.name == entry.name && input.description == entry.description) {
      return;
    }
    try {
      if (entry.id.startsWith('pl_')) {
        await SyncTvService.updatePlaylist(
          widget.roomId,
          entry.id,
          name: input.name,
          description: input.description,
        );
      } else if (entry.id.startsWith('med_')) {
        await SyncTvService.editMedia(
          widget.roomId,
          entry.id,
          name: input.name,
          description: input.description,
        );
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '名称已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '重命名失败: $e');
    }
  }

  Future<void> _deleteEntry(SyncTvMovie entry) async {
    if (!_canMutateCurrentMediaScope || entry.isProviderDynamicEntry) {
      MessageUtils.showInfo(context, '动态来源内容只支持查看和打开');
      return;
    }
    final confirmed = await _confirm(
      title: '删除条目',
      content: entry.isFolder
          ? '确认删除播放列表 ${entry.name}？其中的子播放列表和媒体也会从房间媒体库移除，成员会立即看到变更。'
          : '确认删除媒体 ${entry.name}？该条目会从房间媒体库移除，当前播放或成员播放列表会立即同步变更。',
      action: '删除',
    );
    if (!confirmed) return;
    try {
      if (entry.id.startsWith('pl_')) {
        await SyncTvService.deletePlaylist(
          widget.roomId,
          entry.id,
          force: true,
        );
      } else if (entry.id.startsWith('med_')) {
        await SyncTvService.deleteMovie(widget.roomId, entry.id);
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '条目已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除失败: $e');
    }
  }

  Future<void> _showMediaEntryDetails(SyncTvMovie entry) async {
    try {
      var detail = entry;
      PlaylistDetailInfo? playlistDetail;
      if (entry.id.startsWith('pl_')) {
        playlistDetail = await SyncTvService.getPlaylist(
          widget.roomId,
          entry.id,
        );
        detail = playlistDetail.playlist;
      } else if (entry.id.startsWith('med_')) {
        detail = await SyncTvService.getMedia(widget.roomId, entry.id);
      }
      if (!mounted) return;
      await showAppBottomSheet<void>(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          final isPlaylist = detail.id.startsWith('pl_');
          final canMutate = _canMutateCurrentMediaScope &&
              (detail.id.startsWith('pl_') || detail.id.startsWith('med_')) &&
              !detail.isProviderDynamicEntry;
          return AppSafeArea(
            child: AppSingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCoverPreview(
                      url: detail.coverUrl,
                      fallbackIcon: isPlaylist
                          ? Icons.folder_rounded
                          : detail.live
                              ? Icons.live_tv
                              : Icons.movie_creation_outlined,
                      height: 180,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          isPlaylist
                              ? Icons.folder
                              : detail.live
                                  ? Icons.live_tv
                                  : Icons.movie,
                          color: isPlaylist
                              ? Colors.amber.shade700
                              : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            detail.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailLine('ID', detail.id),
                    _buildDetailLine(
                      '类型',
                      isPlaylist
                          ? detail.metadata['isDynamic'] == true
                              ? '动态播放列表'
                              : '播放列表'
                          : detail.isFolder
                              ? '动态目录'
                              : detail.live
                                  ? '直播媒体'
                                  : '媒体',
                    ),
                    _buildDetailLine(
                      'Provider',
                      detail.sourceProvider.isEmpty
                          ? '-'
                          : detail.sourceProvider,
                    ),
                    _buildDetailLine(
                      '实例',
                      detail.providerInstanceName.isEmpty
                          ? '-'
                          : detail.providerInstanceName,
                    ),
                    if (detail.parentId?.isNotEmpty == true)
                      _buildDetailLine('父级', detail.parentId!),
                    if (detail.description.isNotEmpty)
                      _buildDetailLine('描述', detail.description),
                    if (detail.url.isNotEmpty)
                      _buildDetailLine('URL', detail.url),
                    if (detail.subPath?.isNotEmpty == true)
                      _buildDetailLine('Sub path', detail.subPath!),
                    if (playlistDetail != null) ...[
                      _buildDetailLine(
                        '子播放列表',
                        playlistDetail.childFolderCount.toString(),
                      ),
                      _buildDetailLine(
                        '媒体数量',
                        playlistDetail.mediaCount.toString(),
                      ),
                    ],
                    if (detail.metadata.isNotEmpty)
                      _buildDetailLine('元数据', _compactMap(detail.metadata)),
                    if (detail.sourceConfig.isNotEmpty)
                      _buildDetailLine(
                        '来源配置',
                        _compactMap(detail.sourceConfig),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppActionButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: detail.id));
                            Navigator.pop(context);
                            MessageUtils.showSuccess(context, 'ID 已复制');
                          },
                          icon: Icons.copy_rounded,
                          label: '复制 ID',
                          style: AppActionButtonStyle.text,
                        ),
                        if (canMutate) ...[
                          const SizedBox(width: 8),
                          AppActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _renameEntry(detail);
                            },
                            icon: Icons.edit_outlined,
                            label: '编辑',
                            style: AppActionButtonStyle.tonal,
                          ),
                          const SizedBox(width: 8),
                          AppActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _updateEntryCover(detail);
                            },
                            icon: Icons.image_outlined,
                            label: '封面',
                            style: AppActionButtonStyle.tonal,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载条目详情失败: $e');
    }
  }

  Future<void> _updateEntryCover(SyncTvMovie entry) async {
    if (!_canMutateCurrentMediaScope ||
        entry.isProviderDynamicEntry ||
        (!entry.id.startsWith('pl_') && !entry.id.startsWith('med_'))) {
      return;
    }
    try {
      final image = await pickLocalImageUpload(context, aspectRatio: 16 / 9);
      if (image == null || !mounted) return;
      if (entry.id.startsWith('pl_')) {
        await SyncTvService.updatePlaylistCover(
          widget.roomId,
          entry.id,
          image.upload,
        );
      } else {
        await SyncTvService.updateVideoCover(
          widget.roomId,
          entry.id,
          image.upload,
        );
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '封面已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新封面失败: $e');
    }
  }

  Future<void> _clearEntryCover(SyncTvMovie entry) async {
    if (!_canMutateCurrentMediaScope ||
        entry.isProviderDynamicEntry ||
        (!entry.id.startsWith('pl_') && !entry.id.startsWith('med_'))) {
      return;
    }
    try {
      if (entry.id.startsWith('pl_')) {
        await SyncTvService.clearPlaylistCover(widget.roomId, entry.id);
      } else {
        await SyncTvService.clearVideoCover(widget.roomId, entry.id);
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '封面已移除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移除封面失败: $e');
    }
  }

  Future<void> _editChatMessage(RoomChatMessageInfo message) async {
    if (message.isDeleted) {
      MessageUtils.showInfo(context, '已删除的消息不能编辑');
      return;
    }
    final content = await _showChatMessageEditDialog(message.content);
    if (content == null || content == message.content) return;
    try {
      await SyncTvService.editChatMessage(
        widget.roomId,
        message.id,
        content: content,
        expectedVersion: message.version,
      );
      await _loadChatHistory();
      if (mounted) MessageUtils.showSuccess(context, '消息已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '编辑消息失败: $e');
    }
  }

  Future<String?> _showChatMessageEditDialog(String initialContent) {
    return ChatUtils.showStyledDialog<String>(
      context: context,
      title: '编辑消息',
      icon: const Icon(Icons.edit_outlined),
      content: _ChatMessageEditForm(initialContent: initialContent),
      actions: const [],
    );
  }

  Future<void> _deleteChatMessage(RoomChatMessageInfo message) async {
    if (message.isDeleted) return;
    final confirmed = await _confirm(
      title: '删除消息',
      content: '确认删除这条聊天消息？删除后所有成员的聊天历史都会同步移除该消息。',
      action: '删除',
    );
    if (!confirmed) return;
    try {
      await SyncTvService.deleteChatMessage(
        widget.roomId,
        message.id,
        expectedVersion: message.version,
      );
      await _loadChatHistory();
      if (mounted) MessageUtils.showSuccess(context, '消息已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除消息失败: $e');
    }
  }

  Future<void> _toggleChatPin(RoomChatMessageInfo message) async {
    if (message.isDeleted) return;
    try {
      final event = message.isPinned
          ? await SyncTvService.unpinChatMessage(widget.roomId, message.id)
          : await SyncTvService.pinChatMessage(widget.roomId, message.id);
      if (!mounted) return;
      setState(() => _applyChatPinEvent(event));
      MessageUtils.showSuccess(context, message.isPinned ? '已取消置顶' : '消息已置顶');
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(
          context,
          message.isPinned ? '取消置顶失败: $e' : '置顶消息失败: $e',
        );
      }
    }
  }

  Future<void> _openRoomScopedReportsViewer({
    required String title,
    int targetType = 0,
    String targetMemberUserId = '',
    int targetChatMessageId = 0,
  }) {
    return ChatUtils.showStyledDialog<void>(
      context: context,
      title: title,
      icon: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.red),
      content: SizedBox(
        width: 900,
        height: 620,
        child: AdminContentReportsTab(
          title: '',
          initialTargetType: targetType,
          roomScopedRoomId: widget.roomId,
          initialTargetMemberUserId: targetMemberUserId,
          initialTargetChatMessageId: targetChatMessageId,
          showTargetTypeTabs: targetType == 0,
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
      ],
    );
  }

  Widget _buildReportsTab(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.roomName} 的举报管理',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              AppActionButton(
                onPressed: _reportCurrentRoom,
                icon: Icons.flag_outlined,
                label: '举报房间',
                size: AppActionButtonSize.sm,
                style: AppActionButtonStyle.outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: AdminContentReportsTab(
            title: '',
            roomScopedRoomId: widget.roomId,
            showTargetTypeTabs: true,
          ),
        ),
      ],
    );
  }

  Future<void> _reportCurrentRoom() async {
    await _showReportContentDialog(
      title: '举报房间',
      targetLabel: widget.roomName,
      submit: (reasonCode, reason) => SyncTvService.reportRoom(
        widget.roomId,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _showChatMessageContext(RoomChatMessageInfo message) async {
    try {
      final contextInfo = await SyncTvService.getChatMessageContext(
        widget.roomId,
        message.id,
        beforeLimit: 10,
        afterLimit: 10,
        includeDeleted: true,
      );
      if (!mounted) return;
      final messages = [
        ...contextInfo.before,
        contextInfo.message,
        ...contextInfo.after,
      ];
      await showAppBottomSheet<void>(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          return AppSafeArea(
            child: AppListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                  child: Text(
                    '消息上下文',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ...messages.map(
                  (item) => _buildChatMessageTile(item, theme, isDark),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载消息上下文失败: $e');
    }
  }

  Future<void> _moveMedia(SyncTvMovie entry) async {
    if (!_canMutateCurrentMediaScope || entry.isProviderDynamicEntry) {
      MessageUtils.showInfo(context, '动态来源内容只支持查看和打开');
      return;
    }
    if (!entry.id.startsWith('med_')) return;
    final target = await _showMoveMediaTargetDialog(entry);
    if (target == null) return;
    final targetPlaylistId = target.playlistId;
    final sourcePlaylistId =
        _currentPlaylistId.isEmpty ? null : _currentPlaylistId;
    if ((sourcePlaylistId ?? '') == targetPlaylistId) return;
    try {
      final count = await SyncTvService.moveMedia(
        widget.roomId,
        mediaIds: [entry.id],
        sourcePlaylistId: sourcePlaylistId,
        targetPlaylistId: targetPlaylistId.isEmpty ? null : targetPlaylistId,
      );
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '已移动 $count 个媒体');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移动失败: $e');
    }
  }

  Future<void> _movePlaylistRelative(SyncTvMovie entry, int direction) async {
    if (!_canMutateCurrentMediaScope || entry.isProviderDynamicEntry) {
      MessageUtils.showInfo(context, '动态来源内容只支持查看和打开');
      return;
    }
    if (!entry.id.startsWith('pl_')) return;
    final playlists = _mediaPage?.playlists ?? const <SyncTvMovie>[];
    final index = playlists.indexWhere((item) => item.id == entry.id);
    if (index < 0) return;
    final isUp = direction < 0;
    if (isUp && index == 0) return;
    if (!isUp && index >= playlists.length - 1) return;

    try {
      if (isUp) {
        await SyncTvService.movePlaylist(
          widget.roomId,
          entry.id,
          beforePlaylistId: playlists[index - 1].id,
        );
      } else {
        await SyncTvService.movePlaylist(
          widget.roomId,
          entry.id,
          afterPlaylistId: playlists[index + 1].id,
        );
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '播放列表顺序已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '调整顺序失败: $e');
    }
  }

  Future<_MediaMoveTarget?> _showMoveMediaTargetDialog(
      SyncTvMovie entry) async {
    var loading = true;
    var error = '';
    var playlists = <SyncTvMovie>[];

    Future<void> loadPlaylists(StateSetter setDialogState) async {
      setDialogState(() {
        loading = true;
        error = '';
      });
      try {
        final page = await SyncTvService.listPlaylistsPage(
          widget.roomId,
          pageSize: 100,
          dynamicOnly: false,
        );
        if (!mounted) return;
        setDialogState(() {
          playlists = page.playlists
              .where((item) => item.id != _currentPlaylistId)
              .toList();
          loading = false;
        });
      } catch (e) {
        if (!mounted) return;
        setDialogState(() {
          error = e.toString();
          loading = false;
        });
      }
    }

    return showAppDialog<_MediaMoveTarget>(
      context: context,
      builder: (context) {
        var started = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (!started) {
              started = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) loadPlaylists(setDialogState);
              });
            }

            return AppDialog(
              title: const Text('移动媒体'),
              body: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        entry.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppTile(
                      prefix: const Icon(Icons.home_outlined),
                      title: const Text('根目录'),
                      enabled: _currentPlaylistId.isNotEmpty,
                      onPressed: _currentPlaylistId.isEmpty
                          ? null
                          : () => Navigator.pop(
                                context,
                                const _MediaMoveTarget('', '根目录'),
                              ),
                    ),
                    if (loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: AppLoadingIndicator(centered: false),
                      )
                    else if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: AppListView.builder(
                          shrinkWrap: true,
                          itemCount: playlists.length,
                          itemBuilder: (context, index) {
                            final playlist = playlists[index];
                            return AppTile(
                              prefix: const Icon(Icons.folder_outlined),
                              title: Text(
                                playlist.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: playlist.parentId == null
                                  ? null
                                  : Text('上级 ${playlist.parentId}'),
                              onPressed: () => Navigator.pop(
                                context,
                                _MediaMoveTarget(playlist.id, playlist.name),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.pop(context),
                  label: '取消',
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed:
                      loading ? null : () => loadPlaylists(setDialogState),
                  icon: Icons.refresh,
                  label: '刷新',
                  style: AppActionButtonStyle.text,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _showRejectReasonDialog() {
    final controller = TextEditingController();
    return ChatUtils.showStyledDialog<String>(
      context: context,
      title: '拒绝申请',
      icon: const Icon(Icons.block_rounded),
      iconColor: Theme.of(context).colorScheme.error,
      content: AppTextField(
        controller: controller,
        label: '原因',
        autofocus: true,
        maxLines: 3,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          icon: Icons.block_rounded,
          label: '拒绝',
          style: AppActionButtonStyle.destructive,
        ),
      ],
    ).whenComplete(() => _disposeTextControllersAfterDialog([controller]));
  }

  Future<_EntryEditResult?> _showEntryEditDialog({
    required String title,
    String initialName = '',
    String initialDescription = '',
  }) {
    final nameController = TextEditingController(text: initialName);
    final descriptionController =
        TextEditingController(text: initialDescription);
    return ChatUtils.showStyledDialog<_EntryEditResult>(
      context: context,
      title: title,
      icon: const Icon(Icons.edit_outlined),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: nameController,
              label: '名称',
              autofocus: true,
              onSubmitted: (_) {
                Navigator.pop(
                  context,
                  _EntryEditResult(
                    nameController.text.trim(),
                    descriptionController.text.trim(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: descriptionController,
              label: '描述',
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(
            context,
            _EntryEditResult(
              nameController.text.trim(),
              descriptionController.text.trim(),
            ),
          ),
          text: '保存',
        ),
      ],
    ).whenComplete(() {
      _disposeTextControllersAfterDialog([
        nameController,
        descriptionController,
      ]);
    });
  }

  Future<_MemberEditResult?> _showMemberEditDialog() {
    final userIdController = TextEditingController();
    var role = 3;
    var notify = true;
    return ChatUtils.showStyledDialog<_MemberEditResult>(
      context: context,
      title: '添加成员',
      icon: const Icon(Icons.person_add_alt_1_rounded),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: userIdController,
                label: '用户 ID',
                prefixIcon: Icons.person_outline_rounded,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              AppSelect<int>(
                value: role,
                label: '角色',
                prefixIcon: Icons.admin_panel_settings_outlined,
                options: const {
                  '管理员': 2,
                  '成员': 3,
                  '访客': 4,
                },
                onChanged: (value) {
                  if (value != null) setDialogState(() => role = value);
                },
              ),
              const SizedBox(height: 12),
              AppSwitchTile(
                title: const Text('发送通知'),
                value: notify,
                onChanged: (value) => setDialogState(() => notify = value),
              ),
            ],
          );
        },
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        ChatUtils.createConfirmButton(
          context,
          () {
            final userId = userIdController.text.trim();
            if (userId.isEmpty) return;
            Navigator.pop(
              context,
              _MemberEditResult(userId, role, notify),
            );
          },
          text: '添加',
        ),
      ],
    ).whenComplete(
        () => _disposeTextControllersAfterDialog([userIdController]));
  }

  void _disposeTextControllersAfterDialog(
    List<TextEditingController> controllers,
  ) {
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      for (final controller in controllers) {
        controller.dispose();
      }
    });
  }

  Future<int?> _showMemberRoleDialog(int currentRole) {
    var role = currentRole == 1 ? 3 : currentRole;
    return ChatUtils.showStyledDialog<int>(
      context: context,
      title: '修改角色',
      icon: const Icon(Icons.admin_panel_settings_outlined),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return AppSelect<int>(
            value: role,
            label: '角色',
            prefixIcon: Icons.admin_panel_settings_outlined,
            options: const {
              '管理员': 2,
              '成员': 3,
              '访客': 4,
            },
            onChanged: (value) {
              if (value != null) setDialogState(() => role = value);
            },
          );
        },
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, role),
          text: '保存',
        ),
      ],
    );
  }

  Future<_MemberPermissionOverrideResult?> _showMemberPermissionOverrideDialog(
    AdminRoomMember member,
  ) {
    final isAdmin =
        member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
    var added =
        isAdmin ? member.adminAddedPermissions : member.addedPermissions;
    var removed =
        isAdmin ? member.adminRemovedPermissions : member.removedPermissions;

    return showAppDialog<_MemberPermissionOverrideResult>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void setOverride(int flag, _PermissionOverrideMode mode) {
              setDialogState(() {
                added &= ~flag;
                removed &= ~flag;
                switch (mode) {
                  case _PermissionOverrideMode.inherit:
                    break;
                  case _PermissionOverrideMode.allow:
                    added |= flag;
                  case _PermissionOverrideMode.deny:
                    removed |= flag;
                }
              });
            }

            return AppDialog(
              title: const Text('权限覆盖'),
              body: SizedBox(
                width: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: RoomMemberPermissions.descriptions.entries
                      .map(
                        (entry) => _buildPermissionOverrideRow(
                          entry.value,
                          entry.key,
                          added,
                          removed,
                          setOverride,
                        ),
                      )
                      .toList(),
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.pop(context),
                  label: '取消',
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: () {
                    setDialogState(() {
                      added = 0;
                      removed = 0;
                    });
                  },
                  label: '清除覆盖',
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      _MemberPermissionOverrideResult(
                        addedPermissions: isAdmin ? 0 : added,
                        removedPermissions: isAdmin ? 0 : removed,
                        adminAddedPermissions: isAdmin ? added : 0,
                        adminRemovedPermissions: isAdmin ? removed : 0,
                      ),
                    );
                  },
                  label: '保存',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPermissionOverrideRow(
    String title,
    int flag,
    int added,
    int removed,
    void Function(int flag, _PermissionOverrideMode mode) onChanged,
  ) {
    final mode = (added & flag) != 0
        ? _PermissionOverrideMode.allow
        : (removed & flag) != 0
            ? _PermissionOverrideMode.deny
            : _PermissionOverrideMode.inherit;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          AppSegmentedControl<_PermissionOverrideMode>(
            segments: const [
              ButtonSegment(
                value: _PermissionOverrideMode.inherit,
                label: Text('继承'),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.allow,
                label: Text('允许'),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.deny,
                label: Text('拒绝'),
              ),
            ],
            value: mode,
            onChanged: (selection) => onChanged(flag, selection),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirm({
    required String title,
    required String content,
    required String action,
  }) async {
    final destructive =
        action.contains('删除') || action.contains('移出') || action.contains('拒绝');
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: title,
      icon: Icon(
        destructive ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
      ),
      iconColor: destructive ? Theme.of(context).colorScheme.error : null,
      content: Text(content),
      actions: [
        ChatUtils.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(context, true),
          icon: destructive ? Icons.warning_amber_rounded : Icons.check,
          label: action,
          style: destructive
              ? AppActionButtonStyle.destructive
              : AppActionButtonStyle.tonal,
        ),
      ],
    );
    return confirmed == true;
  }

  Widget _buildSwitchItem(
    String title,
    String? subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          AppSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildPermissionSwitch(
    String title,
    int permissions,
    int flag,
    ValueChanged<bool> onChanged,
    ThemeData theme,
    bool isDark,
  ) {
    return _buildSwitchItem(
      title,
      null,
      _hasPermission(permissions, flag),
      onChanged,
      theme,
      isDark,
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 20),
      child: Text(
        title,
        style: TextStyle(
          color: theme.hintColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSurface({
    required List<Widget> children,
    required bool isDark,
  }) {
    return AppPanelSurface(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: _settingsSurfaceColor(isDark),
      border: _settingsSurfaceBorder(isDark),
      child: Column(children: children),
    );
  }

  Color _settingsSurfaceColor(bool isDark) {
    return isDark ? const Color(0xFF1E1E24) : Colors.white;
  }

  Border _settingsSurfaceBorder(bool isDark) {
    return Border.all(
      color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return AppDivider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: theme.dividerColor.withValues(alpha: 0.12),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onSearch,
    IconData icon = Icons.search_rounded,
  }) {
    return AppSearchField(
      controller: controller,
      hintText: label,
      icon: icon,
      onChanged: (value) {
        if (value.isEmpty) onSearch();
      },
      onSubmitted: (_) => onSearch(),
    );
  }

  Widget _buildMaxMembersField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AppTextField(
        controller: _maxMembersController,
        label: '最大成员数',
        helperText: '0 表示不限制',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildSettingsTab(ThemeData theme, bool isDark) {
    return AppListView(
      padding: const EdgeInsets.only(bottom: 32, top: 8),
      children: [
        _buildSectionHeader('访问控制', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildSwitchItem(
              '允许访客加入',
              '访客 token 只能访问当前房间',
              _allowGuestJoin,
              (v) => setState(() => _allowGuestJoin = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              '加入需要审核',
              '新成员申请需管理员批准',
              _requireApproval,
              (v) => setState(() => _requireApproval = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              '允许自动加入',
              '关闭后只能通过邀请或管理员添加成员',
              _allowAutoJoin,
              (v) => setState(() => _allowAutoJoin = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildMaxMembersField(theme),
          ],
        ),
        _buildSectionHeader('消息', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildSwitchItem(
              '聊天',
              null,
              _chatEnabled,
              (v) => setState(() => _chatEnabled = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              '弹幕',
              null,
              _danmakuEnabled,
              (v) => setState(() => _danmakuEnabled = v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader('普通成员权限', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildPermissionSwitch(
              '发送聊天/弹幕',
              _memberPermissions,
              RoomMemberPermissions.chat,
              (v) => _setMemberPermission(RoomMemberPermissions.chat, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '添加媒体',
              _memberPermissions,
              RoomMemberPermissions.createMediaResource,
              (v) => _setMemberPermission(
                RoomMemberPermissions.createMediaResource,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '查看媒体列表',
              _memberPermissions,
              RoomMemberPermissions.viewMediaResources,
              (v) => _setMemberPermission(
                RoomMemberPermissions.viewMediaResources,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '查看成员列表',
              _memberPermissions,
              RoomMemberPermissions.viewMemberList,
              (v) => _setMemberPermission(
                RoomMemberPermissions.viewMemberList,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '查看聊天历史',
              _memberPermissions,
              RoomMemberPermissions.viewChatHistory,
              (v) => _setMemberPermission(
                RoomMemberPermissions.viewChatHistory,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              'WebRTC 通话',
              _memberPermissions,
              RoomMemberPermissions.useWebRTC,
              (v) => _setMemberPermission(RoomMemberPermissions.useWebRTC, v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader('访客权限', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildPermissionSwitch(
              '查看成员列表',
              _guestPermissions,
              RoomGuestPermissions.viewMemberList,
              (v) =>
                  _setGuestPermission(RoomGuestPermissions.viewMemberList, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '查看聊天历史',
              _guestPermissions,
              RoomGuestPermissions.viewChatHistory,
              (v) =>
                  _setGuestPermission(RoomGuestPermissions.viewChatHistory, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              'WebRTC 通话',
              _guestPermissions,
              RoomGuestPermissions.useWebRTC,
              (v) => _setGuestPermission(RoomGuestPermissions.useWebRTC, v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader('设置操作', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isSaving ? '正在保存设置' : '保存访问控制、消息开关和权限策略',
                      style: TextStyle(color: theme.hintColor, fontSize: 13),
                    ),
                  ),
                  AppActionButton(
                    onPressed: _isSaving ? null : _saveSettings,
                    loading: _isSaving,
                    icon: Icons.save_outlined,
                    label: '保存设置',
                    style: AppActionButtonStyle.tonal,
                  ),
                ],
              ),
            ),
            _buildDivider(theme),
            AppTile(
              prefix: const Icon(Icons.restart_alt),
              title: const Text('重置房间设置'),
              subtitle: const Text('恢复服务端默认房间策略'),
              onPressed: _resetSettings,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreamsTab(ThemeData theme, bool isDark) {
    if (_streamsLoading && _streams.isEmpty) {
      return const AppLoadingIndicator();
    }
    return AppRefreshIndicator(
      onRefresh: _loadStreams,
      child: AppListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '活跃推流',
            count: _streams.length,
            loading: _streamsLoading,
            onRefresh: _loadStreams,
            theme: theme,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildSearchField(
                    controller: _streamSearchController,
                    label: '媒体 ID',
                    onSearch: () {
                      setState(() => _streamsPage = 1);
                      _loadStreams();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                AppIconButton(
                  onPressed: () {
                    setState(() {
                      _streamSortDirection = _streamSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? client_enum.SortDirection.SORT_DIRECTION_DESC
                          : client_enum.SortDirection.SORT_DIRECTION_ASC;
                      _streamsPage = 1;
                    });
                    _loadStreams();
                  },
                  icon: _streamSortDirection ==
                          client_enum.SortDirection.SORT_DIRECTION_ASC
                      ? Icons.north_rounded
                      : Icons.south_rounded,
                  tooltip: _streamSortDirection ==
                          client_enum.SortDirection.SORT_DIRECTION_ASC
                      ? '媒体 ID 升序'
                      : '媒体 ID 降序',
                  style: AppIconButtonStyle.outlined,
                ),
              ],
            ),
          ),
          AppPaginationBar(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            label:
                '第 $_streamsPage 页 · 每页 $_streamsPageSize · 共 $_streamsTotal 条',
            labelStyle: TextStyle(color: theme.hintColor, fontSize: 12),
            onPrevious: _streamsPage <= 1
                ? null
                : () {
                    setState(() => _streamsPage -= 1);
                    _loadStreams();
                  },
            onNext: _streamsPage >= _streamPageCount
                ? null
                : () {
                    setState(() => _streamsPage += 1);
                    _loadStreams();
                  },
          ),
          if (_streams.isEmpty)
            _buildEmptyState('当前没有活跃推流', theme)
          else
            ..._streams.map(
              (stream) => _buildStreamTile(stream, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(ThemeData theme, bool isDark) {
    if (_reviewsLoading && _reviews.isEmpty) {
      return const AppLoadingIndicator();
    }
    return AppRefreshIndicator(
      onRefresh: _loadReviews,
      child: AppListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '加入申请',
            count: _reviewsTotal,
            loading: _reviewsLoading,
            onRefresh: _loadReviews,
            theme: theme,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildSearchField(
                    controller: _reviewUserController,
                    label: '用户 ID',
                    onSearch: () {
                      setState(() => _reviewsPage = 1);
                      _loadReviews();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 150,
                  child: AppSelect<common_enum.ReviewStatus>(
                    value: _reviewStatusFilter,
                    label: '状态',
                    options: const {
                      '待审核': common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
                      '已通过': common_enum.ReviewStatus.REVIEW_STATUS_APPROVED,
                      '已拒绝': common_enum.ReviewStatus.REVIEW_STATUS_REJECTED,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _reviewStatusFilter = value;
                        _reviewsPage = 1;
                      });
                      _loadReviews();
                    },
                  ),
                ),
              ],
            ),
          ),
          AppPaginationBar(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            label:
                '第 $_reviewsPage 页 · 每页 $_reviewsPageSize · 共 $_reviewsTotal 条',
            labelStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
            ),
            onPrevious: _reviewsPage <= 1
                ? null
                : () {
                    setState(() => _reviewsPage -= 1);
                    _loadReviews();
                  },
            onNext: _reviewsPage >= _reviewPageCount
                ? null
                : () {
                    setState(() => _reviewsPage += 1);
                    _loadReviews();
                  },
          ),
          if (_reviews.isEmpty)
            _buildEmptyState('当前没有加入申请', theme)
          else
            ..._reviews.map(
              (review) => _buildReviewTile(review, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaTab(ThemeData theme, bool isDark) {
    final page = _mediaPage;
    if (_mediaLoading && page == null) {
      return const AppLoadingIndicator();
    }
    final entries = page?.entries ?? const <SyncTvMovie>[];
    final canMutateScope = _canMutateCurrentMediaScope;
    return AppRefreshIndicator(
      onRefresh: _loadMediaLibrary,
      child: AppListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '媒体库',
            count: entries.length,
            loading: _mediaLoading,
            onRefresh: _loadMediaLibrary,
            theme: theme,
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  tooltip: '返回上级',
                  onPressed:
                      _mediaTarget.isNotEmpty || _mediaPlaylistStack.isNotEmpty
                          ? _handleMediaBack
                          : null,
                  icon: Icons.arrow_upward,
                ),
                if (canMutateScope) ...[
                  AppIconButton(
                    tooltip: '添加媒体',
                    onPressed: _mediaLoading ? null : _addMediaToCurrentScope,
                    icon: Icons.add_to_queue_rounded,
                    style: AppIconButtonStyle.tonal,
                  ),
                  AppIconButton(
                    tooltip: '新建播放列表',
                    onPressed: _createPlaylist,
                    icon: Icons.create_new_folder,
                  ),
                  AppIconButton(
                    tooltip: '清空当前目录',
                    onPressed: _mediaLoading ? null : _clearCurrentMediaScope,
                    icon: Icons.delete_sweep_rounded,
                    style: AppIconButtonStyle.destructive,
                  ),
                ],
                AppIconButton(
                  tooltip: '刷新动态列表',
                  onPressed: () => _reloadMediaLibrary(refresh: true),
                  icon: Icons.sync,
                ),
              ],
            ),
          ),
          _buildMediaScope(page, theme, isDark),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                _buildSearchField(
                  controller: _mediaSearchController,
                  label: '搜索媒体或目录',
                  onSearch: _reloadMediaLibrary,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppSelect<String>(
                        key: ValueKey('media-source-$_mediaSourceProvider'),
                        value: _mediaSourceProvider,
                        label: '来源',
                        options: {
                          for (final entry in _mediaSourceLabels.entries)
                            entry.value: entry.key,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          _selectMediaSourceProvider(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppSelect<String>(
                        key: ValueKey(
                          'media-instance-$_mediaSourceProvider-'
                          '$_mediaProviderInstanceName-'
                          '${_mediaProviderInstances.join('|')}',
                        ),
                        value: _mediaProviderInstances
                                .contains(_mediaProviderInstanceName)
                            ? _mediaProviderInstanceName
                            : '',
                        label: '实例',
                        options: {
                          for (final instance in _mediaProviderInstances)
                            _providerInstanceLabel(instance): instance,
                        },
                        enabled: _mediaSourcesWithProviderInstances.contains(
                              _mediaSourceProvider,
                            ) &&
                            !_mediaProviderInstancesLoading,
                        onChanged: _mediaSourcesWithProviderInstances.contains(
                                  _mediaSourceProvider,
                                ) &&
                                !_mediaProviderInstancesLoading
                            ? (value) {
                                if (value == null) return;
                                _selectMediaProviderInstance(value);
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppSelect<client_enum.ResourceAvailabilityFilter>(
                        value: _mediaAvailability,
                        label: '可用性',
                        options: const {
                          '全部': client_enum.ResourceAvailabilityFilter
                              .RESOURCE_AVAILABILITY_FILTER_ALL,
                          '可用': client_enum.ResourceAvailabilityFilter
                              .RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
                          '不可用': client_enum.ResourceAvailabilityFilter
                              .RESOURCE_AVAILABILITY_FILTER_UNAVAILABLE,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _mediaAvailability = value);
                          _reloadMediaLibrary();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppSelect<client_enum.MediaListSortBy>(
                        value: _mediaSortBy,
                        label: '排序',
                        options: const {
                          '位置': client_enum
                              .MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION,
                          '名称': client_enum
                              .MediaListSortBy.MEDIA_LIST_SORT_BY_NAME,
                          '添加时间': client_enum
                              .MediaListSortBy.MEDIA_LIST_SORT_BY_ADDED_AT,
                          '更新时间': client_enum
                              .MediaListSortBy.MEDIA_LIST_SORT_BY_UPDATED_AT,
                          '来源': client_enum.MediaListSortBy
                              .MEDIA_LIST_SORT_BY_SOURCE_PROVIDER,
                          '实例': client_enum.MediaListSortBy
                              .MEDIA_LIST_SORT_BY_PROVIDER_INSTANCE_NAME,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _mediaSortBy = value);
                          _reloadMediaLibrary();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppIconButton(
                      onPressed: () {
                        setState(() {
                          _mediaSortDirection = _mediaSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_ASC
                              ? client_enum.SortDirection.SORT_DIRECTION_DESC
                              : client_enum.SortDirection.SORT_DIRECTION_ASC;
                        });
                        _reloadMediaLibrary();
                      },
                      icon: _mediaSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? Icons.north_rounded
                          : Icons.south_rounded,
                      tooltip: _mediaSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? '升序'
                          : '降序',
                      style: AppIconButtonStyle.outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (entries.isEmpty)
            _buildEmptyState('当前目录没有媒体条目', theme)
          else
            ...entries.map((entry) => _buildMediaTile(entry, theme, isDark)),
        ],
      ),
    );
  }

  Widget _buildRealtimeTab(ThemeData theme, bool isDark) {
    final resources = _realtimeResources();
    final loading = _membersLoading || _mediaLoading || _isSaving;
    return Column(
      children: [
        const SizedBox(height: 12),
        _buildToolbar(
          title: '实时诊断',
          count: resources.length,
          loading: loading,
          onRefresh: _refreshRealtimeDiagnostics,
          theme: theme,
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                tooltip: '复制诊断数据',
                onPressed: _copyRealtimeDiagnostics,
                icon: Icons.copy_all_rounded,
                style: AppIconButtonStyle.outlined,
              ),
              const SizedBox(width: 6),
              AppIconButton(
                tooltip: '重置监听',
                onPressed: loading ? null : _resetRealtimeDiagnostics,
                icon: Icons.restart_alt_rounded,
                style: AppIconButtonStyle.outlined,
              ),
            ],
          ),
        ),
        _buildRealtimePaneSelector(theme),
        Expanded(
          child: _buildRealtimePaneBody(resources, theme, isDark),
        ),
      ],
    );
  }

  Widget _buildRealtimePaneSelector(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430;
          return SizedBox(
            width: compact ? double.infinity : null,
            child: AppSegmentedControl<_RealtimeDiagnosticsPane>(
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: compact ? VisualDensity.compact : null,
                textStyle: WidgetStatePropertyAll(
                  theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              segments: const [
                ButtonSegment(
                  value: _RealtimeDiagnosticsPane.overview,
                  icon: Icon(Icons.dashboard_rounded),
                  label: Text('概览'),
                ),
                ButtonSegment(
                  value: _RealtimeDiagnosticsPane.resources,
                  icon: Icon(Icons.storage_rounded),
                  label: Text('资源'),
                ),
                ButtonSegment(
                  value: _RealtimeDiagnosticsPane.events,
                  icon: Icon(Icons.receipt_long_rounded),
                  label: Text('事件'),
                ),
              ],
              value: _realtimePane,
              onChanged: (selection) =>
                  setState(() => _realtimePane = selection),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRealtimePaneBody(
    List<_RealtimeResourceDebugInfo> resources,
    ThemeData theme,
    bool isDark,
  ) {
    switch (_realtimePane) {
      case _RealtimeDiagnosticsPane.overview:
        return AppRefreshIndicator(
          onRefresh: _refreshRealtimeDiagnostics,
          child: AppListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              _buildRealtimeOverview(resources, theme, isDark),
              _buildRealtimeSnapshot(resources, theme, isDark),
            ],
          ),
        );
      case _RealtimeDiagnosticsPane.resources:
        return AppRefreshIndicator(
          onRefresh: _refreshRealtimeDiagnostics,
          child: AppListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              _buildRealtimeDetails(resources, theme, isDark),
            ],
          ),
        );
      case _RealtimeDiagnosticsPane.events:
        return _buildRoomSettingsRealtimeEvents(theme);
    }
  }

  Widget _buildRoomSettingsRealtimeEvents(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: AppPanelSurface(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.55),
        ),
        child: RealtimeEventLogView(
          events: _realtimeEvents,
          padding: const EdgeInsets.all(12),
          onClear: () => setState(_realtimeEvents.clear),
          onMaxEntriesChanged: (_) => setState(_trimRealtimeEvents),
          emptyText: '监听请求和资源事件会显示在这里',
        ),
      ),
    );
  }

  List<_RealtimeResourceDebugInfo> _realtimeResources() {
    final mediaPage = _mediaPage;
    final mediaEntries = mediaPage?.entries.length ?? 0;
    return [
      _RealtimeResourceDebugInfo(
        key: 'settings',
        title: '房间设置',
        icon: Icons.tune_rounded,
        observeId: _settingsObserveId,
        version: _settingsWatchVersion,
        loading: _isSaving,
        localCount: 1,
        summary: _isSaving ? '正在保存设置' : '监听设置变更',
        stats: _settingsWatchStats,
        details: {
          'requirePassword': _settings.requirePassword,
          'allowGuestJoin': _settings.allowGuestJoin,
          'allowAutoJoin': _settings.allowAutoJoin,
          'requireApproval': _settings.requireApproval,
          'chatEnabled': _settings.chatEnabled,
          'danmakuEnabled': _settings.danmakuEnabled,
          'maxMembers': _settings.maxMembers,
          'memberPermissions': _settings.effectiveMemberPermissions,
          'guestPermissions': _settings.effectiveGuestPermissions,
        },
      ),
      _RealtimeResourceDebugInfo(
        key: 'members',
        title: '成员列表',
        icon: Icons.group_rounded,
        observeId: _membersObserveId,
        version: _membersWatchVersion,
        loading: _membersLoading,
        localCount: _members.length,
        summary: _membersLoading
            ? '正在刷新成员'
            : '$_membersOnlineCount 在线 / $_membersTotal 总数',
        stats: _membersWatchStats,
        details: {
          'pageCount': _members.length,
          'total': _membersTotal,
          'online': _membersOnlineCount,
          'page': _membersPage,
          'pageSize': _membersPageSize,
          'roleFilter': _memberRoleFilter?.name ?? '',
          'sortBy': _memberSortBy.name,
          'sortDirection': _memberSortDirection.name,
          'search': _memberSearchController.text.trim(),
        },
      ),
      _RealtimeResourceDebugInfo(
        key: 'media',
        title: '媒体列表',
        icon: Icons.video_library_rounded,
        observeId: _mediaObserveId,
        version: _mediaWatchVersion,
        loading: _mediaLoading,
        localCount: mediaEntries,
        summary: mediaPage == null
            ? '等待媒体快照'
            : '${mediaPage.folderCount} 目录 / ${mediaPage.fileCount} 媒体',
        stats: _mediaWatchStats,
        details: {
          'entries': mediaEntries,
          'total': mediaPage?.total ?? 0,
          'folderCount': mediaPage?.folderCount ?? 0,
          'fileCount': mediaPage?.fileCount ?? 0,
          'playlistId': _currentPlaylistId,
          'target': _mediaTarget,
          'sourceProvider': _mediaSourceProvider,
          'providerInstanceName': _mediaProviderInstanceName,
          'availability': _mediaAvailability.name,
          'sortBy': _mediaSortBy.name,
          'sortDirection': _mediaSortDirection.name,
          'search': _mediaSearchController.text.trim(),
        },
      ),
      _RealtimeResourceDebugInfo(
        key: 'chat',
        title: '聊天事件',
        icon: Icons.forum_rounded,
        observeId: _chatObserveId,
        version: _chatWatchVersion,
        loading: _chatLoading,
        localCount: _chatMessages.length,
        summary: _chatLoading ? '正在刷新聊天历史' : '聊天历史 ${_chatMessages.length} 条',
        stats: _chatWatchStats,
        details: {
          'history_count': _chatMessages.length,
          'next_cursor': _chatCursor,
          'unread': _chatReadState?.unreadCount ?? 0,
          'last_read_event_sequence':
              _chatReadState?.lastReadEventSequence ?? 0,
          'chatEnabled': _settings.chatEnabled,
        },
      ),
    ];
  }

  Map<String, Object?> _realtimeDebugPayload() {
    return {
      'room_id': widget.roomId,
      'room_name': widget.roomName,
      'captured_at': DateTime.now().toIso8601String(),
      'events': _realtimeEvents.map((event) => event.toJson()).toList(),
      'resources': [
        for (final resource in _realtimeResources())
          {
            'key': resource.key,
            'title': resource.title,
            'observe_id': resource.observeId,
            'version': resource.version,
            'loading': resource.loading,
            'local_count': resource.localCount,
            'summary': resource.summary,
            'stats': {
              'observed': resource.stats.observed,
              'changed': resource.stats.changed,
              'errors': resource.stats.errors,
              'last_kind': resource.stats.lastKind,
              'last_seen_at': resource.stats.lastSeenAt?.toIso8601String(),
              'last_error': resource.stats.lastError,
            },
            'details': resource.details,
          },
      ],
    };
  }

  bool _isRealtimeResourceReady(_RealtimeResourceDebugInfo resource) =>
      resource.version.isNotEmpty ||
      resource.stats.observed > 0 ||
      resource.stats.changed > 0;

  String _realtimeResourceStatusLabel(_RealtimeResourceDebugInfo resource) {
    final state = _isRealtimeResourceReady(resource)
        ? (resource.version.isEmpty ? 'ready' : resource.version)
        : 'pending';
    return '${resource.observeId}: $state';
  }

  Widget _buildRealtimeOverview(
    List<_RealtimeResourceDebugInfo> resources,
    ThemeData theme,
    bool isDark,
  ) {
    final watched = resources.where(_isRealtimeResourceReady).length;
    final eventCount = _realtimeEvents.length;
    final outgoingCount =
        _realtimeEvents.where((event) => event.direction == 'out').length;
    final incomingCount = eventCount - outgoingCount;
    final errorCount =
        resources.fold<int>(0, (total, item) => total + item.stats.errors);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          final cards = [
            _buildRealtimeMetricCard(
              theme,
              isDark,
              icon: Icons.sensors_rounded,
              label: '监听资源',
              value: '$watched/${resources.length}',
              tone: watched == resources.length ? Colors.green : Colors.orange,
            ),
            _buildRealtimeMetricCard(
              theme,
              isDark,
              icon: Icons.swap_vert_rounded,
              label: '事件',
              value: eventCount.toString(),
              tone: theme.colorScheme.primary,
            ),
            _buildRealtimeMetricCard(
              theme,
              isDark,
              icon: Icons.compare_arrows_rounded,
              label: '发出 / 收到',
              value: '$outgoingCount / $incomingCount',
              tone: Colors.blueAccent,
            ),
            _buildRealtimeMetricCard(
              theme,
              isDark,
              icon: Icons.error_outline_rounded,
              label: '异常',
              value: errorCount.toString(),
              tone: errorCount == 0 ? Colors.green : Colors.redAccent,
            ),
          ];
          if (compact) {
            return Column(
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  cards[i],
                  if (i != cards.length - 1) const SizedBox(height: 8),
                ],
              ],
            );
          }
          return Row(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                Expanded(child: cards[i]),
                if (i != cards.length - 1) const SizedBox(width: 10),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildRealtimeMetricCard(
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String label,
    required String value,
    required Color tone,
  }) {
    return AppPanelSurface(
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.all(14),
      color: _settingsSurfaceColor(isDark),
      border: _settingsSurfaceBorder(isDark),
      child: Row(
        children: [
          AppIconBadge(icon: icon, color: tone, iconSize: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeSnapshot(
    List<_RealtimeResourceDebugInfo> resources,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: AppPanelSurface(
        padding: const EdgeInsets.all(14),
        color: _settingsSurfaceColor(isDark),
        border: _settingsSurfaceBorder(isDark),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.data_object_rounded,
                    color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '运行快照',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDebugLine(theme, '房间', widget.roomName),
            _buildDebugLine(theme, '房间 ID', widget.roomId),
            _buildDebugLine(
              theme,
              '当前目录',
              _mediaScopeLabel(_mediaPage),
            ),
            _buildDebugLine(
              theme,
              '监听状态',
              resources.map(_realtimeResourceStatusLabel).join('\n'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealtimeDetails(
    List<_RealtimeResourceDebugInfo> resources,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AppResponsiveWrap(
        minItemWidth: 320,
        maxColumns: 3,
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final resource in resources)
            _buildRealtimeResourceCard(
              resource,
              theme,
              isDark,
            ),
        ],
      ),
    );
  }

  Widget _buildRealtimeResourceCard(
    _RealtimeResourceDebugInfo resource,
    ThemeData theme,
    bool isDark,
  ) {
    final ready = _isRealtimeResourceReady(resource);
    final tone = resource.stats.errors > 0
        ? Colors.redAccent
        : ready
            ? Colors.green
            : Colors.orange;
    return AppPanelSurface(
      padding: const EdgeInsets.all(14),
      color: _settingsSurfaceColor(isDark),
      border: _settingsSurfaceBorder(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBadge(
                icon: resource.icon,
                color: tone,
                size: 38,
                iconSize: 21,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      resource.observeId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.hintColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (resource.loading)
                const SizedBox.square(
                  dimension: 18,
                  child: AppLoadingIndicator(
                      size: AppLoadingSize.sm, centered: false),
                )
              else
                Icon(
                  ready ? Icons.check_circle_rounded : Icons.pending_rounded,
                  color: tone,
                ),
            ],
          ),
          const SizedBox(height: 14),
          _buildDebugLine(
              theme,
              '版本',
              resource.version.isEmpty
                  ? (ready ? '未提供' : '等待')
                  : resource.version),
          _buildDebugLine(theme, '本地条目', resource.localCount.toString()),
          _buildDebugLine(theme, '状态', resource.summary),
          _buildDebugLine(theme, '最近事件', resource.stats.lastKind),
          _buildDebugLine(
            theme,
            '事件计数',
            'observed ${resource.stats.observed} / changed ${resource.stats.changed} / errors ${resource.stats.errors}',
          ),
          _buildDebugLine(
            theme,
            '最后时间',
            _formatDateTime(resource.stats.lastSeenAt),
          ),
          if (resource.stats.lastError.isNotEmpty)
            _buildDebugLine(theme, '错误', resource.stats.lastError),
          const AppDivider(height: 20),
          ...resource.details.entries.map(
            (entry) => _buildDebugLine(
              theme,
              entry.key,
              _debugValue(entry.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugLine(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppSelectableText(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistoryTab(ThemeData theme, bool isDark) {
    final searchActive = _chatSearchQuery.isNotEmpty;
    final nextCursor = searchActive ? _chatSearchCursor : _chatCursor;
    return AppRefreshIndicator(
      onRefresh: _loadChatHistory,
      child: AppListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '聊天历史',
            count: _chatMessages.length,
            loading: _chatLoading,
            onRefresh: _loadChatHistory,
            theme: theme,
            action: nextCursor.isEmpty
                ? null
                : AppIconButton(
                    tooltip: '加载更多',
                    onPressed: _chatLoading
                        ? null
                        : () => _loadChatHistory(loadMore: true),
                    icon: Icons.more_horiz,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: _buildSearchField(
              controller: _chatSearchController,
              label: '搜索聊天内容',
              onSearch: _searchChatHistory,
              icon: Icons.manage_search_rounded,
            ),
          ),
          if (searchActive)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '搜索 "$_chatSearchQuery"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppActionButton(
                    onPressed: _chatLoading
                        ? null
                        : () {
                            _chatSearchController.clear();
                            _searchChatHistory();
                          },
                    icon: Icons.close_rounded,
                    label: '清除',
                    style: AppActionButtonStyle.text,
                  ),
                ],
              ),
            ),
          if (_chatMessages.isEmpty)
            _buildEmptyState(searchActive ? '没有匹配的聊天消息' : '当前没有聊天历史', theme)
          else
            ..._chatMessages.reversed.map(
              (message) => _buildChatMessageTile(message, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildNetworkTab(ThemeData theme, bool isDark) {
    return AppRefreshIndicator(
      onRefresh: _loadIceServers,
      child: AppListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: 'ICE 服务器',
            count: _iceServers.length,
            loading: _iceLoading,
            onRefresh: _loadIceServers,
            theme: theme,
          ),
          if (_iceServers.isEmpty)
            _buildEmptyState('当前没有 ICE 服务器配置', theme)
          else
            ..._iceServers.map(
              (server) => _buildIceServerTile(server, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaScope(
    RoomMediaLibraryPage? page,
    ThemeData theme,
    bool isDark,
  ) {
    final label = _mediaScopeLabel(page);
    return AppPanelSurface(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: _settingsSurfaceColor(isDark),
      border: _settingsSurfaceBorder(isDark),
      child: Row(
        children: [
          const Icon(Icons.folder_open, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (page != null)
            Text(
              '${page.folderCount} 目录 / ${page.fileCount} 媒体',
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildMembersTab(ThemeData theme, bool isDark) {
    if (_membersLoading && _members.isEmpty) {
      return const AppLoadingIndicator();
    }
    return AppRefreshIndicator(
      onRefresh: _loadMembers,
      child: AppListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '房间成员',
            count: _membersTotal,
            loading: _membersLoading,
            onRefresh: _loadMembers,
            theme: theme,
            action: AppIconButton(
              tooltip: '添加成员',
              onPressed: _addMember,
              icon: Icons.person_add_alt_1,
            ),
          ),
          _buildMemberPresenceSummary(theme, isDark),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                _buildSearchField(
                  controller: _memberSearchController,
                  label: '用户名或用户 ID',
                  onSearch: () {
                    setState(() => _membersPage = 1);
                    _refreshMembersRealtimeQuery();
                    _loadMembers();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppSelect<common_enum.RoomMemberRole?>(
                        value: _memberRoleFilter,
                        label: '角色',
                        hintText: '全部角色',
                        options: const {
                          '全部角色': null,
                          '房主': common_enum
                              .RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
                          '管理员':
                              common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                          '成员': common_enum
                              .RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                          '访客':
                              common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
                        },
                        onChanged: (value) {
                          setState(() {
                            _memberRoleFilter = value;
                            _membersPage = 1;
                          });
                          _refreshMembersRealtimeQuery();
                          _loadMembers();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppSelect<client_enum.RoomMemberListSortBy>(
                        value: _memberSortBy,
                        label: '排序',
                        options: const {
                          '加入时间': client_enum.RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                          '用户名': client_enum.RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                          '角色': client_enum.RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_ROLE,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _memberSortBy = value;
                            _membersPage = 1;
                          });
                          _refreshMembersRealtimeQuery();
                          _loadMembers();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppIconButton(
                      onPressed: () {
                        setState(() {
                          _memberSortDirection = _memberSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_ASC
                              ? client_enum.SortDirection.SORT_DIRECTION_DESC
                              : client_enum.SortDirection.SORT_DIRECTION_ASC;
                          _membersPage = 1;
                        });
                        _refreshMembersRealtimeQuery();
                        _loadMembers();
                      },
                      icon: _memberSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? Icons.north_rounded
                          : Icons.south_rounded,
                      tooltip: _memberSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? '升序'
                          : '降序',
                      style: AppIconButtonStyle.outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppPaginationBar(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            label:
                '第 $_membersPage 页 · 每页 $_membersPageSize · 共 $_membersTotal 条',
            labelStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
            ),
            onPrevious: _membersPage <= 1
                ? null
                : () {
                    setState(() => _membersPage -= 1);
                    _refreshMembersRealtimeQuery();
                    _loadMembers();
                  },
            onNext: _membersPage >= _memberPageCount
                ? null
                : () {
                    setState(() => _membersPage += 1);
                    _refreshMembersRealtimeQuery();
                    _loadMembers();
                  },
          ),
          if (_members.isEmpty)
            _buildEmptyState('当前没有成员', theme)
          else
            ..._members.map(
              (member) => _buildMemberTile(member, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildToolbar({
    required String title,
    required int count,
    required bool loading,
    required VoidCallback onRefresh,
    required ThemeData theme,
    Widget? action,
  }) {
    return AppDataToolbar(
      title: title,
      count: count,
      loading: loading,
      onRefresh: onRefresh,
      action: action,
    );
  }

  Widget _buildMemberPresenceSummary(ThemeData theme, bool isDark) {
    final connectionCount =
        _members.fold<int>(0, (sum, member) => sum + member.connectionCount);
    final totalConnections = connectionCount > 0
        ? connectionCount
        : _members.where((member) => member.isOnline).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: AppPanelSurface(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: _membersOnlineCount > 0
                  ? const Color(0xFF16A34A)
                  : theme.hintColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '在线 $_membersOnlineCount / 成员 $_membersTotal',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '$totalConnections 个连接',
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String text, ThemeData theme) {
    return SizedBox(
      height: 180,
      child: AppEmptyState(
        icon: Icons.inbox_outlined,
        title: text,
        maxWidth: 360,
      ),
    );
  }

  Widget _buildDetailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            child: AppSelectableText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementTileSurface(
    ThemeData theme,
    bool isDark, {
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(14),
  }) {
    return AppPanelSurface(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: padding,
      color: isDark ? const Color(0xFF1E1E24) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
      ),
      child: child,
    );
  }

  Widget _buildStreamTile(
    RoomStreamEntryInfo stream,
    ThemeData theme,
    bool isDark,
  ) {
    return _buildManagementTileSurface(
      theme,
      isDark,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Icon(
            stream.active ? Icons.sensors : Icons.sensors_off,
            color: stream.active ? Colors.green : theme.disabledColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppInkSurface(
              onTap: () => _showStreamInfo(stream),
              color: Colors.transparent,
              borderRadius: BorderRadius.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stream.mediaId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _streamSubtitle(stream),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          AppIconButton(
            tooltip: '查看详情',
            onPressed: () => _showStreamInfo(stream),
            icon: Icons.info_outline_rounded,
          ),
          AppIconButton(
            tooltip: '断开推流',
            onPressed: stream.active ? () => _kickStream(stream) : null,
            icon: Icons.link_off,
            style: AppIconButtonStyle.destructive,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTile(
    RoomJoinReviewInfo review,
    ThemeData theme,
    bool isDark,
  ) {
    final isPending =
        review.status == common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value;
    return _buildManagementTileSurface(
      theme,
      isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.username.isEmpty ? review.userId : review.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _roleLabel(review.requestedRole),
                style: TextStyle(color: theme.hintColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${review.userId} · ${_formatTimestamp(review.requestedAt)} · ${_reviewStatusLabel(review.status)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.hintColor, fontSize: 12),
          ),
          if (review.rejectionReason.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.rejectionReason,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ],
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppActionButton(
                  onPressed: () => _rejectReview(review),
                  icon: Icons.close,
                  label: '拒绝',
                  style: AppActionButtonStyle.text,
                ),
                const SizedBox(width: 8),
                AppActionButton(
                  onPressed: () => _approveReview(review),
                  icon: Icons.check,
                  label: '通过',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaTile(SyncTvMovie entry, ThemeData theme, bool isDark) {
    final isPersisted =
        entry.id.startsWith('pl_') || entry.id.startsWith('med_');
    final canMutate = _canMutateCurrentMediaScope &&
        isPersisted &&
        !entry.isProviderDynamicEntry;
    final playlistIndex = entry.id.startsWith('pl_')
        ? _mediaPage?.playlists.indexWhere((item) => item.id == entry.id) ?? -1
        : -1;
    final playlistCount = _mediaPage?.playlists.length ?? 0;
    return _buildManagementTileSurface(
      theme,
      isDark,
      child: Row(
        children: [
          _buildCoverPreview(
            url: entry.coverUrl,
            fallbackIcon: entry.isFolder
                ? Icons.folder_rounded
                : entry.live
                    ? Icons.live_tv
                    : Icons.movie_creation_outlined,
            width: 68,
            height: 68,
            borderRadius: 0,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppInkSurface(
              onTap: entry.isFolder ? () => _openMediaEntry(entry) : null,
              color: Colors.transparent,
              borderRadius: BorderRadius.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (entry.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      entry.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.hintColor, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _mediaSubtitle(entry),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          AppPopupMenuButton<_MediaAction>(
            tooltip: '媒体操作',
            onSelected: (action) {
              switch (action) {
                case _MediaAction.details:
                  _showMediaEntryDetails(entry);
                case _MediaAction.open:
                  _openMediaEntry(entry);
                case _MediaAction.rename:
                  _renameEntry(entry);
                case _MediaAction.updateCover:
                  _updateEntryCover(entry);
                case _MediaAction.clearCover:
                  _clearEntryCover(entry);
                case _MediaAction.moveUp:
                  _movePlaylistRelative(entry, -1);
                case _MediaAction.moveDown:
                  _movePlaylistRelative(entry, 1);
                case _MediaAction.move:
                  _moveMedia(entry);
                case _MediaAction.delete:
                  _deleteEntry(entry);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _MediaAction.details,
                child: Text('详情'),
              ),
              PopupMenuItem(
                value: _MediaAction.open,
                enabled: entry.isFolder,
                child: const Text('打开'),
              ),
              if (canMutate) ...[
                const PopupMenuItem(
                  value: _MediaAction.rename,
                  child: Text('编辑'),
                ),
                const PopupMenuItem(
                  value: _MediaAction.updateCover,
                  child: Text('更新封面'),
                ),
                PopupMenuItem(
                  value: _MediaAction.clearCover,
                  enabled: entry.coverUrl.isNotEmpty,
                  child: const Text('移除封面'),
                ),
                PopupMenuItem(
                  value: _MediaAction.moveUp,
                  enabled: playlistIndex > 0,
                  child: const Text('上移'),
                ),
                PopupMenuItem(
                  value: _MediaAction.moveDown,
                  enabled:
                      playlistIndex >= 0 && playlistIndex < playlistCount - 1,
                  child: const Text('下移'),
                ),
                if (entry.id.startsWith('med_'))
                  const PopupMenuItem(
                    value: _MediaAction.move,
                    child: Text('移动到...'),
                  ),
                const PopupMenuItem(
                  value: _MediaAction.delete,
                  child: Text('删除'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessageTile(
    RoomChatMessageInfo message,
    ThemeData theme,
    bool isDark,
  ) {
    final scheme = theme.colorScheme;
    final title = message.username.isEmpty ? message.userId : message.username;
    final isMine =
        _currentUserId.isNotEmpty && message.userId == _currentUserId;
    final receipt = _chatReceiptCache[message.id];
    final isReceiptLoading = _chatReceiptLoadingIds.contains(message.id);
    final bubbleColor = isMine
        ? scheme.primary.withValues(alpha: 0.12)
        : scheme.surfaceContainerHighest
            .withValues(alpha: isDark ? 0.54 : 0.72);
    final borderColor = isMine
        ? scheme.primary.withValues(alpha: 0.25)
        : scheme.outlineVariant.withValues(alpha: 0.55);
    final content = message.isDeleted
        ? '这条消息已删除'
        : message.content.trim().isEmpty && message.images.isNotEmpty
            ? '图片消息'
            : message.content;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine) ...[
            AppAvatar(name: title, radius: 17),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isMine
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimestamp(message.timestamp),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                      if (message.isEdited && !message.isDeleted) ...[
                        const SizedBox(width: 6),
                        Text(
                          '已编辑',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                scheme.onSurfaceVariant.withValues(alpha: 0.64),
                          ),
                        ),
                      ],
                      if (message.isPinned && !message.isDeleted) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.push_pin,
                          size: 13,
                          color: scheme.primary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppPanelSurface(
                    color: bubbleColor,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(8),
                      topRight: const Radius.circular(8),
                      bottomLeft: Radius.circular(isMine ? 8 : 3),
                      bottomRight: Radius.circular(isMine ? 3 : 8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.replyToMessageId.isNotEmpty) ...[
                          _buildChatQuotePreview(message, theme),
                          const SizedBox(height: 7),
                        ],
                        if (content.isNotEmpty)
                          Text(
                            content,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.32,
                              color: message.isDeleted
                                  ? scheme.onSurfaceVariant
                                      .withValues(alpha: 0.72)
                                  : scheme.onSurface,
                              fontStyle: message.isDeleted
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                        if (message.images.isNotEmpty &&
                            !message.isDeleted) ...[
                          if (content.isNotEmpty) const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: message.images
                                .map((image) =>
                                    _buildChatImageThumb(image, theme))
                                .toList(),
                          ),
                        ],
                        if (message.reactions.isNotEmpty &&
                            !message.isDeleted) ...[
                          const SizedBox(height: 7),
                          _buildChatReactionSummaryRow(message, theme),
                        ],
                        if (message.position != null ||
                            (message.color?.isNotEmpty ?? false)) ...[
                          const SizedBox(height: 6),
                          Text(
                            [
                              if (message.position != null)
                                '${message.position!.toStringAsFixed(1)}s',
                              if (message.color?.isNotEmpty ?? false)
                                message.color!,
                            ].join(' · '),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isMine && !message.isDeleted)
                        _buildChatReadReceiptButton(
                          message,
                          receipt,
                          isReceiptLoading,
                          theme,
                        ),
                      _buildChatMessageActionButton(
                        tooltip: '查看上下文',
                        icon: Icons.forum_outlined,
                        onPressed: () => _showChatMessageContext(message),
                      ),
                      _buildChatMessageActionButton(
                        tooltip: '查看举报',
                        icon: Icons.report_gmailerrorred_outlined,
                        onPressed: () => _openRoomScopedReportsViewer(
                          title: '消息 #${message.id} 的举报',
                          targetType: 4,
                          targetChatMessageId: int.tryParse(message.id) ?? 0,
                        ),
                      ),
                      _buildChatMessageActionButton(
                        tooltip: message.isPinned ? '取消置顶' : '置顶',
                        icon: message.isPinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        onPressed: message.isDeleted
                            ? null
                            : () => _toggleChatPin(message),
                      ),
                      _buildChatMessageActionButton(
                        tooltip: '编辑',
                        icon: Icons.edit_outlined,
                        onPressed: message.isDeleted
                            ? null
                            : () => _editChatMessage(message),
                      ),
                      _buildChatMessageActionButton(
                        tooltip: '删除',
                        icon: Icons.delete_outline,
                        color: scheme.error,
                        onPressed: message.isDeleted
                            ? null
                            : () => _deleteChatMessage(message),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMine) ...[
            const SizedBox(width: 8),
            AppAvatar(name: title, radius: 17),
          ],
        ],
      ),
    );
  }

  Widget _buildChatQuotePreview(RoomChatMessageInfo message, ThemeData theme) {
    final scheme = theme.colorScheme;
    RoomChatMessageInfo? quoted;
    for (final item in _chatMessages) {
      if (item.id == message.replyToMessageId) {
        quoted = item;
        break;
      }
    }
    final title = quoted == null
        ? '引用消息'
        : (quoted.username.isEmpty ? quoted.userId : quoted.username);
    final preview = quoted == null
        ? '点击查看上下文'
        : quoted.isDeleted
            ? '这条消息已删除'
            : quoted.content.trim().isEmpty
                ? '图片消息'
                : quoted.content.trim();
    return AppInkSurface(
      onTap: () => _showChatMessageContext(message),
      borderRadius: BorderRadius.circular(7),
      color: scheme.surface.withValues(alpha: 0.62),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatReactionSummaryRow(
    RoomChatMessageInfo message,
    ThemeData theme,
  ) {
    final sorted = [...message.reactions]
      ..sort((a, b) => b.count.compareTo(a.count));
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: sorted.take(6).map((reaction) {
        return Tooltip(
          message: '查看回应成员',
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => _showChatReactionUsers(message, reaction),
            child: AppPanelSurface(
              color: theme.colorScheme.surface.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              child: Text(
                '${reaction.key} ${reaction.count}',
                style: theme.textTheme.labelSmall?.copyWith(height: 1.1),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showChatReactionUsers(
    RoomChatMessageInfo message,
    ChatReactionSummaryInfo reaction,
  ) async {
    if (message.id.isEmpty) return;
    await showAppDialog<void>(
      context: context,
      builder: (context) => ChatReactionUsersDialog(
        roomId: widget.roomId,
        messageId: message.id,
        reactionKey: reaction.key,
      ),
    );
  }

  Widget _buildChatReadReceiptButton(
    RoomChatMessageInfo message,
    ChatMessageReadReceiptsInfo? receipt,
    bool loading,
    ThemeData theme,
  ) {
    final mentionSummary =
        receipt == null ? null : _mentionReadReceiptSummary(message, receipt);
    final text = receipt == null
        ? '已读'
        : mentionSummary ??
            '已读 ${receipt.readerTotal} · 未读 ${receipt.unreadTotal}';
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 4),
      child: TextButton.icon(
        onPressed: loading ? null : () => _showChatReadReceipts(message),
        icon: loading
            ? const SizedBox(
                width: 12,
                height: 12,
                child: AppLoadingIndicator(
                  size: AppLoadingSize.sm,
                  centered: false,
                ),
              )
            : const Icon(Icons.visibility_outlined, size: 15),
        label: Text(text),
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          textStyle: theme.textTheme.labelSmall,
        ),
      ),
    );
  }

  String? _mentionReadReceiptSummary(
    RoomChatMessageInfo message,
    ChatMessageReadReceiptsInfo receipt,
  ) {
    final mentionedUsers = _mentionedUsersForMessage(message, receipt);
    if (mentionedUsers.isEmpty) return null;
    final mentionedIds = mentionedUsers.map((user) => user.id).toSet();
    final readCount = receipt.readers
        .where((reader) => mentionedIds.contains(reader.user.id))
        .length;
    final unreadCount = receipt.unreadMembers
        .where((user) => mentionedIds.contains(user.id))
        .length;
    if (readCount == 0 && unreadCount == 0) return '@ 已读';
    if (mentionedUsers.length == 1) {
      return unreadCount == 0 ? '@ 已读' : '@ 未读';
    }
    return '@ $readCount 已读 · $unreadCount 未读';
  }

  List<SyncTvUser> _mentionedUsersForMessage(
    RoomChatMessageInfo message,
    ChatMessageReadReceiptsInfo? receipt,
  ) {
    if (message.mentions.isEmpty) return const [];
    final mentionedIds =
        message.mentions.map((mention) => mention.userId).toSet();
    final users = <String, SyncTvUser>{};
    for (final mention in message.mentions) {
      if (mention.userId.isEmpty || mention.username.trim().isEmpty) continue;
      users[mention.userId] = SyncTvUser(
        id: mention.userId,
        username: mention.username,
        role: 0,
      );
    }
    if (receipt != null) {
      for (final reader in receipt.readers) {
        users[reader.user.id] = reader.user;
      }
      for (final user in receipt.unreadMembers) {
        users[user.id] = user;
      }
    } else {
      for (final member in _members) {
        users[member.userId] = SyncTvUser(
          id: member.userId,
          username: member.username,
          role: member.role,
          onlineCount: member.isOnline ? 1 : 0,
          connectionCount: member.connectionCount,
        );
      }
    }
    return mentionedIds
        .map((id) => users[id])
        .whereType<SyncTvUser>()
        .where((user) => user.username.trim().isNotEmpty)
        .toList();
  }

  Future<void> _showChatReadReceipts(RoomChatMessageInfo message) async {
    ChatMessageReadReceiptsInfo? receipt = _chatReceiptCache[message.id];
    if (receipt == null) {
      setState(() => _chatReceiptLoadingIds.add(message.id));
      try {
        final loaded = await SyncTvService.getChatMessageReadReceipts(
          widget.roomId,
          message.id,
        );
        if (!mounted) return;
        setState(() {
          _chatReceiptCache[message.id] = loaded;
        });
        receipt = loaded;
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '加载已读详情失败: $e');
        return;
      } finally {
        if (mounted) {
          setState(() => _chatReceiptLoadingIds.remove(message.id));
        }
      }
    }
    final visibleReceipt = receipt;
    if (!mounted) return;
    await showAppDialog<void>(
      context: context,
      builder: (context) => ChatReadReceiptsDialog(receipts: visibleReceipt),
    );
  }

  Widget _buildChatMessageActionButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return AppIconButton(
      iconSize: 18,
      size: AppIconButtonSize.sm,
      onPressed: onPressed,
      icon: icon,
      tooltip: tooltip,
      style: color == null
          ? AppIconButtonStyle.ghost
          : AppIconButtonStyle.destructive,
    );
  }

  Widget _buildChatImageThumb(StoredImageInfo image, ThemeData theme) {
    final resolved = SyncTvService.resolveResourceUrl(image.url);
    return AppImageThumbnail(
      url: resolved,
      width: 160,
      height: 104,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildCoverPreview({
    required String url,
    required IconData fallbackIcon,
    double width = double.infinity,
    required double height,
    double borderRadius = 8,
  }) {
    final theme = Theme.of(context);
    final resolved = SyncTvService.resolveResourceUrl(url);
    if (resolved.isEmpty) {
      return AppPanelSurface(
        width: width,
        height: height,
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Icon(
          fallbackIcon,
          color: theme.colorScheme.onSurfaceVariant,
          size: height >= 120 ? 42 : 24,
        ),
      );
    }
    return AppImageThumbnail(
      url: resolved,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(borderRadius),
      errorIcon: fallbackIcon,
    );
  }

  Widget _buildIceServerTile(
    IceServerInfo server,
    ThemeData theme,
    bool isDark,
  ) {
    return _buildManagementTileSurface(
      theme,
      isDark,
      child: Row(
        children: [
          const Icon(Icons.hub),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  server.urls.join(', '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  server.username.isEmpty ? '匿名' : server.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _mediaSubtitle(SyncTvMovie entry) {
    if (entry.id.startsWith('pl_')) {
      final mode = entry.metadata['isDynamic'] == true ? '动态播放列表' : '播放列表';
      return '$mode · ${entry.sourceProvider.isEmpty ? 'static' : entry.sourceProvider}';
    }
    if (entry.id.startsWith('med_')) {
      return '${entry.sourceProvider} · ${entry.providerInstanceName.isEmpty ? 'default' : entry.providerInstanceName}';
    }
    final size = entry.metadata['size'];
    return entry.isFolder
        ? '动态目录'
        : '动态媒体${size is int && size > 0 ? ' · $size bytes' : ''}';
  }

  String _compactMap(Map<String, dynamic> value) {
    final entries = value.entries
        .where(
            (entry) => entry.value != null && entry.value.toString().isNotEmpty)
        .take(6)
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
    if (entries.isEmpty) return '-';
    return value.length > 6 ? '$entries\n…' : entries;
  }

  String _mediaScopeLabel(RoomMediaLibraryPage? page) {
    if (_mediaTarget.isNotEmpty) {
      final path = page?.currentPath.map((node) => node.name).join(' / ') ?? '';
      return path.isEmpty ? '动态目录' : path;
    }
    if (_mediaPlaylistStack.isEmpty) return '根目录';
    final path = page?.currentPath.map((node) => node.name).join(' / ') ?? '';
    return path.isEmpty ? _currentPlaylistId : path;
  }

  Widget _buildMemberTile(
    AdminRoomMember member,
    ThemeData theme,
    bool isDark,
  ) {
    final isCreator = member.role ==
        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR.value;
    final isCurrentUser =
        _currentUserId.isNotEmpty && member.userId == _currentUserId;
    final canManageMember = !isCreator && !isCurrentUser;
    final connectionText =
        member.connectionCount > 0 ? '${member.connectionCount} 个连接' : '0 个连接';
    final presenceColor =
        member.isOnline ? const Color(0xFF16A34A) : theme.hintColor;
    final displayName =
        member.username.isEmpty ? member.userId : member.username;
    return _buildManagementTileSurface(
      theme,
      isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(
                name: displayName,
                radius: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (isCurrentUser)
                          _buildMemberBadge(
                            label: '我',
                            icon: Icons.person_outline_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        if (isCreator)
                          _buildMemberBadge(
                            label: '房主',
                            icon: Icons.star_rounded,
                            color: const Color(0xFFF59E0B),
                          )
                        else
                          _buildMemberBadge(
                            label: _roleLabel(member.role),
                            icon: Icons.badge_outlined,
                            color: theme.colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildMemberBadge(
                          label: member.isOnline ? '在线' : '离线',
                          icon: Icons.circle,
                          color: presenceColor,
                        ),
                        _buildMemberBadge(
                          label: connectionText,
                          icon: Icons.hub_outlined,
                          color: theme.colorScheme.secondary,
                        ),
                        _buildMemberBadge(
                          label: '加入 ${_formatTimestamp(member.joinedAt)}',
                          icon: Icons.schedule_rounded,
                          color: theme.hintColor,
                        ),
                      ],
                    ),
                    if (member.userId.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        member.userId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: theme.hintColor, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (canManageMember) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppIconButton(
                  tooltip: '修改角色',
                  icon: Icons.admin_panel_settings_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.tonal,
                  onPressed: () => _setMemberRole(member),
                ),
                AppIconButton(
                  tooltip: '权限覆盖',
                  icon: Icons.rule_rounded,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _editMemberPermissionOverrides(member),
                ),
                AppIconButton(
                  tooltip: '转让房主',
                  icon: Icons.verified_user_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _transferOwnership(member),
                ),
                AppIconButton(
                  tooltip: '移出房间',
                  icon: Icons.person_remove_alt_1_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.destructive,
                  onPressed: () => _kickMember(member),
                ),
                AppIconButton(
                  tooltip: '查看成员举报',
                  icon: Icons.report_gmailerrorred_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _openRoomScopedReportsViewer(
                    title:
                        '${member.username.isEmpty ? member.userId : member.username} 的成员举报',
                    targetType: 3,
                    targetMemberUserId: member.userId,
                  ),
                ),
                AppIconButton(
                  tooltip: '举报成员',
                  icon: Icons.flag_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _reportRoomMember(member),
                ),
                AppIconButton(
                  tooltip: '举报用户',
                  icon: Icons.person_off_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _reportUser(member),
                ),
                AppPopupMenuButton<_MemberAction>(
                  tooltip: '更多成员操作',
                  onSelected: (action) {
                    switch (action) {
                      case _MemberAction.role:
                        _setMemberRole(member);
                      case _MemberAction.permissions:
                        _editMemberPermissionOverrides(member);
                      case _MemberAction.transfer:
                        _transferOwnership(member);
                      case _MemberAction.kick:
                        _kickMember(member);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _MemberAction.role,
                      child: Text('修改角色'),
                    ),
                    PopupMenuItem(
                      value: _MemberAction.permissions,
                      child: Text('权限覆盖'),
                    ),
                    PopupMenuItem(
                      value: _MemberAction.transfer,
                      child: Text('转让房主'),
                    ),
                    PopupMenuItem(
                      value: _MemberAction.kick,
                      child: Text('移出房间'),
                    ),
                  ],
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isCurrentUser ? '当前账号' : '房主账号',
                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                  ),
                ),
                AppIconButton(
                  tooltip: '查看成员举报',
                  icon: Icons.report_gmailerrorred_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _openRoomScopedReportsViewer(
                    title:
                        '${member.username.isEmpty ? member.userId : member.username} 的成员举报',
                    targetType: 3,
                    targetMemberUserId: member.userId,
                  ),
                ),
                const SizedBox(width: 6),
                AppIconButton(
                  tooltip: '举报成员',
                  icon: Icons.flag_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _reportRoomMember(member),
                ),
                const SizedBox(width: 6),
                AppIconButton(
                  tooltip: '举报用户',
                  icon: Icons.person_off_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _reportUser(member),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberBadge({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return AppBadge(
      icon: icon,
      iconSize: icon == Icons.circle ? 8 : 13,
      color: color,
      backgroundColor: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(999),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      textStyle: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRoomInfoTab(ThemeData theme, bool isDark) {
    final room = _roomInfo;
    final roomName = room?.roomName ?? widget.roomName;
    final creatorId = (room?.creatorId ?? widget.creatorId).trim();
    final creatorName = (room?.creator ?? '').trim().isEmpty
        ? (creatorId.isEmpty ? '创建者' : creatorId)
        : room!.creator.trim();
    final creatorAvatarUrl =
        SyncTvService.resolveResourceUrl(room?.creatorAvatarUrl ?? '');
    return AppListView(
      padding: const EdgeInsets.only(bottom: 32, top: 8),
      children: [
        _buildSectionHeader('房间信息', theme),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: AppInkSurface(
            color: isDark ? const Color(0xFF1E1E24) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
            ),
            child: Column(
              children: [
                _buildCoverPreview(
                  url: _roomCoverUrl,
                  fallbackIcon: Icons.meeting_room_outlined,
                  height: 148,
                  borderRadius: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roomName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.roomId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppActionButton(
                        onPressed: _loadRoomInfo,
                        icon: Icons.refresh_rounded,
                        label: '刷新',
                        style: AppActionButtonStyle.text,
                      ),
                      const SizedBox(width: 8),
                      AppActionButton(
                        onPressed: _coverUpdating ? null : _updateRoomCover,
                        loading: _coverUpdating,
                        icon: Icons.image_outlined,
                        label: '封面',
                        style: AppActionButtonStyle.tonal,
                      ),
                      if (_roomCoverUrl.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        AppIconButton(
                          tooltip: '移除封面',
                          onPressed: _coverUpdating ? null : _clearRoomCover,
                          icon: Icons.delete_outline_rounded,
                          style: AppIconButtonStyle.destructive,
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Column(
                    children: [
                      if ((room?.description ?? '').trim().isNotEmpty)
                        _buildDetailLine('简介', room!.description.trim()),
                      _buildDetailLine(
                        '创建时间',
                        _formatTimestamp(room?.createdAt ?? 0),
                      ),
                      _buildDetailLine(
                        '更新时间',
                        _formatTimestamp(room?.updatedAt ?? 0),
                      ),
                      _buildDetailLine(
                        '成员',
                        '${room?.viewerCount ?? 0} 在线 / ${room?.memberCount ?? 0} 成员',
                      ),
                      _buildDetailLine(
                        '密码',
                        _settings.requirePassword ? '已设置' : '未设置',
                      ),
                    ],
                  ),
                ),
                _buildDivider(theme),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      AppAvatar(
                        name: creatorName,
                        imageUrl:
                            creatorAvatarUrl.isEmpty ? null : creatorAvatarUrl,
                        radius: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creatorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              creatorId.isEmpty ? '创建者' : creatorId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildSectionHeader('房间密码', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: AppTextField(
                controller: _passwordController,
                label: '新密码',
                helperText: '留空提交会移除房间密码',
                obscureText: true,
                onChanged: (_) => setState(() {}),
                suffix: AppIconButton(
                  tooltip: '清空',
                  icon: Icons.clear,
                  iconSize: 18,
                  size: AppIconButtonSize.sm,
                  onPressed: () {
                    _passwordController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
            _buildDivider(theme),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _settings.requirePassword ? '当前房间需要密码' : '当前房间无需密码',
                      style: TextStyle(color: theme.hintColor, fontSize: 13),
                    ),
                  ),
                  AppActionButton(
                    onPressed:
                        _canSubmitPasswordChange ? _updateRoomPassword : null,
                    loading: _passwordUpdating,
                    icon: Icons.password_rounded,
                    label: _passwordActionLabel,
                    style: AppActionButtonStyle.tonal,
                  ),
                ],
              ),
            ),
          ],
        ),
        _buildSectionHeader('房间操作', theme),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: AppInkSurface(
            color: isDark ? const Color(0xFF1E1E24) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
            ),
            child: Column(
              children: [
                if (_canLeaveRoom) ...[
                  AppTile(
                    prefix: const Icon(Icons.logout),
                    title: const Text('退出房间'),
                    subtitle: const Text('退出后需要重新加入才能访问成员内容'),
                    onPressed: _leaveRoom,
                  ),
                  _buildDivider(theme),
                ],
                AppTile(
                  prefix: Icon(Icons.delete_forever_rounded,
                      color: theme.colorScheme.error),
                  title: Text(
                    '删除房间',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onPressed: _deleteRoom,
                  destructive: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _streamSubtitle(RoomStreamEntryInfo stream) {
    if (!stream.active) return '未活跃';
    final publisher =
        stream.publisherUserId.isEmpty ? '未知发布者' : stream.publisherUserId;
    return '$publisher · ${_formatTimestamp(stream.startedAt)}';
  }

  String _roleLabel(int role) {
    return switch (role) {
      1 => '创建者',
      2 => '管理员',
      3 => '成员',
      4 => '访客',
      _ => '未指定',
    };
  }

  String _reviewStatusLabel(int status) {
    return switch (status) {
      1 => '待审核',
      2 => '已通过',
      3 => '已拒绝',
      _ => '未指定',
    };
  }

  String _formatTimestamp(int timestamp) {
    if (timestamp <= 0) return '时间未知';
    final normalized =
        timestamp > 100000000000 ? (timestamp / 1000).round() : timestamp;
    final time = DateTime.fromMillisecondsSinceEpoch(normalized * 1000);
    return '${time.year.toString().padLeft(4, '0')}-'
        '${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return '等待事件';
    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}:'
        '${value.second.toString().padLeft(2, '0')}';
  }

  String _debugValue(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Iterable) return value.join(', ');
    if (value is Map) return const JsonEncoder.withIndent('  ').convert(value);
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final systemUiOverlayStyle =
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: AppScaffold(
        backgroundColor:
            isDark ? const Color(0xFF121214) : const Color(0xFFF6F7FB),
        appBar: AppAppBar(
          title: Text(
            widget.roomName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor:
              isDark ? const Color(0xFF121214) : const Color(0xFFF6F7FB),
          centerTitle: true,
          systemOverlayStyle: systemUiOverlayStyle,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final useRail = constraints.maxWidth >= 900;
            if (!useRail) {
              return Column(
                children: [
                  _buildTopTabs(theme),
                  Expanded(child: _buildTabView(theme, isDark)),
                ],
              );
            }

            return Row(
              children: [
                _buildSideNavigation(theme, isDark),
                AppVerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.dividerColor.withValues(alpha: 0.55),
                ),
                Expanded(
                  child: AppPanelSurface(
                    color: isDark
                        ? const Color(0xFF151518)
                        : const Color(0xFFF3F5F8),
                    borderRadius: BorderRadius.zero,
                    clipBehavior: Clip.none,
                    child: _buildTabView(theme, isDark),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabView(ThemeData theme, bool isDark) {
    return AppTabBarView(
      controller: _tabController,
      children: _sections
          .map((section) => section.builder(theme, isDark))
          .toList(growable: false),
    );
  }

  Widget _buildTopTabs(ThemeData theme) {
    final compact = AppBreakpoints.widthOf(context) < 430;
    return AppInkSurface(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      clipBehavior: Clip.none,
      child: AppTabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
        labelPadding: EdgeInsets.symmetric(horizontal: compact ? 10 : 16),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: _sections
            .map((section) => Tab(
                  height: compact ? 44 : 64,
                  icon: compact ? null : Icon(section.icon),
                  child: compact
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(section.icon, size: 18),
                            const SizedBox(width: 6),
                            Text(section.label),
                          ],
                        )
                      : Text(section.label),
                ))
            .toList(growable: false),
      ),
    );
  }

  Widget _buildSideNavigation(ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return SizedBox(
          width: 224,
          child: AppInkSurface(
            color: isDark ? const Color(0xFF101012) : Colors.white,
            clipBehavior: Clip.none,
            child: AppSafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
                      child: Text(
                        '房间管理',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.68),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppListView.separated(
                        itemCount: _sections.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final section = _sections[index];
                          return _RoomSettingsNavTile(
                            icon: section.icon,
                            label: section.label,
                            selected: _tabController.index == index,
                            onTap: () => setState(() {
                              _tabController.animateTo(index);
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum _MemberAction { role, permissions, transfer, kick }

class _RoomSettingsNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoomSettingsNavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground =
        selected ? theme.colorScheme.primary : theme.colorScheme.onSurface;
    return AppInkSurface(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: foreground,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _PermissionOverrideMode { inherit, allow, deny }

class _MemberPermissionOverrideResult {
  final int addedPermissions;
  final int removedPermissions;
  final int adminAddedPermissions;
  final int adminRemovedPermissions;

  const _MemberPermissionOverrideResult({
    required this.addedPermissions,
    required this.removedPermissions,
    required this.adminAddedPermissions,
    required this.adminRemovedPermissions,
  });
}

class _ChatMessageEditForm extends StatefulWidget {
  final String initialContent;

  const _ChatMessageEditForm({required this.initialContent});

  @override
  State<_ChatMessageEditForm> createState() => _ChatMessageEditFormState();
}

class _ChatMessageEditFormState extends State<_ChatMessageEditForm> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: _controller,
          label: '消息内容',
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ChatUtils.createCancelButton(context),
            const SizedBox(width: 8),
            ChatUtils.createConfirmButton(
              context,
              _submit,
              text: '保存',
            ),
          ],
        ),
      ],
    );
  }
}

enum _MediaAction {
  details,
  open,
  rename,
  updateCover,
  clearCover,
  moveUp,
  moveDown,
  move,
  delete,
}

class _EntryEditResult {
  final String name;
  final String description;

  const _EntryEditResult(this.name, this.description);
}

class _MediaMoveTarget {
  final String playlistId;
  final String name;

  const _MediaMoveTarget(this.playlistId, this.name);
}

class _MemberEditResult {
  final String userId;
  final int role;
  final bool notify;

  const _MemberEditResult(this.userId, this.role, this.notify);
}
