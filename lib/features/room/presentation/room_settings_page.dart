import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/features/room/domain/realtime_event_log.dart';
import 'package:synctv_app/features/room/application/room_realtime_protocol.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/content_reports/presentation/content_reports_view.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/features/room/application/room_chat_gateway.dart';
import 'package:synctv_app/features/room/application/room_playback_gateway.dart';
import 'package:synctv_app/features/room/application/playback_history_controller.dart';
import 'package:synctv_app/features/room/application/playback_mode_preferences_controller.dart';
import 'package:synctv_app/features/room/application/room_management_gateway.dart';
import 'package:synctv_app/features/media_library/application/media_library_gateway.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/image/local_image_picker.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/widgets/app_responsive_layout.dart';
import 'package:synctv_app/features/media_library/presentation/add_media_dialog.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/features/room/presentation/widgets/chat_read_receipts_dialog.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_reaction_users_dialog.dart';
import 'package:synctv_app/features/room/presentation/widgets/free_mode_settings_fields.dart';
import 'package:synctv_app/features/room/presentation/models/playlist_selection_policy.dart';
import 'package:synctv_app/features/media_p2p/presentation/p2p_media_settings_fields.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_history_list.dart';
import 'package:synctv_app/features/room/presentation/widgets/realtime_event_log_view.dart';

const String _settingsObserveId = 'manage_room_settings';
const String _membersObserveId = 'manage_room_member_events';
const String _membersOnlineCountObserveId = 'manage_member_online_count';
const String _mediaObserveIdPrefix = 'manage_playlist_items';
const String _chatObserveId = 'manage_chat_events';
const String _playbackHistoryObserveId = 'manage_playback_history';
const Set<String> _managementObserveIds = {
  _settingsObserveId,
  _membersObserveId,
  _membersOnlineCountObserveId,
  _chatObserveId,
  _playbackHistoryObserveId,
};

