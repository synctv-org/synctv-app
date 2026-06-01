import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/realtime_event_log.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/realtime_event_log_preferences.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/local_image_picker.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/ios_style_switch.dart';
import 'package:synctv_app/widgets/realtime_event_log_view.dart';

const Map<String, String> _mediaSourceLabels = {
  '': '全部来源',
  'direct_url': '直链',
  'bilibili': 'Bilibili',
  'alist': 'AList',
  'emby': 'Emby',
  'rtmp': 'RTMP',
};

const String _settingsObserveId = 'manage_room_settings';
const String _membersObserveId = 'manage_room_members';
const String _mediaObserveId = 'manage_playlist_items';
const Set<String> _managementObserveIds = {
  _settingsObserveId,
  _membersObserveId,
  _mediaObserveId,
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
  final WRoomSettings currentSettings;
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
  late WRoomSettings _settings;

  final List<RoomStreamEntryInfo> _streams = [];
  final List<RoomJoinReviewInfo> _reviews = [];
  final List<AdminRoomMember> _members = [];
  final List<RoomChatMessageInfo> _chatMessages = [];
  final List<IceServerInfo> _iceServers = [];
  final List<RealtimeEventLogEntry> _realtimeEvents = [];
  final List<String> _mediaPlaylistStack = [];
  final List<String> _mediaTargetStack = [];
  StreamSubscription<RoomRealtimeMessage>? _realtimeMessageSubscription;
  StreamSubscription<RealtimeEventLogEntry>? _realtimeEventSubscription;
  StreamSubscription<void>? _realtimeReconnectSubscription;
  RoomMediaLibraryPage? _mediaPage;
  final _RealtimeWatchStats _settingsWatchStats = _RealtimeWatchStats();
  final _RealtimeWatchStats _membersWatchStats = _RealtimeWatchStats();
  final _RealtimeWatchStats _mediaWatchStats = _RealtimeWatchStats();
  String _chatCursor = '';
  String _settingsWatchVersion = '';
  String _membersWatchVersion = '';
  String _mediaWatchVersion = '';
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
  common_enum.RoomMemberRole? _memberRoleFilter;
  client_enum.RoomMemberListSortBy _memberSortBy =
      client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT;
  client_enum.SortDirection _memberSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_DESC;
  common_enum.ReviewStatus _reviewStatusFilter =
      common_enum.ReviewStatus.REVIEW_STATUS_PENDING;
  _RealtimeDiagnosticsPane _realtimePane = _RealtimeDiagnosticsPane.overview;

  bool _updatePassword = false;
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
  bool _iceLoading = false;
  bool _coverUpdating = false;
  ChatReadStateInfo? _chatReadState;
  late String _currentUserId;
  WRoom? _roomInfo;

  String get _roomCoverUrl => _roomInfo?.coverUrl ?? '';

  bool get _canLeaveRoom =>
      _currentUserId.isNotEmpty &&
      (widget.creatorId.isEmpty || _currentUserId != widget.creatorId);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _settings = widget.currentSettings;
    _currentUserId = widget.currentUserId;
    _passwordController = TextEditingController();
    _maxMembersController = TextEditingController();
    _streamSearchController = TextEditingController();
    _memberSearchController = TextEditingController();
    _reviewUserController = TextEditingController();
    _mediaSearchController = TextEditingController();
    RealtimeEventLogPreferences.maxEntries.addListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    RealtimeEventLogPreferences.load().then((_) {
      if (mounted) _handleRealtimeLogMaxEntriesChanged();
    });
    _applySettings(_settings);
    _loadStreams();
    _loadReviews();
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
    _sendRealtime(RoomRealtimeCodec.encodeUnobserveResource(_mediaObserveId));
    _realtimeMessageSubscription?.cancel();
    _realtimeEventSubscription?.cancel();
    _realtimeReconnectSubscription?.cancel();
    _tabController.dispose();
    _passwordController.dispose();
    _maxMembersController.dispose();
    _streamSearchController.dispose();
    _memberSearchController.dispose();
    _reviewUserController.dispose();
    _mediaSearchController.dispose();
    super.dispose();
  }

  void _applySettings(WRoomSettings settings) {
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
  }

  Future<void> _loadCurrentUserIfNeeded() async {
    if (_currentUserId.isNotEmpty) return;
    try {
      final user = await WatchTogetherService.getMe();
      if (!mounted) return;
      setState(() => _currentUserId = user.id);
    } catch (e) {
      debugPrint('Load room settings current user failed: $e');
    }
  }

  Future<void> _loadRoomInfo() async {
    try {
      final room = await WatchTogetherService.getRoomInfo(widget.roomId);
      if (!mounted) return;
      setState(() => _roomInfo = room);
    } catch (e) {
      debugPrint('Load room info failed: $e');
    }
  }

  Future<void> _updateRoomCover() async {
    if (_coverUpdating) return;
    try {
      final image = await pickLocalImageUpload();
      if (image == null || !mounted) return;
      setState(() => _coverUpdating = true);
      final room = await WatchTogetherService.updateRoomCover(
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
      final room = await WatchTogetherService.clearRoomCover(widget.roomId);
      if (!mounted) return;
      setState(() => _roomInfo = room);
      MessageUtils.showSuccess(context, '房间封面已移除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移除房间封面失败: $e');
    } finally {
      if (mounted) setState(() => _coverUpdating = false);
    }
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

  void _sendRealtime(List<int> bytes) {
    if (bytes.isEmpty) return;
    widget.realtime.send(bytes);
  }

  void _handleRealtimeEvent(RealtimeEventLogEntry entry) {
    final payload = entry.payload;
    final observeId =
        payload is Map ? payload['observe_id']?.toString() ?? '' : '';
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
      case _mediaObserveId:
        _handleRealtimeMediaMessage(message);
        break;
    }
  }

  void _handleRealtimeSettingsMessage(RoomRealtimeMessage message) {
    if (message.kind == RoomRealtimeMessageKind.checkStatus) {
      _handleSettingsWatchEvent(
        RoomResourceWatchEvent<WRoomSettings>.observed(
          version: message.resourceVersion,
          changed: message.resourceChanged,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.roomSettings) {
      _handleSettingsWatchEvent(
        RoomResourceWatchEvent<WRoomSettings>.changed(
          version: message.resourceVersion,
          snapshot: message.roomSettings,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.error) {
      _handleSettingsWatchEvent(
        RoomResourceWatchEvent<WRoomSettings>.error(
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
          changed: message.resourceChanged,
        ),
      );
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.viewerCount) {
      _handleMembersWatchEvent(
        RoomResourceWatchEvent<List<AdminRoomMember>>.changed(
          version: message.resourceVersion,
          snapshot: message.adminMembers,
        ),
        total: message.resourceTotal,
      );
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

  void _handleRealtimeMediaMessage(RoomRealtimeMessage message) {
    if (message.kind == RoomRealtimeMessageKind.checkStatus) {
      _handleMediaWatchEvent(
        RoomResourceWatchEvent<RoomMediaLibraryPage>.observed(
          version: message.resourceVersion,
          changed: message.resourceChanged,
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

  void _handleSettingsWatchEvent(
    RoomResourceWatchEvent<WRoomSettings> event,
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
          MessageUtils.showError(context, '成员列表快照为空');
          return;
        }
        setState(() {
          _members
            ..clear()
            ..addAll(snapshot);
          _membersTotal = total ?? snapshot.length;
        });
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '成员监听失败' : event.errorMessage,
        );
        break;
    }
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
      if (_updatePassword) {
        await WatchTogetherService.updateRoomPassword(
          widget.roomId,
          _passwordController.text,
        );
      }

      final settings = WRoomSettings(
        requirePassword: _updatePassword
            ? _passwordController.text.isNotEmpty
            : _settings.requirePassword,
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

      await WatchTogetherService.updateRoomSettings(
        widget.roomId,
        settings,
      );
      final freshSettings =
          await WatchTogetherService.getRoomSettings(widget.roomId);
      if (!mounted) return;
      setState(() {
        _settings = freshSettings;
        _updatePassword = false;
        _passwordController.clear();
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
      final page = await WatchTogetherService.listRoomStreamsPage(
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
    setState(() => _reviewsLoading = true);
    try {
      final page = await WatchTogetherService.listRoomJoinReviewsPage(
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
      final page = await WatchTogetherService.getRoomMemberDetailsPage(
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
        _membersWatchVersion = page.version;
      });
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
      final page = await WatchTogetherService.listMediaLibrary(
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
      _settingsWatchStats.reset();
      _membersWatchStats.reset();
      _mediaWatchStats.reset();
      _realtimeEvents.clear();
    });
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
      final instances =
          await WatchTogetherService.listAvailableProviderInstances(
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
    if (loadMore && _chatCursor.isEmpty) return;
    setState(() => _chatLoading = true);
    try {
      final page = await WatchTogetherService.getChatHistory(
        widget.roomId,
        cursor: loadMore ? _chatCursor : '',
      );
      ChatReadStateInfo? readState;
      if (!loadMore && page.messages.isNotEmpty) {
        try {
          readState = await WatchTogetherService.markChatRead(
            widget.roomId,
            page.messages.first.id,
          );
        } catch (e) {
          debugPrint('Mark chat read failed: $e');
          try {
            readState = await WatchTogetherService.getChatReadState(
              widget.roomId,
            );
          } catch (_) {}
        }
      }
      if (!mounted) return;
      setState(() {
        if (!loadMore) _chatMessages.clear();
        _chatMessages.addAll(page.messages);
        _chatCursor = page.nextCursor;
        if (readState != null) _chatReadState = readState;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载聊天历史失败: $e');
    } finally {
      if (mounted) setState(() => _chatLoading = false);
    }
  }

  Future<void> _loadIceServers() async {
    if (!mounted) return;
    setState(() => _iceLoading = true);
    try {
      final servers = await WatchTogetherService.getIceServers(widget.roomId);
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

  Future<void> _openMediaEntry(WMovie entry) async {
    if (!entry.isFolder) return;
    final isPersistedPlaylist = entry.id.startsWith('pl_');
    final target = isPersistedPlaylist ? '' : entry.playbackWatchTarget ?? '';
    if (!isPersistedPlaylist && target.isEmpty) return;
    setState(() {
      if (isPersistedPlaylist) {
        _mediaPlaylistStack.add(entry.id);
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
      await WatchTogetherService.kickRoomStream(
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
      final detail = await WatchTogetherService.getRoomStreamInfo(
        widget.roomId,
        stream.mediaId,
      );
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final theme = Theme.of(context);
          return SafeArea(
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
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: detail.mediaId),
                          );
                          Navigator.pop(context);
                          MessageUtils.showSuccess(context, '媒体 ID 已复制');
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('复制 ID'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonalIcon(
                        onPressed: detail.active
                            ? () {
                                Navigator.pop(context);
                                _kickStream(detail);
                              }
                            : null,
                        icon: const Icon(Icons.link_off),
                        label: const Text('断开推流'),
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
      await WatchTogetherService.approveRoomJoinReview(
          widget.roomId, review.id);
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
      await WatchTogetherService.rejectRoomJoinReview(
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
      await WatchTogetherService.addRoomMember(
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
      await WatchTogetherService.setRoomMemberRole(
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
      await WatchTogetherService.updateRoomMemberPermissionOverrides(
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
      await WatchTogetherService.transferRoomOwnership(
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
    final confirmed = await _confirm(
      title: '移出成员',
      content: '确认将 ${member.username} 移出房间？',
      action: '移出',
    );
    if (!confirmed) return;
    try {
      await WatchTogetherService.kickMember(widget.roomId, member.userId);
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员已移出');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移出成员失败: $e');
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await _confirm(
      title: '重置设置',
      content: '确认将访问控制、消息开关、成员权限和访客权限恢复为服务端默认策略？当前未保存的房间策略会被覆盖。',
      action: '重置',
    );
    if (!confirmed) return;
    try {
      await WatchTogetherService.resetRoomSettings(widget.roomId);
      final settings = await WatchTogetherService.getRoomSettings(
        widget.roomId,
        refresh: true,
      );
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _updatePassword = false;
        _passwordController.clear();
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
      await WatchTogetherService.leaveRoom(widget.roomId);
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
      await WatchTogetherService.deleteRoom(widget.roomId);
      if (!mounted) return;
      Navigator.pop(context, true);
      MessageUtils.showSuccess(context, '房间已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除房间失败: $e');
    }
  }

  Future<void> _createPlaylist() async {
    if (_mediaTarget.isNotEmpty) {
      MessageUtils.showInfo(context, '动态目录中不能创建本地播放列表');
      return;
    }
    final input = await _showEntryEditDialog(title: '新建播放列表');
    if (input == null || input.name.isEmpty) return;
    try {
      await WatchTogetherService.createPlaylist(
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

  Future<void> _clearCurrentMediaScope() async {
    if (_mediaTarget.isNotEmpty) {
      MessageUtils.showInfo(context, '动态目录内容不能在房间内清空');
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
      await WatchTogetherService.clearMovies(
        widget.roomId,
        parentId: playlistId.isEmpty ? null : playlistId,
      );
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '媒体库已清空');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '清空失败: $e');
    }
  }

  Future<void> _renameEntry(WMovie entry) async {
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
        await WatchTogetherService.updatePlaylist(
          widget.roomId,
          entry.id,
          name: input.name,
          description: input.description,
        );
      } else if (entry.id.startsWith('med_')) {
        await WatchTogetherService.editMedia(
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

  Future<void> _deleteEntry(WMovie entry) async {
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
        await WatchTogetherService.deletePlaylist(
          widget.roomId,
          entry.id,
          force: true,
        );
      } else if (entry.id.startsWith('med_')) {
        await WatchTogetherService.deleteMovie(widget.roomId, entry.id);
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '条目已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除失败: $e');
    }
  }

  Future<void> _showMediaEntryDetails(WMovie entry) async {
    try {
      var detail = entry;
      PlaylistDetailInfo? playlistDetail;
      if (entry.id.startsWith('pl_')) {
        playlistDetail = await WatchTogetherService.getPlaylist(
          widget.roomId,
          entry.id,
        );
        detail = playlistDetail.playlist;
      } else if (entry.id.startsWith('med_')) {
        detail = await WatchTogetherService.getMedia(widget.roomId, entry.id);
      }
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final theme = Theme.of(context);
          final isPlaylist = detail.id.startsWith('pl_');
          final isPersisted =
              detail.id.startsWith('pl_') || detail.id.startsWith('med_');
          return SafeArea(
            child: SingleChildScrollView(
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
                          ? detail.metadata['is_dynamic'] == true
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
                        TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: detail.id));
                            Navigator.pop(context);
                            MessageUtils.showSuccess(context, 'ID 已复制');
                          },
                          icon: const Icon(Icons.copy_rounded),
                          label: const Text('复制 ID'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.tonalIcon(
                          onPressed: isPersisted
                              ? () {
                                  Navigator.pop(context);
                                  _renameEntry(detail);
                                }
                              : null,
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('编辑'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.tonalIcon(
                          onPressed: isPersisted
                              ? () {
                                  Navigator.pop(context);
                                  _updateEntryCover(detail);
                                }
                              : null,
                          icon: const Icon(Icons.image_outlined),
                          label: const Text('封面'),
                        ),
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

  Future<void> _updateEntryCover(WMovie entry) async {
    if (!entry.id.startsWith('pl_') && !entry.id.startsWith('med_')) return;
    try {
      final image = await pickLocalImageUpload();
      if (image == null || !mounted) return;
      if (entry.id.startsWith('pl_')) {
        await WatchTogetherService.updatePlaylistCover(
          widget.roomId,
          entry.id,
          image.upload,
        );
      } else {
        await WatchTogetherService.updateVideoCover(
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

  Future<void> _clearEntryCover(WMovie entry) async {
    if (!entry.id.startsWith('pl_') && !entry.id.startsWith('med_')) return;
    try {
      if (entry.id.startsWith('pl_')) {
        await WatchTogetherService.clearPlaylistCover(widget.roomId, entry.id);
      } else {
        await WatchTogetherService.clearVideoCover(widget.roomId, entry.id);
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
    final controller = TextEditingController(text: message.content);
    final content = await _showChatMessageEditDialog(controller);
    if (content == null || content == message.content) return;
    try {
      await WatchTogetherService.editChatMessage(
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

  Future<String?> _showChatMessageEditDialog(
    TextEditingController controller,
  ) {
    return ChatUtils.showStyledDialog<String>(
      context: context,
      title: '编辑消息',
      icon: const Icon(Icons.edit_outlined),
      content: TextField(
        controller: controller,
        autofocus: true,
        minLines: 2,
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: '消息内容',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, controller.text.trim()),
          text: '保存',
        ),
      ],
    ).whenComplete(() => _disposeTextControllersAfterDialog([controller]));
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
      await WatchTogetherService.deleteChatMessage(
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

  Future<void> _showChatMessageContext(RoomChatMessageInfo message) async {
    try {
      final contextInfo = await WatchTogetherService.getChatMessageContext(
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
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          return SafeArea(
            child: ListView(
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

  Future<void> _moveMedia(WMovie entry) async {
    if (!entry.id.startsWith('med_')) return;
    final target = await _showMoveMediaTargetDialog(entry);
    if (target == null) return;
    final targetPlaylistId = target.playlistId;
    final sourcePlaylistId =
        _currentPlaylistId.isEmpty ? null : _currentPlaylistId;
    if ((sourcePlaylistId ?? '') == targetPlaylistId) return;
    try {
      final count = await WatchTogetherService.moveMedia(
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

  Future<void> _movePlaylistRelative(WMovie entry, int direction) async {
    if (!entry.id.startsWith('pl_')) return;
    final playlists = _mediaPage?.playlists ?? const <WMovie>[];
    final index = playlists.indexWhere((item) => item.id == entry.id);
    if (index < 0) return;
    final isUp = direction < 0;
    if (isUp && index == 0) return;
    if (!isUp && index >= playlists.length - 1) return;

    try {
      if (isUp) {
        await WatchTogetherService.movePlaylist(
          widget.roomId,
          entry.id,
          beforePlaylistId: playlists[index - 1].id,
        );
      } else {
        await WatchTogetherService.movePlaylist(
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

  Future<_MediaMoveTarget?> _showMoveMediaTargetDialog(WMovie entry) async {
    var loading = true;
    var error = '';
    var playlists = <WMovie>[];

    Future<void> loadPlaylists(StateSetter setDialogState) async {
      setDialogState(() {
        loading = true;
        error = '';
      });
      try {
        final page = await WatchTogetherService.listPlaylistsPage(
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

    return showDialog<_MediaMoveTarget>(
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

            return AlertDialog(
              title: const Text('移动媒体'),
              content: SizedBox(
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
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('根目录'),
                      enabled: _currentPlaylistId.isNotEmpty,
                      onTap: _currentPlaylistId.isEmpty
                          ? null
                          : () => Navigator.pop(
                                context,
                                const _MediaMoveTarget('', '根目录'),
                              ),
                    ),
                    if (loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlists.length,
                          itemBuilder: (context, index) {
                            final playlist = playlists[index];
                            return ListTile(
                              leading: const Icon(Icons.folder_outlined),
                              title: Text(
                                playlist.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: playlist.parentId == null
                                  ? null
                                  : Text('上级 ${playlist.parentId}'),
                              onTap: () => Navigator.pop(
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
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton.icon(
                  onPressed:
                      loading ? null : () => loadPlaylists(setDialogState),
                  icon: const Icon(Icons.refresh),
                  label: const Text('刷新'),
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
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: '原因',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        FilledButton.tonalIcon(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          icon: const Icon(Icons.block_rounded),
          label: const Text('拒绝'),
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
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '名称',
                border: OutlineInputBorder(),
              ),
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
            TextField(
              controller: descriptionController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '描述',
                border: OutlineInputBorder(),
              ),
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
              TextField(
                controller: userIdController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '用户 ID',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: role,
                decoration: const InputDecoration(
                  labelText: '角色',
                  prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 2, child: Text('管理员')),
                  DropdownMenuItem(value: 3, child: Text('成员')),
                  DropdownMenuItem(value: 4, child: Text('访客')),
                ],
                onChanged: (value) {
                  if (value != null) setDialogState(() => role = value);
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          return DropdownButtonFormField<int>(
            initialValue: role,
            decoration: const InputDecoration(
              labelText: '角色',
              prefixIcon: Icon(Icons.admin_panel_settings_outlined),
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 2, child: Text('管理员')),
              DropdownMenuItem(value: 3, child: Text('成员')),
              DropdownMenuItem(value: 4, child: Text('访客')),
            ],
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

    return showDialog<_MemberPermissionOverrideResult>(
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

            return AlertDialog(
              title: const Text('权限覆盖'),
              content: SizedBox(
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
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      added = 0;
                      removed = 0;
                    });
                  },
                  child: const Text('清除覆盖'),
                ),
                FilledButton(
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
                  child: const Text('保存'),
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
          SegmentedButton<_PermissionOverrideMode>(
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
            selected: {mode},
            onSelectionChanged: (selection) {
              onChanged(flag, selection.single);
            },
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
        FilledButton.tonalIcon(
          onPressed: () => Navigator.pop(context, true),
          icon: Icon(destructive ? Icons.warning_amber_rounded : Icons.check),
          label: Text(action),
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
          IOSStyleSwitch(value: value, onChanged: onChanged, isDark: isDark),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: theme.dividerColor.withValues(alpha: 0.12),
    );
  }

  Widget _buildMaxMembersField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _maxMembersController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: '最大成员数',
          helperText: '0 表示不限制',
          labelStyle: TextStyle(color: theme.hintColor),
          helperStyle: TextStyle(color: theme.hintColor, fontSize: 11),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSettingsTab(ThemeData theme, bool isDark) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32, top: 8),
      children: [
        _buildSectionHeader('访问控制', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            InkWell(
              onTap: () => setState(() => _updatePassword = !_updatePassword),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '修改房间密码',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: _updatePassword,
                      onChanged: (v) =>
                          setState(() => _updatePassword = v ?? false),
                      activeColor: theme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            if (_updatePassword) ...[
              _buildDivider(theme),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '新密码',
                    helperText: '留空保存会移除房间密码',
                    labelStyle: TextStyle(color: theme.hintColor),
                    helperStyle:
                        TextStyle(color: theme.hintColor, fontSize: 11),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: _passwordController.clear,
                    ),
                  ),
                ),
              ),
            ],
            _buildDivider(theme),
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
        _buildSectionHeader('房间操作', theme),
        _buildRoomActions(theme, isDark),
      ],
    );
  }

  Widget _buildStreamsTab(ThemeData theme, bool isDark) {
    if (_streamsLoading && _streams.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _loadStreams,
      child: ListView(
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
                  child: TextField(
                    controller: _streamSearchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _streamSearchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _streamSearchController.clear();
                                setState(() => _streamsPage = 1);
                                _loadStreams();
                              },
                              icon: const Icon(Icons.close_rounded),
                              tooltip: '清除搜索',
                            ),
                      labelText: '媒体 ID',
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      setState(() => _streamsPage = 1);
                      _loadStreams();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
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
                  icon: Icon(
                    _streamSortDirection ==
                            client_enum.SortDirection.SORT_DIRECTION_ASC
                        ? Icons.north_rounded
                        : Icons.south_rounded,
                  ),
                  tooltip: _streamSortDirection ==
                          client_enum.SortDirection.SORT_DIRECTION_ASC
                      ? '媒体 ID 升序'
                      : '媒体 ID 降序',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Text(
                  '第 $_streamsPage 页 · 每页 $_streamsPageSize · 共 $_streamsTotal 条',
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
                const Spacer(),
                IconButton(
                  tooltip: '上一页',
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: _streamsPage <= 1
                      ? null
                      : () {
                          setState(() => _streamsPage -= 1);
                          _loadStreams();
                        },
                ),
                IconButton(
                  tooltip: '下一页',
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: _streamsPage >= _streamPageCount
                      ? null
                      : () {
                          setState(() => _streamsPage += 1);
                          _loadStreams();
                        },
                ),
              ],
            ),
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
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _loadReviews,
      child: ListView(
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
                  child: TextField(
                    controller: _reviewUserController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _reviewUserController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _reviewUserController.clear();
                                setState(() => _reviewsPage = 1);
                                _loadReviews();
                              },
                              icon: const Icon(Icons.close_rounded),
                              tooltip: '清除用户过滤',
                            ),
                      labelText: '用户 ID',
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      setState(() => _reviewsPage = 1);
                      _loadReviews();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<common_enum.ReviewStatus>(
                    initialValue: _reviewStatusFilter,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: '状态',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
                        child: Text('待审核'),
                      ),
                      DropdownMenuItem(
                        value: common_enum.ReviewStatus.REVIEW_STATUS_APPROVED,
                        child: Text('已通过'),
                      ),
                      DropdownMenuItem(
                        value: common_enum.ReviewStatus.REVIEW_STATUS_REJECTED,
                        child: Text('已拒绝'),
                      ),
                    ],
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '第 $_reviewsPage 页 · 每页 $_reviewsPageSize · 共 $_reviewsTotal 条',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                ),
                IconButton(
                  tooltip: '上一页',
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: _reviewsPage <= 1
                      ? null
                      : () {
                          setState(() => _reviewsPage -= 1);
                          _loadReviews();
                        },
                ),
                IconButton(
                  tooltip: '下一页',
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: _reviewsPage >= _reviewPageCount
                      ? null
                      : () {
                          setState(() => _reviewsPage += 1);
                          _loadReviews();
                        },
                ),
              ],
            ),
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
      return const Center(child: CircularProgressIndicator());
    }
    final entries = page?.entries ?? const <WMovie>[];
    return RefreshIndicator(
      onRefresh: _loadMediaLibrary,
      child: ListView(
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
                IconButton(
                  tooltip: '返回上级',
                  onPressed:
                      _mediaTarget.isNotEmpty || _mediaPlaylistStack.isNotEmpty
                          ? _handleMediaBack
                          : null,
                  icon: const Icon(Icons.arrow_upward),
                ),
                IconButton(
                  tooltip: '新建播放列表',
                  onPressed: _mediaTarget.isEmpty ? _createPlaylist : null,
                  icon: const Icon(Icons.create_new_folder),
                ),
                IconButton(
                  tooltip: '清空当前目录',
                  onPressed: _mediaTarget.isEmpty && !_mediaLoading
                      ? _clearCurrentMediaScope
                      : null,
                  icon: const Icon(Icons.delete_sweep_rounded),
                ),
                IconButton(
                  tooltip: '刷新动态列表',
                  onPressed: () => _reloadMediaLibrary(refresh: true),
                  icon: const Icon(Icons.sync),
                ),
              ],
            ),
          ),
          _buildMediaScope(page, theme, isDark),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                TextField(
                  controller: _mediaSearchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _mediaSearchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _mediaSearchController.clear();
                              _reloadMediaLibrary();
                            },
                            icon: const Icon(Icons.close_rounded),
                            tooltip: '清除搜索',
                          ),
                    labelText: '搜索媒体或目录',
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _reloadMediaLibrary(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: ValueKey('media-source-$_mediaSourceProvider'),
                        initialValue: _mediaSourceProvider,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '来源',
                          border: OutlineInputBorder(),
                        ),
                        items: _mediaSourceLabels.entries
                            .map(
                              (entry) => DropdownMenuItem<String>(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) return;
                          _selectMediaSourceProvider(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: ValueKey(
                          'media-instance-$_mediaSourceProvider-'
                          '$_mediaProviderInstanceName-'
                          '${_mediaProviderInstances.join('|')}',
                        ),
                        initialValue: _mediaProviderInstances
                                .contains(_mediaProviderInstanceName)
                            ? _mediaProviderInstanceName
                            : '',
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: '实例',
                          border: const OutlineInputBorder(),
                          suffixIcon: _mediaProviderInstancesLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        items: _mediaProviderInstances
                            .map(
                              (instance) => DropdownMenuItem<String>(
                                value: instance,
                                child: Text(_providerInstanceLabel(instance)),
                              ),
                            )
                            .toList(growable: false),
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
                      child: DropdownButtonFormField<
                          client_enum.ResourceAvailabilityFilter>(
                        initialValue: _mediaAvailability,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '可用性',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: client_enum.ResourceAvailabilityFilter
                                .RESOURCE_AVAILABILITY_FILTER_ALL,
                            child: Text('全部'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.ResourceAvailabilityFilter
                                .RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
                            child: Text('可用'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.ResourceAvailabilityFilter
                                .RESOURCE_AVAILABILITY_FILTER_UNAVAILABLE,
                            child: Text('不可用'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _mediaAvailability = value);
                          _reloadMediaLibrary();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child:
                          DropdownButtonFormField<client_enum.MediaListSortBy>(
                        initialValue: _mediaSortBy,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '排序',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: client_enum
                                .MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION,
                            child: Text('位置'),
                          ),
                          DropdownMenuItem(
                            value: client_enum
                                .MediaListSortBy.MEDIA_LIST_SORT_BY_NAME,
                            child: Text('名称'),
                          ),
                          DropdownMenuItem(
                            value: client_enum
                                .MediaListSortBy.MEDIA_LIST_SORT_BY_ADDED_AT,
                            child: Text('添加时间'),
                          ),
                          DropdownMenuItem(
                            value: client_enum
                                .MediaListSortBy.MEDIA_LIST_SORT_BY_UPDATED_AT,
                            child: Text('更新时间'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.MediaListSortBy
                                .MEDIA_LIST_SORT_BY_SOURCE_PROVIDER,
                            child: Text('来源'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.MediaListSortBy
                                .MEDIA_LIST_SORT_BY_PROVIDER_INSTANCE_NAME,
                            child: Text('实例'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _mediaSortBy = value);
                          _reloadMediaLibrary();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      onPressed: () {
                        setState(() {
                          _mediaSortDirection = _mediaSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_ASC
                              ? client_enum.SortDirection.SORT_DIRECTION_DESC
                              : client_enum.SortDirection.SORT_DIRECTION_ASC;
                        });
                        _reloadMediaLibrary();
                      },
                      icon: Icon(
                        _mediaSortDirection ==
                                client_enum.SortDirection.SORT_DIRECTION_ASC
                            ? Icons.north_rounded
                            : Icons.south_rounded,
                      ),
                      tooltip: _mediaSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? '升序'
                          : '降序',
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
              IconButton.outlined(
                tooltip: '复制诊断数据',
                onPressed: _copyRealtimeDiagnostics,
                icon: const Icon(Icons.copy_all_rounded),
              ),
              const SizedBox(width: 6),
              IconButton.outlined(
                tooltip: '重置监听',
                onPressed: loading ? null : _resetRealtimeDiagnostics,
                icon: const Icon(Icons.restart_alt_rounded),
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
            child: SegmentedButton<_RealtimeDiagnosticsPane>(
              showSelectedIcon: false,
              selected: {_realtimePane},
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
              onSelectionChanged: (selection) {
                setState(() => _realtimePane = selection.single);
              },
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
        return RefreshIndicator(
          onRefresh: _refreshRealtimeDiagnostics,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              _buildRealtimeOverview(resources, theme, isDark),
              _buildRealtimeSnapshot(resources, theme, isDark),
            ],
          ),
        );
      case _RealtimeDiagnosticsPane.resources:
        return RefreshIndicator(
          onRefresh: _refreshRealtimeDiagnostics,
          child: ListView(
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
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.55),
          ),
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
    final onlineMembers = _members.where((member) => member.isOnline).length;
    final mediaEntries = mediaPage?.entries.length ?? 0;
    return [
      _RealtimeResourceDebugInfo(
        key: 'settings',
        title: '房间设置',
        icon: Icons.tune_rounded,
        observeId: 'room_settings',
        version: _settingsWatchVersion,
        loading: _isSaving,
        localCount: 1,
        summary: _isSaving ? '正在保存设置' : '监听设置变更',
        stats: _settingsWatchStats,
        details: {
          'require_password': _settings.requirePassword,
          'allow_guest_join': _settings.allowGuestJoin,
          'allow_auto_join': _settings.allowAutoJoin,
          'require_approval': _settings.requireApproval,
          'chat_enabled': _settings.chatEnabled,
          'danmaku_enabled': _settings.danmakuEnabled,
          'max_members': _settings.maxMembers,
          'member_permissions': _settings.effectiveMemberPermissions,
          'guest_permissions': _settings.effectiveGuestPermissions,
        },
      ),
      _RealtimeResourceDebugInfo(
        key: 'members',
        title: '成员列表',
        icon: Icons.group_rounded,
        observeId: 'room_members',
        version: _membersWatchVersion,
        loading: _membersLoading,
        localCount: _members.length,
        summary: _membersLoading
            ? '正在刷新成员'
            : '$onlineMembers 在线 / $_membersTotal 总数',
        stats: _membersWatchStats,
        details: {
          'page_count': _members.length,
          'total': _membersTotal,
          'online': onlineMembers,
          'page': _membersPage,
          'page_size': _membersPageSize,
          'role_filter': _memberRoleFilter?.name ?? '',
          'sort_by': _memberSortBy.name,
          'sort_direction': _memberSortDirection.name,
          'search': _memberSearchController.text.trim(),
        },
      ),
      _RealtimeResourceDebugInfo(
        key: 'media',
        title: '媒体列表',
        icon: Icons.video_library_rounded,
        observeId: 'playlist_items',
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
          'folder_count': mediaPage?.folderCount ?? 0,
          'file_count': mediaPage?.fileCount ?? 0,
          'playlist_id': _currentPlaylistId,
          'target': _mediaTarget,
          'source_provider': _mediaSourceProvider,
          'provider_instance_name': _mediaProviderInstanceName,
          'availability': _mediaAvailability.name,
          'sort_by': _mediaSortBy.name,
          'sort_direction': _mediaSortDirection.name,
          'search': _mediaSearchController.text.trim(),
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

  Widget _buildRealtimeOverview(
    List<_RealtimeResourceDebugInfo> resources,
    ThemeData theme,
    bool isDark,
  ) {
    final watched = resources.where((item) => item.version.isNotEmpty).length;
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
    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: tone, size: 21),
          ),
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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E24) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
          ),
        ),
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
              resources
                  .map((item) =>
                      '${item.observeId}:${item.version.isEmpty ? 'pending' : item.version}')
                  .join('  '),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = width >= 1120 ? 3 : (width >= 720 ? 2 : 1);
          const spacing = 10.0;
          final itemWidth = (width - spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final resource in resources)
                SizedBox(
                  width: itemWidth,
                  child: _buildRealtimeResourceCard(
                    resource,
                    theme,
                    isDark,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRealtimeResourceCard(
    _RealtimeResourceDebugInfo resource,
    ThemeData theme,
    bool isDark,
  ) {
    final ready = resource.version.isNotEmpty;
    final tone = resource.stats.errors > 0
        ? Colors.redAccent
        : ready
            ? Colors.green
            : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(resource.icon, color: tone, size: 21),
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
                  child: CircularProgressIndicator(strokeWidth: 2),
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
              theme, '版本', resource.version.isEmpty ? '等待' : resource.version),
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
          const Divider(height: 20),
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
            child: SelectableText(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistoryTab(ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadChatHistory,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: _chatReadState == null
                ? '聊天历史'
                : '聊天历史 · 未读 ${_chatReadState!.unreadCount}',
            count: _chatMessages.length,
            loading: _chatLoading,
            onRefresh: _loadChatHistory,
            theme: theme,
            action: _chatCursor.isEmpty
                ? null
                : IconButton(
                    tooltip: '加载更多',
                    onPressed: _chatLoading
                        ? null
                        : () => _loadChatHistory(loadMore: true),
                    icon: const Icon(Icons.more_horiz),
                  ),
          ),
          if (_chatMessages.isEmpty)
            _buildEmptyState('当前没有聊天历史', theme)
          else
            ..._chatMessages.map(
              (message) => _buildChatMessageTile(message, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildNetworkTab(ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadIceServers,
      child: ListView(
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
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
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
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _loadMembers,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '房间成员',
            count: _membersTotal,
            loading: _membersLoading,
            onRefresh: _loadMembers,
            theme: theme,
            action: IconButton(
              tooltip: '添加成员',
              onPressed: _addMember,
              icon: const Icon(Icons.person_add_alt_1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                TextField(
                  controller: _memberSearchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _memberSearchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _memberSearchController.clear();
                              setState(() => _membersPage = 1);
                              _refreshMembersRealtimeQuery();
                              _loadMembers();
                            },
                            icon: const Icon(Icons.close_rounded),
                            tooltip: '清除搜索',
                          ),
                    labelText: '用户名或用户 ID',
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) {
                    setState(() => _membersPage = 1);
                    _refreshMembersRealtimeQuery();
                    _loadMembers();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child:
                          DropdownButtonFormField<common_enum.RoomMemberRole?>(
                        initialValue: _memberRoleFilter,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '角色',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('全部角色'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
                            child: Text('房主'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                            child: Text('管理员'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                            child: Text('成员'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
                            child: Text('访客'),
                          ),
                        ],
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
                      child: DropdownButtonFormField<
                          client_enum.RoomMemberListSortBy>(
                        initialValue: _memberSortBy,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '排序',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: client_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                            child: Text('加入时间'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                            child: Text('用户名'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_ROLE,
                            child: Text('角色'),
                          ),
                        ],
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
                    IconButton.outlined(
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
                      icon: Icon(
                        _memberSortDirection ==
                                client_enum.SortDirection.SORT_DIRECTION_ASC
                            ? Icons.north_rounded
                            : Icons.south_rounded,
                      ),
                      tooltip: _memberSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? '升序'
                          : '降序',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '第 $_membersPage 页 · 每页 $_membersPageSize · 共 $_membersTotal 条',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '上一页',
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: _membersPage <= 1
                      ? null
                      : () {
                          setState(() => _membersPage -= 1);
                          _refreshMembersRealtimeQuery();
                          _loadMembers();
                        },
                ),
                IconButton(
                  tooltip: '下一页',
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: _membersPage >= _memberPageCount
                      ? null
                      : () {
                          setState(() => _membersPage += 1);
                          _refreshMembersRealtimeQuery();
                          _loadMembers();
                        },
                ),
              ],
            ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430;
          final titleWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
          final refresh = IconButton(
            tooltip: '刷新',
            onPressed: loading ? null : onRefresh,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          );
          final actions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (action != null) action,
              refresh,
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                titleWidget,
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: actions,
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: titleWidget),
              actions,
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String text, ThemeData theme) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(text, style: TextStyle(color: theme.hintColor)),
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
            child: SelectableText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamTile(
    RoomStreamEntryInfo stream,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          Icon(
            stream.active ? Icons.sensors : Icons.sensors_off,
            color: stream.active ? Colors.green : theme.disabledColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => _showStreamInfo(stream),
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
          IconButton(
            tooltip: '查看详情',
            onPressed: () => _showStreamInfo(stream),
            icon: const Icon(Icons.info_outline_rounded),
          ),
          IconButton(
            tooltip: '断开推流',
            onPressed: stream.active ? () => _kickStream(stream) : null,
            icon: const Icon(Icons.link_off),
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
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
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
                TextButton.icon(
                  onPressed: () => _rejectReview(review),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('拒绝'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _approveReview(review),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('通过'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaTile(WMovie entry, ThemeData theme, bool isDark) {
    final isPersisted =
        entry.id.startsWith('pl_') || entry.id.startsWith('med_');
    final isDynamic = !isPersisted;
    final playlistIndex = entry.id.startsWith('pl_')
        ? _mediaPage?.playlists.indexWhere((item) => item.id == entry.id) ?? -1
        : -1;
    final playlistCount = _mediaPage?.playlists.length ?? 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      clipBehavior: Clip.antiAlias,
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
            child: InkWell(
              onTap: entry.isFolder ? () => _openMediaEntry(entry) : null,
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
          PopupMenuButton<_MediaAction>(
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
              PopupMenuItem(
                value: _MediaAction.rename,
                enabled: isPersisted,
                child: const Text('编辑'),
              ),
              PopupMenuItem(
                value: _MediaAction.updateCover,
                enabled: isPersisted,
                child: const Text('更新封面'),
              ),
              PopupMenuItem(
                value: _MediaAction.clearCover,
                enabled: isPersisted && entry.coverUrl.isNotEmpty,
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
              PopupMenuItem(
                value: _MediaAction.move,
                enabled: entry.id.startsWith('med_'),
                child: const Text('移动到...'),
              ),
              PopupMenuItem(
                value: _MediaAction.delete,
                enabled: isPersisted && !isDynamic,
                child: const Text('删除'),
              ),
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
    final title = message.username.isEmpty ? message.userId : message.username;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  message.isDeleted ? '$title · 已删除' : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              if (message.isEdited && !message.isDeleted) ...[
                Text(
                  '已编辑',
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(color: theme.hintColor, fontSize: 12),
              ),
              const SizedBox(width: 4),
              _buildChatMessageActionButton(
                tooltip: '查看上下文',
                icon: Icons.forum_outlined,
                onPressed: () => _showChatMessageContext(message),
              ),
              _buildChatMessageActionButton(
                tooltip: '编辑',
                icon: Icons.edit_outlined,
                onPressed:
                    message.isDeleted ? null : () => _editChatMessage(message),
              ),
              _buildChatMessageActionButton(
                tooltip: '删除',
                icon: Icons.delete_outline,
                color: theme.colorScheme.error,
                onPressed: message.isDeleted
                    ? null
                    : () => _deleteChatMessage(message),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (message.content.isNotEmpty)
            Text(
              message.isDeleted ? '这条消息已删除' : message.content,
              style: message.isDeleted
                  ? TextStyle(
                      color: theme.hintColor,
                      fontStyle: FontStyle.italic,
                    )
                  : null,
            ),
          if (message.images.isNotEmpty && !message.isDeleted) ...[
            if (message.content.isNotEmpty) const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: message.images
                  .map(
                    (image) => _buildChatImageThumb(image, theme),
                  )
                  .toList(),
            ),
          ],
          if (message.position != null || message.color != null) ...[
            const SizedBox(height: 6),
            Text(
              [
                if (message.position != null)
                  '${message.position!.toStringAsFixed(1)}s',
                if (message.color != null && message.color!.isNotEmpty)
                  message.color!,
              ].join(' · '),
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatMessageActionButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 18,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        onPressed: onPressed,
        icon: Icon(icon, color: color),
      ),
    );
  }

  Widget _buildChatImageThumb(StoredImageInfo image, ThemeData theme) {
    final resolved = WatchTogetherService.resolveResourceUrl(image.url);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        resolved,
        width: 160,
        height: 104,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 160,
          height: 104,
          color: theme.colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
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
    final resolved = WatchTogetherService.resolveResourceUrl(url);
    final fallback = Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        color: theme.colorScheme.onSurfaceVariant,
        size: height >= 120 ? 42 : 24,
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: resolved.isEmpty
          ? fallback
          : Image.network(
              resolved,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => fallback,
            ),
    );
  }

  Widget _buildIceServerTile(
    IceServerInfo server,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
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

  String _mediaSubtitle(WMovie entry) {
    if (entry.id.startsWith('pl_')) {
      final mode = entry.metadata['is_dynamic'] == true ? '动态播放列表' : '播放列表';
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
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            child: Text(
              _memberInitial(member),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.username.isEmpty ? member.userId : member.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_roleLabel(member.role)} · ${member.isOnline ? '在线' : '离线'} · ${_formatTimestamp(member.joinedAt)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
              ],
            ),
          ),
          if (canManageMember)
            PopupMenuButton<_MemberAction>(
              tooltip: '成员操作',
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
    );
  }

  Widget _buildRoomActions(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Material(
            color: isDark ? const Color(0xFF1E1E24) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
              ),
            ),
            clipBehavior: Clip.antiAlias,
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
                        child: Text(
                          _roomInfo?.roomName ?? widget.roomName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: _coverUpdating ? null : _updateRoomCover,
                        icon: _coverUpdating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.image_outlined),
                        label: const Text('封面'),
                      ),
                      if (_roomCoverUrl.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        IconButton.outlined(
                          tooltip: '移除封面',
                          onPressed: _coverUpdating ? null : _clearRoomCover,
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: isDark ? const Color(0xFF1E1E24) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restart_alt),
                  title: const Text('重置房间设置'),
                  subtitle: const Text('恢复服务端默认房间策略'),
                  onTap: _resetSettings,
                ),
                if (_canLeaveRoom) ...[
                  _buildDivider(theme),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('退出房间'),
                    subtitle: const Text('退出后需要重新加入才能访问成员内容'),
                    onTap: _leaveRoom,
                  ),
                ],
                _buildDivider(theme),
                ListTile(
                  leading: Icon(Icons.delete_forever_rounded,
                      color: theme.colorScheme.error),
                  title: Text(
                    '删除房间',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: _deleteRoom,
                ),
              ],
            ),
          ),
        ],
      ),
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

  String _memberInitial(AdminRoomMember member) {
    final source = member.username.isNotEmpty ? member.username : member.userId;
    return source.isEmpty ? '?' : source.characters.first.toUpperCase();
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
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121214) : const Color(0xFFF6F7FB),
        appBar: AppBar(
          title: Text(
            widget.roomName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor:
              isDark ? const Color(0xFF121214) : const Color(0xFFF6F7FB),
          centerTitle: true,
          systemOverlayStyle: systemUiOverlayStyle,
          actions: [
            if (_isSaving)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              TextButton(
                onPressed: _saveSettings,
                child: Text(
                  '保存',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
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
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.dividerColor.withValues(alpha: 0.55),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF151518)
                          : const Color(0xFFF3F5F8),
                    ),
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
    return TabBarView(
      controller: _tabController,
      children: _sections
          .map((section) => section.builder(theme, isDark))
          .toList(growable: false),
    );
  }

  Widget _buildTopTabs(ThemeData theme) {
    final compact = MediaQuery.sizeOf(context).width < 430;
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      child: TabBar(
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
          child: Material(
            color: isDark ? const Color(0xFF101012) : Colors.white,
            child: SafeArea(
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
                      child: ListView.separated(
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
    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
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
        ),
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