const Set<source_enum.SourceProvider> _mediaSourcesWithProviderInstances = {
  source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
  source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
  source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
  source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
  source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
  source_enum.SourceProvider.SOURCE_PROVIDER_YOUTUBE,
  source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
  source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
  source_enum.SourceProvider.SOURCE_PROVIDER_HUYA,
  source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU,
  source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN,
  source_enum.SourceProvider.SOURCE_PROVIDER_CCTV,
};

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
  String lastKind = 'waiting';
  String lastError = '';

  int get total => observed + changed + errors;

  void reset() {
    observed = 0;
    changed = 0;
    errors = 0;
    lastSeenAt = null;
    lastKind = 'waiting';
    lastError = '';
  }

  void record<T>(RoomResourceWatchEvent<T> event) {
    lastSeenAt = DateTime.now();
    switch (event) {
      case RoomResourceObserved(:final changed):
        observed += 1;
        lastKind = changed ? 'observed_changed' : 'observed_unchanged';
        lastError = '';
      case RoomResourceChanged():
        changed += 1;
        lastKind = 'snapshot';
        lastError = '';
      case RoomResourceWatchFailed(:final message):
        errors += 1;
        lastKind = 'error';
        lastError = message;
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
  final bool isPublic;
  final SyncTvRoomSettings currentSettings;
  final RoomRealtimeSession realtime;
  final bool canViewPlaybackHistory;
  final bool canNavigatePlayback;
  final bool canUseWebRtc;
  final P2pMediaPreferencesController p2pMediaPreferences;

  const RoomSettingsPage({
    super.key,
    required this.roomId,
    required this.roomName,
    this.creatorId = '',
    this.currentUserId = '',
    required this.isPublic,
    required this.currentSettings,
    required this.realtime,
    required this.p2pMediaPreferences,
    this.canViewPlaybackHistory = false,
    this.canNavigatePlayback = false,
    required this.canUseWebRtc,
  });

  @override
  State<RoomSettingsPage> createState() => _RoomSettingsPageState();
}

class _RoomSettingsPageState extends State<RoomSettingsPage>
    with SingleTickerProviderStateMixin {
  late final RoomChatGateway _chatGateway;
  late final RoomPlaybackGateway _playbackGateway;
  late final PlaybackModePreferencesController _playbackModePreferences;
  late final ResourceUrlResolver _resourceUrlResolver;
  late final RoomManagementGateway _roomGateway;
  late final MediaLibraryGateway _mediaLibraryGateway;
  late final RealtimeEventLogPreferencesController _realtimeLogPreferences;
  late final RoomRealtimeProtocol _realtimeProtocol;

  int get _sectionCount =>
      10 +
      (widget.canViewPlaybackHistory ? 1 : 0) +
      (widget.canUseWebRtc ? 1 : 0);
  late final TabController _tabController;
  late final TextEditingController _passwordController;
  late final TextEditingController _maxMembersController;
  late final TextEditingController _streamSearchController;
  late final TextEditingController _memberSearchController;
  late final TextEditingController _reviewUserController;
  late final TextEditingController _mediaSearchController;
  late final TextEditingController _chatSearchController;
  late SyncTvRoomSettings _settings;
  late PlaybackModeConfig _playbackModeConfig;

  final List<RoomStreamEntryInfo> _streams = [];
  final List<RoomJoinReviewInfo> _reviews = [];
  final List<AdminRoomMember> _members = [];
  final List<RoomChatMessageInfo> _chatMessages = [];
  late final PlaybackHistoryController _playbackHistoryController;
  final Map<String, ChatMessageReadReceiptsInfo> _chatReceiptCache = {};
  final List<IceServerInfo> _iceServers = [];
  final List<RealtimeEventLogEntry> _realtimeEvents = [];
  final List<String> _mediaPlaylistStack = [];
  final List<RoomMediaEntry> _mediaPlaylistEntryStack = [];
  final List<String> _mediaTargetStack = [];
  StreamSubscription<RoomRealtimeMessage>? _realtimeMessageSubscription;
  StreamSubscription<RealtimeEventLogEntry>? _realtimeEventSubscription;
  StreamSubscription<void>? _realtimeReconnectSubscription;
  StreamSubscription<void>? _realtimeDisconnectSubscription;
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
  String _mediaObserveId = '${_mediaObserveIdPrefix}_0';
  int _mediaObserveGeneration = 0;
  int _mediaLoadGeneration = 0;
  String _chatWatchVersion = '';
  client_enum.MediaListSortBy _mediaSortBy =
      client_enum.MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION;
  client_enum.SortDirection _mediaSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_ASC;
  client_enum.ResourceAvailabilityFilter _mediaAvailability =
      client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL;
  source_enum.SourceProvider _mediaSourceProvider =
      source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED;
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
  late bool _isPublic;
  bool _requireApproval = false;
  bool _allowAutoJoin = true;
  bool _chatEnabled = true;
  bool _voiceChatEnabled = true;
  bool _p2pMediaEnabled = true;
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
  bool _visibilityUpdating = false;
  int _visibilityMutationGeneration = 0;
  bool _freeModeSaving = false;
  bool _isDisposing = false;
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
    _chatGateway = DependencyScope.read<RoomChatGateway>(context);
    _playbackGateway = DependencyScope.read<RoomPlaybackGateway>(context);
    _playbackHistoryController = PlaybackHistoryController(
      gateway: _playbackGateway,
      roomId: widget.roomId,
    );
    _playbackModePreferences =
        DependencyScope.read<PlaybackModePreferencesController>(context);
    _resourceUrlResolver = DependencyScope.read<ResourceUrlResolver>(context);
    _roomGateway = DependencyScope.read<RoomManagementGateway>(context);
    _mediaLibraryGateway = DependencyScope.read<MediaLibraryGateway>(context);
    _realtimeLogPreferences =
        DependencyScope.read<RealtimeEventLogPreferencesController>(context);
    _realtimeProtocol = DependencyScope.read<RoomRealtimeProtocol>(context);
    _tabController = TabController(length: _sectionCount, vsync: this);
    _tabController.addListener(_handleTabChanged);
    _settings = widget.currentSettings;
    _isPublic = widget.isPublic;
    _playbackModeConfig = _playbackModePreferences.value;
    _currentUserId = widget.currentUserId;
    _passwordController = TextEditingController();
    _maxMembersController = TextEditingController();
    _streamSearchController = TextEditingController();
    _memberSearchController = TextEditingController();
    _reviewUserController = TextEditingController();
    _mediaSearchController = TextEditingController();
    _chatSearchController = TextEditingController();
    _realtimeLogPreferences.maxEntries.addListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    _applySettings(_settings);
    _loadStreams();
    _loadMembers();
    _loadMediaProviderInstances();
    _loadMediaLibrary();
    _loadRoomInfo();
    _loadChatHistory();
    if (widget.canViewPlaybackHistory) _loadPlaybackHistory();
    if (widget.canUseWebRtc) _loadIceServers();
    _loadCurrentUserIfNeeded();
    _realtimeMessageSubscription = widget.realtime.messages.listen(
      _handleRealtimeMessage,
    );
    _realtimeEventSubscription = widget.realtime.events.listen(
      _handleRealtimeEvent,
    );
    _realtimeReconnectSubscription = widget.realtime.reconnects.listen((_) {
      if (_isDisposing || !mounted) return;
      _chatHistoryLoaded = false;
      _loadChatHistory();
      if (widget.canViewPlaybackHistory) {
        _playbackHistoryController.observe('');
        _requestPlaybackHistoryRefresh();
      }
      _startResourceWatches();
    });
    _realtimeDisconnectSubscription = widget.realtime.disconnections.listen(
      (_) => _closeAfterRealtimeDisconnect(),
    );
    _startResourceWatches();
  }

  void _closeAfterRealtimeDisconnect() {
    if (_isDisposing || !mounted) return;
    final route = ModalRoute.of(context);
    if (route == null) return;
    final navigator = Navigator.of(context);
    navigator.popUntil((candidate) => candidate == route);
    if (route.isCurrent) navigator.pop();
  }

  @override
  void dispose() {
    _isDisposing = true;
    _realtimeLogPreferences.maxEntries.removeListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    _sendRealtime(
      _realtimeProtocol.encodeUnobserveResource(_settingsObserveId),
    );
    _sendRealtime(_realtimeProtocol.encodeUnobserveResource(_membersObserveId));
    _sendRealtime(
      _realtimeProtocol.encodeUnobserveResource(_membersOnlineCountObserveId),
    );
    _sendRealtime(_realtimeProtocol.encodeUnobserveResource(_mediaObserveId));
    _sendRealtime(_realtimeProtocol.encodeUnobserveResource(_chatObserveId));
    _sendRealtime(
      _realtimeProtocol.encodeUnobserveResource(_playbackHistoryObserveId),
    );
    _realtimeMessageSubscription?.cancel();
    _realtimeEventSubscription?.cancel();
    _realtimeReconnectSubscription?.cancel();
    _realtimeDisconnectSubscription?.cancel();
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    _passwordController.dispose();
    _maxMembersController.dispose();
    _streamSearchController.dispose();
    _memberSearchController.dispose();
    _reviewUserController.dispose();
    _mediaSearchController.dispose();
    _chatSearchController.dispose();
    _playbackHistoryController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging) return;
    if (_tabController.index == _sectionCount - 1 &&
        !_reviewsLoaded &&
        !_reviewsLoading) {
      _loadReviews();
    }
  }

  void _applySettings(SyncTvRoomSettings settings) {
    _allowGuestJoin = settings.allowGuestJoin;
    _requireApproval = settings.requireApproval;
    _allowAutoJoin = settings.allowAutoJoin;
    _chatEnabled = settings.chatEnabled;
    _voiceChatEnabled = settings.voiceChatEnabled;
    _p2pMediaEnabled = settings.p2pMediaEnabled;
    _memberPermissions = settings.effectiveMemberPermissions;
    _guestPermissions = settings.effectiveGuestPermissions;
    _maxMembersController.text = settings.maxMembers.toString();
  }

  void _startResourceWatches() {
    _startSettingsWatch();
    _startMembersWatch();
    _startMediaWatch();
    _startChatWatch();
    if (widget.canViewPlaybackHistory) _startPlaybackHistoryWatch();
  }

  void _startPlaybackHistoryWatch() {
    _sendRealtime(
      _realtimeProtocol.encodePlaybackHistoryObservation(
        observeId: _playbackHistoryObserveId,
        version: _playbackHistoryController.state.version,
      ),
    );
  }

  void _requestPlaybackHistoryRefresh([String expectedCursorId = '']) {
    if (!widget.canViewPlaybackHistory || !mounted) return;
    unawaited(
      _playbackHistoryController
          .requestRefresh(expectedCursorId: expectedCursorId)
          .catchError((error) {
            if (mounted) AppNotifications.showError(context, error.toString());
          }),
    );
  }

  Future<void> _loadPlaybackHistory() async {
    try {
      await _playbackHistoryController.refresh();
    } catch (error) {
      if (mounted) AppNotifications.showError(context, error.toString());
    }
  }

  Future<void> _playHistoryEntry(String entryId) async {
    try {
      await _playbackHistoryController.play(entryId);
    } catch (error) {
      if (mounted) AppNotifications.showError(context, error.toString());
    }
  }

  Future<void> _loadCurrentUserIfNeeded() async {
    if (_currentUserId.isNotEmpty) return;
    try {
      final user = await _roomGateway.getMe();
      if (!mounted) return;
      setState(() => _currentUserId = user.id);
    } catch (e) {
      debugPrint('Load room settings current user failed: $e');
    }
  }

  Future<void> _loadRoomInfo() async {
    final visibilityGeneration = _visibilityMutationGeneration;
    try {
      final room = await _roomGateway.getRoomInfo(widget.roomId);
      if (!mounted) return;
      setState(() {
        _roomInfo = room;
        if (visibilityGeneration == _visibilityMutationGeneration) {
          _isPublic = room.isPublic;
        }
      });
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
      final room = await _roomGateway.updateRoomCover(
        widget.roomId,
        image.upload,
      );
      if (!mounted) return;
      setState(() => _roomInfo = room);
      AppNotifications.showSuccess(context, context.l10n.roomCoverUpdated);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateRoomCoverFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _coverUpdating = false);
    }
  }

  Future<void> _updateRoomVisibility(bool isPublic) async {
    if (_visibilityUpdating || isPublic == _isPublic) return;
    if (!isPublic) {
      setState(() => _visibilityUpdating = true);
      final confirmed = await _confirm(
        title: context.l10n.makeRoomPrivate,
        content: context.l10n.makeRoomPrivateConfirmation,
        action: context.l10n.makePrivate,
        destructive: true,
      );
      if (!mounted) return;
      if (!confirmed) {
        setState(() => _visibilityUpdating = false);
        return;
      }
    }
    final previousValue = _isPublic;
    setState(() {
      _isPublic = isPublic;
      _visibilityUpdating = true;
      _visibilityMutationGeneration += 1;
    });
    try {
      final room = await _roomGateway.updateRoomVisibility(
        widget.roomId,
        isPublic,
      );
      if (!mounted) return;
      setState(() {
        _roomInfo = room;
        _isPublic = room.isPublic;
      });
      AppNotifications.showSuccess(context, context.l10n.roomVisibilityUpdated);
    } catch (e) {
      if (mounted) {
        setState(() => _isPublic = previousValue);
        AppNotifications.showError(context, context.l10n.updateFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _visibilityUpdating = false);
    }
  }

  Future<void> _clearRoomCover() async {
    if (_coverUpdating || _roomCoverUrl.isEmpty) return;
    try {
      setState(() => _coverUpdating = true);
      final room = await _roomGateway.clearRoomCover(widget.roomId);
      if (!mounted) return;
      setState(() => _roomInfo = room);
      AppNotifications.showSuccess(context, context.l10n.roomCoverRemoved);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.removeRoomCoverFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _coverUpdating = false);
    }
  }

  Future<void> _updateRoomPassword() async {
    if (_passwordUpdating) return;
    final password = _passwordController.text.trim();
    setState(() => _passwordUpdating = true);
    try {
      await _roomGateway.updateRoomPassword(
        widget.roomId,
        password.isEmpty ? null : password,
      );
      final freshSettings = await _roomGateway.getRoomSettings(widget.roomId);
      if (!mounted) return;
      setState(() {
        _settings = freshSettings;
        _passwordController.clear();
        _applySettings(freshSettings);
      });
      AppNotifications.showSuccess(
        context,
        password.isEmpty
            ? context.l10n.roomPasswordRemoved
            : context.l10n.roomPasswordUpdated,
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateRoomPasswordFailed('$e'),
        );
      }
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
    if (_passwordController.text.trim().isNotEmpty) {
      return context.l10n.savePassword;
    }
    return _settings.requirePassword
        ? context.l10n.removePassword
        : context.l10n.noActionNeeded;
  }

  void _startSettingsWatch() {
    _sendRealtime(
      _realtimeProtocol.encodeRoomSettingsObservation(
        observeId: _settingsObserveId,
        version: _settingsWatchVersion,
      ),
    );
  }

  void _startMembersWatch() {
    _sendRealtime(
      _realtimeProtocol.encodeRoomMembersObservation(
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
        _realtimeProtocol.encodeUnobserveResource(_membersOnlineCountObserveId),
      );
      return;
    }
    final roles = _memberRoleFilter == null
        ? const <common_enum.RoomMemberRole>[]
        : <common_enum.RoomMemberRole>[_memberRoleFilter!];
    _sendRealtime(
      _realtimeProtocol.encodeOnlineCountObservation(
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
    final previousObserveId = _mediaObserveId;
    _mediaObserveGeneration += 1;
    _mediaObserveId = '${_mediaObserveIdPrefix}_$_mediaObserveGeneration';
    _sendRealtime(_realtimeProtocol.encodeUnobserveResource(previousObserveId));
    _sendRealtime(
      _realtimeProtocol.encodePlaylistObservation(
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
      _realtimeProtocol.encodeChatEventsObservation(
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
    if (_isDisposing || !mounted) return;
    final payload = entry.payload;
    final observeId = payload is Map
        ? payload['observeId']?.toString() ?? ''
        : '';
    if (observeId != _mediaObserveId &&
        !_managementObserveIds.contains(observeId)) {
      return;
    }
    _appendRealtimeEvent(entry);
  }

  void _handleRealtimeMessage(RoomRealtimeMessage message) {
    if (_isDisposing || !mounted) return;
    final playbackHistoryCursorId =
        message.playbackStatus?.historyCursorId ?? '';
    if (playbackHistoryCursorId.isNotEmpty &&
        playbackHistoryCursorId != _playbackHistoryController.state.cursorId) {
      _requestPlaybackHistoryRefresh(playbackHistoryCursorId);
    }
    if (message.resourceObserveId == _mediaObserveId) {
      _handleRealtimeMediaMessage(message);
      return;
    }
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
      case _chatObserveId:
        _handleRealtimeChatMessage(message);
        break;
      case _playbackHistoryObserveId:
        if (message.kind == RoomRealtimeMessageKind.playbackHistory &&
            message.playbackHistory != null) {
          _playbackHistoryController.applyRealtimeHistory(
            message.playbackHistory!,
            message.resourceVersion,
          );
        } else if (message.kind == RoomRealtimeMessageKind.checkStatus &&
            message.resourceEvent) {
          _loadPlaybackHistory();
        }
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
    if (message.kind == RoomRealtimeMessageKind.presenceCount) {
      _membersWatchStats.record(
        RoomResourceWatchEvent<void>.changed(version: message.resourceVersion),
      );
      if (mounted) {
        setState(() => _membersOnlineCount = message.onlineMemberCount);
      }
      return;
    }
    if (message.kind == RoomRealtimeMessageKind.onlineEvent) {
      _membersWatchStats.record(
        RoomResourceWatchEvent<void>.changed(version: message.resourceVersion),
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
        AppNotifications.showError(
          context,
          message.error?.message.isNotEmpty == true
              ? message.error!.message
              : context.l10n.memberOnlineWatchFailed,
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
    if (message.kind == RoomRealtimeMessageKind.mediaLibrary) {
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
    switch (event) {
      case RoomResourceObserved(:final version):
        if (version.isNotEmpty) _settingsWatchVersion = version;
        setState(() {});
      case RoomResourceChanged(:final version, :final snapshot):
        if (version.isNotEmpty) _settingsWatchVersion = version;
        if (snapshot == null) {
          AppNotifications.showError(
            context,
            context.l10n.roomSettingsSnapshotEmpty,
          );
          return;
        }
        setState(() {
          _settings = snapshot;
          _applySettings(snapshot);
        });
      case RoomResourceWatchFailed(:final message):
        AppNotifications.showError(
          context,
          message.isEmpty ? context.l10n.roomSettingsWatchFailed : message,
        );
    }
  }

  void _handleMembersWatchEvent(
    RoomResourceWatchEvent<List<AdminRoomMember>> event, {
    int? total,
  }) {
    if (!mounted) return;
    _membersWatchStats.record(event);
    switch (event) {
      case RoomResourceObserved(:final version):
        if (version.isNotEmpty) _membersWatchVersion = version;
        setState(() {});
      case RoomResourceChanged(:final version, :final snapshot):
        if (version.isNotEmpty) _membersWatchVersion = version;
        if (snapshot == null) {
          setState(() {});
          return;
        }
        setState(() {
          _members
            ..clear()
            ..addAll(snapshot);
          _membersTotal = total ?? snapshot.length;
          _membersOnlineCount = snapshot
              .where((member) => member.isOnline)
              .length;
        });
        _startMembersOnlineWatches();
      case RoomResourceWatchFailed(:final message):
        AppNotifications.showError(
          context,
          message.isEmpty ? context.l10n.memberWatchFailed : message,
        );
    }
  }

  void _applyMemberOnlineEvent(RoomRealtimeOnlineEvent? event) {
    if (!mounted || event == null || event.userId.isEmpty) return;
    final index = _members.indexWhere(
      (member) => member.userId == event.userId,
    );
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
    switch (event) {
      case RoomResourceObserved(:final version):
        if (version.isNotEmpty) _mediaWatchVersion = version;
        setState(() {});
      case RoomResourceChanged(:final version, :final snapshot):
        if (version.isNotEmpty) _mediaWatchVersion = version;
        if (snapshot == null) {
          AppNotifications.showError(context, context.l10n.mediaSnapshotEmpty);
          return;
        }
        setState(() => _mediaPage = snapshot);
      case RoomResourceWatchFailed(:final message):
        AppNotifications.showError(
          context,
          message.isEmpty ? context.l10n.mediaLibraryWatchFailed : message,
        );
    }
  }

  void _handleChatWatchEvent<T>(RoomResourceWatchEvent<T> event) {
    if (!mounted) return;
    _chatWatchStats.record(event);
    switch (event) {
      case RoomResourceObserved(:final version):
        if (version.isNotEmpty) _chatWatchVersion = version;
        setState(() {});
      case RoomResourceChanged(:final version, :final snapshot):
        if (version.isNotEmpty) _chatWatchVersion = version;
        if (snapshot is RoomRealtimeMessage) {
          setState(() => _applyChatRealtimeMessage(snapshot));
        } else {
          setState(() {});
        }
      case RoomResourceWatchFailed(:final message):
        AppNotifications.showError(
          context,
          message.isEmpty ? context.l10n.chatWatchFailed : message,
        );
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
    final maxEntries = _realtimeLogPreferences.maxEntries.value;
    if (_realtimeEvents.length > maxEntries) {
      _realtimeEvents.removeRange(0, _realtimeEvents.length - maxEntries);
    }
  }

  bool _hasPermission(int permissions, int flag) => (permissions & flag) != 0;

  void _setMemberPermission(int flag, bool enabled) {
    setState(() {
      _memberPermissions = enabled
          ? (_memberPermissions | flag)
          : (_memberPermissions & ~flag);
    });
  }

  void _setGuestPermission(int flag, bool enabled) {
    setState(() {
      _guestPermissions = enabled
          ? (_guestPermissions | flag)
          : (_guestPermissions & ~flag);
    });
  }

  int _memberRemovedPermissions() =>
      RoomMemberPermissions.all & ~_memberPermissions;

  int _guestRemovedPermissions() =>
      RoomGuestPermissions.all & ~_guestPermissions;

  Future<void> _saveSettings() async {
    final maxMembers = int.tryParse(_maxMembersController.text.trim());
    if (maxMembers == null || maxMembers < 0 || maxMembers > 10000) {
      AppNotifications.showError(context, context.l10n.maxMembersRange);
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
        autoPlayEnabled: _settings.autoPlayEnabled,
        autoPlayMode: _settings.autoPlayMode,
        autoPlayDelay: _settings.autoPlayDelay,
        voiceChatEnabled: _voiceChatEnabled,
        p2pMediaEnabled: _p2pMediaEnabled,
        memberAddedPermissions: 0,
        memberRemovedPermissions: _memberRemovedPermissions(),
        guestAddedPermissions: _guestPermissions,
        guestRemovedPermissions: _guestRemovedPermissions(),
      );

      await _roomGateway.updateRoomSettings(widget.roomId, settings);
      final freshSettings = await _roomGateway.getRoomSettings(widget.roomId);
      if (!mounted) return;
      setState(() {
        _settings = freshSettings;
        _applySettings(freshSettings);
      });
      AppNotifications.showSuccess(context, context.l10n.settingsUpdated);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.updateFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _loadStreams() async {
    if (!mounted) return;
    setState(() => _streamsLoading = true);
    try {
      final page = await _roomGateway.listRoomStreamsPage(
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
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadActiveStreamsFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _streamsLoading = false);
    }
  }

  Future<void> _loadReviews() async {
    if (!mounted) return;
    _reviewsLoaded = true;
    setState(() => _reviewsLoading = true);
    try {
      final page = await _roomGateway.listRoomJoinReviewsPage(
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
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadJoinReviewsFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _reviewsLoading = false);
    }
  }

  Future<void> _loadMembers() async {
    if (!mounted) return;
    setState(() => _membersLoading = true);
    try {
      final page = await _roomGateway.getRoomMemberDetailsPage(
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
        _membersOnlineCount = page.onlineMemberCount > 0
            ? page.onlineMemberCount
            : _members.where((m) => m.isOnline).length;
        _membersWatchVersion = page.version;
      });
      _startMembersOnlineWatches();
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadMembersFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _membersLoading = false);
    }
  }

  Future<void> _loadMediaLibrary({bool refresh = false}) async {
    if (!mounted) return;
    final loadGeneration = ++_mediaLoadGeneration;
    setState(() => _mediaLoading = true);
    try {
      final page = await _mediaLibraryGateway.listMediaLibrary(
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
      if (!mounted || loadGeneration != _mediaLoadGeneration) return;
      setState(() {
        _mediaPage = page;
        _mediaWatchVersion = page.version;
      });
    } catch (e) {
      if (mounted && loadGeneration == _mediaLoadGeneration) {
        AppNotifications.showError(
          context,
          context.l10n.loadMediaLibraryFailed('$e'),
        );
      }
    } finally {
      if (mounted && loadGeneration == _mediaLoadGeneration) {
        setState(() => _mediaLoading = false);
      }
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
    if (mounted) {
      AppNotifications.showSuccess(
        context,
        context.l10n.realtimeDiagnosticsCopied,
      );
    }
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
      final instances = await _mediaLibraryGateway
          .listAvailableProviderInstances(
            providerType: SourceConfigCodec.providerToString(provider),
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
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadMediaSourceInstancesFailed('$e'),
        );
      }
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

  Future<void> _selectMediaSourceProvider(
    source_enum.SourceProvider provider,
  ) async {
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
      final page = await _chatGateway.getHistory(
        widget.roomId,
        cursor: loadMore ? _chatCursor : '',
      );
      ChatReadStateInfo? readState;
      if (!loadMore && page.messages.isNotEmpty) {
        try {
          readState = await _chatGateway.markRead(
            widget.roomId,
            page.messages.first.id,
          );
        } catch (e) {
          debugPrint('Mark chat read failed: $e');
          try {
            readState = await _chatGateway.getReadState(widget.roomId);
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
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadChatHistoryFailed('$e'),
        );
      }
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
      final page = await _chatGateway.search(
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
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.searchChatHistoryFailed('$e'),
        );
      }
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
      messageType: message.chatMessageType,
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
    final clearPin =
        event.kind ==
            client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_UNPINNED ||
        event.kind ==
            client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_MESSAGE_DELETED;
    final index = _chatMessages.indexWhere(
      (item) => item.id == event.message.id,
    );
    if (index >= 0) {
      _chatMessages[index] = _chatMessages[index].copyWith(
        pin: event.pin,
        clearPin: clearPin,
      );
    }
  }

  Future<void> _loadIceServers() async {
    if (!mounted) return;
    setState(() => _iceLoading = true);
    try {
      final servers = await _roomGateway.getIceServers(widget.roomId);
      if (!mounted) return;
      setState(() {
        _iceServers
          ..clear()
          ..addAll(servers);
      });
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadIceConfigFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _iceLoading = false);
    }
  }

  int get _streamPageCount {
    if (_streamsTotal <= 0) return 1;
    return ((_streamsTotal + _streamsPageSize - 1) ~/ _streamsPageSize).clamp(
      1,
      1 << 31,
    );
  }

  int get _reviewPageCount {
    if (_reviewsTotal <= 0) return 1;
    return ((_reviewsTotal + _reviewsPageSize - 1) ~/ _reviewsPageSize).clamp(
      1,
      1 << 31,
    );
  }

  int get _memberPageCount {
    if (_membersTotal <= 0) return 1;
    return ((_membersTotal + _membersPageSize - 1) ~/ _membersPageSize).clamp(
      1,
      1 << 31,
    );
  }

  List<_RoomSettingsSection> get _sections => [
    _RoomSettingsSection(
      label: context.l10n.info,
      icon: Icons.info_outline_rounded,
      builder: _buildRoomInfoTab,
    ),
    _RoomSettingsSection(
      label: context.l10n.settings,
      icon: Icons.tune_rounded,
      builder: _buildSettingsTab,
    ),
    _RoomSettingsSection(
      label: context.l10n.freeModeSettings,
      icon: Icons.explore_rounded,
      builder: _buildFreeModeTab,
    ),
    _RoomSettingsSection(
      label: context.l10n.members,
      icon: Icons.group_rounded,
      builder: _buildMembersTab,
    ),
    _RoomSettingsSection(
      label: context.l10n.media,
      icon: Icons.video_library_rounded,
      builder: _buildMediaTab,
    ),
    _RoomSettingsSection(
      label: context.l10n.realtime,
      icon: Icons.sensors_rounded,
      builder: _buildRealtimeTab,
    ),
    _RoomSettingsSection(
      label: context.l10n.chat,
      icon: Icons.forum_rounded,
      builder: _buildChatHistoryTab,
    ),
    if (widget.canViewPlaybackHistory)
      _RoomSettingsSection(
        label: context.l10n.playbackHistory,
        icon: Icons.history_rounded,
        builder: _buildPlaybackHistoryTab,
      ),
    _RoomSettingsSection(
      label: context.l10n.reports,
      icon: Icons.report_gmailerrorred_rounded,
      builder: _buildReportsTab,
    ),
    if (widget.canUseWebRtc)
      _RoomSettingsSection(
        label: context.l10n.network,
        icon: Icons.hub_rounded,
        builder: _buildNetworkTab,
      ),
    _RoomSettingsSection(
      label: context.l10n.streaming,
      icon: Icons.podcasts_rounded,
      builder: _buildStreamsTab,
    ),
    _RoomSettingsSection(
      label: context.l10n.review,
      icon: Icons.fact_check_rounded,
      builder: _buildReviewsTab,
    ),
  ];

  Widget _buildPlaybackHistoryTab(ThemeData theme, bool isDark) {
    return ListenableBuilder(
      listenable: _playbackHistoryController,
      builder: (context, _) {
        final state = _playbackHistoryController.state;
        if (state.loading && state.entries.isEmpty) {
          return const AppLoadingIndicator();
        }
        if (state.entries.isEmpty) {
          return Center(child: Text(context.l10n.playbackHistoryEmpty));
        }
        return AppRefreshIndicator(
          onRefresh: _loadPlaybackHistory,
          child: PlaybackHistoryList(
            entries: state.entries,
            historyCursorId: state.cursorId,
            unknownSourceLabel: context.l10n.unknownVideo,
            playTooltip: context.l10n.playHistoryEntry,
            sourceDetailsBuilder: (entry) {
              if (!entry.hasSourceProvider()) return '';
              final provider =
                  _mediaSourceLabels[entry.sourceProvider] ??
                  SourceConfigCodec.providerToString(entry.sourceProvider);
              final instance = entry.providerInstanceName.trim();
              return instance.isEmpty ? provider : '$provider · $instance';
            },
            playingEntryId: state.playingEntryId,
            canPlay: widget.canNavigatePlayback,
            onPlay: _playHistoryEntry,
          ),
        );
      },
    );
  }

  Map<source_enum.SourceProvider, String> get _mediaSourceLabels => {
    source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED:
        context.l10n.allSources,
    source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL:
        context.l10n.directLink,
    source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI: 'Bilibili',
    source_enum.SourceProvider.SOURCE_PROVIDER_ALIST: 'AList',
    source_enum.SourceProvider.SOURCE_PROVIDER_EMBY: 'Emby',
    source_enum.SourceProvider.SOURCE_PROVIDER_RTMP: 'RTMP',
    source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE: 'Cloudreve',
    source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH: 'Twitch',
    source_enum.SourceProvider.SOURCE_PROVIDER_YOUTUBE: 'YouTube',
    source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN: 'Douyin',
    source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK: 'TikTok',
    source_enum.SourceProvider.SOURCE_PROVIDER_HUYA: 'Huya',
    source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU: 'Douyu',
    source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN: 'AcFun',
    source_enum.SourceProvider.SOURCE_PROVIDER_CCTV: 'CCTV',
    source_enum.SourceProvider.SOURCE_PROVIDER_FNOS: 'FNOS',
    source_enum.SourceProvider.SOURCE_PROVIDER_QNAP: 'QNAP',
  };

  String _providerInstanceLabel(String instanceName) =>
      instanceName.isEmpty ? context.l10n.localInstance : instanceName;

  String get _currentPlaylistId =>
      _mediaPlaylistStack.isEmpty ? '' : _mediaPlaylistStack.last;

  String get _mediaTarget =>
      _mediaTargetStack.isEmpty ? '' : _mediaTargetStack.last;

  bool get _isInsideDynamicMediaPlaylist =>
      _mediaPlaylistEntryStack.any((entry) => entry.isDynamicPlaylist);

  bool get _canMutateCurrentMediaScope =>
      _mediaTarget.isEmpty && !_isInsideDynamicMediaPlaylist;

  bool _canOpenMediaEntry(RoomMediaEntry entry) {
    return PlaylistSelectionPolicy.canActivate(
      entry: entry,
      viewerId: _currentUserId,
      canControlPlayback: false,
    );
  }

  Future<void> _openMediaEntry(RoomMediaEntry entry) async {
    if (!_canOpenMediaEntry(entry)) {
      if (!entry.isAvailable) {
        AppNotifications.showError(context, context.l10n.creatorUnavailable);
      } else if (entry.isPlaylist) {
        AppNotifications.showError(
          context,
          context.l10n.dynamicPlaylistCreatorOnly,
        );
      }
      return;
    }
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
      _mediaSearchController.clear();
      _mediaPage = null;
      _mediaWatchVersion = '';
    });
    _startMediaWatch();
    await _loadMediaLibrary();
  }

  Future<bool> _handleMediaBack() async {
    if (_mediaTargetStack.isNotEmpty) {
      setState(() {
        _mediaTargetStack.removeLast();
        _mediaPage = null;
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
        _mediaPage = null;
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
      await _roomGateway.kickRoomStream(
        widget.roomId,
        stream.mediaId,
        reason: 'Kicked from room settings',
      );
      await _loadStreams();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.streamDisconnected);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.disconnectStreamFailed('$e'),
        );
      }
    }
  }

  Future<void> _showStreamInfo(RoomStreamEntryInfo stream) async {
    try {
      final detail = await _roomGateway.getRoomStreamInfo(
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
                        color: detail.active
                            ? Colors.green
                            : theme.disabledColor,
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
                  _buildDetailLine(
                    context.l10n.status,
                    detail.active ? context.l10n.active : context.l10n.inactive,
                  ),
                  _buildDetailLine(
                    context.l10n.publisher,
                    detail.publisherUserId.isEmpty
                        ? context.l10n.unknownPublisher
                        : detail.publisherUserId,
                  ),
                  _buildDetailLine(
                    context.l10n.startTime,
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
                          AppNotifications.showSuccess(
                            context,
                            context.l10n.mediaIdCopied,
                          );
                        },
                        icon: Icons.copy_rounded,
                        label: context.l10n.copyId,
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
                        label: context.l10n.disconnectStream,
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
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadStreamDetailsFailed('$e'),
        );
      }
    }
  }

  Future<void> _approveReview(RoomJoinReviewInfo review) async {
    try {
      await _roomGateway.approveRoomJoinReview(widget.roomId, review.id);
      await _loadReviews();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.requestApproved);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.reviewFailed('$e'));
      }
    }
  }

  Future<void> _rejectReview(RoomJoinReviewInfo review) async {
    final reason = await _showRejectReasonDialog();
    if (reason == null) return;
    try {
      await _roomGateway.rejectRoomJoinReview(
        widget.roomId,
        review.id,
        reason: reason,
      );
      await _loadReviews();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.requestRejected);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.reviewFailed('$e'));
      }
    }
  }

  Future<void> _addMember() async {
    final result = await _showMemberEditDialog();
    if (result == null) return;
    try {
      await _roomGateway.addRoomMember(
        widget.roomId,
        result.userId,
        role: result.role,
        notify: result.notify,
      );
      await _loadMembers();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.memberAdded);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addMemberFailed('$e'));
      }
    }
  }

  Future<void> _setMemberRole(AdminRoomMember member) async {
    final result = await _showMemberRoleDialog(member.role);
    if (result == null || result == member.role) return;
    try {
      final updatedMember = await _roomGateway.setRoomMemberRole(
        widget.roomId,
        member.userId,
        result,
      );
      if (!mounted) return;
      setState(() {
        final index = _members.indexWhere(
          (item) => item.userId == updatedMember.userId,
        );
        if (index >= 0) _members[index] = updatedMember;
      });
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.memberRoleUpdated);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateRoleFailed('$e'),
        );
      }
    }
  }

  Future<void> _editMemberPermissionOverrides(AdminRoomMember member) async {
    final result = await _showMemberPermissionOverrideDialog(member);
    if (result == null) return;
    try {
      await _roomGateway.updateRoomMemberPermissionOverrides(
        widget.roomId,
        member.userId,
        addedPermissions: result.addedPermissions,
        removedPermissions: result.removedPermissions,
        adminAddedPermissions: result.adminAddedPermissions,
        adminRemovedPermissions: result.adminRemovedPermissions,
      );
      await _loadMembers();
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.memberPermissionsUpdated,
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updatePermissionsFailed('$e'),
        );
      }
    }
  }

  Future<void> _editMemberRemarkName(AdminRoomMember member) async {
    final value = await _showMemberTextDialog(
      title: context.l10n.remarkName,
      label: context.l10n.remarkName,
      initialValue: member.remarkName,
      icon: Icons.drive_file_rename_outline_rounded,
    );
    if (value == null || value == member.remarkName) return;
    try {
      await _roomGateway.updateRoomMemberRemarkName(
        widget.roomId,
        member.userId,
        value,
      );
      await _loadMembers();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.remarkNameUpdated);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateRemarkNameFailed('$e'),
        );
      }
    }
  }

  Future<void> _editMemberDisplayTag(AdminRoomMember member) async {
    final value = await _showMemberTextDialog(
      title: context.l10n.displayLabel,
      label: context.l10n.displayLabel,
      initialValue: member.displayTag,
      icon: Icons.sell_outlined,
    );
    if (value == null || value == member.displayTag) return;
    try {
      await _roomGateway.updateRoomMemberDisplayTag(
        widget.roomId,
        member.userId,
        value,
      );
      await _loadMembers();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.displayLabelUpdated);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateDisplayLabelFailed('$e'),
        );
      }
    }
  }

  Future<void> _transferOwnership(AdminRoomMember member) async {
    final confirmed = await _confirm(
      title: context.l10n.transferOwnership,
      content: context.l10n.confirmTransferOwnership(member.username),
      action: context.l10n.transfer,
    );
    if (!confirmed) return;
    try {
      await _roomGateway.transferRoomOwnership(widget.roomId, member.userId);
      await _loadMembers();
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.ownershipTransferred,
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.transferFailed('$e'));
      }
    }
  }

  Future<void> _kickMember(AdminRoomMember member) async {
    final cooldown = await _askKickCooldownSeconds(member.username);
    if (cooldown == null) return;
    try {
      await _roomGateway.kickMember(
        widget.roomId,
        member.userId,
        kickCooldownSeconds: cooldown,
      );
      await _loadMembers();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.memberRemoved);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.removeMemberFailed('$e'),
        );
      }
    }
  }

  Future<void> _reportRoomMember(AdminRoomMember member) async {
    if (member.userId.isEmpty) return;
    await _showReportContentDialog(
      title: context.l10n.reportMember,
      targetLabel: member.username.isEmpty ? member.userId : member.username,
      submit: (reasonCode, reason) => _chatGateway.reportMember(
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
      title: context.l10n.reportUser,
      targetLabel: member.username.isEmpty ? member.userId : member.username,
      submit: (reasonCode, reason) => _chatGateway.reportUser(
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
    final reasons = <String, String>{
      'spam': context.l10n.reportReasonSpam,
      'abuse': context.l10n.reportReasonAbuse,
      'illegal': context.l10n.reportReasonIllegal,
      'sexual': context.l10n.reportReasonSexual,
      'other': context.l10n.reportReasonOther,
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
                      label: context.l10n.additionalDetails,
                      hintText: context.l10n.describeIssue,
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
                  label: context.l10n.cancel,
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  label: context.l10n.submit,
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
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.reportSubmitted);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.reportFailed('$e'));
      }
    } finally {
      detailController.dispose();
    }
  }

  Future<int?> _askKickCooldownSeconds(String username) async {
    final controller = TextEditingController(text: '60');
    final value = await showAppDialog<int>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: Text(context.l10n.removeMember),
        icon: const Icon(Icons.logout_rounded),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.confirmRemoveMember(username)),
            const SizedBox(height: 12),
            AppTextField(
              controller: controller,
              label: context.l10n.cooldownSeconds,
              hintText: '1 - 2592000',
              prefixIcon: Icons.timer_outlined,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          AppActionButton(
            onPressed: () => Navigator.pop(dialogContext),
            label: context.l10n.cancel,
            style: AppActionButtonStyle.text,
          ),
          AppActionButton(
            onPressed: () {
              final seconds = int.tryParse(controller.text.trim());
              if (seconds == null || seconds < 1 || seconds > 2592000) {
                AppNotifications.showWarning(
                  context,
                  context.l10n.cooldownSecondsRange,
                );
                return;
              }
              Navigator.pop(dialogContext, seconds);
            },
            icon: Icons.logout_rounded,
            label: context.l10n.remove,
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
      title: context.l10n.resetSettings,
      content: context.l10n.resetRoomSettingsDescription,
      action: context.l10n.reset,
    );
    if (!confirmed) return;
    try {
      await _roomGateway.resetRoomSettings(widget.roomId);
      final settings = await _roomGateway.getRoomSettings(
        widget.roomId,
        refresh: true,
      );
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _applySettings(settings);
      });
      AppNotifications.showSuccess(context, context.l10n.settingsReset);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.resetFailed('$e'));
      }
    }
  }

  Future<void> _leaveRoom() async {
    final confirmed = await _confirm(
      title: context.l10n.leaveRoom,
      content: context.l10n.confirmLeaveRoom(widget.roomName),
      action: context.l10n.leave,
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await _roomGateway.leaveRoom(widget.roomId);
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, context.l10n.leftRoom);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.leaveRoomFailed('$e'));
      }
    }
  }

  Future<void> _deleteRoom() async {
    final confirmed = await _confirm(
      title: context.l10n.deleteRoom,
      content: context.l10n.confirmPermanentRoomDeletion(widget.roomName),
      action: context.l10n.delete,
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await _roomGateway.deleteRoom(widget.roomId);
      if (!mounted) return;
      Navigator.pop(context, true);
      AppNotifications.showSuccess(context, context.l10n.roomDeleted);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.deleteFailed('$e'));
      }
    }
  }

  Future<void> _createPlaylist() async {
    if (!_canMutateCurrentMediaScope) {
      AppNotifications.showInfo(context, context.l10n.dynamicContentReadOnly);
      return;
    }
    final input = await _showEntryEditDialog(
      title: context.l10n.newPlaylist,
      playlistBrowseAccessMode: client_enum
          .PlaylistBrowseAccessMode
          .PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
    );
    if (input == null || input.name.isEmpty) return;
    try {
      await _mediaLibraryGateway.createPlaylist(
        widget.roomId,
        name: input.name,
        parentId: _currentPlaylistId,
        description: input.description,
        browseAccessMode:
            input.playlistBrowseAccessMode ??
            client_enum
                .PlaylistBrowseAccessMode
                .PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
      );
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.playlistCreated);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.createPlaylistFailed('$e'),
        );
      }
    }
  }

  Future<void> _addMediaToCurrentScope() async {
    if (!_canMutateCurrentMediaScope) {
      AppNotifications.showInfo(context, context.l10n.dynamicContentReadOnly);
      return;
    }
    await AddMediaDialog.show(
      context,
      widget.roomId,
      parentId: _currentPlaylistId.isEmpty ? null : _currentPlaylistId,
    );
    await _loadMediaLibrary();
  }

  Future<void> _clearCurrentMediaScope() async {
    if (!_canMutateCurrentMediaScope) {
      AppNotifications.showInfo(context, context.l10n.dynamicContentReadOnly);
      return;
    }
    final playlistId = _currentPlaylistId;
    final confirmed = await _confirm(
      title: playlistId.isEmpty
          ? context.l10n.clearMediaLibrary
          : context.l10n.clearPlaylist,
      content: playlistId.isEmpty
          ? context.l10n.confirmClearMediaLibrary
          : context.l10n.confirmClearPlaylist,
      action: context.l10n.clear,
      destructive: true,
    );
    if (!confirmed) return;

    try {
      await _mediaLibraryGateway.clearMediaLibrary(
        widget.roomId,
        parentId: playlistId.isEmpty ? null : playlistId,
      );
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.mediaLibraryCleared);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.clearFailed('$e'));
      }
    }
  }

  Future<void> _renameEntry(RoomMediaEntry entry) async {
    if (!_canMutateCurrentMediaScope || entry.isProviderDynamicItem) {
      AppNotifications.showInfo(context, context.l10n.dynamicContentReadOnly);
      return;
    }
    provider_common.PlaybackProxyPolicy? playbackProxyPolicy;
    final mediaSourceConfig = entry.id.startsWith('med_')
        ? SourceConfigCodec.mediaSourceConfigFromMap(
            sourceProvider: entry.sourceProvider,
            sourceConfig: entry.sourceConfig,
          )
        : null;
    final playlistSourceConfig = entry.id.startsWith('pl_')
        ? SourceConfigCodec.playlistSourceConfigFromMap(
            sourceProvider: entry.sourceProvider,
            sourceConfig: entry.sourceConfig,
          )
        : null;
    final discoveredSource = switch ((
      mediaSourceConfig,
      playlistSourceConfig,
    )) {
      (final media?, _) => provider_common.DiscoveredSource(
        media: media,
        providerInstanceName: entry.providerInstanceName,
      ),
      (_, final playlist?) => provider_common.DiscoveredSource(
        playlist: playlist,
        providerInstanceName: entry.providerInstanceName,
      ),
      _ => null,
    };
    if (discoveredSource != null) {
      try {
        playbackProxyPolicy = await DependencyScope.read<ProviderGateway>(
          context,
        ).resolvePlaybackProxyPolicy(discoveredSource);
      } catch (error) {
        if (mounted) {
          AppNotifications.showWarning(
            context,
            context.l10n.playbackProxyPolicyUnavailable('$error'),
          );
        }
      }
    }
    if (!mounted) return;
    final input = await _showEntryEditDialog(
      title: entry.isPlaylist
          ? context.l10n.editPlaylist
          : context.l10n.editMedia,
      initialName: entry.name,
      initialDescription: entry.description,
      playbackProxyPolicy: playbackProxyPolicy,
      playlistBrowseAccessMode: entry.isPlaylist
          ? entry.browseAccessMode
          : null,
    );
    if (input == null || input.name.isEmpty) return;
    final playbackProxyMode = input.playbackProxyMode;
    final playbackProxyModeChanged =
        playbackProxyMode != null &&
        playbackProxyMode != playbackProxyPolicy?.currentMode;
    final playlistBrowseAccessModeChanged =
        input.playlistBrowseAccessMode != null &&
        input.playlistBrowseAccessMode != entry.browseAccessMode;
    if (input.name == entry.name &&
        input.description == entry.description &&
        !playbackProxyModeChanged &&
        !playlistBrowseAccessModeChanged) {
      return;
    }
    try {
      if (entry.id.startsWith('pl_')) {
        await _mediaLibraryGateway.updatePlaylist(
          widget.roomId,
          entry.id,
          name: input.name,
          description: input.description,
          browseAccessMode: playlistBrowseAccessModeChanged
              ? input.playlistBrowseAccessMode
              : null,
          sourceConfig: playbackProxyModeChanged && playlistSourceConfig != null
              ? provider_common.DiscoveredSource(
                  playlist: playlistSourceConfig,
                  providerInstanceName: entry.providerInstanceName,
                ).withPlaybackProxyMode(playbackProxyMode).requirePlaylist()
              : null,
        );
      } else if (entry.id.startsWith('med_')) {
        await _mediaLibraryGateway.editMedia(
          widget.roomId,
          entry.id,
          name: input.name,
          description: input.description,
          playbackProxyMode: playbackProxyModeChanged
              ? playbackProxyMode
              : null,
        );
      }
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          playbackProxyModeChanged || playlistBrowseAccessModeChanged
              ? context.l10n.settingsUpdated
              : context.l10n.nameUpdated,
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.renameFailed('$e'));
      }
    }
  }

  Future<void> _deleteEntry(RoomMediaEntry entry) async {
    if (!_canMutateCurrentMediaScope || entry.isProviderDynamicItem) {
      AppNotifications.showInfo(context, context.l10n.dynamicContentReadOnly);
      return;
    }
    final confirmed = await _confirm(
      title: context.l10n.deleteEntries,
      content: entry.isPlaylist
          ? context.l10n.confirmDeletePlaylist(entry.name)
          : context.l10n.confirmDeleteMedia(entry.name),
      action: context.l10n.delete,
      destructive: true,
    );
    if (!confirmed) return;
    try {
      if (entry.id.startsWith('pl_')) {
        await _mediaLibraryGateway.deletePlaylist(
          widget.roomId,
          entry.id,
          force: true,
        );
      } else if (entry.id.startsWith('med_')) {
        await _mediaLibraryGateway.deleteMedia(widget.roomId, entry.id);
      }
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.entryDeleted);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.deleteEntryFailed('$e'),
        );
      }
    }
  }

  Future<void> _showMediaEntryDetails(RoomMediaEntry entry) async {
    try {
      var detail = entry;
      PlaylistDetailInfo? playlistDetail;
      if (entry.id.startsWith('pl_')) {
        playlistDetail = await _mediaLibraryGateway.getPlaylist(
          widget.roomId,
          entry.id,
        );
        detail = playlistDetail.playlist;
      } else if (entry.id.startsWith('med_')) {
        detail = await _mediaLibraryGateway.getMedia(widget.roomId, entry.id);
      }
      if (!mounted) return;
      await showAppBottomSheet<void>(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          final isPlaylist = detail.id.startsWith('pl_');
          final canMutate =
              _canMutateCurrentMediaScope &&
              (detail.id.startsWith('pl_') || detail.id.startsWith('med_')) &&
              !detail.isProviderDynamicItem;
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
                      context.l10n.type,
                      isPlaylist
                          ? detail.metadata['isDynamic'] == true
                                ? context.l10n.dynamicPlaylist
                                : context.l10n.playlist
                          : detail.isPlaylist
                          ? context.l10n.dynamicPlaylist
                          : detail.live
                          ? context.l10n.liveMedia
                          : context.l10n.media,
                    ),
                    _buildDetailLine(
                      'Provider',
                      !SourceConfigCodec.isSpecified(detail.sourceProvider)
                          ? '-'
                          : SourceConfigCodec.providerToString(
                              detail.sourceProvider,
                            ),
                    ),
                    _buildDetailLine(
                      context.l10n.instance,
                      detail.providerInstanceName.isEmpty
                          ? '-'
                          : detail.providerInstanceName,
                    ),
                    if (detail.parentId?.isNotEmpty == true)
                      _buildDetailLine(context.l10n.parent, detail.parentId!),
                    if (detail.description.isNotEmpty)
                      _buildDetailLine(
                        context.l10n.description,
                        detail.description,
                      ),
                    if (detail.thumbnailUrl.isNotEmpty)
                      _buildDetailLine(
                        context.l10n.thumbnail,
                        detail.thumbnailUrl,
                      ),
                    if (detail.url.isNotEmpty)
                      _buildDetailLine('URL', detail.url),
                    if (detail.subPath?.isNotEmpty == true)
                      _buildDetailLine('Sub path', detail.subPath!),
                    if (playlistDetail != null) ...[
                      _buildDetailLine(
                        context.l10n.childPlaylists,
                        playlistDetail.childPlaylistCount.toString(),
                      ),
                      _buildDetailLine(
                        context.l10n.mediaCount,
                        playlistDetail.mediaCount.toString(),
                      ),
                    ],
                    if (detail.metadata.isNotEmpty)
                      _buildDetailLine(
                        context.l10n.metadata,
                        _compactMap(detail.metadata),
                      ),
                    if (detail.sourceConfig.isNotEmpty)
                      _buildDetailLine(
                        context.l10n.sourceConfiguration,
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
                            AppNotifications.showSuccess(
                              context,
                              context.l10n.idCopied,
                            );
                          },
                          icon: Icons.copy_rounded,
                          label: context.l10n.copyId,
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
                            label: context.l10n.edit,
                            style: AppActionButtonStyle.tonal,
                          ),
                          const SizedBox(width: 8),
                          AppActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _updateEntryCover(detail);
                            },
                            icon: Icons.image_outlined,
                            label: context.l10n.cover,
                            style: AppActionButtonStyle.tonal,
                          ),
                          if (detail.id.startsWith('med_')) ...[
                            const SizedBox(width: 8),
                            AppActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _updateEntryThumbnail(detail);
                              },
                              icon: Icons.photo_size_select_actual_outlined,
                              label: context.l10n.thumbnail,
                              style: AppActionButtonStyle.tonal,
                            ),
                          ],
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
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadEntryDetailsFailed('$e'),
        );
      }
    }
  }

  Future<void> _updateEntryCover(RoomMediaEntry entry) async {
    if (!_canMutateCurrentMediaScope ||
        entry.isProviderDynamicItem ||
        (!entry.id.startsWith('pl_') && !entry.id.startsWith('med_'))) {
      return;
    }
    try {
      final image = await pickLocalImageUpload(context, aspectRatio: 16 / 9);
      if (image == null || !mounted) return;
      if (entry.id.startsWith('pl_')) {
        await _mediaLibraryGateway.updatePlaylistCover(
          widget.roomId,
          entry.id,
          image.upload,
        );
      } else {
        await _mediaLibraryGateway.updateVideoCover(
          widget.roomId,
          entry.id,
          image.upload,
        );
      }
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.coverUpdated);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateCoverFailed('$e'),
        );
      }
    }
  }

  Future<void> _clearEntryCover(RoomMediaEntry entry) async {
    if (!_canMutateCurrentMediaScope ||
        entry.isProviderDynamicItem ||
        (!entry.id.startsWith('pl_') && !entry.id.startsWith('med_'))) {
      return;
    }
    try {
      if (entry.id.startsWith('pl_')) {
        await _mediaLibraryGateway.clearPlaylistCover(widget.roomId, entry.id);
      } else {
        await _mediaLibraryGateway.clearVideoCover(widget.roomId, entry.id);
      }
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.coverRemoved);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.removeCoverFailed('$e'),
        );
      }
    }
  }

  Future<void> _updateEntryThumbnail(RoomMediaEntry entry) async {
    if (!_canMutateCurrentMediaScope ||
        entry.isProviderDynamicItem ||
        !entry.id.startsWith('med_')) {
      return;
    }
    try {
      final image = await pickLocalImageUpload(context, aspectRatio: 16 / 9);
      if (image == null || !mounted) return;
      await _mediaLibraryGateway.updateVideoThumbnail(
        widget.roomId,
        entry.id,
        image.upload,
      );
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.thumbnailUpdated);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateThumbnailFailed('$e'),
        );
      }
    }
  }

  Future<void> _clearEntryThumbnail(RoomMediaEntry entry) async {
    if (!_canMutateCurrentMediaScope ||
        entry.isProviderDynamicItem ||
        !entry.id.startsWith('med_')) {
      return;
    }
    try {
      await _mediaLibraryGateway.clearVideoThumbnail(widget.roomId, entry.id);
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.thumbnailRemoved);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.removeThumbnailFailed('$e'),
        );
      }
    }
  }

  Future<void> _editChatMessage(RoomChatMessageInfo message) async {
    if (message.isDeleted) {
      AppNotifications.showInfo(context, context.l10n.deletedMessageCannotEdit);
      return;
    }
    final content = await _showChatMessageEditDialog(message.content);
    if (content == null || content == message.content) return;
    try {
      await _chatGateway.edit(
        widget.roomId,
        message.id,
        content: content,
        expectedVersion: message.version,
      );
      await _loadChatHistory();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.messageUpdated);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.editMessageFailed('$e'),
        );
      }
    }
  }

  Future<String?> _showChatMessageEditDialog(String initialContent) {
    return AppDialogs.showStyledDialog<String>(
      context: context,
      title: context.l10n.editMessage,
      icon: const Icon(Icons.edit_outlined),
      content: _ChatMessageEditForm(initialContent: initialContent),
      actions: const [],
    );
  }

  Future<void> _deleteChatMessage(RoomChatMessageInfo message) async {
    if (message.isDeleted) return;
    final confirmed = await _confirm(
      title: context.l10n.deleteMessage,
      content: context.l10n.confirmDeleteChatMessage,
      action: context.l10n.delete,
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await _chatGateway.delete(
        widget.roomId,
        message.id,
        expectedVersion: message.version,
      );
      await _loadChatHistory();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.messageDeleted);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.deleteMessageFailed('$e'),
        );
      }
    }
  }

  Future<void> _toggleChatPin(RoomChatMessageInfo message) async {
    if (message.isDeleted) return;
    try {
      final event = message.isPinned
          ? await _chatGateway.unpin(widget.roomId, message.id)
          : await _chatGateway.pin(widget.roomId, message.id);
      if (!mounted) return;
      setState(() => _applyChatPinEvent(event));
      AppNotifications.showSuccess(
        context,
        message.isPinned
            ? context.l10n.messageUnpinned
            : context.l10n.messagePinned,
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          message.isPinned
              ? context.l10n.unpinMessageFailed('$e')
              : context.l10n.pinMessageFailed('$e'),
        );
      }
    }
  }

  Future<void> _openRoomScopedReportsViewer({
    required String title,
    admin_enum.ContentReportTargetType targetType = admin_enum
        .ContentReportTargetType
        .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    String targetMemberUserId = '',
    int targetChatMessageId = 0,
  }) {
    return AppDialogs.showStyledDialog<void>(
      context: context,
      title: title,
      icon: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.red),
      content: SizedBox(
        width: 900,
        height: 620,
        child: ContentReportsView(
          title: '',
          initialTargetType: targetType,
          roomScopedRoomId: widget.roomId,
          initialTargetMemberUserId: targetMemberUserId,
          initialTargetChatMessageId: targetChatMessageId,
          showTargetTypeTabs:
              targetType ==
              admin_enum
                  .ContentReportTargetType
                  .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
        ),
      ),
      actions: [AppDialogs.createCancelButton(context)],
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
                  context.l10n.roomReportManagement(widget.roomName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              AppActionButton(
                onPressed: _reportCurrentRoom,
                icon: Icons.flag_outlined,
                label: context.l10n.reportRoom,
                size: AppActionButtonSize.sm,
                style: AppActionButtonStyle.outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ContentReportsView(
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
      title: context.l10n.reportRoom,
      targetLabel: widget.roomName,
      submit: (reasonCode, reason) => _chatGateway.reportRoom(
        widget.roomId,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _showChatMessageContext(RoomChatMessageInfo message) async {
    try {
      final contextInfo = await _chatGateway.getContext(
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
                    context.l10n.messageContext,
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
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadMessageContextFailed('$e'),
        );
      }
    }
  }

  Future<void> _moveMedia(RoomMediaEntry entry) async {
    if (!_canMutateCurrentMediaScope || entry.isProviderDynamicItem) {
      AppNotifications.showInfo(context, context.l10n.dynamicContentReadOnly);
      return;
    }
    if (!entry.id.startsWith('med_')) return;
    final target = await _showMoveMediaTargetDialog(entry);
    if (target == null) return;
    final targetPlaylistId = target.playlistId;
    final sourcePlaylistId = _currentPlaylistId.isEmpty
        ? null
        : _currentPlaylistId;
    if ((sourcePlaylistId ?? '') == targetPlaylistId) return;
    try {
      final count = await _mediaLibraryGateway.moveMedia(
        widget.roomId,
        mediaIds: [entry.id],
        sourcePlaylistId: sourcePlaylistId,
        targetPlaylistId: targetPlaylistId.isEmpty ? null : targetPlaylistId,
      );
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.mediaItemsMoved(count),
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.moveFailed('$e'));
      }
    }
  }

  Future<void> _movePlaylistRelative(
    RoomMediaEntry entry,
    int direction,
  ) async {
    if (!_canMutateCurrentMediaScope || entry.isProviderDynamicItem) {
      AppNotifications.showInfo(context, context.l10n.dynamicContentReadOnly);
      return;
    }
    if (!entry.id.startsWith('pl_')) return;
    final playlists = _mediaPage?.playlists ?? const <RoomMediaEntry>[];
    final index = playlists.indexWhere((item) => item.id == entry.id);
    if (index < 0) return;
    final isUp = direction < 0;
    if (isUp && index == 0) return;
    if (!isUp && index >= playlists.length - 1) return;

    try {
      if (isUp) {
        await _mediaLibraryGateway.movePlaylist(
          widget.roomId,
          entry.id,
          beforePlaylistId: playlists[index - 1].id,
        );
      } else {
        await _mediaLibraryGateway.movePlaylist(
          widget.roomId,
          entry.id,
          afterPlaylistId: playlists[index + 1].id,
        );
      }
      await _loadMediaLibrary();
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.playlistOrderUpdated,
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.reorderFailed('$e'));
      }
    }
  }

  Future<_MediaMoveTarget?> _showMoveMediaTargetDialog(
    RoomMediaEntry entry,
  ) async {
    var loading = true;
    var error = '';
    var playlists = <RoomMediaEntry>[];

    Future<void> loadPlaylists(StateSetter setDialogState) async {
      setDialogState(() {
        loading = true;
        error = '';
      });
      try {
        final page = await _mediaLibraryGateway.listPlaylistsPage(
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
              title: Text(context.l10n.moveMedia),
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
                      title: Text(context.l10n.mediaLibraryRoot),
                      enabled: _currentPlaylistId.isNotEmpty,
                      onPressed: _currentPlaylistId.isEmpty
                          ? null
                          : () => Navigator.pop(
                              context,
                              _MediaMoveTarget(
                                '',
                                context.l10n.mediaLibraryRoot,
                              ),
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
                                  : Text(
                                      context.l10n.parentId(playlist.parentId!),
                                    ),
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
                  label: context.l10n.cancel,
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: loading
                      ? null
                      : () => loadPlaylists(setDialogState),
                  icon: Icons.refresh,
                  label: context.l10n.refresh,
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
    return AppDialogs.showStyledDialog<String>(
      context: context,
      title: context.l10n.rejectRequest,
      icon: const Icon(Icons.block_rounded),
      iconColor: Theme.of(context).colorScheme.error,
      content: AppTextField(
        controller: controller,
        label: context.l10n.reason,
        autofocus: true,
        maxLines: 3,
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          icon: Icons.block_rounded,
          label: context.l10n.reject,
          style: AppActionButtonStyle.destructive,
        ),
      ],
    ).whenComplete(() => _disposeTextControllersAfterDialog([controller]));
  }

  Future<_EntryEditResult?> _showEntryEditDialog({
    required String title,
    String initialName = '',
    String initialDescription = '',
    provider_common.PlaybackProxyPolicy? playbackProxyPolicy,
    client_enum.PlaylistBrowseAccessMode? playlistBrowseAccessMode,
  }) {
    final nameController = TextEditingController(text: initialName);
    final descriptionController = TextEditingController(
      text: initialDescription,
    );
    var playbackProxyMode = playbackProxyPolicy?.currentMode;
    var selectedPlaylistBrowseAccessMode = playlistBrowseAccessMode;
    return AppDialogs.showStyledDialog<_EntryEditResult>(
      context: context,
      title: title,
      icon: const Icon(Icons.edit_outlined),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameController,
                label: context.l10n.name,
                autofocus: true,
                onSubmitted: (_) {
                  Navigator.pop(
                    context,
                    _EntryEditResult(
                      nameController.text.trim(),
                      descriptionController.text.trim(),
                      playbackProxyMode,
                      selectedPlaylistBrowseAccessMode,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: descriptionController,
                label: context.l10n.description,
                minLines: 2,
                maxLines: 4,
              ),
              if (playbackProxyPolicy != null && playbackProxyMode != null) ...[
                const SizedBox(height: 16),
                PlaybackProxyModeControl(
                  value: playbackProxyMode!,
                  policy: playbackProxyPolicy,
                  onChanged: (value) =>
                      setDialogState(() => playbackProxyMode = value),
                ),
              ],
              if (selectedPlaylistBrowseAccessMode != null) ...[
                const SizedBox(height: 16),
                AppSelect<client_enum.PlaylistBrowseAccessMode>(
                  value: selectedPlaylistBrowseAccessMode,
                  label: context.l10n.playlistBrowseAccess,
                  description: context.l10n.playlistBrowseAccessDescription,
                  prefixIcon: Icons.visibility_outlined,
                  options: {
                    context.l10n.playlistBrowseAccessModeDefault: client_enum
                        .PlaylistBrowseAccessMode
                        .PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
                    context.l10n.playlistBrowseAccessModeRoomMembers:
                        client_enum
                            .PlaylistBrowseAccessMode
                            .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS,
                    context.l10n.playlistBrowseAccessModeCreatorOnly:
                        client_enum
                            .PlaylistBrowseAccessMode
                            .PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY,
                  },
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(
                        () => selectedPlaylistBrowseAccessMode = value,
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(
            context,
            _EntryEditResult(
              nameController.text.trim(),
              descriptionController.text.trim(),
              playbackProxyMode,
              selectedPlaylistBrowseAccessMode,
            ),
          ),
          text: context.l10n.save,
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
    var role = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER;
    var notify = true;
    return AppDialogs.showStyledDialog<_MemberEditResult>(
      context: context,
      title: context.l10n.addMember,
      icon: const Icon(Icons.person_add_alt_1_rounded),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: userIdController,
                label: context.l10n.userId,
                prefixIcon: Icons.person_outline_rounded,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              AppSelect<common_enum.RoomMemberRole>(
                value: role,
                label: context.l10n.role,
                prefixIcon: Icons.admin_panel_settings_outlined,
                options: {
                  context.l10n.administrator:
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                  context.l10n.member:
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                  context.l10n.guest:
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
                },
                onChanged: (value) {
                  if (value != null) setDialogState(() => role = value);
                },
              ),
              const SizedBox(height: 12),
              AppSwitchTile(
                title: Text(context.l10n.sendNotification),
                value: notify,
                onChanged: (value) => setDialogState(() => notify = value),
              ),
            ],
          );
        },
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        AppDialogs.createConfirmButton(context, () {
          final userId = userIdController.text.trim();
          if (userId.isEmpty) return;
          Navigator.pop(context, _MemberEditResult(userId, role, notify));
        }, text: context.l10n.add),
      ],
    ).whenComplete(
      () => _disposeTextControllersAfterDialog([userIdController]),
    );
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

  Future<common_enum.RoomMemberRole?> _showMemberRoleDialog(
    common_enum.RoomMemberRole currentRole,
  ) {
    var role =
        currentRole == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR
        ? common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER
        : currentRole;
    return AppDialogs.showStyledDialog<common_enum.RoomMemberRole>(
      context: context,
      title: context.l10n.changeRole,
      icon: const Icon(Icons.admin_panel_settings_outlined),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return AppSelect<common_enum.RoomMemberRole>(
            value: role,
            label: context.l10n.role,
            prefixIcon: Icons.admin_panel_settings_outlined,
            options: {
              context.l10n.administrator:
                  common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
              context.l10n.member:
                  common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
              context.l10n.guest:
                  common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
            },
            onChanged: (value) {
              if (value != null) setDialogState(() => role = value);
            },
          );
        },
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, role),
          text: context.l10n.save,
        ),
      ],
    );
  }

  Future<String?> _showMemberTextDialog({
    required String title,
    required String label,
    required String initialValue,
    required IconData icon,
  }) {
    final controller = TextEditingController(text: initialValue);
    void submit() => Navigator.pop(context, controller.text.trim());

    return AppDialogs.showStyledDialog<String>(
      context: context,
      title: title,
      icon: Icon(icon),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: AppTextField(
          controller: controller,
          label: label,
          autofocus: true,
          maxLength: 64,
          onSubmitted: (_) => submit(),
        ),
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        AppDialogs.createConfirmButton(
          context,
          submit,
          text: context.l10n.save,
        ),
      ],
    ).whenComplete(() => _disposeTextControllersAfterDialog([controller]));
  }

  Future<_MemberPermissionOverrideResult?> _showMemberPermissionOverrideDialog(
    AdminRoomMember member,
  ) {
    final isAdmin =
        member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN;
    var added = isAdmin
        ? member.adminAddedPermissions
        : member.addedPermissions;
    var removed = isAdmin
        ? member.adminRemovedPermissions
        : member.removedPermissions;
    final permissions = isAdmin
        ? RoomAdminPermissions.values
        : RoomMemberPermissions.values;

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
              title: Text(context.l10n.permissionOverrides),
              body: SizedBox(
                width: 440,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 520),
                  child: AppListView(
                    shrinkWrap: true,
                    children: permissions
                        .map(
                          (permission) => _buildPermissionOverrideRow(
                            isAdmin
                                ? context.l10n.roomAdminPermissionLabel(
                                    permission,
                                  )
                                : context.l10n.roomMemberPermissionLabel(
                                    permission,
                                  ),
                            permission,
                            added,
                            removed,
                            setOverride,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.pop(context),
                  label: context.l10n.cancel,
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: () {
                    setDialogState(() {
                      added = 0;
                      removed = 0;
                    });
                  },
                  label: context.l10n.clearOverrides,
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
                  label: context.l10n.save,
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
            segments: [
              ButtonSegment(
                value: _PermissionOverrideMode.inherit,
                label: Text(context.l10n.inherit),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.allow,
                label: Text(context.l10n.allow),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.deny,
                label: Text(context.l10n.deny),
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
    bool destructive = false,
  }) async {
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: title,
      icon: Icon(
        destructive ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
      ),
      iconColor: destructive ? Theme.of(context).colorScheme.error : null,
      content: Text(content),
      actions: [
        AppDialogs.createCancelButton(context),
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
    ValueChanged<bool>? onChanged,
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

  Widget _buildSurface({required List<Widget> children, required bool isDark}) {
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
    return Border.all(color: isDark ? Colors.white10 : const Color(0xFFE6E7EE));
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
        label: context.l10n.maximumMembers,
        helperText: context.l10n.zeroMeansUnlimited,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Future<void> _saveFreeModeSettings({PlaybackModeConfig? config}) async {
    if (_freeModeSaving) return;
    setState(() => _freeModeSaving = true);
    try {
      await _playbackModePreferences.update(
        (config ?? _playbackModeConfig).normalized(),
      );
      if (!mounted) return;
      setState(() {
        _playbackModeConfig = _playbackModePreferences.value;
      });
      AppNotifications.showSuccess(context, context.l10n.freeModeSettingsSaved);
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.savePreferencesFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _freeModeSaving = false);
    }
  }

  Widget _buildFreeModeTab(ThemeData theme, bool isDark) {
    return AppListView(
      padding: const EdgeInsets.only(bottom: 32, top: 8),
      children: [
        _buildSectionHeader(context.l10n.freeModeSettings, theme),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FreeModeSettingsFields(
            config: _playbackModeConfig,
            onChanged: (value) {
              setState(() => _playbackModeConfig = value);
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildSurface(
          isDark: isDark,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppActionButton(
                      onPressed: _freeModeSaving
                          ? null
                          : () => _saveFreeModeSettings(
                              config: PlaybackModeConfig.defaults,
                            ),
                      label: context.l10n.restoreDefaults,
                      style: AppActionButtonStyle.tonal,
                    ),
                    AppActionButton(
                      onPressed: _freeModeSaving ? null : _saveFreeModeSettings,
                      loading: _freeModeSaving,
                      icon: Icons.save_outlined,
                      label: context.l10n.save,
                      style: AppActionButtonStyle.filled,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_p2pMediaEnabled) ...[
          const SizedBox(height: 20),
          _buildSectionHeader(context.l10n.p2pMedia, theme),
          _buildSurface(
            isDark: isDark,
            children: [
              P2pMediaSettingsFields(preferences: widget.p2pMediaPreferences),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSettingsTab(ThemeData theme, bool isDark) {
    return AppListView(
      padding: const EdgeInsets.only(bottom: 32, top: 8),
      children: [
        _buildSectionHeader(context.l10n.accessControl, theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildSwitchItem(
              context.l10n.publicRoom,
              _isPublic
                  ? context.l10n.publicRoomVisibilityDescription
                  : context.l10n.privateRoomVisibilityDescription,
              _isPublic,
              _visibilityUpdating ? null : _updateRoomVisibility,
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              context.l10n.allowGuestJoin,
              context.l10n.guestTokenCurrentRoomOnly,
              _allowGuestJoin,
              (v) => setState(() => _allowGuestJoin = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              context.l10n.joinRequiresApproval,
              context.l10n.newMembersRequireApproval,
              _requireApproval,
              (v) => setState(() => _requireApproval = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              context.l10n.allowAutomaticJoin,
              context.l10n.automaticJoinDescription,
              _allowAutoJoin,
              (v) => setState(() => _allowAutoJoin = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildMaxMembersField(theme),
          ],
        ),
        _buildSectionHeader(context.l10n.roomRealtimeFeatures, theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildSwitchItem(
              context.l10n.voiceChat,
              context.l10n.voiceChatRoomEnabledDescription,
              _voiceChatEnabled,
              (value) => setState(() => _voiceChatEnabled = value),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              context.l10n.p2pMedia,
              context.l10n.p2pMediaRoomEnabledDescription,
              _p2pMediaEnabled,
              (value) => setState(() => _p2pMediaEnabled = value),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader(context.l10n.message, theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildSwitchItem(
              context.l10n.chat,
              null,
              _chatEnabled,
              (v) => setState(() => _chatEnabled = v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader(context.l10n.regularMemberPermissions, theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildPermissionSwitch(
              context.l10n.sendChatAndDanmaku,
              _memberPermissions,
              RoomMemberPermissions.sendChatMessages,
              (v) => _setMemberPermission(
                RoomMemberPermissions.sendChatMessages,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              context.l10n.addMedia,
              _memberPermissions,
              RoomMemberPermissions.manageOwnMedia,
              (v) =>
                  _setMemberPermission(RoomMemberPermissions.manageOwnMedia, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              context.l10n.browseLibraryList,
              _memberPermissions,
              RoomMemberPermissions.browseLibrary,
              (v) =>
                  _setMemberPermission(RoomMemberPermissions.browseLibrary, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              context.l10n.viewMemberList,
              _memberPermissions,
              RoomMemberPermissions.viewMembers,
              (v) => _setMemberPermission(RoomMemberPermissions.viewMembers, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              context.l10n.viewChatHistory,
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
              context.l10n.voiceChat,
              _memberPermissions,
              RoomMemberPermissions.useVoiceChat,
              (v) =>
                  _setMemberPermission(RoomMemberPermissions.useVoiceChat, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              context.l10n.p2pMedia,
              _memberPermissions,
              RoomMemberPermissions.useP2pMedia,
              (v) => _setMemberPermission(RoomMemberPermissions.useP2pMedia, v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader(context.l10n.guestPermissions, theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildPermissionSwitch(
              context.l10n.viewMemberList,
              _guestPermissions,
              RoomGuestPermissions.viewMembers,
              (v) => _setGuestPermission(RoomGuestPermissions.viewMembers, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              context.l10n.viewChatHistory,
              _guestPermissions,
              RoomGuestPermissions.viewChatHistory,
              (v) =>
                  _setGuestPermission(RoomGuestPermissions.viewChatHistory, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              context.l10n.voiceChat,
              _guestPermissions,
              RoomGuestPermissions.useVoiceChat,
              (v) => _setGuestPermission(RoomGuestPermissions.useVoiceChat, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              context.l10n.p2pMedia,
              _guestPermissions,
              RoomGuestPermissions.useP2pMedia,
              (v) => _setGuestPermission(RoomGuestPermissions.useP2pMedia, v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader(context.l10n.settingsActions, theme),
        _buildSurface(
          isDark: isDark,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isSaving
                          ? context.l10n.savingSettings
                          : context.l10n.saveRoomPolicyDescription,
                      style: TextStyle(color: theme.hintColor, fontSize: 13),
                    ),
                  ),
                  AppActionButton(
                    onPressed: _isSaving ? null : _saveSettings,
                    loading: _isSaving,
                    icon: Icons.save_outlined,
                    label: context.l10n.saveSettings,
                    style: AppActionButtonStyle.tonal,
                  ),
                ],
              ),
            ),
            _buildDivider(theme),
            AppTile(
              prefix: const Icon(Icons.restart_alt),
              title: Text(context.l10n.resetRoomSettings),
              subtitle: Text(context.l10n.restoreServerRoomPolicy),
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
            title: context.l10n.activeStreams,
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
                    label: context.l10n.mediaId,
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
                      _streamSortDirection =
                          _streamSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? client_enum.SortDirection.SORT_DIRECTION_DESC
                          : client_enum.SortDirection.SORT_DIRECTION_ASC;
                      _streamsPage = 1;
                    });
                    _loadStreams();
                  },
                  icon:
                      _streamSortDirection ==
                          client_enum.SortDirection.SORT_DIRECTION_ASC
                      ? Icons.north_rounded
                      : Icons.south_rounded,
                  tooltip:
                      _streamSortDirection ==
                          client_enum.SortDirection.SORT_DIRECTION_ASC
                      ? context.l10n.mediaIdAscending
                      : context.l10n.mediaIdDescending,
                  style: AppIconButtonStyle.outlined,
                ),
              ],
            ),
          ),
          AppPaginationBar(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            label: context.l10n.pagedItemSummary(
              _streamsPage,
              _streamsPageSize,
              _streamsTotal,
            ),
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
            _buildEmptyState(context.l10n.noActiveStreams, theme)
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
            title: context.l10n.joinRequests,
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
                    label: context.l10n.userId,
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
                    label: context.l10n.status,
                    options: {
                      context.l10n.pendingReview:
                          common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
                      context.l10n.approved:
                          common_enum.ReviewStatus.REVIEW_STATUS_APPROVED,
                      context.l10n.rejected:
                          common_enum.ReviewStatus.REVIEW_STATUS_REJECTED,
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
            label: context.l10n.pagedItemSummary(
              _reviewsPage,
              _reviewsPageSize,
              _reviewsTotal,
            ),
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
            _buildEmptyState(context.l10n.noJoinRequests, theme)
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
    final entries = page?.entries ?? const <RoomMediaEntry>[];
    final canMutateScope = _canMutateCurrentMediaScope;
    return AppRefreshIndicator(
      onRefresh: _loadMediaLibrary,
      child: AppListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: context.l10n.mediaLibrary,
            count: entries.length,
            loading: _mediaLoading,
            onRefresh: _loadMediaLibrary,
            theme: theme,
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  tooltip: context.l10n.parentPlaylist,
                  onPressed:
                      _mediaTarget.isNotEmpty || _mediaPlaylistStack.isNotEmpty
                      ? _handleMediaBack
                      : null,
                  icon: Icons.arrow_upward,
                ),
                if (canMutateScope) ...[
                  AppIconButton(
                    tooltip: context.l10n.addMedia,
                    onPressed: _mediaLoading ? null : _addMediaToCurrentScope,
                    icon: Icons.add_to_queue_rounded,
                    style: AppIconButtonStyle.tonal,
                  ),
                  AppIconButton(
                    tooltip: context.l10n.newPlaylist,
                    onPressed: _createPlaylist,
                    icon: Icons.create_new_folder,
                  ),
                  AppIconButton(
                    tooltip: context.l10n.clearCurrentLevel,
                    onPressed: _mediaLoading ? null : _clearCurrentMediaScope,
                    icon: Icons.delete_sweep_rounded,
                    style: AppIconButtonStyle.destructive,
                  ),
                ],
                AppIconButton(
                  tooltip: context.l10n.refreshDynamicList,
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
                if (page == null ||
                    page.supportsSearch ||
                    !_isInsideDynamicMediaPlaylist)
                  _buildSearchField(
                    controller: _mediaSearchController,
                    label: context.l10n.searchMediaOrPlaylist,
                    onSearch: _reloadMediaLibrary,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppSelect<source_enum.SourceProvider>(
                        key: ValueKey('media-source-$_mediaSourceProvider'),
                        value: _mediaSourceProvider,
                        label: context.l10n.source,
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
                        value:
                            _mediaProviderInstances.contains(
                              _mediaProviderInstanceName,
                            )
                            ? _mediaProviderInstanceName
                            : '',
                        label: context.l10n.instance,
                        options: {
                          for (final instance in _mediaProviderInstances)
                            _providerInstanceLabel(instance): instance,
                        },
                        enabled:
                            _mediaSourcesWithProviderInstances.contains(
                              _mediaSourceProvider,
                            ) &&
                            !_mediaProviderInstancesLoading,
                        onChanged:
                            _mediaSourcesWithProviderInstances.contains(
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
                        label: context.l10n.availability,
                        options: {
                          context.l10n.all: client_enum
                              .ResourceAvailabilityFilter
                              .RESOURCE_AVAILABILITY_FILTER_ALL,
                          context.l10n.available: client_enum
                              .ResourceAvailabilityFilter
                              .RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
                          context.l10n.unavailable: client_enum
                              .ResourceAvailabilityFilter
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
                        label: context.l10n.sort,
                        options: {
                          context.l10n.position: client_enum
                              .MediaListSortBy
                              .MEDIA_LIST_SORT_BY_POSITION,
                          context.l10n.name: client_enum
                              .MediaListSortBy
                              .MEDIA_LIST_SORT_BY_NAME,
                          context.l10n.addedAt: client_enum
                              .MediaListSortBy
                              .MEDIA_LIST_SORT_BY_ADDED_AT,
                          context.l10n.updatedAt: client_enum
                              .MediaListSortBy
                              .MEDIA_LIST_SORT_BY_UPDATED_AT,
                          context.l10n.source: client_enum
                              .MediaListSortBy
                              .MEDIA_LIST_SORT_BY_SOURCE_PROVIDER,
                          context.l10n.instance: client_enum
                              .MediaListSortBy
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
                          _mediaSortDirection =
                              _mediaSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_ASC
                              ? client_enum.SortDirection.SORT_DIRECTION_DESC
                              : client_enum.SortDirection.SORT_DIRECTION_ASC;
                        });
                        _reloadMediaLibrary();
                      },
                      icon:
                          _mediaSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? Icons.north_rounded
                          : Icons.south_rounded,
                      tooltip:
                          _mediaSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? context.l10n.ascending
                          : context.l10n.descending,
                      style: AppIconButtonStyle.outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (entries.isEmpty)
            _buildEmptyState(context.l10n.noMediaEntriesAtCurrentLevel, theme)
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
          title: context.l10n.realtimeDiagnostics,
          count: resources.length,
          loading: loading,
          onRefresh: _refreshRealtimeDiagnostics,
          theme: theme,
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                tooltip: context.l10n.copyDiagnostics,
                onPressed: _copyRealtimeDiagnostics,
                icon: Icons.copy_all_rounded,
                style: AppIconButtonStyle.outlined,
              ),
              const SizedBox(width: 6),
              AppIconButton(
                tooltip: context.l10n.resetWatches,
                onPressed: loading ? null : _resetRealtimeDiagnostics,
                icon: Icons.restart_alt_rounded,
                style: AppIconButtonStyle.outlined,
              ),
            ],
          ),
        ),
        _buildRealtimePaneSelector(theme),
        Expanded(child: _buildRealtimePaneBody(resources, theme, isDark)),
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
              segments: [
                ButtonSegment(
                  value: _RealtimeDiagnosticsPane.overview,
                  icon: const Icon(Icons.dashboard_rounded),
                  label: Text(context.l10n.overview),
                ),
                ButtonSegment(
                  value: _RealtimeDiagnosticsPane.resources,
                  icon: const Icon(Icons.storage_rounded),
                  label: Text(context.l10n.resources),
                ),
                ButtonSegment(
                  value: _RealtimeDiagnosticsPane.events,
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: Text(context.l10n.events),
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
            children: [_buildRealtimeDetails(resources, theme, isDark)],
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
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
        child: RealtimeEventLogView(
          events: _realtimeEvents,
          padding: const EdgeInsets.all(12),
          onClear: () => setState(_realtimeEvents.clear),
          onMaxEntriesChanged: (_) => setState(_trimRealtimeEvents),
          emptyText: context.l10n.watchEventsDescription,
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
        title: context.l10n.roomSettings,
        icon: Icons.tune_rounded,
        observeId: _settingsObserveId,
        version: _settingsWatchVersion,
        loading: _isSaving,
        localCount: 1,
        summary: _isSaving
            ? context.l10n.savingSettings
            : context.l10n.watchingSettingChanges,
        stats: _settingsWatchStats,
        details: {
          'requirePassword': _settings.requirePassword,
          'allowGuestJoin': _settings.allowGuestJoin,
          'allowAutoJoin': _settings.allowAutoJoin,
          'requireApproval': _settings.requireApproval,
          'chatEnabled': _settings.chatEnabled,
          'maxMembers': _settings.maxMembers,
          'memberPermissions': _settings.effectiveMemberPermissions,
          'guestPermissions': _settings.effectiveGuestPermissions,
        },
      ),
      _RealtimeResourceDebugInfo(
        key: 'members',
        title: context.l10n.memberList,
        icon: Icons.group_rounded,
        observeId: _membersObserveId,
        version: _membersWatchVersion,
        loading: _membersLoading,
        localCount: _members.length,
        summary: _membersLoading
            ? context.l10n.refreshingMembers
            : context.l10n.onlineTotalSummary(
                _membersOnlineCount,
                _membersTotal,
              ),
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
        title: context.l10n.mediaList,
        icon: Icons.video_library_rounded,
        observeId: _mediaObserveId,
        version: _mediaWatchVersion,
        loading: _mediaLoading,
        localCount: mediaEntries,
        summary: mediaPage == null
            ? context.l10n.waitingForMediaSnapshot
            : context.l10n.playlistMediaSummary(
                mediaPage.effectivePlaylistCount,
                mediaPage.effectiveFileCount,
              ),
        stats: _mediaWatchStats,
        details: {
          'entries': mediaEntries,
          'total': mediaPage?.total ?? 0,
          'playlistCount': mediaPage?.playlistCount ?? 0,
          'fileCount': mediaPage?.fileCount ?? 0,
          'playlistId': _currentPlaylistId,
          'target': _mediaTarget,
          'sourceProvider': SourceConfigCodec.providerToString(
            _mediaSourceProvider,
          ),
          'providerInstanceName': _mediaProviderInstanceName,
          'availability': _mediaAvailability.name,
          'sortBy': _mediaSortBy.name,
          'sortDirection': _mediaSortDirection.name,
          'search': _mediaSearchController.text.trim(),
        },
      ),
      _RealtimeResourceDebugInfo(
        key: 'chat',
        title: context.l10n.chatEvents,
        icon: Icons.forum_rounded,
        observeId: _chatObserveId,
        version: _chatWatchVersion,
        loading: _chatLoading,
        localCount: _chatMessages.length,
        summary: _chatLoading
            ? context.l10n.refreshingChatHistory
            : context.l10n.chatHistoryCount(_chatMessages.length),
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
    final outgoingCount = _realtimeEvents
        .where((event) => event.direction == 'out')
        .length;
    final incomingCount = eventCount - outgoingCount;
    final errorCount = resources.fold<int>(
      0,
      (total, item) => total + item.stats.errors,
    );
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
              label: context.l10n.watchedResources,
              value: '$watched/${resources.length}',
              tone: watched == resources.length ? Colors.green : Colors.orange,
            ),
            _buildRealtimeMetricCard(
              theme,
              isDark,
              icon: Icons.swap_vert_rounded,
              label: context.l10n.events,
              value: eventCount.toString(),
              tone: theme.colorScheme.primary,
            ),
            _buildRealtimeMetricCard(
              theme,
              isDark,
              icon: Icons.compare_arrows_rounded,
              label: context.l10n.sentReceived,
              value: '$outgoingCount / $incomingCount',
              tone: Colors.blueAccent,
            ),
            _buildRealtimeMetricCard(
              theme,
              isDark,
              icon: Icons.error_outline_rounded,
              label: context.l10n.errors,
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
                Icon(
                  Icons.data_object_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.runtimeSnapshot,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDebugLine(theme, context.l10n.room, widget.roomName),
            _buildDebugLine(theme, context.l10n.roomId, widget.roomId),
            _buildDebugLine(
              theme,
              context.l10n.currentMediaLocation,
              _mediaScopeLabel(_mediaPage),
            ),
            _buildDebugLine(
              theme,
              context.l10n.watchStatus,
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
            _buildRealtimeResourceCard(resource, theme, isDark),
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
                    size: AppLoadingSize.sm,
                    centered: false,
                  ),
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
            context.l10n.version,
            resource.version.isEmpty
                ? (ready ? context.l10n.notProvided : context.l10n.waiting)
                : resource.version,
          ),
          _buildDebugLine(
            theme,
            context.l10n.localItems,
            resource.localCount.toString(),
          ),
          _buildDebugLine(theme, context.l10n.status, resource.summary),
          _buildDebugLine(
            theme,
            context.l10n.latestEvent,
            _watchKindLabel(resource.stats.lastKind),
          ),
          _buildDebugLine(
            theme,
            context.l10n.eventCounts,
            'observed ${resource.stats.observed} / changed ${resource.stats.changed} / errors ${resource.stats.errors}',
          ),
          _buildDebugLine(
            theme,
            context.l10n.lastTime,
            _formatDateTime(resource.stats.lastSeenAt),
          ),
          if (resource.stats.lastError.isNotEmpty)
            _buildDebugLine(
              theme,
              context.l10n.error,
              resource.stats.lastError,
            ),
          const AppDivider(height: 20),
          ...resource.details.entries.map(
            (entry) =>
                _buildDebugLine(theme, entry.key, _debugValue(entry.value)),
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
            title: context.l10n.chatHistory,
            count: _chatMessages.length,
            loading: _chatLoading,
            onRefresh: _loadChatHistory,
            theme: theme,
            action: nextCursor.isEmpty
                ? null
                : AppIconButton(
                    tooltip: context.l10n.loadMore,
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
              label: context.l10n.searchChatContent,
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
                      context.l10n.searchQuery(_chatSearchQuery),
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
                    label: context.l10n.clear,
                    style: AppActionButtonStyle.text,
                  ),
                ],
              ),
            ),
          if (_chatMessages.isEmpty)
            _buildEmptyState(
              searchActive
                  ? context.l10n.noMatchingChatMessages
                  : context.l10n.noChatHistory,
              theme,
            )
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
            title: context.l10n.iceServers,
            count: _iceServers.length,
            loading: _iceLoading,
            onRefresh: _loadIceServers,
            theme: theme,
          ),
          if (_iceServers.isEmpty)
            _buildEmptyState(context.l10n.noIceServers, theme)
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
              context.l10n.playlistMediaSummary(
                page.effectivePlaylistCount,
                page.effectiveFileCount,
              ),
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
            title: context.l10n.roomMembers,
            count: _membersTotal,
            loading: _membersLoading,
            onRefresh: _loadMembers,
            theme: theme,
            action: AppIconButton(
              tooltip: context.l10n.addMember,
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
                  label: context.l10n.usernameOrUserId,
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
                        label: context.l10n.role,
                        hintText: context.l10n.allRoles,
                        options: {
                          context.l10n.allRoles: null,
                          context.l10n.roomOwner: common_enum
                              .RoomMemberRole
                              .ROOM_MEMBER_ROLE_CREATOR,
                          context.l10n.administrator:
                              common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                          context.l10n.member: common_enum
                              .RoomMemberRole
                              .ROOM_MEMBER_ROLE_MEMBER,
                          context.l10n.guest:
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
                        label: context.l10n.sort,
                        options: {
                          context.l10n.joinedAt: client_enum
                              .RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                          context.l10n.username: client_enum
                              .RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                          context.l10n.role: client_enum
                              .RoomMemberListSortBy
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
                          _memberSortDirection =
                              _memberSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_ASC
                              ? client_enum.SortDirection.SORT_DIRECTION_DESC
                              : client_enum.SortDirection.SORT_DIRECTION_ASC;
                          _membersPage = 1;
                        });
                        _refreshMembersRealtimeQuery();
                        _loadMembers();
                      },
                      icon:
                          _memberSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? Icons.north_rounded
                          : Icons.south_rounded,
                      tooltip:
                          _memberSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? context.l10n.ascending
                          : context.l10n.descending,
                      style: AppIconButtonStyle.outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppPaginationBar(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            label: context.l10n.pagedItemSummary(
              _membersPage,
              _membersPageSize,
              _membersTotal,
            ),
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
            _buildEmptyState(context.l10n.noMembers, theme)
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
    final connectionCount = _members.fold<int>(
      0,
      (sum, member) => sum + member.connectionCount,
    );
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
                context.l10n.onlineMemberSummary(
                  _membersOnlineCount,
                  _membersTotal,
                ),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              context.l10n.roomConnections(totalConnections),
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
            width: 104,
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
            tooltip: context.l10n.viewDetails,
            onPressed: () => _showStreamInfo(stream),
            icon: Icons.info_outline_rounded,
          ),
          AppIconButton(
            tooltip: context.l10n.disconnectStream,
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
        review.status == common_enum.ReviewStatus.REVIEW_STATUS_PENDING;
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
                  label: context.l10n.reject,
                  style: AppActionButtonStyle.text,
                ),
                const SizedBox(width: 8),
                AppActionButton(
                  onPressed: () => _approveReview(review),
                  icon: Icons.check,
                  label: context.l10n.approve,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaTile(RoomMediaEntry entry, ThemeData theme, bool isDark) {
    final isPersisted =
        entry.id.startsWith('pl_') || entry.id.startsWith('med_');
    final canMutate =
        _canMutateCurrentMediaScope &&
        isPersisted &&
        !entry.isProviderDynamicItem;
    final playlistIndex = entry.id.startsWith('pl_')
        ? _mediaPage?.playlists.indexWhere((item) => item.id == entry.id) ?? -1
        : -1;
    final playlistCount = _mediaPage?.playlists.length ?? 0;
    final canOpen = _canOpenMediaEntry(entry);
    return _buildManagementTileSurface(
      theme,
      isDark,
      child: Row(
        children: [
          _buildCoverPreview(
            url: entry.coverUrl,
            fallbackIcon: entry.isPlaylist
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
              onTap: canOpen ? () => _openMediaEntry(entry) : null,
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
            tooltip: context.l10n.mediaActions,
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
                case _MediaAction.updateThumbnail:
                  _updateEntryThumbnail(entry);
                case _MediaAction.clearThumbnail:
                  _clearEntryThumbnail(entry);
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
              PopupMenuItem(
                value: _MediaAction.details,
                child: Text(context.l10n.details),
              ),
              PopupMenuItem(
                value: _MediaAction.open,
                enabled: canOpen,
                child: Text(context.l10n.open),
              ),
              if (canMutate) ...[
                PopupMenuItem(
                  value: _MediaAction.rename,
                  child: Text(context.l10n.edit),
                ),
                PopupMenuItem(
                  value: _MediaAction.updateCover,
                  child: Text(context.l10n.updateCover),
                ),
                PopupMenuItem(
                  value: _MediaAction.clearCover,
                  enabled: entry.coverUrl.isNotEmpty,
                  child: Text(context.l10n.removeCover),
                ),
                if (entry.id.startsWith('med_')) ...[
                  PopupMenuItem(
                    value: _MediaAction.updateThumbnail,
                    child: Text(context.l10n.updateThumbnail),
                  ),
                  PopupMenuItem(
                    value: _MediaAction.clearThumbnail,
                    enabled: entry.thumbnailUrl.isNotEmpty,
                    child: Text(context.l10n.removeThumbnail),
                  ),
                ],
                if (entry.id.startsWith('pl_')) ...[
                  PopupMenuItem(
                    value: _MediaAction.moveUp,
                    enabled: playlistIndex > 0,
                    child: Text(context.l10n.moveUp),
                  ),
                  PopupMenuItem(
                    value: _MediaAction.moveDown,
                    enabled: playlistIndex < playlistCount - 1,
                    child: Text(context.l10n.moveDown),
                  ),
                ],
                if (entry.id.startsWith('med_'))
                  PopupMenuItem(
                    value: _MediaAction.move,
                    child: Text(context.l10n.moveTo),
                  ),
                PopupMenuItem(
                  value: _MediaAction.delete,
                  child: Text(context.l10n.delete),
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
    final title = chatMessageDisplayUsername(
      messageType: message.messageType,
      username: message.username,
      missingUsername: context.l10n.deletedUser,
    );
    final isMine =
        _currentUserId.isNotEmpty && message.userId == _currentUserId;
    final receipt = _chatReceiptCache[message.id];
    final isReceiptLoading = _chatReceiptLoadingIds.contains(message.id);
    final bubbleColor = isMine
        ? scheme.primary.withValues(alpha: 0.12)
        : scheme.surfaceContainerHighest.withValues(
            alpha: isDark ? 0.54 : 0.72,
          );
    final borderColor = isMine
        ? scheme.primary.withValues(alpha: 0.25)
        : scheme.outlineVariant.withValues(alpha: 0.55);
    final content = message.isDeleted
        ? context.l10n.messageDeleted
        : message.content.trim().isEmpty && message.images.isNotEmpty
        ? context.l10n.imageMessagePlain
        : message.content;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMine) ...[
            AppAvatar(name: title, radius: 17),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
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
                          context.l10n.edited,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant.withValues(
                              alpha: 0.64,
                            ),
                          ),
                        ),
                      ],
                      if (message.isPinned && !message.isDeleted) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.push_pin, size: 13, color: scheme.primary),
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
                          AppSelectableText(
                            content,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.32,
                              color: message.isDeleted
                                  ? scheme.onSurfaceVariant.withValues(
                                      alpha: 0.72,
                                    )
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
                                .map(
                                  (image) => _buildChatImageThumb(image, theme),
                                )
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
                              color: scheme.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              ),
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
                        tooltip: context.l10n.viewContext,
                        icon: Icons.forum_outlined,
                        onPressed: () => _showChatMessageContext(message),
                      ),
                      _buildChatMessageActionButton(
                        tooltip: context.l10n.viewReports,
                        icon: Icons.report_gmailerrorred_outlined,
                        onPressed: () => _openRoomScopedReportsViewer(
                          title: context.l10n.messageReports(message.id),
                          targetType: admin_enum
                              .ContentReportTargetType
                              .CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE,
                          targetChatMessageId: int.tryParse(message.id) ?? 0,
                        ),
                      ),
                      _buildChatMessageActionButton(
                        tooltip: message.isPinned
                            ? context.l10n.unpin
                            : context.l10n.pin,
                        icon: message.isPinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        onPressed: message.isDeleted
                            ? null
                            : () => _toggleChatPin(message),
                      ),
                      if (message.canEditBy(_currentUserId))
                        _buildChatMessageActionButton(
                          tooltip: context.l10n.edit,
                          icon: Icons.edit_outlined,
                          onPressed: () => _editChatMessage(message),
                        ),
                      _buildChatMessageActionButton(
                        tooltip: context.l10n.delete,
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
        ? context.l10n.quotedMessage
        : chatMessageDisplayUsername(
            messageType: quoted.messageType,
            username: quoted.username,
            missingUsername: context.l10n.deletedUser,
          );
    final preview = quoted == null
        ? context.l10n.tapToViewContext
        : quoted.isDeleted
        ? context.l10n.messageDeleted
        : quoted.content.trim().isEmpty
        ? context.l10n.imageMessagePlain
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
        return AppTooltip(
          message: context.l10n.viewReactionMembers,
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
        loadUsers: ({String cursor = ''}) => _chatGateway.listReactionUsers(
          widget.roomId,
          message.id,
          reaction.key,
          cursor: cursor,
        ),
      ),
    );
  }

  Widget _buildChatReadReceiptButton(
    RoomChatMessageInfo message,
    ChatMessageReadReceiptsInfo? receipt,
    bool loading,
    ThemeData theme,
  ) {
    final mentionSummary = receipt == null
        ? null
        : _mentionReadReceiptSummary(message, receipt);
    final text = receipt == null
        ? context.l10n.read
        : mentionSummary ??
              context.l10n.readUnreadSummary(
                receipt.readerTotal,
                receipt.unreadTotal,
              );
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
    if (readCount == 0 && unreadCount == 0) return context.l10n.mentionRead;
    if (mentionedUsers.length == 1) {
      return unreadCount == 0
          ? context.l10n.mentionRead
          : context.l10n.mentionUnread;
    }
    return context.l10n.mentionReadUnreadSummary(readCount, unreadCount);
  }

  List<SyncTvUser> _mentionedUsersForMessage(
    RoomChatMessageInfo message,
    ChatMessageReadReceiptsInfo? receipt,
  ) {
    if (message.mentions.isEmpty) return const [];
    final mentionedIds = message.mentions
        .map((mention) => mention.userId)
        .toSet();
    final users = <String, SyncTvUser>{};
    for (final mention in message.mentions) {
      if (mention.userId.isEmpty || mention.username.trim().isEmpty) continue;
      users[mention.userId] = SyncTvUser(
        id: mention.userId,
        username: mention.username,
        role: const RoomMembershipRole(
          common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED,
        ),
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
          role: RoomMembershipRole(member.role),
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
        final loaded = await _chatGateway.getReadReceipts(
          widget.roomId,
          message.id,
        );
        if (!mounted) return;
        setState(() {
          _chatReceiptCache[message.id] = loaded;
        });
        receipt = loaded;
      } catch (e) {
        if (mounted) {
          AppNotifications.showError(
            context,
            context.l10n.loadReadDetailsFailed('$e'),
          );
        }
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
    final resolved = _resourceUrlResolver.resolve(image.url);
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
    final resolved = _resourceUrlResolver.resolve(url);
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
                  server.username.isEmpty
                      ? context.l10n.anonymous
                      : server.username,
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

  String _mediaSubtitle(RoomMediaEntry entry) {
    if (entry.id.startsWith('pl_')) {
      final mode = entry.metadata['isDynamic'] == true
          ? context.l10n.dynamicPlaylist
          : context.l10n.playlist;
      if (!entry.isAvailable) {
        return '$mode · ${context.l10n.creatorUnavailable}';
      }
      if (!_canOpenMediaEntry(entry)) {
        return context.l10n.creatorOnlyMode(mode);
      }
      final provider = SourceConfigCodec.providerToString(entry.sourceProvider);
      return '$mode · ${provider.isEmpty ? 'static' : provider}';
    }
    if (entry.id.startsWith('med_')) {
      final provider = SourceConfigCodec.providerToString(entry.sourceProvider);
      final details =
          '$provider · ${entry.providerInstanceName.isEmpty ? 'default' : entry.providerInstanceName}';
      return entry.isAvailable
          ? details
          : '$details · ${context.l10n.creatorUnavailable}';
    }
    final size = entry.metadata['size'];
    return entry.isPlaylist
        ? context.l10n.dynamicPlaylist
        : context.l10n.dynamicMediaSize(size is int && size > 0 ? size : 0);
  }

  String _compactMap(Map<String, dynamic> value) {
    final entries = value.entries
        .where(
          (entry) => entry.value != null && entry.value.toString().isNotEmpty,
        )
        .take(6)
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
    if (entries.isEmpty) return '-';
    return value.length > 6 ? '$entries\n…' : entries;
  }

  String _mediaScopeLabel(RoomMediaLibraryPage? page) {
    if (_mediaTarget.isNotEmpty) {
      final path = page?.currentPath.map((node) => node.name).join(' / ') ?? '';
      return path.isEmpty ? context.l10n.dynamicPlaylist : path;
    }
    if (_mediaPlaylistStack.isEmpty) return context.l10n.mediaLibraryRoot;
    final path = page?.currentPath.map((node) => node.name).join(' / ') ?? '';
    if (path.isNotEmpty) return path;
    final entryName = _mediaPlaylistEntryStack.lastOrNull?.name.trim() ?? '';
    return entryName.isEmpty ? _currentPlaylistId : entryName;
  }

  Widget _buildMemberTile(
    AdminRoomMember member,
    ThemeData theme,
    bool isDark,
  ) {
    final isCreator =
        member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR;
    final isCurrentUser =
        _currentUserId.isNotEmpty && member.userId == _currentUserId;
    final canManageMember = !isCreator && !isCurrentUser;
    final connectionText = member.connectionCount > 0
        ? context.l10n.roomConnections(member.connectionCount)
        : context.l10n.roomConnections(0);
    final presenceColor = member.isOnline
        ? const Color(0xFF16A34A)
        : theme.hintColor;
    final baseName = member.username.isEmpty ? member.userId : member.username;
    final remarkName = member.remarkName.trim();
    final displayTag = member.displayTag.trim();
    final displayName = remarkName.isEmpty ? baseName : remarkName;
    return _buildManagementTileSurface(
      theme,
      isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(name: displayName, radius: 18),
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
                            label: context.l10n.me,
                            icon: Icons.person_outline_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        if (isCreator)
                          _buildMemberBadge(
                            label: context.l10n.roomOwner,
                            icon: Icons.star_rounded,
                            color: const Color(0xFFF59E0B),
                          )
                        else
                          _buildMemberBadge(
                            label: _roleLabel(member.role),
                            icon: Icons.badge_outlined,
                            color: theme.colorScheme.primary,
                          ),
                        if (displayTag.isNotEmpty)
                          _buildMemberBadge(
                            label: displayTag,
                            icon: Icons.sell_outlined,
                            color: theme.colorScheme.tertiary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildMemberBadge(
                          label: member.isOnline
                              ? context.l10n.online
                              : context.l10n.offline,
                          icon: Icons.circle,
                          color: presenceColor,
                        ),
                        _buildMemberBadge(
                          label: connectionText,
                          icon: Icons.hub_outlined,
                          color: theme.colorScheme.secondary,
                        ),
                        _buildMemberBadge(
                          label: context.l10n.joinedAtValue(
                            _formatTimestamp(member.joinedAt),
                          ),
                          icon: Icons.schedule_rounded,
                          color: theme.hintColor,
                        ),
                      ],
                    ),
                    if (member.userId.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        remarkName.isEmpty
                            ? member.userId
                            : '$baseName · ${member.userId}',
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
                  tooltip: context.l10n.remarkName,
                  icon: Icons.drive_file_rename_outline_rounded,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _editMemberRemarkName(member),
                ),
                AppIconButton(
                  tooltip: context.l10n.displayLabel,
                  icon: Icons.sell_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _editMemberDisplayTag(member),
                ),
                AppIconButton(
                  tooltip: context.l10n.changeRole,
                  icon: Icons.admin_panel_settings_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.tonal,
                  onPressed: () => _setMemberRole(member),
                ),
                AppIconButton(
                  tooltip: context.l10n.permissionOverrides,
                  icon: Icons.rule_rounded,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _editMemberPermissionOverrides(member),
                ),
                AppIconButton(
                  tooltip: context.l10n.transferOwnership,
                  icon: Icons.verified_user_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _transferOwnership(member),
                ),
                AppIconButton(
                  tooltip: context.l10n.removeFromRoom,
                  icon: Icons.person_remove_alt_1_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.destructive,
                  onPressed: () => _kickMember(member),
                ),
                AppIconButton(
                  tooltip: context.l10n.viewMemberReports,
                  icon: Icons.report_gmailerrorred_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _openRoomScopedReportsViewer(
                    title: context.l10n.memberReports(
                      member.username.isEmpty ? member.userId : member.username,
                    ),
                    targetType: admin_enum
                        .ContentReportTargetType
                        .CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER,
                    targetMemberUserId: member.userId,
                  ),
                ),
                AppIconButton(
                  tooltip: context.l10n.reportMember,
                  icon: Icons.flag_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _reportRoomMember(member),
                ),
                AppIconButton(
                  tooltip: context.l10n.reportUser,
                  icon: Icons.person_off_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _reportUser(member),
                ),
                AppPopupMenuButton<_MemberAction>(
                  tooltip: context.l10n.moreMemberActions,
                  onSelected: (action) {
                    switch (action) {
                      case _MemberAction.remarkName:
                        _editMemberRemarkName(member);
                      case _MemberAction.displayTag:
                        _editMemberDisplayTag(member);
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
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _MemberAction.remarkName,
                      child: Text(context.l10n.remarkName),
                    ),
                    PopupMenuItem(
                      value: _MemberAction.displayTag,
                      child: Text(context.l10n.displayLabel),
                    ),
                    PopupMenuItem(
                      value: _MemberAction.role,
                      child: Text(context.l10n.changeRole),
                    ),
                    PopupMenuItem(
                      value: _MemberAction.permissions,
                      child: Text(context.l10n.permissionOverrides),
                    ),
                    PopupMenuItem(
                      value: _MemberAction.transfer,
                      child: Text(context.l10n.transferOwnership),
                    ),
                    PopupMenuItem(
                      value: _MemberAction.kick,
                      child: Text(context.l10n.removeFromRoom),
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
                    isCurrentUser
                        ? context.l10n.currentAccount
                        : context.l10n.ownerAccount,
                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                  ),
                ),
                AppIconButton(
                  tooltip: context.l10n.viewMemberReports,
                  icon: Icons.report_gmailerrorred_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _openRoomScopedReportsViewer(
                    title: context.l10n.memberReports(
                      member.username.isEmpty ? member.userId : member.username,
                    ),
                    targetType: admin_enum
                        .ContentReportTargetType
                        .CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER,
                    targetMemberUserId: member.userId,
                  ),
                ),
                const SizedBox(width: 6),
                AppIconButton(
                  tooltip: context.l10n.reportMember,
                  icon: Icons.flag_outlined,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.outlined,
                  onPressed: () => _reportRoomMember(member),
                ),
                const SizedBox(width: 6),
                AppIconButton(
                  tooltip: context.l10n.reportUser,
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
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildRoomInfoTab(ThemeData theme, bool isDark) {
    final room = _roomInfo;
    final roomName = room?.roomName ?? widget.roomName;
    final creatorId = (room?.creatorId ?? widget.creatorId).trim();
    final creatorName = (room?.creator ?? '').trim().isEmpty
        ? (creatorId.isEmpty ? context.l10n.creator : creatorId)
        : room!.creator.trim();
    final creatorAvatarUrl = _resourceUrlResolver.resolve(
      room?.creatorAvatarUrl ?? '',
    );
    return AppListView(
      padding: const EdgeInsets.only(bottom: 32, top: 8),
      children: [
        _buildSectionHeader(context.l10n.roomInformation, theme),
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
                        label: context.l10n.refresh,
                        style: AppActionButtonStyle.text,
                      ),
                      const SizedBox(width: 8),
                      AppActionButton(
                        onPressed: _coverUpdating ? null : _updateRoomCover,
                        loading: _coverUpdating,
                        icon: Icons.image_outlined,
                        label: context.l10n.cover,
                        style: AppActionButtonStyle.tonal,
                      ),
                      if (_roomCoverUrl.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        AppIconButton(
                          tooltip: context.l10n.removeCover,
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
                        _buildDetailLine(
                          context.l10n.description,
                          room!.description.trim(),
                        ),
                      _buildDetailLine(
                        context.l10n.createdAt,
                        _formatTimestamp(room?.createdAt ?? 0),
                      ),
                      _buildDetailLine(
                        context.l10n.updatedAt,
                        _formatTimestamp(room?.updatedAt ?? 0),
                      ),
                      _buildDetailLine(
                        context.l10n.members,
                        context.l10n.roomPresenceWithMembers(
                          room?.onlineMemberCount ?? 0,
                          room?.onlineGuestCount ?? 0,
                          room?.memberCount ?? 0,
                        ),
                      ),
                      _buildDetailLine(
                        context.l10n.password,
                        _settings.requirePassword
                            ? context.l10n.configured
                            : context.l10n.notConfigured,
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
                        imageUrl: creatorAvatarUrl.isEmpty
                            ? null
                            : creatorAvatarUrl,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              creatorId.isEmpty
                                  ? context.l10n.creator
                                  : creatorId,
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
        _buildSectionHeader(context.l10n.roomPassword, theme),
        _buildSurface(
          isDark: isDark,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: AppTextField(
                controller: _passwordController,
                label: context.l10n.newPassword,
                helperText: context.l10n.emptyRemovesRoomPassword,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                suffix: AppIconButton(
                  tooltip: context.l10n.clear,
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
                      _settings.requirePassword
                          ? context.l10n.roomCurrentlyRequiresPassword
                          : context.l10n.roomCurrentlyNoPassword,
                      style: TextStyle(color: theme.hintColor, fontSize: 13),
                    ),
                  ),
                  AppActionButton(
                    onPressed: _canSubmitPasswordChange
                        ? _updateRoomPassword
                        : null,
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
        _buildSectionHeader(context.l10n.roomActions, theme),
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
                    title: Text(context.l10n.leaveRoom),
                    subtitle: Text(context.l10n.leaveRoomTileDescription),
                    onPressed: _leaveRoom,
                  ),
                  _buildDivider(theme),
                ],
                AppTile(
                  prefix: Icon(
                    Icons.delete_forever_rounded,
                    color: theme.colorScheme.error,
                  ),
                  title: Text(
                    context.l10n.deleteRoom,
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
    if (!stream.active) return context.l10n.inactive;
    final publisher = stream.publisherUserId.isEmpty
        ? context.l10n.unknownPublisher
        : stream.publisherUserId;
    return '$publisher · ${_formatTimestamp(stream.startedAt)}';
  }

  String _watchKindLabel(String kind) => switch (kind) {
    'observed_changed' => context.l10n.observedWithChanges,
    'observed_unchanged' => context.l10n.observedWithoutChanges,
    'snapshot' => context.l10n.snapshotPushed,
    'error' => context.l10n.error,
    _ => context.l10n.waiting,
  };

  String _roleLabel(common_enum.RoomMemberRole role) {
    return switch (role) {
      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR =>
        context.l10n.creator,
      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN =>
        context.l10n.administrator,
      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER => context.l10n.member,
      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST => context.l10n.guest,
      _ => context.l10n.unspecified,
    };
  }

  String _reviewStatusLabel(common_enum.ReviewStatus status) {
    return switch (status) {
      common_enum.ReviewStatus.REVIEW_STATUS_PENDING =>
        context.l10n.pendingReview,
      common_enum.ReviewStatus.REVIEW_STATUS_APPROVED => context.l10n.approved,
      common_enum.ReviewStatus.REVIEW_STATUS_REJECTED => context.l10n.rejected,
      _ => context.l10n.unspecified,
    };
  }

  String _formatTimestamp(int timestamp) {
    if (timestamp <= 0) return context.l10n.unknownTime;
    final normalized = timestamp > 100000000000
        ? (timestamp / 1000).round()
        : timestamp;
    final time = DateTime.fromMillisecondsSinceEpoch(normalized * 1000);
    return '${time.year.toString().padLeft(4, '0')}-'
        '${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return context.l10n.waitingForEvent;
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
    final systemUiOverlayStyle = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: AppScaffold(
        backgroundColor: isDark
            ? const Color(0xFF121214)
            : const Color(0xFFF6F7FB),
        appBar: AppPageBar(
          title: Text(
            widget.roomName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: isDark
              ? const Color(0xFF121214)
              : const Color(0xFFF6F7FB),
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
            .map(
              (section) => Tab(
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
              ),
            )
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
                        context.l10n.roomManagement,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.68,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppListView.separated(
                        itemCount: _sections.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
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

enum _MemberAction { remarkName, displayTag, role, permissions, transfer, kick }

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
    final foreground = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;
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
          label: context.l10n.messageContent,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppDialogs.createCancelButton(context),
            const SizedBox(width: 8),
            AppDialogs.createConfirmButton(
              context,
              _submit,
              text: context.l10n.save,
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
  updateThumbnail,
  clearThumbnail,
  moveUp,
  moveDown,
  move,
  delete,
}

class _EntryEditResult {
  final String name;
  final String description;
  final source_enum.PlaybackProxyMode? playbackProxyMode;
  final client_enum.PlaylistBrowseAccessMode? playlistBrowseAccessMode;

  const _EntryEditResult(
    this.name,
    this.description, [
    this.playbackProxyMode,
    this.playlistBrowseAccessMode,
  ]);
}

class _MediaMoveTarget {
  final String playlistId;
  final String name;

  const _MediaMoveTarget(this.playlistId, this.name);
}

class _MemberEditResult {
  final String userId;
  final common_enum.RoomMemberRole role;
  final bool notify;

  const _MemberEditResult(this.userId, this.role, this.notify);
}
