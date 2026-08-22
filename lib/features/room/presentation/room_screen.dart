import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/presentation/room_shell_view.dart';
import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';
import 'package:synctv_app/contracts/chat_message_selection.dart';
import 'package:synctv_app/contracts/playback_client_profile.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/room/presentation/models/chat_context_menu_layout.dart';
import 'package:synctv_app/features/room/presentation/playback_control_reporter.dart';
import 'package:synctv_app/features/room/domain/playback_operation_tracker.dart';
import 'package:synctv_app/features/room/presentation/models/playlist_source_presentation.dart';
import 'package:synctv_app/features/room/presentation/models/playback_player_update.dart';
import 'package:synctv_app/features/room/presentation/models/room_ui_capabilities.dart';
import 'package:synctv_app/features/room/presentation/models/playlist_selection_policy.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/features/room/domain/playback_sync_target.dart';
import 'package:synctv_app/features/room/domain/playback_resource_localizer.dart';
import 'package:synctv_app/features/room/domain/realtime_event_log.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/application/room_realtime_protocol.dart';
import 'package:synctv_app/features/account/application/account_gateway.dart';
import 'package:synctv_app/features/room/application/danmaku_source.dart';
import 'package:synctv_app/features/room/application/subtitle_source.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/room/application/room_chat_gateway.dart';
import 'package:synctv_app/features/room/application/chat_read_state_updater.dart';
import 'package:synctv_app/features/room/application/room_playback_gateway.dart';
import 'package:synctv_app/features/room/application/room_playback_controller.dart';
import 'package:synctv_app/features/room/application/playback_mode_preferences_controller.dart';
import 'package:synctv_app/features/room/application/room_session_gateway.dart';
import 'package:synctv_app/features/room/application/room_management_gateway.dart';
import 'package:synctv_app/features/media_library/application/media_library_gateway.dart';
import 'package:synctv_app/features/room/application/picture_in_picture_controller.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:synctv_app/features/room/application/browser_autoplay_controller.dart';
import 'package:synctv_app/features/room/application/playback_overlay_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/image/local_image_picker.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/media_provider_brand.dart';
import 'package:synctv_app/core/presentation/media_variant_label.dart';
import 'package:synctv_app/features/room/domain/chat_reactions.dart';
import 'package:synctv_app/features/room/presentation/playback_danmaku.dart';
import 'package:synctv_app/features/room/presentation/playback_error_messages.dart';
import 'package:synctv_app/core/identifiers/client_operation_id.dart';
import 'package:synctv_app/features/room/presentation/room_settings_page.dart';
import 'package:synctv_app/features/media_library/presentation/add_media_dialog.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/custom_video_player.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_diagnostics.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_empty_state.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_options_control.dart';
import 'package:synctv_app/features/room/presentation/widgets/playlist_empty_state.dart';
import 'package:synctv_app/features/room/presentation/widgets/playlist_search_field.dart';
import 'package:synctv_app/features/room/presentation/widgets/free_mode_settings_fields.dart';
import 'package:synctv_app/features/media_p2p/presentation/p2p_media_settings_fields.dart';
import 'package:synctv_app/features/room_invite/presentation/room_invite_actions.dart';
import 'package:synctv_app/features/room/presentation/widgets/realtime_event_log_view.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_input_area.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_message_hover_layout.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_read_receipts_dialog.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_reaction_users_dialog.dart';
import 'package:synctv_app/features/voice/application/voice_chat_session.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

enum _PlaybackControlIntentKind { playbackState, seek, speed }

class _PlaybackControlIntent {
  const _PlaybackControlIntent({
    required this.kind,
    required this.clientOperationId,
    required this.clientTimeMillis,
    this.isPlaying,
    this.position,
    this.speed,
  });

  final _PlaybackControlIntentKind kind;
  final String clientOperationId;
  final int clientTimeMillis;
  final bool? isPlaying;
  final Duration? position;
  final double? speed;
}

class _P2pMetricsSnapshot {
  const _P2pMetricsSnapshot({
    this.httpBytes = 0,
    this.p2pDownloadBytes = 0,
    this.p2pUploadBytes = 0,
    this.httpDownloadRate = 0,
    this.p2pDownloadRate = 0,
    this.p2pUploadRate = 0,
    this.cacheBytes = 0,
    this.cacheHits = 0,
    this.cacheMisses = 0,
    this.integrityChecks = 0,
    this.integrityMismatches = 0,
    this.integrityUnavailable = 0,
  });

  final int httpBytes;
  final int p2pDownloadBytes;
  final int p2pUploadBytes;
  final double httpDownloadRate;
  final double p2pDownloadRate;
  final double p2pUploadRate;
  final int cacheBytes;
  final int cacheHits;
  final int cacheMisses;
  final int integrityChecks;
  final int integrityMismatches;
  final int integrityUnavailable;

  int get totalDownloadBytes => httpBytes + p2pDownloadBytes;
  double get totalDownloadRate => httpDownloadRate + p2pDownloadRate;
  double get cacheHitRatio {
    final total = cacheHits + cacheMisses;
    return total == 0 ? 0 : cacheHits / total;
  }
}

String videoPlayerSourceKey(String url, Map<String, String> headers) {
  final names = headers.keys.toList()..sort();
  final buffer = StringBuffer('${url.length}:$url');
  for (final name in names) {
    final value = headers[name]!;
    buffer
      ..write('|${name.length}:')
      ..write(name)
      ..write('|${value.length}:')
      ..write(value);
  }
  return buffer.toString();
}

class RoomScreen extends StatefulWidget {
  final SyncTvRoom room;
  final P2pMediaPreferencesController p2pMediaPreferences;

  const RoomScreen({
    super.key,
    required this.room,
    required this.p2pMediaPreferences,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class RoomCollaborationTabBar extends StatelessWidget {
  const RoomCollaborationTabBar({
    super.key,
    required this.labels,
    required this.icons,
    required this.selectedIndex,
    required this.enabled,
    required this.onSelected,
  }) : assert(labels.length == icons.length),
       assert(labels.length == enabled.length);

  final List<String> labels;
  final List<IconData> icons;
  final int selectedIndex;
  final List<bool> enabled;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleIndexes = [
      for (var index = 0; index < labels.length; index++)
        if (enabled[index]) index,
    ];

    if (visibleIndexes.isEmpty) return const SizedBox.shrink();

    return AppPanelSurface(
      height: 56,
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          for (final index in visibleIndexes)
            Expanded(
              child: _RoomCollaborationTabButton(
                label: labels[index],
                icon: icons[index],
                selected: selectedIndex == index,
                enabled: true,
                onPressed: () => onSelected(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoomCollaborationTabButton extends StatelessWidget {
  const _RoomCollaborationTabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppTooltip(
      message: label,
      child: AppInkSurface(
        onTap: enabled ? onPressed : null,
        semanticLabel: label,
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.zero,
        child: SizedBox.expand(
          child: Stack(
            children: [
              Center(
                child: IgnorePointer(
                  child: AppIconButton(
                    onPressed: enabled ? onPressed : null,
                    icon: icon,
                    tooltip: label,
                    iconSize: 22,
                    selected: selected,
                    showTooltip: false,
                    style: selected
                        ? AppIconButtonStyle.tonal
                        : AppIconButtonStyle.ghost,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: AppAnimatedPanelSurface(
                    duration: const Duration(milliseconds: 160),
                    height: selected ? 2 : 0,
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.zero,
                    child: const SizedBox.shrink(),
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

enum _PlaylistViewMode { compact, detailed, grid }

class _RoomScreenState extends State<RoomScreen>
    with SingleTickerProviderStateMixin {
  static const _endedLiveStreamDrainTimeout = Duration(seconds: 120);

  late final RoomChatGateway _chatGateway;
  late final AccountGateway _accountGateway;
  late final ChatReadStateUpdater _chatReadStateUpdater;
  late final RoomPlaybackGateway _playbackGateway;
  late final PlaybackModePreferencesController _playbackModePreferences;
  late final RoomSessionGateway _sessionGateway;
  late final RoomManagementGateway _roomGateway;
  late final MediaLibraryGateway _mediaLibraryGateway;
  late final RealtimeEventLogPreferencesController _realtimeLogPreferences;
  late final RoomRealtimeProtocol _realtimeProtocol;
  late final RoomRealtimeChannelFactory _realtimeChannelFactory;
  late final P2pMediaRuntimeFactory _p2pRuntimeFactory;
  late final VoiceChatSessionFactory _voiceChatSessionFactory;
  late final PlayerVolumePreferencesController _playerVolumePreferences;
  late final BrowserAutoplayController _browserAutoplay;
  late final PlaybackOverlayPreferencesController _playbackOverlayPreferences;
  late final bool _supportsP2pMediaLoader = supportsP2pMediaLoader();

  late TabController _tabController;
  late PlaybackModeConfig _playbackModeConfig;
  VideoPlayerController? _videoPlayerController;
  VideoPlayerController? _initializingVideoPlayerController;
  StreamSubscription<AdaptiveVideoTrackSnapshot>?
  _adaptiveVideoTracksSubscription;
  AdaptiveVideoTrackSnapshot _adaptiveVideoTracks =
      const AdaptiveVideoTrackSnapshot();
  String? _videoPlayerSourceKey;
  int? _videoPlayerSourceExpireAt;
  String? _initializingVideoSourceKey;
  bool _videoPlaybackHasProgress = false;
  VideoPlayerController? _recoveringErroredVideoController;
  bool _isDrainingEndedLiveStream = false;
  Timer? _endedLiveStreamDrainTimer;
  int _forcedVideoLoadGeneration = 0;
  final LatestAsyncOperationCoordinator _videoInitialization =
      LatestAsyncOperationCoordinator();
  final SerialAsyncOperationCoordinator _p2pEngineOperations =
      SerialAsyncOperationCoordinator();
  bool _p2pPreferenceUpdateRunning = false;
  bool _p2pPreferenceUpdateRequested = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<RoomRealtimeChatEntry> _messages = [];
  final List<RoomRealtimeChatEntry> _pinnedMessages = [];
  final Map<String, RoomRealtimeChatEntry> _chatMessageCache = {};
  final Map<String, GlobalKey> _chatMessageKeys = {};
  final Map<String, ChatMessageReadReceiptsInfo> _chatReceiptCache = {};
  final Set<String> _blockedUserIds = <String>{};
  final Set<String> _loadingReplyMessageIds = {};
  final Set<String> _chatReceiptLoadingIds = {};
  final List<RealtimeEventLogEntry> _realtimeEvents = [];
  PickedLocalImage? _selectedChatImage;
  RoomRealtimeChatEntry? _replyingToMessage;
  bool _sendingChatMessage = false;
  final StreamController<RoomRealtimeMessage> _realtimeMessageBus =
      StreamController<RoomRealtimeMessage>.broadcast();
  final StreamController<RealtimeEventLogEntry> _realtimeEventBus =
      StreamController<RealtimeEventLogEntry>.broadcast();
  final StreamController<void> _realtimeReconnectBus =
      StreamController<void>.broadcast();
  final StreamController<void> _realtimeDisconnectBus =
      StreamController<void>.broadcast();
  String _lastChatEventId = '';
  String? _hoveredChatMessageId;
  String? _activeChatMessageId;
  String? _expandedChatActionMessageId;
  String? _highlightedChatMessageId;
  Timer? _syncTimer;
  Timer? _diagnosticsTimer;
  Duration? _serverLatencySnapshot;
  double? _playbackDeviationSnapshot;
  Timer? _chatHighlightTimer;
  late final RoomPlaybackController _playbackController;
  SyncTvPlaybackStatus? get _currentStatus => _playbackController.state.status;
  set _currentStatus(SyncTvPlaybackStatus? value) =>
      _playbackController.setStatus(value);
  RoomRealtimeChannel? _channel;
  List<SyncTvUser> _members = [];
  List<SyncTvUser> _mentionCandidates = [];
  List<ChatMentionInfo> _pendingChatMentions = [];
  AdminRoomMember? _selfMember;
  bool _membershipObservationStarted = false;
  SyncTvRoomSettings _roomSettings = SyncTvRoomSettings();
  bool _playModeUpdateInFlight = false;
  int _onlineMemberCount = 0;
  int _onlineGuestCount = 0;
  bool _membersLoading = false;
  bool _pinnedMessagesLoading = false;
  bool _memberEventsObserved = false;
  bool _playlistItemsObserved = false;
  bool _chatEventsObserved = false;
  bool _chatHistoryRequested = false;
  bool _mentionCandidatesRequested = false;
  bool _mentionCandidatesLoading = false;
  String _mentionCandidateQuery = '';
  int _mentionCandidatePage = 0;
  bool _mentionCandidatesHasMore = true;
  List<RoomMediaEntry> _mediaEntries = [];
  late final TextEditingController _mediaSearchController;
  bool _mediaSupportsSearch = true;
  bool _isLoadingMediaEntries = true;
  bool _isVideoLoading = false;
  bool get _playbackNavigationInFlight =>
      _playbackController.state.navigationInFlight;
  set _playbackNavigationInFlight(bool value) =>
      _playbackController.setNavigationInFlight(value);
  late final PictureInPictureController _pictureInPicture;
  bool _pictureInPictureAvailable = false;
  bool _fullScreenRouteOpen = false;
  final ValueNotifier<int> _videoPresentationRevision = ValueNotifier<int>(0);
  String? _videoError;
  String? _roomSessionError;

  // Pagination
  int _currentPage = 1;
  bool _usesCursorPagination = false;
  String _nextCursor = '';
  final int _pageSize = 20;
  int? _mediaEntryTotal;
  bool _hasMoreMediaEntries = true;
  bool _isLoadingMoreMediaEntries = false;
  bool _isRefreshingMediaEntries = false;
  final AsyncStateEpoch _mediaLibraryStateEpoch = AsyncStateEpoch();
  final ScrollController _mediaEntryScrollController = ScrollController();

  // Playlist navigation
  final List<RoomMediaEntry> _playlistStack = [];
  final List<String> _playlistNameStack = [''];

  SyncTvUser? _currentUser;
  bool _showChatScrollToBottom = false;

  // Sync state
  bool _isSyncing = false;
  int _playbackSyncGeneration = 0;
  final PlaybackOperationTracker<SyncTvPlaybackStatus>
  _playbackOperationTracker = PlaybackOperationTracker();
  bool _serverTimeSyncInFlight = false;
  bool _joiningVoice = false;
  PlaybackDanmakuWindow? _playbackDanmakuWindow;
  bool _loadingPlaybackDanmaku = false;

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _isDisposing = false;

  StreamSubscription<Uint8List>? _realtimeSubscription;
  StreamSubscription? _authErrorSubscription;

  VoiceChatSession? _voiceChatManager;
  P2pMediaSession? _p2pMediaManager;
  P2pMediaPlaybackEngine? _p2pMediaEngine;
  static const _p2pMediaRole = 'media';
  static const _p2pSubtitleRole = 'subtitle';
  static const _p2pDanmakuRole = 'danmaku';
  final Map<String, P2pResourceDelivery> _activeP2pResources = {};
  String get _activeP2pSwarmId =>
      _activeP2pResources[_p2pMediaRole]?.swarmId ?? '';
  _P2pMetricsSnapshot _p2pMetrics = const _P2pMetricsSnapshot();
  DateTime _p2pMetricsSampledAt = DateTime.now();
  int _lastP2pHttpBytes = 0;
  int _lastP2pDownloadBytes = 0;
  int _lastP2pUploadBytes = 0;
  int _retainedP2pHttpBytes = 0;
  int _retainedP2pDownloadBytes = 0;
  int _retainedP2pCacheHits = 0;
  int _retainedP2pCacheMisses = 0;
  int _retainedP2pIntegrityChecks = 0;
  int _retainedP2pIntegrityMismatches = 0;
  int _retainedP2pIntegrityUnavailable = 0;

  // Danmaku Stream
  late final DanmakuController _danmakuController;
  late final ResourceUrlResolver _resourceUrlResolver;

  bool _isSelectionMode = false;
  final Set<String> _selectedMediaEntryIds = {};
  final Map<String, RoomMediaEntry> _selectedMediaEntries = {};
  String _mediaEntriesScopeKey = '';
  String _selectionObservationScopeKey = '';
  int _roomTabIndex = 0;
  _PlaylistViewMode _playlistViewMode = _PlaylistViewMode.compact;

  bool get _showRealtimeDebugTab => kDebugMode;
  int get _roomTabCount => 3 + (_showRealtimeDebugTab ? 1 : 0);
  RoomUiCapabilities get _capabilities => RoomUiCapabilities(
    room: widget.room,
    currentUser: _currentUser,
    selfMember: _selfMember,
    allowDiscoveryFallback: !_membershipObservationStarted,
  );

  bool get _canManageRoom => _capabilities.canManageRoomSettings;

  bool get _canManagePlaybackMode {
    return _capabilities.canManageRoomSettings;
  }

  bool get _isCurrentPlaybackLive => _currentStatus?.entry?.live == true;
  bool get _hasCurrentPlayback {
    final status = _currentStatus;
    return status != null &&
        (status.entry != null ||
            status.playingMediaId.isNotEmpty ||
            status.playingPlaylistId.isNotEmpty);
  }

  bool get _isRoomCreator => _capabilities.isRoomCreator;
  bool get _canNavigatePlayback => _capabilities.canNavigatePlayback;
  bool get _canControlPlaybackState => _capabilities.canControlPlaybackState;

  bool get _canUseVoiceChat {
    if (!_roomSettings.voiceChatEnabled) return false;
    return _capabilities.canUseVoiceChat;
  }

  bool get _canUseP2pMedia {
    if (!_roomSettings.p2pMediaEnabled) return false;
    return _supportsP2pMediaLoader && _capabilities.canUseP2pMedia;
  }

  bool get _canBrowseLibrary => _capabilities.canBrowseLibrary;
  bool get _canViewMembers => _capabilities.canViewMembers;
  bool get _canViewChatHistory => _capabilities.canViewChatHistory;
  bool get _canSendChatMessages => _capabilities.canSendChatMessages;
  bool get _canSendRoomDanmaku =>
      _roomSettings.chatEnabled && _canSendChatMessages;
  bool get _canAccessChat => _canViewChatHistory || _canSendChatMessages;
  bool get _canManageOwnMedia => _capabilities.canManageOwnMedia;
  bool get _canDeleteMedia => _capabilities.canDeleteMedia;
  bool get _canClearMedia => _capabilities.canClearMedia;
  bool get _canRemoveMembers => _capabilities.canRemoveMembers;
  bool get _canManageMemberPermissions =>
      _capabilities.canManageMemberPermissions;
  bool get _canDeleteChatMessages => _capabilities.canDeleteChatMessages;

  bool get _canViewPlaybackHistory => _capabilities.canViewPlaybackHistory;

  List<int> get _visibleRoomTabIndexes => [
    if (_canAccessChat) 0,
    if (_canBrowseLibrary) 1,
    if (_canViewMembers) 2,
    if (_showRealtimeDebugTab) 3,
  ];

  void _ensureSelectedRoomTabIsVisible() {
    final visibleTabs = _visibleRoomTabIndexes;
    if (visibleTabs.isEmpty || visibleTabs.contains(_roomTabIndex)) return;

    final nextIndex = visibleTabs.first;
    _tabController.index = nextIndex;
    if (mounted) {
      setState(() => _roomTabIndex = nextIndex);
    }
  }

  Future<void> _navigatePlayback({required bool previous}) async {
    if (_playbackNavigationInFlight || !_canNavigatePlayback) return;
    setState(() => _playbackNavigationInFlight = true);
    try {
      if (previous) {
        await _playbackGateway.playPrevious(widget.room.roomId);
      } else {
        await _playbackGateway.playNext(widget.room.roomId);
      }
      if (!mounted) return;
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, error.toString());
      }
    } finally {
      if (mounted) setState(() => _playbackNavigationInFlight = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _onlineMemberCount = widget.room.onlineMemberCount;
    _onlineGuestCount = widget.room.onlineGuestCount;
    _mediaSearchController = TextEditingController();
    _chatGateway = DependencyScope.read<RoomChatGateway>(context);
    _accountGateway = DependencyScope.read<AccountGateway>(context);
    _chatReadStateUpdater = ChatReadStateUpdater(
      markRead: (messageId) =>
          _chatGateway.markRead(widget.room.roomId, messageId),
    );
    _playbackGateway = DependencyScope.read<RoomPlaybackGateway>(context);
    _playbackController = RoomPlaybackController();
    _playbackModePreferences =
        DependencyScope.read<PlaybackModePreferencesController>(context);
    _sessionGateway = DependencyScope.read<RoomSessionGateway>(context);
    _roomGateway = DependencyScope.read<RoomManagementGateway>(context);
    _mediaLibraryGateway = DependencyScope.read<MediaLibraryGateway>(context);
    _realtimeLogPreferences =
        DependencyScope.read<RealtimeEventLogPreferencesController>(context);
    _realtimeProtocol = DependencyScope.read<RoomRealtimeProtocol>(context);
    _realtimeChannelFactory = DependencyScope.read<RoomRealtimeChannelFactory>(
      context,
    );
    _p2pRuntimeFactory = DependencyScope.read<P2pMediaRuntimeFactory>(context);
    _voiceChatSessionFactory = DependencyScope.read<VoiceChatSessionFactory>(
      context,
    );
    _playerVolumePreferences =
        DependencyScope.read<PlayerVolumePreferencesController>(context);
    _browserAutoplay = BrowserAutoplayController(
      volumePreferences: _playerVolumePreferences,
    );
    _playbackOverlayPreferences =
        DependencyScope.read<PlaybackOverlayPreferencesController>(context);
    _resourceUrlResolver = DependencyScope.read<ResourceUrlResolver>(context);
    _pictureInPicture = DependencyScope.read<PictureInPictureController>(
      context,
    );
    _danmakuController = DanmakuController(
      DependencyScope.read<DanmakuSource>(context),
      resourceUrlResolver: _resourceUrlResolver,
    );
    _playbackModeConfig = _playbackModePreferences.value;
    _chatScrollController.addListener(_handleChatScroll);
    _authErrorSubscription = _sessionGateway.authErrors.listen((_) {
      if (mounted) {
        _handleRoomSessionClosed(context.l10n.loginExpired);
      }
    });
    _tabController = TabController(length: _roomTabCount, vsync: this);
    _tabController.addListener(_handleRoomTabChanged);
    _realtimeLogPreferences.maxEntries.addListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    _danmakuController.onStreamAccessExpired = () {
      unawaited(_refreshDanmakuStreamAccess());
    };

    // Initialize independent voice-chat and P2P-media sessions.
    _voiceChatManager = _voiceChatSessionFactory.create(
      loadIceServers: () => _loadWebRtcIceServers(),
      onSignalingMessage: (type, data) {
        if (_channel != null) {
          try {
            final bytes = _realtimeProtocol.encodeWebRtcVoiceSignal(type, data);
            _sendRealtimeMessage(bytes);
          } catch (e) {
            debugPrint('WebRTC encode error: $e');
          }
        }
      },
      onStateChange: () {
        if (mounted) setState(() {});
      },
    );
    if (_supportsP2pMediaLoader) {
      _p2pMediaManager = _p2pRuntimeFactory.createSession(
        loadIceServers: () => _loadWebRtcIceServers(),
        loadCachedPiece: (swarmId, pieceKey) =>
            _p2pEngineOperations.run(() async {
              final engine = _p2pMediaEngine;
              if (engine == null) return null;
              return engine.cachedPiece(swarmId, pieceKey);
            }),
        onSignalingMessage: (type, data) {
          if (_channel == null) return;
          try {
            _sendRealtimeMessage(
              _realtimeProtocol.encodeWebRtcMediaSignal(type, data),
            );
          } catch (error) {
            debugPrint('P2P media signaling encode error: $error');
          }
        },
        onStateChange: () {
          if (mounted) setState(() {});
        },
      );
    }
    widget.p2pMediaPreferences.addListener(_handleP2pPreferenceChanged);
    unawaited(
      widget.p2pMediaPreferences.load().then((_) {
        if (mounted) _handleP2pPreferenceChanged();
      }),
    );

    _mediaEntryScrollController.addListener(_onMediaEntryScroll);
    _startDiagnosticsTimers();
    unawaited(_initializePictureInPicture());
    _joinRoom();
  }

  Future<void> _initializePictureInPicture() async {
    final available = await _pictureInPicture.initialize();
    if (mounted) {
      setState(() => _pictureInPictureAvailable = available);
    }
  }

  void _handleP2pPreferenceChanged() {
    _p2pPreferenceUpdateRequested = true;
    if (_p2pPreferenceUpdateRunning) return;
    _p2pPreferenceUpdateRunning = true;
    unawaited(Future<void>.microtask(_drainP2pPreferenceUpdates));
  }

  Future<void> _drainP2pPreferenceUpdates() async {
    try {
      while (_p2pPreferenceUpdateRequested && mounted && !_isDisposing) {
        _p2pPreferenceUpdateRequested = false;
        try {
          await _applyP2pPreference();
        } catch (error) {
          debugPrint('P2P media preference update failed: $error');
        }
      }
    } finally {
      _p2pPreferenceUpdateRunning = false;
      if (_p2pPreferenceUpdateRequested && mounted && !_isDisposing) {
        _handleP2pPreferenceChanged();
      }
    }
  }

  Future<void> _applyP2pPreference() async {
    if (!mounted || _isDisposing) return;
    await _p2pEngineOperations.run(() async {
      final currentEngine = _p2pMediaEngine;
      final modeChanged =
          currentEngine != null &&
          currentEngine.securityMode != widget.p2pMediaPreferences.securityMode;
      final cacheSizeChanged =
          currentEngine != null &&
          currentEngine.maxCacheBytes !=
              widget.p2pMediaPreferences.cacheSizeMiB * 1024 * 1024;
      final activeSwarmIds = _activeP2pResources.values
          .map((delivery) => delivery.swarmId)
          .where((swarmId) => swarmId.isNotEmpty)
          .toSet();
      final currentSwarmsActive =
          activeSwarmIds.isNotEmpty &&
          _p2pMediaManager?.activeSwarms.containsAll(activeSwarmIds) == true;
      if (widget.p2pMediaPreferences.enabled &&
          _canUseP2pMedia &&
          currentEngine != null &&
          !modeChanged &&
          !cacheSizeChanged &&
          currentSwarmsActive) {
        return;
      }
      await _deactivateP2pResources();
      if (identical(_p2pMediaEngine, currentEngine)) {
        _p2pMediaEngine = null;
      }
      if (currentEngine != null) {
        _retainP2pEngineStats(currentEngine.stats.value);
        await currentEngine.dispose();
      }
    });
    if (!mounted || _isDisposing) return;
    final status = _currentStatus;
    final rawUrl = status?.entry?.url ?? '';
    if (!mounted || rawUrl.isEmpty) return;
    await _applyPlaybackStatus(
      status!,
      forceReloadVideo: true,
      forceSeek: true,
    );
  }

  Future<void> _deactivateP2pMedia() async {
    await _setActiveP2pResource(_p2pMediaRole, null);
  }

  Future<void> _deactivateP2pResources() async {
    if (_activeP2pResources.isEmpty &&
        _p2pMediaManager?.activeSwarms.isEmpty == true) {
      return;
    }
    _activeP2pResources.clear();
    await _p2pMediaManager?.setActiveSwarms(const {});
  }

  Future<void> _setActiveP2pResource(
    String role,
    P2pResourceDelivery? delivery,
  ) async {
    if (delivery == null ||
        delivery.swarmId.isEmpty ||
        delivery.swarmTicket.isEmpty) {
      _activeP2pResources.remove(role);
    } else {
      _activeP2pResources[role] = delivery;
    }
    final swarms = <String, String>{};
    for (final active in _activeP2pResources.values) {
      swarms[active.swarmId] = active.swarmTicket;
    }
    await _p2pMediaManager?.setActiveSwarms(swarms);
  }

  Future<P2pMediaPlaybackEngine?> _ensureP2pPlaybackEngine() async {
    final existing = _p2pMediaEngine;
    if (existing != null) return existing;
    final session = _p2pMediaManager;
    if (session == null) return null;
    final engine = await _p2pRuntimeFactory.createPlaybackEngine(
      session: session,
      serverBaseUrl: _sessionGateway.serverBaseUrl,
      maxCacheBytes: widget.p2pMediaPreferences.cacheSizeMiB * 1024 * 1024,
      securityMode: widget.p2pMediaPreferences.securityMode,
    );
    _p2pMediaEngine = engine;
    return engine;
  }

  Future<LocalizedPlaybackResource> _localizeStaticPlaybackResource(
    String role,
    String url,
    Map<String, String> headers,
    P2pResourceDelivery delivery,
  ) => _p2pEngineOperations.run(() async {
    final origin = LocalizedPlaybackResource(
      uri: Uri.parse(url),
      headers: headers,
    );
    await widget.p2pMediaPreferences.load();
    final scheme = origin.uri.scheme.toLowerCase();
    final canUseP2p =
        widget.p2pMediaPreferences.enabled &&
        _canUseP2pMedia &&
        delivery.swarmId.isNotEmpty &&
        delivery.swarmTicket.isNotEmpty &&
        (scheme == 'http' || scheme == 'https');
    if (!canUseP2p) {
      await _setActiveP2pResource(role, null);
      return origin;
    }
    try {
      final engine = await _ensureP2pPlaybackEngine();
      if (engine == null) {
        await _setActiveP2pResource(role, null);
        return origin;
      }
      await _setActiveP2pResource(role, delivery);
      final localized = await engine.localizeStatic(
        upstream: origin.uri,
        headers: headers,
        swarmId: delivery.swarmId,
        logicalKey: 'root',
      );
      return LocalizedPlaybackResource(uri: localized);
    } catch (error) {
      debugPrint('P2P $role gateway setup failed, using HTTP: $error');
      await _setActiveP2pResource(role, null);
      return origin;
    }
  });

  Future<LocalizedPlaybackResource> _resolveSubtitlePlaybackResource(
    String url,
    Map<String, String> headers,
    P2pResourceDelivery delivery,
  ) =>
      _localizeStaticPlaybackResource(_p2pSubtitleRole, url, headers, delivery);

  Future<LocalizedPlaybackResource> _resolveDanmakuPlaybackResource(
    String url,
    Map<String, String> headers,
    P2pResourceDelivery delivery,
  ) => _localizeStaticPlaybackResource(_p2pDanmakuRole, url, headers, delivery);

  void _reconcileActiveP2pTickets(RoomMediaEntry? entry) {
    if (_activeP2pResources.isEmpty) return;
    unawaited(
      _p2pEngineOperations.run(() async {
        P2pResourceDelivery? matchingSubtitle;
        final activeSubtitle = _activeP2pResources[_p2pSubtitleRole];
        if (activeSubtitle != null) {
          for (final value in entry?.subtitles?.values ?? const []) {
            if (value is! Map) continue;
            final candidate = value['p2pDelivery'];
            if (candidate is P2pResourceDelivery &&
                candidate.swarmId == activeSubtitle.swarmId) {
              matchingSubtitle = candidate;
              break;
            }
          }
        }
        final candidates = <String, P2pResourceDelivery?>{
          _p2pMediaRole: entry?.selectedPlaybackUrlOption?.p2pDelivery,
          _p2pSubtitleRole: matchingSubtitle,
          _p2pDanmakuRole: entry?.danmuP2pDelivery,
        };
        var changed = false;
        for (final role in _activeP2pResources.keys.toList()) {
          final active = _activeP2pResources[role]!;
          final candidate = candidates[role];
          if (candidate?.swarmId == active.swarmId) {
            if (candidate!.swarmTicket != active.swarmTicket) {
              _activeP2pResources[role] = candidate;
              changed = true;
            }
          } else {
            _activeP2pResources.remove(role);
            changed = true;
          }
        }
        if (changed) {
          final swarms = <String, String>{};
          for (final active in _activeP2pResources.values) {
            swarms[active.swarmId] = active.swarmTicket;
          }
          await _p2pMediaManager?.setActiveSwarms(swarms);
        }
      }),
    );
  }

  void _retainP2pEngineStats(P2pMediaStats stats) {
    _retainedP2pHttpBytes += stats.httpBytes;
    _retainedP2pDownloadBytes += stats.p2pBytes;
    _retainedP2pCacheHits += stats.cacheHits;
    _retainedP2pCacheMisses += stats.cacheMisses;
    _retainedP2pIntegrityChecks += stats.integrityChecks;
    _retainedP2pIntegrityMismatches += stats.integrityMismatches;
    _retainedP2pIntegrityUnavailable += stats.integrityUnavailable;
  }

  Future<void> _enterPictureInPicture() async {
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;
    if (kIsWeb && _fullScreenRouteOpen && mounted) {
      final entered = await _pictureInPicture.enter(
        aspectRatio: controller.value.aspectRatio,
        videoController: controller,
      );
      if (entered && mounted && _fullScreenRouteOpen) {
        Navigator.of(context).pop();
      }
      return;
    }
    if (_fullScreenRouteOpen && mounted) {
      Navigator.of(context).pop();
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
    }
    await _pictureInPicture.enter(
      aspectRatio: controller.value.aspectRatio,
      videoController: controller,
    );
  }

  Future<void> _setPictureInPicture(bool active) async {
    if (active) {
      await _enterPictureInPicture();
    } else {
      await _pictureInPicture.exit();
    }
  }

  void _startDiagnosticsTimers() {
    unawaited(_syncRoomServerTime());
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_syncRoomServerTime());
    });
    _samplePlaybackDiagnostics();
    _diagnosticsTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      _retryAutomaticPlaybackSync();
      setState(_samplePlaybackDiagnostics);
    });
  }

  void _samplePlaybackDiagnostics() {
    _serverLatencySnapshot = SyncedClock.estimatedLatency;
    _playbackDeviationSnapshot = _playbackDeviationSeconds();
    _sampleP2pMetrics();
  }

  void _sampleP2pMetrics() {
    final now = DateTime.now();
    final elapsed = now.difference(_p2pMetricsSampledAt).inMilliseconds / 1000;
    final stats = _p2pMediaEngine?.stats.value ?? const P2pMediaStats();
    final uploadedBytes = _p2pMediaManager?.uploadedBytes ?? 0;
    final httpBytes = _retainedP2pHttpBytes + stats.httpBytes;
    final p2pDownloadBytes = _retainedP2pDownloadBytes + stats.p2pBytes;
    final seconds = elapsed > 0 ? elapsed : 1;
    _p2pMetrics = _P2pMetricsSnapshot(
      httpBytes: httpBytes,
      p2pDownloadBytes: p2pDownloadBytes,
      p2pUploadBytes: uploadedBytes,
      httpDownloadRate: math.max(0, httpBytes - _lastP2pHttpBytes) / seconds,
      p2pDownloadRate:
          math.max(0, p2pDownloadBytes - _lastP2pDownloadBytes) / seconds,
      p2pUploadRate: math.max(0, uploadedBytes - _lastP2pUploadBytes) / seconds,
      cacheBytes: stats.cacheBytes,
      cacheHits: _retainedP2pCacheHits + stats.cacheHits,
      cacheMisses: _retainedP2pCacheMisses + stats.cacheMisses,
      integrityChecks: _retainedP2pIntegrityChecks + stats.integrityChecks,
      integrityMismatches:
          _retainedP2pIntegrityMismatches + stats.integrityMismatches,
      integrityUnavailable:
          _retainedP2pIntegrityUnavailable + stats.integrityUnavailable,
    );
    _lastP2pHttpBytes = httpBytes;
    _lastP2pDownloadBytes = p2pDownloadBytes;
    _lastP2pUploadBytes = uploadedBytes;
    _p2pMetricsSampledAt = now;
  }

  Future<void> _syncRoomServerTime() async {
    if (_isDisposing || _serverTimeSyncInFlight) return;
    _serverTimeSyncInFlight = true;
    try {
      await _sessionGateway.syncServerTime(refresh: true);
    } finally {
      _serverTimeSyncInFlight = false;
      if (!_isDisposing && mounted) setState(() {});
    }
  }

  Future<void> _joinRoom() async {
    _connectRealtime();
    if (_sessionGateway.sessionIdentity is AccountSessionIdentity) {
      unawaited(_fetchCurrentUser());
      unawaited(_loadBlockedUserIds());
    }
  }

  Future<void> _loadBlockedUserIds() async {
    try {
      final blockedUserIds = <String>{};
      var page = 1;
      while (true) {
        final result = await _accountGateway.listBlockedUsers(
          page: page,
          pageSize: 100,
        );
        blockedUserIds.addAll(result.users.map((item) => item.user.id));
        if (blockedUserIds.length >= result.total || result.users.isEmpty) {
          break;
        }
        page++;
      }
      if (!mounted) return;
      setState(() {
        _blockedUserIds
          ..clear()
          ..addAll(blockedUserIds.where((userId) => userId.isNotEmpty));
        for (final userId in _blockedUserIds) {
          _removeBlockedUserContent(userId);
        }
      });
    } catch (e) {
      debugPrint('Fetch blocked users error: $e');
    }
  }

  void _syncPermissionScopedRoomData() {
    final channel = _channel;
    if (channel == null || _selfMember == null) return;

    _ensureSelectedRoomTabIsVisible();

    if (!_canSelectCurrentPlaylistEntries &&
        (_isSelectionMode || _selectedMediaEntryIds.isNotEmpty)) {
      setState(() {
        _isSelectionMode = false;
        _selectedMediaEntryIds.clear();
        _selectedMediaEntries.clear();
      });
    }

    if (_canBrowseLibrary) {
      if (!_playlistItemsObserved) {
        _playlistItemsObserved = _sendRealtimeMessage(
          _realtimeProtocol.encodePlaylistObservation(),
        );
      }
    } else {
      _invalidateMediaLibraryRequests();
      if (_playlistItemsObserved) {
        _sendRealtimeMessage(
          _realtimeProtocol.encodeUnobserveResource('playlist_items'),
        );
        _playlistItemsObserved = false;
      }
      if (mounted) {
        setState(() {
          _mediaEntries = const [];
          _isLoadingMediaEntries = false;
          _isLoadingMoreMediaEntries = false;
          _hasMoreMediaEntries = false;
        });
      }
    }

    if (_canViewChatHistory) {
      if (!_chatEventsObserved) {
        _chatEventsObserved = _sendRealtimeMessage(
          _realtimeProtocol.encodeChatEventsObservation(
            afterEventId: _lastChatEventId,
          ),
        );
      }
      if (!_chatHistoryRequested) {
        _chatHistoryRequested = true;
        unawaited(_loadChatHistory());
        unawaited(_loadPinnedChatMessages());
      }
    } else {
      if (_chatEventsObserved) {
        _sendRealtimeMessage(
          _realtimeProtocol.encodeUnobserveResource('chat_events'),
        );
        _chatEventsObserved = false;
      }
      _chatHistoryRequested = false;
      if (mounted) {
        setState(() {
          _messages.clear();
          _pinnedMessages.clear();
          _pinnedMessagesLoading = false;
        });
      }
    }

    if (_canViewMembers) {
      if (!_mentionCandidatesRequested) {
        _mentionCandidatesRequested = true;
        unawaited(_loadMentionCandidates(query: '', reset: true));
      }
    } else {
      _mentionCandidatesRequested = false;
      if (mounted) {
        setState(() {
          _mentionCandidates = const [];
          _mentionCandidatesLoading = false;
          _mentionCandidatesHasMore = false;
        });
      }
    }
    _syncMemberTabObservation();
  }

  Future<void> _handleRoomSessionClosed(String message) async {
    _reconnectTimer?.cancel();
    await _disposeVideoController();
    await _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    await _channel?.close();
    _channel = null;
    _voiceChatManager?.leave();
    await _deactivateP2pResources();
    if (!mounted) return;
    setState(() {
      _roomSessionError = message;
      _isVideoLoading = false;
      _isSyncing = false;
    });
    AppNotifications.showError(context, message);
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await _roomGateway.getMe();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      debugPrint('Fetch user error: $e');
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      final page = await _chatGateway.getHistory(
        widget.room.roomId,
        limit: 100,
      );
      final history = page.messages
          .map(RoomRealtimeChatEntry.fromHistory)
          .where((entry) => !entry.isDeleted)
          .toList()
          .reversed;
      if (_canViewChatHistory && page.messages.isNotEmpty) {
        _chatReadStateUpdater.markVisible(page.messages.first.id);
      }
      if (mounted) {
        setState(() {
          _messages.prependUnique(history, maxEntries: 100);
          _indexChatMessages(history);
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Fetch chat history error: $e');
    }
  }

  Future<void> _loadPinnedChatMessages() async {
    if (!mounted) return;
    setState(() => _pinnedMessagesLoading = true);
    try {
      final pinned = await _chatGateway.listPinned(
        widget.room.roomId,
        limit: 20,
      );
      final entries =
          pinned
              .map(
                (entry) => RoomRealtimeChatEntry.fromHistory(
                  entry.message.copyWith(pin: entry.pin),
                ),
              )
              .where((entry) => !entry.isDeleted && entry.isPinned)
              .toList()
            ..sort(_comparePinnedMessages);
      if (!mounted) return;
      setState(() {
        _pinnedMessages
          ..clear()
          ..addAll(entries);
        _indexChatMessages(entries);
      });
    } catch (e) {
      debugPrint('Fetch pinned chat messages error: $e');
    } finally {
      if (mounted) setState(() => _pinnedMessagesLoading = false);
    }
  }

  void _sortMembers(List<SyncTvUser> members) {
    members.sort((a, b) {
      if (a.id == widget.room.creatorId) return -1;
      if (b.id == widget.room.creatorId) return 1;
      final aAdmin = a.role.isRoomAdministrator;
      final bAdmin = b.role.isRoomAdministrator;
      if (aAdmin && !bAdmin) return -1;
      if (!aAdmin && bAdmin) return 1;
      return 0;
    });
  }

  Future<List<IceServerInfo>> _loadWebRtcIceServers() {
    return _roomGateway.getIceServers(widget.room.roomId);
  }

  void _onMediaEntryScroll() {
    if (!_usesCursorPagination) return;
    if (_mediaEntryScrollController.position.pixels >=
        _mediaEntryScrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMediaEntries &&
          !_isLoadingMoreMediaEntries &&
          !_isRefreshingMediaEntries &&
          _hasMoreMediaEntries) {
        _loadMoreMediaEntries();
      }
    }
  }

  Future<void> _loadMoreMediaEntries() async {
    if (_isLoadingMediaEntries ||
        _isLoadingMoreMediaEntries ||
        _isRefreshingMediaEntries ||
        !_hasMoreMediaEntries) {
      return;
    }

    final requestEpoch = _mediaLibraryStateEpoch.capture();
    final parentPlaylist = _playlistStack.isNotEmpty
        ? _playlistStack.last
        : null;
    final requestedPage = _currentPage + 1;
    final requestedCursor = _nextCursor;
    final requestedSearch = _mediaSearchController.text.trim();

    setState(() {
      _isLoadingMoreMediaEntries = true;
    });

    try {
      final result = await _mediaLibraryGateway.listMediaLibrary(
        widget.room.roomId,
        playlistId: parentPlaylist?.playbackPlaylistId ?? '',
        target: parentPlaylist?.playbackTarget,
        page: requestedPage,
        cursor: requestedCursor,
        pageSize: _pageSize,
        search: requestedSearch,
      );

      final entries = result.entries;
      final total = result.total;

      if (!mounted || !_mediaLibraryStateEpoch.isCurrent(requestEpoch)) return;
      setState(() {
        if (entries.isNotEmpty) {
          _mediaEntries.addAll(entries);
          _usesCursorPagination = result.usesCursor;
          _nextCursor = result.nextCursor;
          _currentPage = result.page;
          _mediaEntryTotal = result.total;
          _mediaSupportsSearch = result.supportsSearch;
          _hasMoreMediaEntries = result.usesCursor
              ? result.nextCursor.isNotEmpty
              : total != null && _mediaEntries.length < total;
        } else {
          _hasMoreMediaEntries = false;
        }
        _isLoadingMoreMediaEntries = false;
      });
    } catch (e) {
      debugPrint('Load more media entries error: $e');
      if (!mounted || !_mediaLibraryStateEpoch.isCurrent(requestEpoch)) return;
      setState(() {
        _isLoadingMoreMediaEntries = false;
        _hasMoreMediaEntries = false;
      });
      AppNotifications.showError(context, context.l10n.errorMessage('$e'));
    }
  }

  Future<void> _connectRealtime() async {
    _reconnectTimer?.cancel();
    RoomRealtimeChannel? connectingChannel;

    _invalidateRealtimeMembership();

    try {
      final previousSubscription = _realtimeSubscription;
      final previousChannel = _channel;
      _realtimeSubscription = null;
      _channel = null;
      unawaited(
        _disposePreviousRealtimeConnection(
          previousSubscription,
          previousChannel,
        ),
      );
      final channel = _realtimeChannelFactory.connect(
        widget.room.roomId,
        initialMessages: _realtimeProtocol.encodeInitialObservations(
          includeResolvedPlayback: true,
        ),
        onOutgoing: _recordRealtimeOutgoing,
        onIncoming: _recordRealtimeIncoming,
      );
      connectingChannel = channel;
      _channel = channel;
      _playlistItemsObserved = false;
      _chatEventsObserved = false;
      _memberEventsObserved = false;
      unawaited(_p2pMediaManager?.resetSignalingSession());

      _realtimeSubscription = channel.stream.listen(
        (data) {
          if (_isDisposing) return;
          _reconnectAttempts = 0;
          try {
            final message = _realtimeProtocol.decode(data);
            if (!_realtimeMessageBus.isClosed) {
              _realtimeMessageBus.add(message);
            }
            _handleRealtimeMessage(message);
          } catch (e) {
            debugPrint('Proto decode error: $e');
          }
        },
        onError: (error) {
          if (_isDisposing) return;
          debugPrint('Realtime stream error: $error');
          _handleRealtimeTransportClosed(channel);
        },
        onDone: () {
          if (_isDisposing) return;
          debugPrint('Realtime stream closed');
          _handleRealtimeTransportClosed(channel);
        },
      );
      await channel.ready;
      if (!mounted || _channel != channel) return;
      _reconnectAttempts = 0;
      if (!_realtimeReconnectBus.isClosed) {
        _realtimeReconnectBus.add(null);
      }
      _syncMemberTabObservation();
    } catch (e) {
      debugPrint('Realtime stream connection error: $e');
      if (_channel == connectingChannel) _channel = null;
      _scheduleReconnect();
    }
  }

  void _invalidateRealtimeMembership() {
    _membershipObservationStarted = true;
    if (_selfMember == null) return;
    if (mounted) {
      setState(() => _selfMember = null);
    } else {
      _selfMember = null;
    }
  }

  void _handleRealtimeTransportClosed(RoomRealtimeChannel channel) {
    if (_channel != channel) return;
    _channel = null;
    _realtimeSubscription = null;
    _invalidateRealtimeMembership();
    if (!_realtimeDisconnectBus.isClosed) {
      _realtimeDisconnectBus.add(null);
    }
    _scheduleReconnect();
  }

  Future<void> _disposePreviousRealtimeConnection(
    StreamSubscription<Uint8List>? subscription,
    RoomRealtimeChannel? channel,
  ) async {
    await Future.wait<void>([
      if (subscription != null)
        subscription.cancel().timeout(
          const Duration(seconds: 2),
          onTimeout: () {},
        ),
      if (channel != null)
        channel.close().timeout(const Duration(seconds: 2), onTimeout: () {}),
    ]).catchError((Object error) {
      debugPrint('Realtime connection cleanup error: $error');
      return <void>[];
    });
  }

  void _recordRealtimeIncoming(Uint8List bytes) {
    if (_isDisposing) return;
    final entry = _realtimeProtocol.describeIncoming(bytes);
    if (!_realtimeEventBus.isClosed) _realtimeEventBus.add(entry);
    if (!_showRealtimeDebugTab || !mounted) return;
    _appendRealtimeEvent(entry);
  }

  void _recordRealtimeOutgoing(List<int> bytes) {
    if (_isDisposing) return;
    final entry = _realtimeProtocol.describeOutgoing(bytes);
    if (!_realtimeEventBus.isClosed) _realtimeEventBus.add(entry);
    if (!_showRealtimeDebugTab || !mounted) return;
    _appendRealtimeEvent(entry);
  }

  bool _sendRealtimeMessage(List<int> bytes) {
    if (bytes.isEmpty) return false;
    final channel = _channel;
    if (channel == null) {
      _scheduleReconnect();
      return false;
    }
    try {
      channel.send(bytes);
      return true;
    } catch (e) {
      debugPrint('Realtime send error: $e');
      _channel = null;
      _scheduleReconnect();
      return false;
    }
  }

  void _appendRealtimeEvent(RealtimeEventLogEntry entry) {
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

  void _scheduleReconnect() {
    if (_isDisposing) return;
    if (_reconnectTimer?.isActive ?? false) return;
    _reconnectAttempts = math.min(_reconnectAttempts + 1, 5);
    final delay = Duration(seconds: _reconnectAttempts * 2);
    debugPrint(
      'Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s',
    );

    _reconnectTimer = Timer(delay, () {
      if (mounted) {
        _connectRealtime();
      }
    });
  }

  void _handleRealtimeMessage(RoomRealtimeMessage message) {
    final type = message.kind;

    if (type == RoomRealtimeMessageKind.chat) {
      final content = message.chatContent;
      final chatEntry = _chatEntryFromRealtimeMessage(message);
      final username = chatEntry.username;
      if (message.chatEventId.isNotEmpty) {
        _lastChatEventId = message.chatEventId;
      }
      if (_blockedUserIds.contains(chatEntry.userId)) return;

      if (message.isChatCreated &&
          _playbackOverlayPreferences.value.chatDanmakuEnabled &&
          chatDanmakuMessageTypes.contains(message.chatMessageType) &&
          _videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized) {
        final currentPos = _videoPlayerController!.value.position;
        final danmaku = DanmakuItem(
          text: chatTextWithReactionSummary(
            username: username,
            content: content,
            reactions: message.reactions,
          ),
          startTime: currentPos,
          endTime: currentPos + const Duration(seconds: 8),
          color: Colors.white,
          type: DanmakuType.floating,
          origin: DanmakuOrigin.chat,
        );
        _danmakuController.add(danmaku);
      }

      final shouldAutoScroll = _isChatNearBottom();
      if (mounted) {
        setState(() {
          _messages.applyRealtimeEvent(
            chatEntry,
            eventKind: message.chatEventKind,
            maxEntries: 100,
          );
          _indexChatMessage(chatEntry);
          if (chatEntry.isDeleted) {
            _chatReceiptCache.remove(chatEntry.id);
            _chatMessageKeys.remove(chatEntry.id);
            _pinnedMessages.removeWhere((entry) => entry.id == chatEntry.id);
            if (_replyingToMessage?.id == chatEntry.id) {
              _replyingToMessage = null;
            }
          } else {
            _syncPinnedChatEntryFromRealtime(chatEntry);
          }
        });
        if (shouldAutoScroll) {
          _scrollToBottom();
          if (message.isChatCreated && _canViewChatHistory) {
            _chatReadStateUpdater.markVisible(chatEntry.id);
          }
        } else if (!_showChatScrollToBottom) {
          setState(() => _showChatScrollToBottom = true);
        }
      }
    } else if (type == RoomRealtimeMessageKind.chatPin) {
      final event = message.chatPinEvent;
      if (event == null) return;
      if (_blockedUserIds.contains(event.message.userId)) return;
      if (mounted) {
        setState(() => _applyChatPinEvent(event));
      }
    } else if (type == RoomRealtimeMessageKind.sync ||
        type == RoomRealtimeMessageKind.status ||
        type == RoomRealtimeMessageKind.checkStatus) {
      if (type == RoomRealtimeMessageKind.checkStatus &&
          message.resourceEvent &&
          message.resourceObserveId == 'chat_events') {
        if (_canViewChatHistory) {
          unawaited(_loadChatHistory());
          unawaited(_loadPinnedChatMessages());
        }
        return;
      }
      final playbackStatus = message.playbackStatus;
      if (playbackStatus != null) {
        final mergedStatus = _mergePlaybackStatus(
          playbackStatus,
          incomingHasTiming: true,
        );
        final operationResolution = _playbackOperationTracker.acknowledge(
          playbackStatus.clientOperationId,
          mergedStatus,
        );
        if (!operationResolution.handled) {
          _applyPlaybackStatus(mergedStatus);
        } else if (operationResolution.stateToApply case final state?) {
          _applyPlaybackStatus(state, skipPlayerSync: true);
        }
      } else if (message.status != null) {
        final status = message.status!;
        _applyPlaybackStatus(
          SyncTvPlaybackStatus(
            entry: _currentStatus?.entry,
            isPlaying: status.isPlaying,
            currentTime: status.currentTime,
            playbackRate: status.playbackRate,
            generatedAtMillis: SyncedClock.nowMillis(),
          ),
        );
      }
    } else if (type == RoomRealtimeMessageKind.current) {
      final playbackStatus = message.playbackStatus;
      if (playbackStatus == null) {
        _reportInvalidRealtimePayload(context.l10n.playbackResource);
      } else {
        _applyPlaybackStatus(
          _mergePlaybackStatus(playbackStatus, incomingHasTiming: false),
        );
      }
    } else if (type == RoomRealtimeMessageKind.roomSettings) {
      if (!_isPrimaryResourceMessage(message, 'room_settings')) return;
      final settings = message.roomSettings;
      if (settings == null) return;
      final voiceWasEnabled = _roomSettings.voiceChatEnabled;
      final p2pWasEnabled = _roomSettings.p2pMediaEnabled;
      final voiceWasActive = _voiceChatManager?.isConnected == true;
      final p2pWasActive = _activeP2pResources.isNotEmpty;
      if (mounted) setState(() => _roomSettings = settings);
      if (voiceWasEnabled && !settings.voiceChatEnabled) {
        unawaited(_voiceChatManager?.leave());
        if (voiceWasActive && mounted) {
          AppNotifications.showInfo(
            context,
            context.l10n.voiceChatDisabledByRoom,
          );
        }
      }
      if (p2pWasEnabled != settings.p2pMediaEnabled) {
        _handleP2pPreferenceChanged();
        if (!settings.p2pMediaEnabled && p2pWasActive && mounted) {
          AppNotifications.showInfo(
            context,
            context.l10n.p2pMediaDisabledByRoom,
          );
        }
      }
      return;
    } else if (type == RoomRealtimeMessageKind.myStatus) {
      if (!_isPrimaryResourceMessage(message, 'self_room_member')) return;
      if (mounted) {
        final couldUseVoiceChat = _canUseVoiceChat;
        final couldUseP2pMedia = _canUseP2pMedia;
        setState(() => _selfMember = message.selfMember);
        if (couldUseVoiceChat && !_canUseVoiceChat) {
          unawaited(_voiceChatManager?.leave());
        }
        if (couldUseP2pMedia != _canUseP2pMedia) {
          _handleP2pPreferenceChanged();
        }
        _syncPermissionScopedRoomData();
      }
      return;
    } else if (type == RoomRealtimeMessageKind.memberEvent) {
      if (_isPrimaryResourceMessage(message, 'room_member_events')) {
        _observeRoomMembers();
      }
      return;
    } else if (type == RoomRealtimeMessageKind.mediaLibrary) {
      if (!_isPrimaryResourceMessage(message, 'playlist_items')) return;
      final mediaLibrary = message.mediaLibrary;
      if (mediaLibrary == null) {
        if (message.resourceObserveId.isEmpty) {
          _observeCurrentPlaylist();
        } else {
          _reportInvalidRealtimePayload(context.l10n.playlist);
        }
      } else {
        _applyMediaLibrary(mediaLibrary);
      }
    } else if (type == RoomRealtimeMessageKind.presenceCount) {
      if (!_isPrimaryResourceMessage(message, 'online_count')) return;
      final members = message.members;
      if (members == null) {
        if (mounted) {
          setState(() {
            _onlineMemberCount = message.onlineMemberCount;
            _onlineGuestCount = message.onlineGuestCount;
          });
        }
      } else {
        _applyMembers(members);
      }
    } else if (type == RoomRealtimeMessageKind.error) {
      if (message.resourceObserveId.isNotEmpty &&
          !_isPrimaryObserveId(message.resourceObserveId)) {
        return;
      }
      final error = message.error;
      if (message.resourceObserveId == 'playlist_items' && mounted) {
        final shouldReturnFromPlaylist =
            error?.isPermissionDenied == true && _playlistStack.isNotEmpty;
        _invalidateMediaLibraryRequests();
        setState(() {
          _mediaEntries = const [];
          _currentPage = 1;
          _usesCursorPagination = false;
          _nextCursor = '';
          _mediaEntryTotal = null;
          _hasMoreMediaEntries = false;
          _isLoadingMediaEntries = false;
          _isLoadingMoreMediaEntries = false;
          _selectedMediaEntryIds.clear();
          _selectedMediaEntries.clear();
          _isSelectionMode = false;
          if (shouldReturnFromPlaylist) {
            _playlistStack.removeLast();
            _playlistNameStack.removeLast();
            _mediaSearchController.clear();
            _isLoadingMediaEntries = true;
          }
        });

        if (shouldReturnFromPlaylist) {
          _observeCurrentPlaylist();
        }
      }
      if (error != null && error.clientOperationId.isNotEmpty) {
        final voiceChatManager = _voiceChatManager;
        if (voiceChatManager != null) {
          unawaited(voiceChatManager.rejectJoin(error.clientOperationId));
        }
      }
      if (error != null && error.clientOperationId.isNotEmpty) {
        _rejectLocalPlaybackOperation(error.clientOperationId);
      }
      if (error?.isConflict == true) {
        return;
      }
      final errorMsg = error?.message ?? '';
      if (errorMsg.isNotEmpty && mounted) {
        AppNotifications.showError(
          context,
          message.isPlaylistBrowseAccessDenied
              ? context.l10n.playlistBrowseAccessDenied
              : context.l10n.errorMessage(errorMsg),
        );
      }
    } else if (type == RoomRealtimeMessageKind.expired) {
      if (mounted) {
        _handleRoomSessionClosed(context.l10n.loginExpired);
      }
    } else if (type == RoomRealtimeMessageKind.webrtcVoiceOffer ||
        type == RoomRealtimeMessageKind.webrtcVoiceAnswer ||
        type == RoomRealtimeMessageKind.webrtcVoiceIceCandidate ||
        type == RoomRealtimeMessageKind.webrtcVoicePeerJoined ||
        type == RoomRealtimeMessageKind.webrtcVoicePeerLeft ||
        type == RoomRealtimeMessageKind.webrtcMediaOffer ||
        type == RoomRealtimeMessageKind.webrtcMediaAnswer ||
        type == RoomRealtimeMessageKind.webrtcMediaIceCandidate ||
        type == RoomRealtimeMessageKind.webrtcMediaPeerLeft ||
        type == RoomRealtimeMessageKind.webrtcMediaSwarmPeers) {
      final signal = message.webRtc;
      if (signal == null) return;
      try {
        final signalType = signal.signalType;
        if (signalType.isNotEmpty) {
          switch (signal) {
            case RoomRealtimeWebRtcMediaSignal():
              if (!_canUseP2pMedia) return;
              _p2pMediaManager?.handleSignalingMessage(
                signalType,
                signal.payload(),
              );
            case RoomRealtimeWebRtcVoiceSignal():
              if (!_canUseVoiceChat) return;
              _voiceChatManager?.handleSignalingMessage(
                signalType,
                signal.payload(),
              );
          }
        }
      } catch (e) {
        debugPrint('WebRTC signaling processing error: $e');
      }
    }
  }

  RoomRealtimeChatEntry _chatEntryFromRealtimeMessage(
    RoomRealtimeMessage message,
  ) {
    final currentUser = _currentUser;
    final isCurrentUserMessage =
        currentUser != null &&
        message.senderUserId.isNotEmpty &&
        message.senderUserId == currentUser.id;
    return RoomRealtimeChatEntry.fromMessage(
      message,
      receivedAtMillis: SyncedClock.nowMillis(),
      missingUsername: isCurrentUserMessage
          ? currentUser.username
          : context.l10n.deletedUser,
    );
  }

  void _indexChatMessage(RoomRealtimeChatEntry message) {
    if (message.id.isEmpty) return;
    if (message.isDeleted) {
      _chatMessageCache[message.id] = message;
      _chatReceiptCache.remove(message.id);
      _chatMessageKeys.remove(message.id);
      return;
    }
    _chatMessageCache[message.id] = message;
  }

  void _indexChatMessages(Iterable<RoomRealtimeChatEntry> messages) {
    for (final message in messages) {
      _indexChatMessage(message);
    }
  }

  void _applyChatPinEvent(ChatPinEventInfo event) {
    final clearPin =
        event.kind ==
            client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_UNPINNED ||
        event.kind ==
            client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_MESSAGE_DELETED;
    final pin = clearPin ? null : event.pin;
    final eventEntry = RoomRealtimeChatEntry.fromHistory(
      event.message.copyWith(pin: pin, clearPin: clearPin),
    );
    final index = _messages.indexWhere((entry) => entry.id == event.message.id);
    if (index >= 0) {
      final updated = _messages[index].copyWith(pin: pin, clearPin: clearPin);
      _messages[index] = updated;
      _indexChatMessage(updated);
    } else {
      _indexChatMessage(eventEntry);
    }
    final cached = _chatMessageCache[event.message.id];
    if (cached != null) {
      _chatMessageCache[event.message.id] = cached.copyWith(
        pin: pin,
        clearPin: clearPin,
      );
    }
    _applyPinnedChatEntry(eventEntry, clearPin: clearPin);
  }

  void _applyPinnedChatEntry(
    RoomRealtimeChatEntry entry, {
    required bool clearPin,
  }) {
    if (entry.id.isEmpty) return;
    _pinnedMessages.removeWhere((message) => message.id == entry.id);
    if (!clearPin && entry.isPinned && !entry.isDeleted) {
      _pinnedMessages.add(entry);
      _pinnedMessages.sort(_comparePinnedMessages);
    }
  }

  void _syncPinnedChatEntryFromRealtime(RoomRealtimeChatEntry entry) {
    if (entry.id.isEmpty) return;
    final index = _pinnedMessages.indexWhere(
      (message) => message.id == entry.id,
    );
    if (index < 0) return;
    final pinned = _pinnedMessages[index];
    _pinnedMessages[index] = entry.copyWith(pin: pinned.pin);
    _pinnedMessages.sort(_comparePinnedMessages);
  }

  int _comparePinnedMessages(RoomRealtimeChatEntry a, RoomRealtimeChatEntry b) {
    final pinnedAtCompare =
        b.pin?.pinnedAt.compareTo(a.pin?.pinnedAt ?? 0) ?? 0;
    if (pinnedAtCompare != 0) return pinnedAtCompare;
    return b.timestampMillis.compareTo(a.timestampMillis);
  }

  RoomRealtimeChatEntry? _replyPreviewFor(RoomRealtimeChatEntry message) {
    final replyId = message.replyToMessageId;
    if (replyId.isEmpty) return null;
    final cached = _chatMessageCache[replyId];
    if (cached != null) return cached;
    _ensureReplyPreviewLoaded(replyId);
    return null;
  }

  void _ensureReplyPreviewLoaded(String messageId) {
    if (messageId.isEmpty ||
        _chatMessageCache.containsKey(messageId) ||
        _loadingReplyMessageIds.contains(messageId)) {
      return;
    }
    _loadingReplyMessageIds.add(messageId);
    unawaited(() async {
      try {
        final message = await _chatGateway.getMessage(
          widget.room.roomId,
          messageId,
          includeDeleted: true,
        );
        final entry = RoomRealtimeChatEntry.fromHistory(message);
        if (!mounted) return;
        setState(() => _indexChatMessage(entry));
      } catch (e) {
        debugPrint('Load reply preview error: $e');
      } finally {
        _loadingReplyMessageIds.remove(messageId);
      }
    }());
  }

  String _chatPreviewText(RoomRealtimeChatEntry message) {
    if (message.isDeleted) return context.l10n.messageDeleted;
    final text = message.content.trim();
    if (text.isNotEmpty) return text;
    if (message.images.isNotEmpty) return context.l10n.imageMessage;
    return context.l10n.genericMessage;
  }

  GlobalKey _chatMessageKey(String messageId) {
    return _chatMessageKeys.putIfAbsent(messageId, GlobalKey.new);
  }

  Future<void> _jumpToChatMessage(String messageId) async {
    if (messageId.isEmpty) return;
    var index = _messages.indexWhere((message) => message.id == messageId);
    if (index < 0) {
      await _loadChatMessageContext(messageId);
      if (!mounted) return;
      index = _messages.indexWhere((message) => message.id == messageId);
    }
    if (index < 0) {
      AppNotifications.showInfo(context, context.l10n.quotedMessageUnavailable);
      return;
    }
    _highlightChatMessage(messageId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = _chatMessageKeys[messageId]?.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          alignment: 0.28,
        );
        return;
      }
      if (!_chatScrollController.hasClients || _messages.length <= 1) return;
      final maxScroll = _chatScrollController.position.maxScrollExtent;
      final offset = maxScroll * (index / (_messages.length - 1));
      _chatScrollController.animateTo(
        offset.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _loadChatMessageContext(String messageId) async {
    try {
      final contextInfo = await _chatGateway.getContext(
        widget.room.roomId,
        messageId,
        beforeLimit: 30,
        afterLimit: 30,
        includeDeleted: true,
      );
      final entries =
          [...contextInfo.before, contextInfo.message, ...contextInfo.after]
              .map(RoomRealtimeChatEntry.fromHistory)
              .where((entry) => !entry.isDeleted);
      if (!mounted) return;
      setState(() {
        for (final entry in entries) {
          _messages.applyRealtimeEvent(
            entry,
            eventKind: RoomRealtimeChatEventKind.created,
            maxEntries: 160,
          );
          _indexChatMessage(entry);
        }
        _messages.sort(
          (a, b) => a.timestampMillis.compareTo(b.timestampMillis),
        );
      });
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadQuotedContextFailed('$e'),
        );
      }
    }
  }

  void _highlightChatMessage(String messageId) {
    _chatHighlightTimer?.cancel();
    setState(() => _highlightedChatMessageId = messageId);
    _chatHighlightTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted || _highlightedChatMessageId != messageId) return;
      setState(() => _highlightedChatMessageId = null);
    });
  }

  bool _isPrimaryResourceMessage(
    RoomRealtimeMessage message,
    String observeId,
  ) {
    return message.resourceObserveId.isEmpty ||
        message.resourceObserveId == observeId;
  }

  bool _isPrimaryObserveId(String observeId) {
    return observeId == 'room_settings' ||
        observeId == 'playlist_items' ||
        observeId == 'room_member_events' ||
        observeId == 'self_room_member' ||
        observeId == 'online_count' ||
        observeId == 'playback_state' ||
        observeId == 'playback';
  }

  SyncTvPlaybackStatus _mergePlaybackStatus(
    SyncTvPlaybackStatus incoming, {
    required bool incomingHasTiming,
  }) => mergePlaybackStatusSnapshot(
    current: _currentStatus,
    incoming: incoming,
    incomingHasTiming: incomingHasTiming,
  );

  void _deactivateP2pSubtitle() {
    unawaited(
      _p2pEngineOperations.run(
        () => _setActiveP2pResource(_p2pSubtitleRole, null),
      ),
    );
  }

  void _applyMediaLibrary(RoomMediaLibraryPage mediaLibrary) {
    if (!mounted) return;
    final scopeChanged = _mediaEntriesScopeKey != _selectionObservationScopeKey;
    final pageChanged =
        !mediaLibrary.usesCursor && mediaLibrary.page != _currentPage;
    if (!scopeChanged && !pageChanged) {
      final currentIds = mediaLibrary.entries.map((entry) => entry.id).toSet();
      for (final entry in _mediaEntries) {
        if (!currentIds.contains(entry.id)) {
          _selectedMediaEntryIds.remove(entry.id);
          _selectedMediaEntries.remove(entry.id);
        }
      }
    }
    for (final entry in mediaLibrary.entries) {
      if (_selectedMediaEntryIds.contains(entry.id)) {
        _selectedMediaEntries[entry.id] = entry;
      }
    }
    setState(() {
      _mediaEntries = mediaLibrary.entries;
      _mediaSupportsSearch = mediaLibrary.supportsSearch;
      _mediaEntriesScopeKey = _selectionObservationScopeKey;
      _currentPage = mediaLibrary.page;
      _mediaEntryTotal = mediaLibrary.total;
      _usesCursorPagination = mediaLibrary.usesCursor;
      _nextCursor = mediaLibrary.nextCursor;
      _hasMoreMediaEntries = mediaLibrary.hasNextPage(_pageSize);
      _isLoadingMediaEntries = false;
      if (_selectedMediaEntryIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _applyMembers(List<SyncTvUser> members) {
    if (!mounted) return;
    _sortMembers(members);
    setState(() {
      _members = members;
    });
  }

  void _reportInvalidRealtimePayload(String resourceName) {
    final message = context.l10n.serverSnapshotMissing(resourceName);
    debugPrint(message);
    if (mounted) AppNotifications.showError(context, message);
  }

  Future<void> _performSync(
    SyncTvPlaybackStatus status, {
    bool forceSeek = false,
  }) async {
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final syncGeneration = ++_playbackSyncGeneration;
    bool isCurrentSync() =>
        mounted &&
        syncGeneration == _playbackSyncGeneration &&
        identical(_currentStatus, status) &&
        identical(_videoPlayerController, controller);
    if (!isCurrentSync()) return;
    _isSyncing = true;

    try {
      if (controller.value.playbackSpeed != status.playbackRate) {
        await controller.setPlaybackSpeed(status.playbackRate);
        if (!isCurrentSync()) return;
        _refreshPlaybackUi(controller);
      }

      final isLive = status.entry?.live == true;
      final target = isLive ? null : _playbackSyncTarget(status, controller);
      final targetIsPlaying = target?.isAtEnd == true
          ? false
          : status.isPlaying;
      if (!targetIsPlaying && controller.value.isPlaying) {
        await controller.pause();
        if (!isCurrentSync()) return;
        _refreshPlaybackUi(controller);
      }
      if (target != null) {
        final currentPos = controller.value.position.inMilliseconds / 1000.0;
        final positionDrift = (currentPos - target.positionSeconds).abs();
        final shouldAutoSeek =
            target.isAtEnd ||
            shouldAutoSeekToPlaybackSyncTarget(
              currentPositionSeconds: currentPos,
              target: target,
              driftThresholdSeconds:
                  _playbackModeConfig.autoSeekDriftThresholdSeconds,
              freeModeEnabled: _playbackModeConfig.freeModeEnabled,
            );
        final shouldManualSeek =
            forceSeek &&
            positionDrift >=
                _playbackModeConfig.manualSeekDriftThresholdSeconds;
        if (target.isAtEnd || shouldManualSeek || shouldAutoSeek) {
          await controller.seekTo(
            Duration(milliseconds: (target.positionSeconds * 1000).toInt()),
          );
          if (!isCurrentSync()) return;
          _refreshPlaybackUi(controller);
        }
      }

      if (targetIsPlaying && controller.value.isPlaying == false) {
        await _browserAutoplay.play(controller);
        if (!isCurrentSync()) return;
        _refreshPlaybackUi(controller);
      }
      if (isCurrentSync()) _refreshPlaybackUi(controller);
    } catch (e) {
      if (!_isDisposedVideoControllerError(e)) {
        debugPrint('Sync execution error: $e');
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && syncGeneration == _playbackSyncGeneration) {
          _isSyncing = false;
        }
      });
    }
  }

  PlaybackSyncTarget _playbackSyncTarget(
    SyncTvPlaybackStatus status,
    VideoPlayerController controller,
  ) {
    return resolvePlaybackSyncTarget(
      status: status,
      duration: controller.value.duration,
      now: SyncedClock.now(),
    );
  }

  void _retryAutomaticPlaybackSync() {
    if (_isSyncing || _playbackModeConfig.freeModeEnabled) return;

    final status = _currentStatus;
    final controller = _videoPlayerController;
    if (status?.entry?.live != false ||
        controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    final target = _playbackSyncTarget(status!, controller);
    final currentPositionSeconds =
        controller.value.position.inMilliseconds / 1000.0;
    if (!shouldAutoSeekToPlaybackSyncTarget(
      currentPositionSeconds: currentPositionSeconds,
      target: target,
      driftThresholdSeconds: _playbackModeConfig.autoSeekDriftThresholdSeconds,
      freeModeEnabled: _playbackModeConfig.freeModeEnabled,
    )) {
      return;
    }

    unawaited(_performSync(status));
  }

  double? _playbackDeviationSeconds() {
    final status = _currentStatus;
    final controller = _videoPlayerController;
    if (status == null ||
        status.entry == null ||
        status.entry!.live ||
        controller == null ||
        !controller.value.isInitialized) {
      return null;
    }
    final target = _playbackSyncTarget(status, controller);
    final actual = controller.value.position.inMilliseconds / 1000.0;
    final deviation = actual - target.positionSeconds;
    return deviation.isFinite ? deviation : null;
  }

  String _formatLatency(Duration? latency) {
    if (latency == null) return '--';
    final millis = latency.inMicroseconds / 1000.0;
    if (millis > 0 && millis < 1) return '<1ms';
    if (millis < 10) return '${millis.toStringAsFixed(1)}ms';
    if (millis < 1000) return '${millis.round()}ms';
    return '${(millis / 1000).toStringAsFixed(2)}s';
  }

  String _formatDeviation(double seconds) {
    final sign = seconds > 0
        ? '+'
        : seconds < 0
        ? '-'
        : '';
    final absolute = seconds.abs();
    final digits = absolute < 10 ? 2 : 1;
    return '$sign${absolute.toStringAsFixed(digits)}s';
  }

  Color _serverLatencyColor(Duration? latency, {required bool videoStyle}) {
    if (latency == null) {
      return videoStyle
          ? Colors.white70
          : Theme.of(context).colorScheme.onSurfaceVariant;
    }
    final millis = latency.inMicroseconds / 1000.0;
    if (millis <= 120) {
      return videoStyle ? const Color(0xFF7CFFB2) : Colors.green;
    }
    if (millis <= 350) {
      return videoStyle ? Colors.amberAccent : Colors.orange;
    }
    return videoStyle
        ? const Color(0xFFFF8A80)
        : Theme.of(context).colorScheme.error;
  }

  Color _playbackDeviationColor(double deviation, {required bool videoStyle}) {
    final absolute = deviation.abs();
    final warningThreshold = math.max(
      0.5,
      _playbackModeConfig.autoSeekDriftThresholdSeconds,
    );
    if (absolute <= 0.5) {
      return videoStyle ? const Color(0xFF7CFFB2) : Colors.green;
    }
    if (absolute <= warningThreshold) {
      return videoStyle ? Colors.amberAccent : Colors.orange;
    }
    return videoStyle
        ? const Color(0xFFFF8A80)
        : Theme.of(context).colorScheme.error;
  }

  Widget _buildServerLatencyBadge({
    required bool compact,
    bool videoStyle = false,
  }) {
    final latency = _serverLatencySnapshot;
    final color = _serverLatencyColor(latency, videoStyle: videoStyle);
    final background = videoStyle
        ? Colors.white.withValues(alpha: 0.12)
        : color.withValues(alpha: 0.10);
    final label = compact
        ? _formatLatency(latency)
        : context.l10n.latencyValue(_formatLatency(latency));
    return AppTooltip(
      message: context.l10n.serverLatency,
      child: AppBadge(
        constraints: const BoxConstraints(minHeight: 28, maxWidth: 128),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: BorderRadius.circular(16),
        borderSide: videoStyle ? const BorderSide(color: Colors.white24) : null,
        icon: Icons.network_ping_rounded,
        iconSize: 15,
        color: color,
        backgroundColor: background,
        textStyle: TextStyle(color: color, fontSize: 12),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget? _buildPlaybackDeviationBadge({
    required bool compact,
    bool videoStyle = false,
  }) {
    final deviation = _playbackDeviationSnapshot;
    if (deviation == null) return null;
    final color = _playbackDeviationColor(deviation, videoStyle: videoStyle);
    final background = videoStyle
        ? Colors.white.withValues(alpha: 0.12)
        : color.withValues(alpha: 0.10);
    final label = compact
        ? _formatDeviation(deviation)
        : context.l10n.deviationValue(_formatDeviation(deviation));
    return AppTooltip(
      message: context.l10n.playbackDeviation,
      child: AppBadge(
        constraints: const BoxConstraints(minHeight: 28, maxWidth: 128),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: BorderRadius.circular(16),
        borderSide: videoStyle ? const BorderSide(color: Colors.white24) : null,
        icon: Icons.speed_rounded,
        iconSize: 15,
        color: color,
        backgroundColor: background,
        textStyle: TextStyle(color: color, fontSize: 12),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget? _buildP2pMediaBadge({bool videoStyle = false}) {
    if (!_canUseP2pMedia ||
        _activeP2pResources.isEmpty ||
        !widget.p2pMediaPreferences.enabled) {
      return null;
    }
    final peers = _p2pMediaManager?.connectedPeerCount ?? 0;
    final color = peers > 0
        ? (videoStyle ? const Color(0xFF7CFFB2) : Colors.green)
        : (videoStyle
              ? Colors.white70
              : Theme.of(context).colorScheme.onSurfaceVariant);
    final rate = _formatByteRate(_p2pMetrics.totalDownloadRate);
    return AppTooltip(
      message:
          '${context.l10n.p2pMediaDescription}\n'
          '${context.l10n.totalDownload}: $rate',
      child: GestureDetector(
        onTap: _showP2pMetricsDialog,
        child: AppBadge(
          constraints: const BoxConstraints(minHeight: 28, maxWidth: 160),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          borderRadius: BorderRadius.circular(16),
          borderSide: videoStyle
              ? const BorderSide(color: Colors.white24)
              : null,
          icon: Icons.hub_rounded,
          iconSize: 15,
          color: color,
          backgroundColor: videoStyle
              ? Colors.white.withValues(alpha: 0.12)
              : color.withValues(alpha: 0.10),
          textStyle: TextStyle(color: color, fontSize: 12),
          label: Text('P2P · $peers · $rate'),
        ),
      ),
    );
  }

  String _formatBytes(num bytes) {
    const units = ['B', 'KiB', 'MiB', 'GiB', 'TiB'];
    var value = bytes.toDouble();
    var unit = 0;
    while (value >= 1024 && unit < units.length - 1) {
      value /= 1024;
      unit++;
    }
    return '${value.toStringAsFixed(unit == 0 || value >= 100 ? 0 : 1)} ${units[unit]}';
  }

  String _formatByteRate(num bytesPerSecond) =>
      '${_formatBytes(bytesPerSecond)}/s';

  String _formatTransferMetric(int bytes, double rate) =>
      '${_formatByteRate(rate)} · ${_formatBytes(bytes)}';

  Future<void> _showP2pMetricsDialog() {
    final metrics = _p2pMetrics;
    final peers = _p2pMediaManager?.connectedPeerCount ?? 0;
    final rows = <(String, String)>[
      (
        context.l10n.totalDownload,
        _formatTransferMetric(
          metrics.totalDownloadBytes,
          metrics.totalDownloadRate,
        ),
      ),
      (
        context.l10n.totalUpload,
        _formatTransferMetric(metrics.p2pUploadBytes, metrics.p2pUploadRate),
      ),
      (
        context.l10n.httpDownload,
        _formatTransferMetric(metrics.httpBytes, metrics.httpDownloadRate),
      ),
      (
        context.l10n.p2pDownload,
        _formatTransferMetric(
          metrics.p2pDownloadBytes,
          metrics.p2pDownloadRate,
        ),
      ),
      (
        context.l10n.p2pUpload,
        _formatTransferMetric(metrics.p2pUploadBytes, metrics.p2pUploadRate),
      ),
      (context.l10n.connectedPeers, peers.toString()),
      (context.l10n.p2pCache, _formatBytes(metrics.cacheBytes)),
      (
        context.l10n.cacheHitRate,
        '${(metrics.cacheHitRatio * 100).toStringAsFixed(1)}%',
      ),
      (context.l10n.p2pIntegrityChecks, metrics.integrityChecks.toString()),
      (
        context.l10n.p2pIntegrityMismatches,
        metrics.integrityMismatches.toString(),
      ),
      (
        context.l10n.p2pIntegrityUnavailable,
        metrics.integrityUnavailable.toString(),
      ),
    ];
    return showAppDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialog(
        icon: const Icon(Icons.hub_rounded),
        title: Text(context.l10n.p2pMetrics),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: rows
              .map(
                (row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(child: Text(row.$1)),
                      const SizedBox(width: 20),
                      Text(
                        row.$2,
                        style: const TextStyle(
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
        ),
        actions: [
          AppActionButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            label: context.l10n.close,
            style: AppActionButtonStyle.text,
          ),
        ],
      ),
    );
  }

  String _playModeDiagnosticsLabel(client_enum.PlayMode mode) {
    return switch (mode) {
      client_enum.PlayMode.PLAY_MODE_REPEAT_ONE => 'repeat_one',
      client_enum.PlayMode.PLAY_MODE_REPEAT_ALL => 'repeat_all',
      client_enum.PlayMode.PLAY_MODE_SHUFFLE => 'shuffle',
      _ => 'sequential',
    };
  }

  AdaptiveVideoTrackInfo? _selectedAdaptiveVideoTrack() {
    final selectedId = _adaptiveVideoTracks.selectedTrackId;
    if (selectedId == 'auto') return null;
    for (final track in _adaptiveVideoTracks.tracks) {
      if (track.id == selectedId) return track;
    }
    return null;
  }

  String _adaptiveTrackDiagnosticsLabel() {
    final selectedId = _adaptiveVideoTracks.selectedTrackId;
    if (_adaptiveVideoTracks.tracks.isEmpty) return '';
    if (selectedId == 'auto') return context.l10n.automatic;
    final selected = _selectedAdaptiveVideoTrack();
    if (selected == null) return selectedId;
    return [
      selected.title ?? '',
      selected.resolution,
      if (selected.fps != null && selected.fps! > 0)
        '${selected.fps!.toStringAsFixed(2)} fps',
    ].where((value) => value.isNotEmpty).join(' · ');
  }

  PlaybackDiagnosticsContext _playbackDiagnosticsContext() {
    final status = _currentStatus;
    final entry = status?.entry;
    final selectedUrl = entry?.selectedPlaybackUrlOption;
    final selectedTrack = _selectedAdaptiveVideoTrack();
    return PlaybackDiagnosticsContext(
      roomId: widget.room.roomId,
      mediaId: status?.playingMediaId.isNotEmpty == true
          ? status!.playingMediaId
          : entry?.playbackMediaId ?? '',
      playlistId: status?.playingPlaylistId.isNotEmpty == true
          ? status!.playingPlaylistId
          : entry?.playbackPlaylistId ?? '',
      targetHash: status?.targetHash ?? '',
      provider: entry == null
          ? ''
          : SourceConfigCodec.providerToString(entry.sourceProvider),
      providerInstance: entry?.providerInstanceName ?? '',
      resourceType: selectedUrl?.format.isNotEmpty == true
          ? selectedUrl!.format
          : entry?.type ?? '',
      playbackRoute: entry?.playbackChoiceLabel ?? '',
      adaptiveTrack: _adaptiveTrackDiagnosticsLabel(),
      codec: selectedTrack?.codec ?? selectedUrl?.codec ?? '',
      bitrate: selectedTrack?.bitrate ?? selectedUrl?.bitrate,
      roomPlaybackVersion: status?.version,
      playMode: _playModeDiagnosticsLabel(_roomSettings.autoPlayMode),
      serverLatency: _serverLatencySnapshot,
      playbackDeviationSeconds: _playbackDeviationSnapshot,
      httpBytes: _p2pMetrics.httpBytes,
      p2pDownloadBytes: _p2pMetrics.p2pDownloadBytes,
      p2pUploadBytes: _p2pMetrics.p2pUploadBytes,
      httpDownloadRate: _p2pMetrics.httpDownloadRate,
      p2pDownloadRate: _p2pMetrics.p2pDownloadRate,
      p2pUploadRate: _p2pMetrics.p2pUploadRate,
      connectedPeers: _p2pMediaManager?.connectedPeerCount ?? 0,
      cacheBytes: _p2pMetrics.cacheBytes,
      cacheHits: _p2pMetrics.cacheHits,
      cacheMisses: _p2pMetrics.cacheMisses,
      integrityChecks: _p2pMetrics.integrityChecks,
      integrityMismatches: _p2pMetrics.integrityMismatches,
      integrityUnavailable: _p2pMetrics.integrityUnavailable,
    );
  }

  Widget? _buildPlaybackDiagnosticsBadges({
    bool compact = false,
    bool includeLatency = false,
    bool videoStyle = false,
  }) {
    final badges = <Widget>[
      if (includeLatency)
        _buildServerLatencyBadge(compact: compact, videoStyle: videoStyle),
    ];
    final deviationBadge = _buildPlaybackDeviationBadge(
      compact: compact,
      videoStyle: videoStyle,
    );
    if (deviationBadge != null) badges.add(deviationBadge);
    final p2pBadge = _buildP2pMediaBadge(videoStyle: videoStyle);
    if (p2pBadge != null) badges.add(p2pBadge);
    if (badges.isEmpty) return null;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: badges,
    );
  }

  void _refreshPlaybackUi(VideoPlayerController controller) {
    if (!mounted || !identical(_videoPlayerController, controller)) return;
    setState(() {});
  }

  bool _isDisposedVideoControllerError(Object error) {
    return error.toString().contains(
      'VideoPlayerController was used after being disposed',
    );
  }

  double _boundedPlaybackTime(double currentTime) {
    if (!currentTime.isFinite || currentTime < 0) return 0;
    final duration = _videoPlayerController?.value.duration;
    if (duration == null || duration <= Duration.zero) return currentTime;
    final durationSeconds = duration.inMilliseconds / 1000.0;
    if (durationSeconds <= 0) return currentTime;
    return currentTime.clamp(0.0, durationSeconds).toDouble();
  }

  void _videoListener() {
    final controller = _videoPlayerController;
    if (controller == null) return;

    final value = controller.value;
    if (_isDrainingEndedLiveStream && (value.isCompleted || value.hasError)) {
      _finishEndedLiveStreamDrain(controller);
      return;
    }
    if (value.hasError) {
      unawaited(_recoverErroredVideoPlayback(controller));
      return;
    }
    if (!value.isInitialized) return;
    if (!_videoPlaybackHasProgress && value.position > Duration.zero) {
      _videoPlaybackHasProgress = true;
    }
    if (_isSyncing) return;

    final position = _boundedPlaybackTime(
      value.position.inMilliseconds / 1000.0,
    );
    if (value.isPlaying && !_isCurrentPlaybackLive) {
      unawaited(_maybeFetchPlaybackDanmaku(position));
    }
  }

  Future<void> _recoverErroredVideoPlayback(
    VideoPlayerController controller,
  ) async {
    if (!mounted ||
        !identical(_videoPlayerController, controller) ||
        identical(_recoveringErroredVideoController, controller)) {
      return;
    }
    _recoveringErroredVideoController = controller;
    try {
      final status = _currentStatus;
      if (status?.entry?.url.isNotEmpty == true) {
        await _applyPlaybackStatus(
          status!,
          forceReloadVideo: true,
          forceSeek: true,
        );
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    } finally {
      if (identical(_recoveringErroredVideoController, controller)) {
        _recoveringErroredVideoController = null;
      }
    }
  }

  void _handleUserPlaybackStateChanged(bool isPlaying) {
    _dispatchPlaybackControlIntent(
      _newPlaybackControlIntent(
        _PlaybackControlIntentKind.playbackState,
        isPlaying: isPlaying,
      ),
    );
  }

  void _handleUserSeek(Duration position) {
    if (_isCurrentPlaybackLive) return;
    _dispatchPlaybackControlIntent(
      _newPlaybackControlIntent(
        _PlaybackControlIntentKind.seek,
        position: position,
      ),
    );
  }

  void _handleUserPlaybackSpeedChanged(double speed) {
    _dispatchPlaybackControlIntent(
      _newPlaybackControlIntent(_PlaybackControlIntentKind.speed, speed: speed),
    );
  }

  _PlaybackControlIntent _newPlaybackControlIntent(
    _PlaybackControlIntentKind kind, {
    bool? isPlaying,
    Duration? position,
    double? speed,
  }) {
    return _PlaybackControlIntent(
      kind: kind,
      clientOperationId: newClientOperationId(),
      clientTimeMillis: SyncedClock.nowMillis(),
      isPlaying: isPlaying,
      position: position,
      speed: speed,
    );
  }

  void _dispatchPlaybackControlIntent(_PlaybackControlIntent intent) {
    final message = _buildPlaybackControlMessage(intent);
    if (message == null) return;
    final previousStatus = _currentStatus;
    final optimisticStatus = _optimisticPlaybackStatus(intent);
    if (previousStatus == null || optimisticStatus == null) return;

    _playbackOperationTracker.remember(
      intent.clientOperationId,
      previousStatus,
    );
    setState(() => _currentStatus = optimisticStatus);
    if (!_sendRealtimeMessage(message)) {
      _rejectLocalPlaybackOperation(intent.clientOperationId);
    }
  }

  List<int>? _buildPlaybackControlMessage(_PlaybackControlIntent intent) {
    final value = _videoPlayerController?.value;
    if (value == null) return null;
    final reporter = _playbackControlReporter();
    return switch (intent.kind) {
      _PlaybackControlIntentKind.playbackState => reporter.playbackStateChanged(
        value: value,
        isPlaying: intent.isPlaying!,
        clientOperationId: intent.clientOperationId,
        clientTimeMillis: intent.clientTimeMillis,
      ),
      _PlaybackControlIntentKind.seek => reporter.seek(
        value: value,
        position: intent.position!,
        clientOperationId: intent.clientOperationId,
        clientTimeMillis: intent.clientTimeMillis,
      ),
      _PlaybackControlIntentKind.speed => reporter.playbackSpeedChanged(
        value: value,
        speed: intent.speed!,
        clientOperationId: intent.clientOperationId,
        clientTimeMillis: intent.clientTimeMillis,
      ),
    };
  }

  SyncTvPlaybackStatus? _optimisticPlaybackStatus(
    _PlaybackControlIntent intent,
  ) {
    final status = _currentStatus;
    final value = _videoPlayerController?.value;
    if (status == null || value == null) return null;
    final currentTime = _isCurrentPlaybackLive
        ? status.currentTime
        : intent.position?.inMilliseconds.toDouble() ??
              value.position.inMilliseconds.toDouble();
    return status.copyWith(
      isPlaying: intent.isPlaying ?? status.isPlaying,
      currentTime: _isCurrentPlaybackLive ? currentTime : currentTime / 1000.0,
      playbackRate: intent.speed ?? value.playbackSpeed,
      generatedAtMillis: intent.clientTimeMillis,
      clientOperationId: intent.clientOperationId,
    );
  }

  void _rejectLocalPlaybackOperation(String operationId) {
    final resolution = _playbackOperationTracker.reject(operationId);
    final state = resolution.stateToApply;
    if (state != null) {
      unawaited(_applyPlaybackStatus(state, forceSeek: true));
    }
  }

  PlaybackControlReporter _playbackControlReporter() {
    return PlaybackControlReporter(
      currentStatus: _currentStatus,
      isLive: _isCurrentPlaybackLive,
      boundPosition: _boundedPlaybackTime,
      protocol: _realtimeProtocol,
    );
  }

  Future<void> _maybeFetchPlaybackDanmaku(
    double positionSeconds, {
    bool force = false,
  }) async {
    if (!_playbackOverlayPreferences.value.chatDanmakuEnabled) {
      _playbackDanmakuWindow = null;
      return;
    }
    final entry = _currentStatus?.entry;
    if (entry == null || entry.live) {
      _playbackDanmakuWindow = null;
      return;
    }
    final sourceKey = playbackDanmakuSourceKey(entry);
    if (sourceKey.isEmpty || _loadingPlaybackDanmaku) return;
    if (!force &&
        _playbackDanmakuWindow?.covers(sourceKey, positionSeconds, 20) ==
            true) {
      return;
    }

    _loadingPlaybackDanmaku = true;
    try {
      final result = await fetchPlaybackDanmakuWindow(
        loadMessages: (query) => _chatGateway.getPlaybackMessages(
          query.roomId,
          playbackMediaId: query.playbackMediaId,
          playbackPlaylistId: query.playbackPlaylistId,
          playbackTarget: query.playbackTarget,
          positionSeconds: query.positionSeconds,
          beforeSeconds: query.beforeSeconds,
          afterSeconds: query.afterSeconds,
          limit: query.limit,
          includeMessageTypes: chatDanmakuMessageTypes,
        ),
        roomId: widget.room.roomId,
        entry: entry,
        positionSeconds: positionSeconds,
      );
      final currentEntry = _currentStatus?.entry;
      if (!mounted ||
          result == null ||
          !_playbackOverlayPreferences.value.chatDanmakuEnabled ||
          currentEntry == null ||
          currentEntry.live ||
          playbackDanmakuSourceKey(currentEntry) != sourceKey) {
        return;
      }
      _playbackDanmakuWindow = result.window;
      _danmakuController.addUniqueItems(result.items);
    } catch (e) {
      debugPrint('Fetch playback danmaku error: $e');
    } finally {
      _loadingPlaybackDanmaku = false;
    }
  }

  Future<void> _applyPlaybackStatus(
    SyncTvPlaybackStatus status, {
    bool forceReloadVideo = false,
    bool forceSeek = false,
    bool skipPlayerSync = false,
  }) async {
    if (!mounted) return;
    final previousStatus = _currentStatus;
    final previousVersion = previousStatus?.version;
    final incomingVersion = status.version;
    if (previousVersion != null &&
        incomingVersion != null &&
        incomingVersion < previousVersion) {
      return;
    }
    final oldMovieId = previousStatus?.entry?.id;
    final nextMovieId = status.entry?.id;
    final previousEntry = previousStatus?.entry;
    final nextEntry = status.entry;
    final generationChanged = liveStreamGenerationChanged(
      previousEntry,
      nextEntry,
    );
    final sourceChanged =
        previousStatus != null &&
        (!previousStatus.hasSamePlaybackSource(status) || generationChanged);
    final reloadErroredController =
        _videoPlayerController?.value.hasError == true;
    final effectiveForceReloadVideo =
        forceReloadVideo || reloadErroredController;
    if (oldMovieId != nextMovieId || sourceChanged) {
      _danmakuController.clear();
      _playbackDanmakuWindow = null;
    }

    final canPlayEntry =
        nextEntry != null &&
        nextEntry.url.isNotEmpty &&
        nextEntry.isLiveStreamPlayable;
    final newUrl = canPlayEntry
        ? _resourceUrlResolver.resolve(nextEntry.url)
        : null;
    final newSourceKey = newUrl == null
        ? null
        : videoPlayerSourceKey(newUrl, nextEntry!.headers);
    final activeP2pMediaSwarm = _activeP2pSwarmId;
    final nextP2pMediaSwarm =
        nextEntry?.selectedPlaybackUrlOption?.p2pDelivery?.swarmId ?? '';
    final p2pMediaRouteChanged =
        _videoPlayerController != null &&
        activeP2pMediaSwarm != nextP2pMediaSwarm &&
        (activeP2pMediaSwarm.isNotEmpty || nextP2pMediaSwarm.isNotEmpty);
    final playerUpdate = playbackPlayerUpdateAction(
      previous: previousEntry,
      next: nextEntry,
      hasController: _videoPlayerController != null,
      controllerHasPlayed: _videoPlaybackHasProgress,
      isDrainingEndedLiveStream: _isDrainingEndedLiveStream,
      samePlayerSource:
          !p2pMediaRouteChanged &&
          ((newSourceKey != null && _videoPlayerSourceKey == newSourceKey) ||
              shouldRetainActivePlaybackSource(
                previous: previousEntry,
                next: nextEntry,
                authoritativeSourceChanged: sourceChanged,
                activeSourceCanContinue: activePlaybackSourceCanContinue(
                  expireAt: _videoPlayerSourceExpireAt,
                  now: SyncedClock.now(),
                ),
              )),
      forceReload: effectiveForceReloadVideo,
    );
    if (_videoPlayerController != null &&
        newSourceKey != null &&
        _videoPlayerSourceKey == newSourceKey) {
      _videoPlayerSourceExpireAt =
          nextEntry?.selectedPlaybackUrlOption?.expireAt;
    }
    setState(() {
      _currentStatus = status;
      if (!canPlayEntry) {
        _videoInitialization.invalidate();
        _isVideoLoading = false;
        _videoError = null;
      }
    });
    _reconcileActiveP2pTickets(status.entry);

    if (playerUpdate == PlaybackPlayerUpdateAction.drain) {
      _startEndedLiveStreamDrain();
      return;
    }
    if (playerUpdate == PlaybackPlayerUpdateAction.dispose) {
      _cancelEndedLiveStreamDrain();
      final hadController = _videoPlayerController != null;
      _disposeVideoControllerImmediately();
      if (mounted && hadController) setState(() {});
      await _deactivateP2pResources();
      return;
    }

    _cancelEndedLiveStreamDrain();
    if (skipPlayerSync &&
        canPlayEntry &&
        !generationChanged &&
        !effectiveForceReloadVideo) {
      _updateDanmakuResources(
        previousEntry: previousEntry,
        nextEntry: nextEntry,
      );
      return;
    }

    if (playerUpdate == PlaybackPlayerUpdateAction.initialize ||
        playerUpdate == PlaybackPlayerUpdateAction.reload) {
      await _initVideo(
        newUrl!,
        headers: nextEntry!.headers,
        sourceExpireAt: nextEntry.selectedPlaybackUrlOption?.expireAt,
        forceReload: playerUpdate == PlaybackPlayerUpdateAction.reload,
      );
      if (!mounted ||
          !_isCurrentPlaybackSource(newUrl, nextEntry.liveStreamGenerationId)) {
        return;
      }
      final latestStatus = _currentStatus;
      if (latestStatus != null &&
          _videoPlayerController?.value.isInitialized == true) {
        await _performSync(latestStatus, forceSeek: true);
      }
    } else {
      unawaited(_performSync(status, forceSeek: forceSeek || sourceChanged));
    }

    _updateDanmakuResources(
      previousEntry: previousEntry,
      nextEntry: nextEntry!,
    );
    if (!nextEntry.live) {
      unawaited(_maybeFetchPlaybackDanmaku(status.currentTime));
    }
  }

  void _updateDanmakuResources({
    required RoomMediaEntry? previousEntry,
    required RoomMediaEntry nextEntry,
  }) {
    final streamUrl = nextEntry.streamDanmu == null
        ? null
        : _resourceUrlResolver.resolve(nextEntry.streamDanmu!);
    final danmuUrl = nextEntry.danmu == null
        ? null
        : _resourceUrlResolver.resolve(nextEntry.danmu!);
    final danmuHeaders = authenticatedServerResourceHeaders(
      _resourceUrlResolver,
      nextEntry.danmu ?? '',
      nextEntry.danmuHeaders,
    );
    final streamDanmuHeaders = authenticatedServerResourceHeaders(
      _resourceUrlResolver,
      nextEntry.streamDanmu ?? '',
      nextEntry.streamDanmuHeaders,
    );

    _danmakuController.updateConfig(
      danmakuUrl: danmuUrl,
      danmakuHeaders: danmuHeaders,
      danmakuP2pDelivery: nextEntry.danmuP2pDelivery,
      localizeStaticResource: _resolveDanmakuPlaybackResource,
      streamDanmakuUrl: streamUrl,
      streamDanmakuHeaders: streamDanmuHeaders,
      controller: _videoPlayerController,
      preserveLoadedDocument:
          previousEntry?.playbackAttachmentIdentity ==
              nextEntry.playbackAttachmentIdentity &&
          !(previousEntry?.danmuP2pDelivery != null &&
              nextEntry.danmuP2pDelivery != null &&
              previousEntry!.danmuP2pDelivery!.swarmId !=
                  nextEntry.danmuP2pDelivery!.swarmId),
    );
  }

  Future<void> _refreshDanmakuStreamAccess() async {
    try {
      final refreshed = await _sessionGateway.refreshSessionAfterUnauthorized();
      if (!mounted || !refreshed) return;

      final entry = _currentStatus?.entry;
      if (entry == null) return;
      _updateDanmakuResources(previousEntry: entry, nextEntry: entry);
    } catch (error) {
      debugPrint('Failed to refresh danmaku stream access: $error');
    }
  }

  void _startEndedLiveStreamDrain() {
    final controller = _videoPlayerController;
    if (controller == null) return;
    _cancelSupersededVideoLoad();
    if (!_isDrainingEndedLiveStream) {
      _isDrainingEndedLiveStream = true;
      _endedLiveStreamDrainTimer = Timer(
        _endedLiveStreamDrainTimeout,
        () => _finishEndedLiveStreamDrain(controller),
      );
    }
    final value = controller.value;
    if (value.isCompleted || value.hasError) {
      _finishEndedLiveStreamDrain(controller);
    }
  }

  void _cancelEndedLiveStreamDrain() {
    _endedLiveStreamDrainTimer?.cancel();
    _endedLiveStreamDrainTimer = null;
    _isDrainingEndedLiveStream = false;
  }

  void _finishEndedLiveStreamDrain(VideoPlayerController controller) {
    if (!_isDrainingEndedLiveStream ||
        !identical(_videoPlayerController, controller)) {
      return;
    }
    _cancelEndedLiveStreamDrain();
    _disposeVideoControllerImmediately();
    unawaited(_deactivateP2pResources());
    if (mounted) setState(() {});
  }

  bool _isCurrentPlaybackSource(String url, String liveStreamGenerationId) {
    final currentEntry = _currentStatus?.entry;
    final currentUrl = currentEntry?.url;
    return currentEntry != null &&
        currentEntry.liveStreamGenerationId == liveStreamGenerationId &&
        currentUrl != null &&
        currentUrl.isNotEmpty &&
        _resourceUrlResolver.resolve(currentUrl) == url;
  }

  Future<void> _initVideo(
    String url, {
    Map<String, String>? headers,
    int? sourceExpireAt,
    bool forceReload = false,
  }) async {
    if (url.isEmpty) return;
    final sourceHeaders = Map<String, String>.unmodifiable(headers ?? const {});
    final sourceKey = videoPlayerSourceKey(url, sourceHeaders);
    if (!forceReload && _videoPlayerSourceKey == sourceKey) {
      final controller = _videoPlayerController;
      if (controller != null && controller.value.isInitialized) {
        _videoPlayerSourceExpireAt = sourceExpireAt;
        if (mounted) {
          setState(() {
            _isVideoLoading = false;
            _videoError = null;
          });
        }
        return;
      }
    }

    final reusesPendingLoad =
        !forceReload && _initializingVideoSourceKey == sourceKey;
    if (!reusesPendingLoad) {
      _cancelSupersededVideoLoad();
      _disposeVideoControllerImmediately(invalidateInitialization: false);
    }
    if (mounted) {
      setState(() {
        _isVideoLoading = true;
        _videoError = null;
      });
    }
    final operationKey = forceReload
        ? '$sourceKey#reload:${++_forcedVideoLoadGeneration}'
        : sourceKey;
    await _videoInitialization.run(
      operationKey,
      (isLatest) => _initVideoOnce(
        url,
        sourceKey: sourceKey,
        sourceExpireAt: sourceExpireAt,
        headers: sourceHeaders,
        isLatest: isLatest,
      ),
    );
  }

  Future<void> _initVideoOnce(
    String url, {
    required String sourceKey,
    required int? sourceExpireAt,
    required Map<String, String> headers,
    required IsLatestOperation isLatest,
  }) async {
    if (!isLatest()) return;
    await widget.p2pMediaPreferences.load();
    if (!isLatest()) return;

    var playbackUrl = url;
    var playbackHeaders = headers;
    var localizedByP2p = false;
    final status = _currentStatus;
    final canUseP2p =
        widget.p2pMediaPreferences.enabled &&
        _canUseP2pMedia &&
        status != null &&
        (Uri.tryParse(url)?.scheme == 'http' ||
            Uri.tryParse(url)?.scheme == 'https');
    await _p2pEngineOperations.run(() async {
      if (!isLatest()) return;
      if (canUseP2p) {
        final delivery = status.entry?.selectedPlaybackUrlOption?.p2pDelivery;
        if (delivery != null && delivery.swarmId.isNotEmpty) {
          final swarmId = delivery.swarmId;
          try {
            final engine = await _ensureP2pPlaybackEngine();
            if (engine == null) return;
            if (!isLatest()) return;
            playbackUrl = (await engine.localize(
              upstream: Uri.parse(url),
              headers: headers,
              swarmId: swarmId,
              format:
                  status.entry?.selectedPlaybackUrlOption?.format ??
                  status.entry?.type ??
                  '',
            )).toString();
            localizedByP2p = true;
            if (!isLatest()) return;
            await _setActiveP2pResource(_p2pMediaRole, delivery);
            if (!isLatest()) return;
            playbackHeaders = const {};
          } catch (error) {
            debugPrint('P2P media gateway setup failed, using HTTP: $error');
            playbackUrl = url;
            playbackHeaders = headers;
            localizedByP2p = false;
            if (isLatest()) await _deactivateP2pMedia();
          }
        } else if (isLatest()) {
          await _deactivateP2pMedia();
        }
      } else if (isLatest()) {
        await _deactivateP2pMedia();
      }
    });
    if (!isLatest()) return;

    final mediaFormat =
        status?.entry?.selectedPlaybackUrlOption?.format ??
        status?.entry?.type ??
        '';
    Map<String, String> controllerHeaders(Map<String, String> sourceHeaders) =>
        {
          ...sourceHeaders,
          if (kIsWeb && mediaFormat.isNotEmpty)
            syncTvVideoFormatHeader: mediaFormat,
        };
    VideoPlayerController createController(
      String sourceUrl,
      Map<String, String> sourceHeaders,
    ) => VideoPlayerController.networkUrl(
      Uri.parse(sourceUrl),
      httpHeaders: controllerHeaders(sourceHeaders),
      formatHint: _videoFormatHint(mediaFormat, Uri.parse(url)),
    );

    var newController = createController(playbackUrl, playbackHeaders);
    _initializingVideoPlayerController = newController;
    _initializingVideoSourceKey = sourceKey;

    try {
      try {
        await newController.initialize().timeout(const Duration(seconds: 20));
      } catch (error) {
        if (!localizedByP2p || !isLatest()) rethrow;
        _disposeControllerEventually(newController);
        debugPrint(
          'P2P media playback failed, retrying the origin URL: $error',
        );
        try {
          await _deactivateP2pMedia();
        } catch (deactivationError) {
          debugPrint('Failed to leave the P2P media swarm: $deactivationError');
        }
        if (!mounted || !isLatest()) return;
        playbackUrl = url;
        playbackHeaders = headers;
        newController = createController(playbackUrl, playbackHeaders);
        _initializingVideoPlayerController = newController;
        await newController.initialize().timeout(const Duration(seconds: 20));
      }

      if (!mounted || !isLatest()) {
        _disposeControllerEventually(newController);
        return;
      }

      await _browserAutoplay.applyPreferredVolume(newController);
      if (!mounted || !isLatest()) {
        _disposeControllerEventually(newController);
        return;
      }
      _videoPlayerController = newController;
      _videoPresentationRevision.value++;
      _videoPlayerSourceKey = sourceKey;
      _videoPlayerSourceExpireAt = sourceExpireAt;
      _videoPlaybackHasProgress = false;
      _videoPlayerController!.addListener(_videoListener);
      _observeAdaptiveVideoTracks(newController);

      if (mounted) {
        setState(() {
          _isVideoLoading = false;
          _videoError = null;
        });
      }
    } catch (e) {
      _disposeControllerEventually(newController);
      if (mounted && isLatest()) {
        debugPrint(
          'Video initialization failed '
          '(source: $url, playback: $playbackUrl, '
          'format: ${status?.entry?.selectedPlaybackUrlOption?.format ?? status?.entry?.type ?? ''}): $e',
        );
        final message = playbackLoadErrorMessage(context.l10n, e);
        setState(() {
          _isVideoLoading = false;
          _videoError = message;
        });
        AppNotifications.showError(context, message);
      }
    } finally {
      if (identical(_initializingVideoPlayerController, newController)) {
        _initializingVideoPlayerController = null;
        _initializingVideoSourceKey = null;
      }
    }
  }

  VideoFormat? _videoFormatHint(String format, Uri uri) {
    final normalized = format.trim().toLowerCase();
    final path = uri.path.toLowerCase();
    if (normalized.contains('m3u8') ||
        normalized.contains('hls') ||
        path.endsWith('.m3u8')) {
      return VideoFormat.hls;
    }
    if (normalized.contains('mpd') ||
        normalized.contains('dash') ||
        path.endsWith('.mpd')) {
      return VideoFormat.dash;
    }
    return null;
  }

  Future<void> _selectPlaybackOption(
    SyncTvPlaybackModeOption mode,
    int urlIndex,
  ) async {
    final status = _currentStatus;
    final entry = status?.entry;
    if (status == null || entry == null) return;
    final wasPlaying = _videoPlayerController?.value.isPlaying ?? false;
    final selected = entry.selectPlayback(
      modeKey: mode.key,
      urlIndex: urlIndex,
      resolveUrl: _resourceUrlResolver.resolve,
    );
    final position = selected.live
        ? 0.0
        : _videoPlayerController == null
        ? status.derivedCurrentTime(now: SyncedClock.now())
        : _videoPlayerController!.value.position.inMilliseconds / 1000.0;
    final selectedStatus = SyncTvPlaybackStatus(
      entry: selected,
      isPlaying: wasPlaying || status.isPlaying,
      currentTime: position,
      playbackRate: status.playbackRate,
      generatedAtMillis: SyncedClock.nowMillis(),
      version: status.version,
      playingMediaId: status.playingMediaId,
      playingPlaylistId: status.playingPlaylistId,
      targetHash: status.targetHash,
    );
    await _applyPlaybackStatus(selectedStatus);
    if (mounted) {
      AppNotifications.showInfo(
        context,
        context.l10n.switchedToPlaybackRoute(selected.playbackChoiceLabel),
        duration: const Duration(seconds: 1),
      );
    }
  }

  void _observeAdaptiveVideoTracks(VideoPlayerController controller) {
    unawaited(_adaptiveVideoTracksSubscription?.cancel());
    _adaptiveVideoTracks = const AdaptiveVideoTrackSnapshot();
    _adaptiveVideoTracksSubscription = controller.adaptiveVideoTracks.listen((
      snapshot,
    ) {
      if (!mounted || !identical(_videoPlayerController, controller)) {
        return;
      }
      setState(() => _adaptiveVideoTracks = snapshot);
    });
  }

  Future<void> _selectAdaptiveVideoTrack(String trackId) async {
    final controller = _videoPlayerController;
    if (controller == null) return;
    try {
      await controller.selectAdaptiveVideoTrack(trackId);
    } catch (error) {
      debugPrint('Adaptive video track selection failed: $error');
      if (mounted) AppNotifications.showError(context, error.toString());
    }
  }

  Widget? _buildPlaybackOptionButton({bool compact = false}) {
    final entry = _currentStatus?.entry;
    if (entry == null ||
        (!entry.hasPlaybackChoices &&
            _adaptiveVideoTracks.tracks.length <= 1)) {
      return null;
    }
    return PlaybackOptionsControl(
      key: ValueKey(
        'playback_options_${entry.id}_${entry.selectedPlaybackMode}_$compact',
      ),
      modes: entry.playbackModes,
      selectedModeKey: entry.selectedPlaybackMode,
      selectedMediaIndex: entry.selectedPlaybackUrlIndex,
      adaptiveTracks: _adaptiveVideoTracks,
      tooltip: context.l10n.playbackRoute,
      compact: compact,
      onMediaSelected: _selectPlaybackOption,
      onAdaptiveTrackSelected: _selectAdaptiveVideoTrack,
    );
  }

  void _selectPlaybackOptionValue(RoomMediaEntry entry, String value) {
    final parts = value.split('|');
    if (parts.length != 2) return;
    final mode = entry.playbackModes.firstWhere(
      (entry) => entry.key == parts[0],
      orElse: () => entry.playbackModes.first,
    );
    final index = int.tryParse(parts[1]) ?? mode.safeDefaultUrlIndex;
    unawaited(_selectPlaybackOption(mode, index));
  }

  Widget? _buildPictureInPicturePlaybackOptions() {
    final entry = _currentStatus?.entry;
    final hasAdaptiveQualities = _adaptiveVideoTracks.tracks.length > 1;
    if (entry == null || (!entry.hasPlaybackChoices && !hasAdaptiveQualities)) {
      return null;
    }
    return PictureInPicturePlaybackOptionsControl(
      tooltip: context.l10n.playbackRoute,
      choices: [
        for (final mode in entry.playbackModes)
          for (var index = 0; index < mode.urls.length; index++)
            PictureInPicturePlaybackChoice(
              value: '${mode.key}|$index',
              groupLabel: mode.label,
              label: mode.urls[index].label(index),
              selected:
                  mode.key == entry.selectedPlaybackMode &&
                  index == entry.selectedPlaybackUrlIndex,
            ),
        if (hasAdaptiveQualities)
          PictureInPicturePlaybackChoice(
            value: 'track:auto',
            groupLabel: '清单内画质',
            label: '自动',
            selected: _adaptiveVideoTracks.selectedTrackId == 'auto',
          ),
        if (hasAdaptiveQualities)
          for (final track in _adaptiveVideoTracks.tracks)
            PictureInPicturePlaybackChoice(
              value: 'track:${track.id}',
              groupLabel: '清单内画质',
              label: track.resolution.isEmpty
                  ? (track.title?.trim().isNotEmpty == true
                        ? track.title!.trim()
                        : '画质 ${track.id}')
                  : track.resolution,
              selected: _adaptiveVideoTracks.selectedTrackId == track.id,
            ),
      ],
      onSelected: (value) {
        if (value.startsWith('track:')) {
          unawaited(
            _selectAdaptiveVideoTrack(value.substring('track:'.length)),
          );
        } else {
          _selectPlaybackOptionValue(entry, value);
        }
      },
    );
  }

  Widget _buildVideoEmptyState() {
    final entry = _currentStatus?.entry;
    final hasPlayback =
        entry?.url.isNotEmpty == true && entry?.isLiveStreamPlayable == true;
    return PlaybackEmptyState(
      error: _roomSessionError ?? _videoError,
      loading: _isVideoLoading,
      hasPlayback: hasPlayback,
    );
  }

  void _cancelSupersededVideoLoad() {
    _videoInitialization.invalidate();
    final controller = _initializingVideoPlayerController;
    _initializingVideoPlayerController = null;
    _initializingVideoSourceKey = null;
    if (controller != null) {
      _disposeControllerEventually(controller);
    }
  }

  void _disposeVideoControllerImmediately({
    bool invalidateInitialization = true,
  }) {
    _cancelEndedLiveStreamDrain();
    if (invalidateInitialization) _cancelSupersededVideoLoad();
    final controller = _videoPlayerController;
    unawaited(_adaptiveVideoTracksSubscription?.cancel());
    _adaptiveVideoTracksSubscription = null;
    _adaptiveVideoTracks = const AdaptiveVideoTrackSnapshot();
    _videoPlayerController = null;
    _videoPresentationRevision.value++;
    _videoPlayerSourceKey = null;
    _videoPlayerSourceExpireAt = null;
    _videoPlaybackHasProgress = false;
    _playbackDeviationSnapshot = null;
    if (controller == null) return;
    _browserAutoplay.detach(controller);
    controller.removeListener(_videoListener);
    _danmakuController.detachVideoController(controller);
    _disposeControllerEventually(controller);
  }

  void _disposeControllerEventually(VideoPlayerController controller) {
    unawaited(_disposeController(controller));
  }

  Future<void> _disposeController(VideoPlayerController controller) async {
    try {
      await controller.dispose();
    } on Exception catch (error) {
      debugPrint('Video controller disposal error: $error');
    }
  }

  Future<void> _disposeVideoController({
    bool invalidateInitialization = true,
  }) async {
    _cancelEndedLiveStreamDrain();
    if (invalidateInitialization) {
      _cancelSupersededVideoLoad();
    }
    final controller = _videoPlayerController;
    await _adaptiveVideoTracksSubscription?.cancel();
    _adaptiveVideoTracksSubscription = null;
    _adaptiveVideoTracks = const AdaptiveVideoTrackSnapshot();
    _videoPlayerController = null;
    _videoPresentationRevision.value++;
    _videoPlayerSourceKey = null;
    _videoPlayerSourceExpireAt = null;
    _videoPlaybackHasProgress = false;
    _playbackDeviationSnapshot = null;
    if (controller != null) {
      _browserAutoplay.detach(controller);
      controller.removeListener(_videoListener);
      _danmakuController.detachVideoController(controller);
      await _disposeController(controller);
    }
  }

  @override
  void dispose() {
    _isDisposing = true;
    _chatReadStateUpdater.dispose();
    _realtimeLogPreferences.maxEntries.removeListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    widget.p2pMediaPreferences.removeListener(_handleP2pPreferenceChanged);
    _tabController.removeListener(_handleRoomTabChanged);
    _authErrorSubscription?.cancel();
    _realtimeSubscription?.cancel();
    _disposeVideoControllerImmediately();
    _tabController.dispose();
    unawaited(_pictureInPicture.exit());
    _syncTimer?.cancel();
    _diagnosticsTimer?.cancel();
    _chatHighlightTimer?.cancel();
    _reconnectTimer?.cancel();
    unawaited(_channel?.close());
    _messageController.dispose();
    _mediaSearchController.dispose();
    _chatScrollController.dispose();
    _mediaEntryScrollController.dispose();
    unawaited(_voiceChatManager?.dispose());
    unawaited(_p2pMediaManager?.dispose());
    final p2pEngine = _p2pMediaEngine;
    _p2pMediaEngine = null;
    if (p2pEngine != null) {
      unawaited(_p2pEngineOperations.run(p2pEngine.dispose));
    }
    _danmakuController.dispose();
    _videoPresentationRevision.dispose();
    _playbackController.dispose();
    _browserAutoplay.dispose();
    _channel = null;
    _realtimeMessageBus.close();
    _realtimeEventBus.close();
    _realtimeReconnectBus.close();
    _realtimeDisconnectBus.close();
    super.dispose();
  }

  void _handleRoomTabChanged() {
    if (mounted) {
      setState(() => _roomTabIndex = _tabController.index);
    }
    _syncMemberTabObservation();
  }

  void _selectRoomTab(int index) {
    if (!_visibleRoomTabIndexes.contains(index)) return;
    if (_roomTabIndex == index && _tabController.index == index) return;
    _tabController.index = index;
    if (mounted) {
      setState(() => _roomTabIndex = index);
    }
    _syncMemberTabObservation();
  }

  void _syncMemberTabObservation() {
    if (_roomTabIndex == 2 && _canViewMembers) {
      unawaited(_observeRoomMembers());
      return;
    }
    if (_memberEventsObserved) {
      _sendRealtimeMessage(
        _realtimeProtocol.encodeUnobserveResource('room_member_events'),
      );
      _memberEventsObserved = false;
    }
  }

  void _handleChatScroll() {
    final show = !_isChatNearBottom();
    if (show != _showChatScrollToBottom && mounted) {
      setState(() => _showChatScrollToBottom = show);
    }
    if (!show && _canViewChatHistory && _messages.isNotEmpty) {
      _chatReadStateUpdater.markVisible(_messages.last.id);
    }
  }

  bool _isChatNearBottom() {
    if (!_chatScrollController.hasClients) return true;
    final position = _chatScrollController.position;
    return position.maxScrollExtent - position.pixels <= 96;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        if (_showChatScrollToBottom) {
          setState(() => _showChatScrollToBottom = false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pictureInPicture.active,
      builder: (context, active, _) =>
          active && _pictureInPicture.usesCompactApplicationSurface
          ? _buildPictureInPictureSurface()
          : _buildRoomScaffold(context),
    );
  }

  Widget _buildPictureInPictureSurface() {
    return PictureInPicturePlaybackSurface(
      controller: _videoPlayerController,
      browserAutoplay: _browserAutoplay,
      danmakuController: _danmakuController,
      overlayPreferences: _playbackOverlayPreferences,
      emptyState: PlaybackEmptyState(
        error: _roomSessionError ?? _videoError,
        loading: _isVideoLoading,
        hasPlayback: _currentStatus?.entry?.url.isNotEmpty == true,
        iconSize: 30,
        textSize: 13,
      ),
      exitTooltip: context.l10n.exitPictureInPicture,
      volumeTooltip: context.l10n.volume,
      playbackOptionsControl: _buildPictureInPicturePlaybackOptions(),
      diagnostics: _buildPlaybackDiagnosticsBadges(
        compact: true,
        videoStyle: true,
      ),
      isLive: _isCurrentPlaybackLive,
      liveStartedAt: _currentStatus?.entry?.liveStartedAt,
      canControlPlayback: _canControlPlaybackState,
      isPlaybackExpectedToBePlaying: () => _currentStatus?.isPlaying == true,
      onPlaybackStateChanged: _canControlPlaybackState
          ? _handleUserPlaybackStateChanged
          : null,
      onPlaybackSpeedChanged: _canControlPlaybackState
          ? _handleUserPlaybackSpeedChanged
          : null,
      onSeek: _canControlPlaybackState ? _handleUserSeek : null,
      onSync: _currentStatus == null ? null : _handleSync,
      onPrevious: _canNavigatePlayback
          ? () => unawaited(_navigatePlayback(previous: true))
          : null,
      onNext: _canNavigatePlayback
          ? () => unawaited(_navigatePlayback(previous: false))
          : null,
      onDragStart: _pictureInPicture.startDragging,
      onExit: _pictureInPicture.supportsWindowDragging
          ? () => unawaited(_pictureInPicture.exit())
          : null,
    );
  }

  Widget _buildRoomScaffold(BuildContext context) {
    return RoomShellView(
      state: RoomShellState(
        roomName: widget.room.roomName,
        hasCurrentPlayback: _hasCurrentPlayback,
        canControlPlayback: _canControlPlaybackState,
        hasCurrentUser: _currentUser != null,
        canManageRoom: _canManageRoom,
      ),
      callbacks: RoomShellCallbacks(
        back: () => Navigator.of(context).maybePop(),
        stopPlayback: _stopPlayback,
        openRoomSettings: _openRoomSettings,
      ),
      latencyBadge: (compact) => _buildServerLatencyBadge(compact: compact),
      primary: _buildVideoSurface(),
      secondary: _buildRoomSidePanel(Theme.of(context)),
    );
  }

  Widget _buildVideoSurface() {
    return AppPanelSurface(
      color: Colors.black,
      borderRadius: BorderRadius.circular(8),
      child: LayoutBuilder(
        builder: (context, _) {
          return Stack(
            children: [
              Center(
                child:
                    _videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized
                    ? CustomVideoPlayer(
                        volumePreferences: _playerVolumePreferences,
                        browserAutoplay: _browserAutoplay,
                        overlayPreferences: _playbackOverlayPreferences,
                        p2pMediaPreferences: _canUseP2pMedia
                            ? widget.p2pMediaPreferences
                            : null,
                        subtitleSource: DependencyScope.read<SubtitleSource>(
                          context,
                        ),
                        resourceUrlResolver: _resourceUrlResolver,
                        controller: _videoPlayerController!,
                        title:
                            _currentStatus?.entry?.name ??
                            context.l10n.unknownVideo,
                        danmakuController: _danmakuController,
                        subtitles: _currentStatus?.entry?.subtitles,
                        playbackResourceIdentity:
                            _currentStatus?.entry?.playbackAttachmentIdentity ??
                            '',
                        resolveSubtitleResource:
                            _resolveSubtitlePlaybackResource,
                        onSubtitleP2pDeactivated: _deactivateP2pSubtitle,
                        isLive: _currentStatus?.entry?.live == true,
                        liveStartedAt: _currentStatus?.entry?.liveStartedAt,
                        onToggleFullScreen: _toggleFullScreen,
                        onSync: _handleSync,
                        onPrevious: _canNavigatePlayback
                            ? () => unawaited(_navigatePlayback(previous: true))
                            : null,
                        onNext: _canNavigatePlayback
                            ? () =>
                                  unawaited(_navigatePlayback(previous: false))
                            : null,
                        pictureInPictureActive: _pictureInPicture.active,
                        onPictureInPictureChanged: _pictureInPictureAvailable
                            ? (active) =>
                                  unawaited(_setPictureInPicture(active))
                            : null,
                        freeModeEnabled: _playbackModeConfig.freeModeEnabled,
                        onFreeModeChanged: (enabled) =>
                            unawaited(_setFreeModeEnabled(enabled)),
                        canControlPlayback: _canControlPlaybackState,
                        isPlaybackExpectedToBePlaying: () =>
                            _currentStatus?.isPlaying == true,
                        onUserPlaybackStateChanged: _canControlPlaybackState
                            ? _handleUserPlaybackStateChanged
                            : null,
                        onUserSeek: _canControlPlaybackState
                            ? _handleUserSeek
                            : null,
                        onUserPlaybackSpeedChanged: _canControlPlaybackState
                            ? _handleUserPlaybackSpeedChanged
                            : null,
                        diagnosticsProvider: _playbackDiagnosticsContext,
                        loopPlayback:
                            _roomSettings.autoPlayEnabled &&
                            _roomSettings.autoPlayMode ==
                                client_enum.PlayMode.PLAY_MODE_REPEAT_ONE,
                        shufflePlayback:
                            _roomSettings.autoPlayEnabled &&
                            _roomSettings.autoPlayMode ==
                                client_enum.PlayMode.PLAY_MODE_SHUFFLE,
                        canChangePlayMode:
                            _canManagePlaybackMode && !_playModeUpdateInFlight,
                        onLoopPlaybackChanged: (enabled) =>
                            _updateRoomPlaybackMode(
                              enabled
                                  ? client_enum.PlayMode.PLAY_MODE_REPEAT_ONE
                                  : client_enum.PlayMode.PLAY_MODE_SEQUENTIAL,
                            ),
                        onShufflePlaybackChanged: (enabled) =>
                            _updateRoomPlaybackMode(
                              enabled
                                  ? client_enum.PlayMode.PLAY_MODE_SHUFFLE
                                  : client_enum.PlayMode.PLAY_MODE_SEQUENTIAL,
                            ),
                        onReloadPlayback: () =>
                            unawaited(_reloadCurrentPlaybackUrl()),
                        onSendDanmaku: _canSendRoomDanmaku
                            ? _sendDanmaku
                            : null,
                        interactionMode: videoPlayerInteractionModeForPlatform(
                          defaultTargetPlatform,
                        ),
                        diagnosticsBuilder: (_) =>
                            _buildPlaybackDiagnosticsBadges(
                              compact: true,
                              videoStyle: true,
                            ),
                        extraBottomWidget: _buildPlaybackOptionButton(
                          compact: true,
                        ),
                      )
                    : _buildVideoEmptyState(),
              ),
              if (_videoPlayerController == null && _canNavigatePlayback)
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Row(
                    children: [
                      AppIconButton(
                        key: const Key('empty_playback_previous_button'),
                        icon: Icons.skip_previous_rounded,
                        tooltip: context.l10n.previousVideo,
                        onPressed: _playbackNavigationInFlight
                            ? null
                            : () =>
                                  unawaited(_navigatePlayback(previous: true)),
                      ),
                      const SizedBox(width: 8),
                      AppIconButton(
                        key: const Key('empty_playback_next_button'),
                        icon: Icons.skip_next_rounded,
                        tooltip: context.l10n.nextVideo,
                        onPressed: _playbackNavigationInFlight
                            ? null
                            : () =>
                                  unawaited(_navigatePlayback(previous: false)),
                      ),
                    ],
                  ),
                ),
              if (_videoPlayerController == null &&
                  _currentStatus?.entry?.hasPlaybackChoices == true)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: _buildPlaybackOptionButton(compact: true)!,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoomSidePanel(ThemeData theme) {
    return AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.roomCollaboration,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Flexible(
                  child: AppTooltip(
                    message: context.l10n.roomPresenceSummary(
                      _onlineMemberCount,
                      _onlineGuestCount,
                    ),
                    child: Text(
                      context.l10n.roomOnlineTotal(
                        _onlineMemberCount + _onlineGuestCount,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.58,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_canBrowseLibrary) ...[
                  const SizedBox(width: 8),
                  AppIconButton(
                    onPressed: () => _selectRoomTab(1),
                    icon: Icons.playlist_play_rounded,
                    tooltip: context.l10n.playlist,
                  ),
                ],
                const SizedBox(width: 4),
                AppIconButton(
                  onPressed: () => copyRoomInviteLink(context, widget.room),
                  icon: Icons.ios_share_rounded,
                  tooltip: context.l10n.copyInviteLink,
                ),
              ],
            ),
          ),
          _buildTabBar(theme),
          Expanded(child: _buildRoomTabContent()),
        ],
      ),
    );
  }

  Widget _buildRoomTabContent() {
    final visibleTabs = _visibleRoomTabIndexes;
    if (visibleTabs.isEmpty) return const SizedBox.shrink();

    final selectedIndex = visibleTabs.indexOf(_roomTabIndex);
    return IndexedStack(
      index: selectedIndex < 0 ? 0 : selectedIndex,
      children: [
        for (final index in visibleTabs)
          switch (index) {
            0 => _buildChatTab(),
            1 => _buildPlaylistTab(),
            2 => _buildMembersTab(),
            _ => _buildRealtimeEventsTab(),
          },
      ],
    );
  }

  void _handleSync() {
    final status = _currentStatus;
    if (status == null) return;
    if (status.entry?.live == true) {
      unawaited(_reloadCurrentPlaybackUrl());
      return;
    }
    unawaited(_performSync(status, forceSeek: true));
    if (mounted) {
      AppNotifications.showInfo(
        context,
        context.l10n.syncedToLatestProgress,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<bool> _updateRoomPlaybackMode(client_enum.PlayMode mode) async {
    if (_isCurrentPlaybackLive ||
        !_canManagePlaybackMode ||
        _playModeUpdateInFlight) {
      return false;
    }
    setState(() => _playModeUpdateInFlight = true);
    try {
      await _roomGateway.updateRoomAutoPlay(
        widget.room.roomId,
        enabled: true,
        mode: mode,
      );
      if (!mounted) return true;
      setState(() {
        _roomSettings.autoPlayEnabled = true;
        _roomSettings.autoPlayMode = mode;
      });
      final label = switch (mode) {
        client_enum.PlayMode.PLAY_MODE_REPEAT_ONE => context.l10n.loopPlayback,
        client_enum.PlayMode.PLAY_MODE_SHUFFLE => context.l10n.shufflePlayback,
        _ => context.l10n.sequentialPlayback,
      };
      AppNotifications.showSuccess(
        context,
        context.l10n.playbackModeUpdated(label),
      );
      return true;
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updatePlaybackModeFailed('$error'),
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => _playModeUpdateInFlight = false);
    }
  }

  Future<void> _reloadCurrentPlaybackUrl() async {
    final status = _currentStatus;
    if (status?.entry?.url.isNotEmpty == true) {
      await _applyPlaybackStatus(
        status!,
        forceReloadVideo: true,
        forceSeek: true,
      );
    }
    if (mounted) {
      AppNotifications.showInfo(
        context,
        context.l10n.playbackAddressReloaded,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> _openFreeModeSettings() async {
    final nextConfig = await showAppDialog<PlaybackModeConfig>(
      context: context,
      builder: (dialogContext) {
        var draft = _playbackModeConfig;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: Text(context.l10n.freeModeSettings),
              icon: const Icon(Icons.explore_rounded),
              body: SizedBox(
                width: 520,
                child: AppSingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FreeModeSettingsFields(
                        config: draft,
                        onChanged: (value) {
                          setDialogState(() => draft = value);
                        },
                      ),
                      if (_canUseP2pMedia) ...[
                        const SizedBox(height: 16),
                        P2pMediaSettingsFields(
                          preferences: widget.p2pMediaPreferences,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  label: context.l10n.cancel,
                  style: AppActionButtonStyle.outlined,
                ),
                AppActionButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, PlaybackModeConfig.defaults);
                  },
                  label: context.l10n.restoreDefaults,
                  style: AppActionButtonStyle.tonal,
                ),
                AppActionButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, draft.normalized());
                  },
                  icon: Icons.check_rounded,
                  label: context.l10n.save,
                  style: AppActionButtonStyle.filled,
                ),
              ],
            );
          },
        );
      },
    );

    if (nextConfig == null) return;
    await _playbackModePreferences.update(nextConfig);
    if (!mounted) return;
    setState(() {
      _playbackModeConfig = _playbackModePreferences.value;
    });
    AppNotifications.showSuccess(context, context.l10n.freeModeSettingsSaved);
  }

  Future<void> _setFreeModeEnabled(bool enabled) async {
    final nextConfig = _playbackModeConfig
        .copyWith(freeModeEnabled: enabled)
        .normalized();
    if (mounted) {
      setState(() => _playbackModeConfig = nextConfig);
    }
    await _playbackModePreferences.update(nextConfig);
  }

  Future<void> _observeRoomMembers() async {
    if (_membersLoading) return;
    if (mounted) setState(() => _membersLoading = true);
    try {
      final page = await _roomGateway.getRoomMemberDetailsPage(
        widget.room.roomId,
        page: 1,
        pageSize: 100,
      );
      final members = page.members.map(_roomMemberToUser).toList();
      if (mounted) {
        _sortMembers(members);
        setState(() {
          _members = members;
        });
      }
      if (!_memberEventsObserved) {
        _sendRealtimeMessage(_realtimeProtocol.encodeRoomMembersObservation());
        _memberEventsObserved = true;
      }
    } catch (e) {
      debugPrint('Observe room members error: $e');
      if (mounted) {
        AppNotifications.showError(context, context.l10n.loadMemberListFailed);
      }
    } finally {
      if (mounted) setState(() => _membersLoading = false);
    }
  }

  Future<void> _loadMentionCandidates({
    required String query,
    bool reset = false,
  }) async {
    final normalizedQuery = query.trim();
    final queryChanged = normalizedQuery != _mentionCandidateQuery;
    final shouldReset = reset || queryChanged;
    if (_mentionCandidatesLoading) return;
    if (!shouldReset && !_mentionCandidatesHasMore) return;
    final nextPage = shouldReset ? 1 : _mentionCandidatePage + 1;
    if (mounted) {
      setState(() {
        _mentionCandidatesLoading = true;
        if (shouldReset) {
          _mentionCandidateQuery = normalizedQuery;
          _mentionCandidatePage = 0;
          _mentionCandidatesHasMore = true;
          _mentionCandidates = [];
        }
      });
    } else {
      _mentionCandidatesLoading = true;
      if (shouldReset) {
        _mentionCandidateQuery = normalizedQuery;
        _mentionCandidatePage = 0;
        _mentionCandidatesHasMore = true;
        _mentionCandidates = [];
      }
    }
    try {
      final page = await _roomGateway.getRoomMemberDetailsPage(
        widget.room.roomId,
        page: nextPage,
        pageSize: 30,
        search: normalizedQuery,
      );
      final members = page.members.map(_roomMemberToUser).toList();
      _sortMembers(members);
      if (!mounted) return;
      setState(() {
        final merged = <String, SyncTvUser>{
          for (final member
              in shouldReset ? const <SyncTvUser>[] : _mentionCandidates)
            if (member.id.isNotEmpty) member.id: member,
        };
        for (final member in members) {
          if (member.id.isNotEmpty) merged[member.id] = member;
        }
        _mentionCandidates = merged.values.toList();
        _sortMembers(_mentionCandidates);
        _mentionCandidateQuery = normalizedQuery;
        _mentionCandidatePage = nextPage;
        _mentionCandidatesHasMore =
            page.total > _mentionCandidates.length && members.isNotEmpty;
      });
    } catch (e) {
      debugPrint('Load mention candidates error: $e');
    } finally {
      _mentionCandidatesLoading = false;
      if (mounted) setState(() {});
    }
  }

  void _handleMentionQueryChanged(String query) {
    unawaited(_loadMentionCandidates(query: query, reset: true));
  }

  void _loadMoreMentionCandidates() {
    unawaited(_loadMentionCandidates(query: _mentionCandidateQuery));
  }

  SyncTvUser _roomMemberToUser(AdminRoomMember member) {
    return SyncTvUser(
      id: member.userId,
      username: member.username,
      role: RoomMembershipRole(member.role),
      createdAt: member.joinedAt,
      status: common_enum.UserStatus.USER_STATUS_ACTIVE,
      onlineCount: member.isOnline ? 1 : 0,
      connectionCount: member.connectionCount,
    );
  }

  Future<void> _toggleFullScreen() async {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    _fullScreenRouteOpen = true;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ValueListenableBuilder<int>(
          valueListenable: _videoPresentationRevision,
          builder: (context, _, child) {
            final controller = _videoPlayerController;
            if (controller == null || !controller.value.isInitialized) {
              return Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: _buildVideoEmptyState()),
              );
            }
            return CustomVideoPlayer(
              key: ValueKey(controller),
              volumePreferences: _playerVolumePreferences,
              browserAutoplay: _browserAutoplay,
              overlayPreferences: _playbackOverlayPreferences,
              p2pMediaPreferences: _canUseP2pMedia
                  ? widget.p2pMediaPreferences
                  : null,
              subtitleSource: DependencyScope.read<SubtitleSource>(context),
              resourceUrlResolver: _resourceUrlResolver,
              controller: controller,
              title: _currentStatus?.entry?.name ?? context.l10n.unknownVideo,
              danmakuController: _danmakuController,
              subtitles: _currentStatus?.entry?.subtitles,
              playbackResourceIdentity:
                  _currentStatus?.entry?.playbackAttachmentIdentity ?? '',
              resolveSubtitleResource: _resolveSubtitlePlaybackResource,
              onSubtitleP2pDeactivated: _deactivateP2pSubtitle,
              isLive: _currentStatus?.entry?.live == true,
              liveStartedAt: _currentStatus?.entry?.liveStartedAt,
              onToggleFullScreen: () => Navigator.of(context).pop(),
              onSync: _handleSync,
              onPrevious: _canNavigatePlayback
                  ? () => unawaited(_navigatePlayback(previous: true))
                  : null,
              onNext: _canNavigatePlayback
                  ? () => unawaited(_navigatePlayback(previous: false))
                  : null,
              pictureInPictureActive: _pictureInPicture.active,
              onPictureInPictureChanged: _pictureInPictureAvailable
                  ? (active) => unawaited(_setPictureInPicture(active))
                  : null,
              freeModeEnabled: _playbackModeConfig.freeModeEnabled,
              onFreeModeChanged: (enabled) =>
                  unawaited(_setFreeModeEnabled(enabled)),
              canControlPlayback: _canControlPlaybackState,
              isPlaybackExpectedToBePlaying: () =>
                  _currentStatus?.isPlaying == true,
              onUserPlaybackStateChanged: _canControlPlaybackState
                  ? _handleUserPlaybackStateChanged
                  : null,
              onUserSeek: _canControlPlaybackState ? _handleUserSeek : null,
              onUserPlaybackSpeedChanged: _canControlPlaybackState
                  ? _handleUserPlaybackSpeedChanged
                  : null,
              diagnosticsProvider: _playbackDiagnosticsContext,
              loopPlayback:
                  _roomSettings.autoPlayEnabled &&
                  _roomSettings.autoPlayMode ==
                      client_enum.PlayMode.PLAY_MODE_REPEAT_ONE,
              shufflePlayback:
                  _roomSettings.autoPlayEnabled &&
                  _roomSettings.autoPlayMode ==
                      client_enum.PlayMode.PLAY_MODE_SHUFFLE,
              canChangePlayMode:
                  _canManagePlaybackMode && !_playModeUpdateInFlight,
              onLoopPlaybackChanged: (enabled) => _updateRoomPlaybackMode(
                enabled
                    ? client_enum.PlayMode.PLAY_MODE_REPEAT_ONE
                    : client_enum.PlayMode.PLAY_MODE_SEQUENTIAL,
              ),
              onShufflePlaybackChanged: (enabled) => _updateRoomPlaybackMode(
                enabled
                    ? client_enum.PlayMode.PLAY_MODE_SHUFFLE
                    : client_enum.PlayMode.PLAY_MODE_SEQUENTIAL,
              ),
              onReloadPlayback: () => unawaited(_reloadCurrentPlaybackUrl()),
              onSendDanmaku: _canSendRoomDanmaku ? _sendDanmaku : null,
              isFullScreen: true,
              interactionMode: videoPlayerInteractionModeForPlatform(
                defaultTargetPlatform,
              ),
              diagnosticsBuilder: (_) => _buildPlaybackDiagnosticsBadges(
                compact: true,
                includeLatency: true,
                videoStyle: true,
              ),
              extraBottomWidget: _buildPlaybackOptionButton(compact: true),
            );
          },
        ),
      ),
    );
    _fullScreenRouteOpen = false;
  }

  void _sendDanmaku(String text) {
    if (!_canSendRoomDanmaku || text.trim().isEmpty) return;
    if (_channel != null) {
      try {
        final bytes = _realtimeProtocol.encodeChat(
          text,
          displayPosition: 'scroll',
          displayColor: '#ffffff',
        );
        _sendRealtimeMessage(bytes);
      } catch (e) {
        debugPrint('Send danmaku error: $e');
        if (mounted) {
          AppNotifications.showError(
            context,
            context.l10n.sendDanmakuFailed('$e'),
          );
        }
      }
    }
  }

  Widget _buildTabBar(ThemeData theme) {
    final visibleTabs = _visibleRoomTabIndexes;
    if (visibleTabs.isEmpty) return const SizedBox.shrink();

    final labels = [
      for (final index in visibleTabs)
        switch (index) {
          0 => context.l10n.chat,
          1 => context.l10n.playlist,
          2 => context.l10n.members,
          _ => context.l10n.realtime,
        },
    ];
    final icons = [
      for (final index in visibleTabs)
        switch (index) {
          0 => Icons.chat_bubble_rounded,
          1 => Icons.playlist_play_rounded,
          2 => Icons.group_rounded,
          _ => Icons.bolt_rounded,
        },
    ];
    final selectedIndex = visibleTabs.indexOf(_roomTabIndex);

    return RoomCollaborationTabBar(
      labels: labels,
      icons: icons,
      selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
      enabled: List.filled(visibleTabs.length, true),
      onSelected: (index) => _selectRoomTab(visibleTabs[index]),
    );
  }

  Widget _buildRealtimeEventsTab() {
    return RealtimeEventLogView(
      events: _realtimeEvents,
      onClear: () => setState(_realtimeEvents.clear),
      onMaxEntriesChanged: (_) => setState(_trimRealtimeEvents),
      emptyText: context.l10n.realtimeEventsWebSocketDescription,
    );
  }

  Widget _buildChatTab() {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildVoiceControl(theme),
        if (_pinnedMessages.isNotEmpty || _pinnedMessagesLoading)
          _buildPinnedChatMessagesBar(theme),
        Expanded(
          child: Stack(
            children: [
              AppListView.builder(
                controller: _chatScrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 56),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildChatMessageItem(msg);
                },
              ),
              if (_showChatScrollToBottom)
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: AppFloatingActionButton(
                    heroTag: 'desktop_chat_scroll_to_bottom',
                    onPressed: _scrollToBottom,
                    tooltip: context.l10n.scrollToBottom,
                    icon: Icons.keyboard_arrow_down_rounded,
                    small: true,
                  ),
                ),
            ],
          ),
        ),
        if (_canSendChatMessages) ...[
          const AppDivider(height: 1),
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
            ),
            child: _buildChatInputArea(),
          ),
        ],
      ],
    );
  }

  Widget _buildPinnedChatMessagesBar(ThemeData theme) {
    final scheme = theme.colorScheme;
    return AppPanelSurface(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.52),
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.62),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: [
          Icon(Icons.push_pin_rounded, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            context.l10n.pinned,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _pinnedMessagesLoading && _pinnedMessages.isEmpty
                ? const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: AppLoadingIndicator(
                        size: AppLoadingSize.sm,
                        centered: false,
                      ),
                    ),
                  )
                : AppSingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final message in _pinnedMessages)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: _buildPinnedChatMessageChip(message, theme),
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(width: 6),
          AppIconButton(
            tooltip: context.l10n.refreshPinnedMessages,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            padding: EdgeInsets.zero,
            iconSize: 17,
            size: AppIconButtonSize.sm,
            onPressed: _pinnedMessagesLoading ? null : _loadPinnedChatMessages,
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedChatMessageChip(
    RoomRealtimeChatEntry message,
    ThemeData theme,
  ) {
    final scheme = theme.colorScheme;
    final note = message.pin?.note.trim() ?? '';
    final preview = _chatPreviewText(message);
    final title = note.isEmpty ? message.username : note;
    final subtitle = note.isEmpty ? preview : '${message.username}: $preview';
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _jumpToChatMessage(message.id),
        child: AppPanelSurface(
          color: scheme.surface.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              AppIconButton(
                tooltip: context.l10n.unpin,
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
                padding: EdgeInsets.zero,
                iconSize: 15,
                size: AppIconButtonSize.sm,
                style: AppIconButtonStyle.ghost,
                onPressed: () => _toggleChatPin(message),
                icon: Icons.close_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatInputArea() {
    final mentionCandidates = <String, SyncTvUser>{};
    for (final member in _mentionCandidates) {
      if (member.id.isNotEmpty) mentionCandidates[member.id] = member;
    }
    for (final member in _members) {
      if (member.id.isNotEmpty) {
        mentionCandidates.putIfAbsent(member.id, () => member);
      }
    }
    final currentUser = _currentUser;
    if (currentUser != null && currentUser.id.isNotEmpty) {
      mentionCandidates[currentUser.id] = currentUser;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_replyingToMessage != null) ...[
          _buildReplyComposerPreview(_replyingToMessage!),
          const SizedBox(height: 8),
        ],
        ChatInputArea(
          textController: _messageController,
          isVoiceInputMode: false,
          isLoading: _sendingChatMessage,
          conversationType: 'synctv',
          onSendMessage: () => _sendMessage(_messageController.text),
          mentionCandidates: mentionCandidates.values.toList(),
          mentionCandidatesLoading: _mentionCandidatesLoading,
          mentionCandidatesHasMore: _mentionCandidatesHasMore,
          onMentionsChanged: (mentions) {
            _pendingChatMentions = mentions;
          },
          onMentionQueryChanged: _handleMentionQueryChanged,
          onMentionLoadMore: _loadMoreMentionCandidates,
          onSwitchToVoiceMode: () {},
          onShowImagePicker: _pickChatImage,
          onStartRecording: () {},
          onStopRecording: () {},
          onCancelRecording: () {},
          selectedImageBytes: _selectedChatImage?.previewBytes,
          onCancelSelectedImage: () {
            setState(() => _selectedChatImage = null);
          },
        ),
      ],
    );
  }

  Widget _buildReplyComposerPreview(RoomRealtimeChatEntry message) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppPanelSurface(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 34,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.replyingTo(message.username),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _chatPreviewText(message),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          AppIconButton(
            tooltip: context.l10n.cancelReply,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            padding: EdgeInsets.zero,
            iconSize: 17,
            size: AppIconButtonSize.sm,
            onPressed: () => setState(() => _replyingToMessage = null),
            icon: Icons.close_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildChatImageGrid(List<StoredImageInfo> images) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.map((image) => _buildChatImageThumb(image)).toList(),
    );
  }

  Widget _buildChatMessageItem(RoomRealtimeChatEntry message) {
    if (message.isDeleted) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isMine =
        _currentUser != null &&
        message.userId.isNotEmpty &&
        message.userId == _currentUser!.id;
    final alignment = isMine ? Alignment.centerRight : Alignment.centerLeft;
    final messageKey = message.dedupeKey;
    final actionsVisible =
        message.id.isNotEmpty &&
        (_hoveredChatMessageId == messageKey ||
            _activeChatMessageId == messageKey);
    final reactionsVisible =
        message.id.isNotEmpty && _expandedChatActionMessageId == messageKey;
    final bubbleColor = isMine
        ? scheme.primary.withValues(alpha: 0.12)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.72);
    final borderColor = isMine
        ? scheme.primary.withValues(alpha: 0.22)
        : scheme.outlineVariant.withValues(alpha: 0.55);
    final textColor = isMine ? scheme.onPrimaryContainer : scheme.onSurface;
    final authorColor = isMine
        ? scheme.primary
        : scheme.onSurfaceVariant.withValues(alpha: 0.92);
    final replyPreview = _replyPreviewFor(message);
    final highlighted =
        message.id.isNotEmpty && _highlightedChatMessageId == message.id;
    final itemKey = message.id.isEmpty ? null : _chatMessageKey(message.id);

    return MouseRegion(
      key: itemKey,
      onEnter: (_) => setState(() => _hoveredChatMessageId = messageKey),
      onExit: (_) {
        if (_activeChatMessageId != messageKey &&
            _expandedChatActionMessageId != messageKey) {
          setState(() => _hoveredChatMessageId = null);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: (details) {
          setState(() {
            _activeChatMessageId = messageKey;
            _hoveredChatMessageId = messageKey;
          });
          _showChatMessageContextMenu(message, details.globalPosition);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: highlighted
                ? scheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ChatMessageHoverLayout(
                alignEnd: isMine,
                actions: actionsVisible
                    ? _buildChatMessageActionBar(
                        message,
                        isMine,
                        showReactions: reactionsVisible,
                      )
                    : null,
                message: Column(
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    AppPanelSurface(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(8),
                        topRight: const Radius.circular(8),
                        bottomLeft: Radius.circular(isMine ? 8 : 3),
                        bottomRight: Radius.circular(isMine ? 3 : 8),
                      ),
                      border: Border.all(color: borderColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  message.username,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: authorColor,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                message.timeLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant.withValues(
                                    alpha: 0.68,
                                  ),
                                  height: 1.15,
                                ),
                              ),
                              if (message.isEdited) ...[
                                const SizedBox(width: 6),
                                Text(
                                  context.l10n.edited,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant.withValues(
                                      alpha: 0.62,
                                    ),
                                    height: 1.15,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (message.replyToMessageId.isNotEmpty) ...[
                            const SizedBox(height: 7),
                            _buildQuotedChatMessage(
                              replyPreview,
                              messageId: message.replyToMessageId,
                              isMine: isMine,
                            ),
                          ],
                          if (message.content.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            AppSelectableText(
                              message.content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: textColor,
                                height: 1.32,
                              ),
                            ),
                          ],
                          if (message.images.isNotEmpty) ...[
                            if (message.content.isNotEmpty)
                              const SizedBox(height: 8),
                            _buildChatImageGrid(message.images),
                          ],
                        ],
                      ),
                    ),
                    if (message.id.isNotEmpty &&
                        (message.reactions.isNotEmpty || isMine)) ...[
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: isMine
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (message.reactions.isNotEmpty)
                            Expanded(child: _buildChatReactionBar(message))
                          else if (isMine)
                            const Spacer(),
                          if (isMine) ...[
                            if (message.reactions.isNotEmpty)
                              const SizedBox(width: 6),
                            _buildChatReadReceiptButton(message),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatReactionBar(RoomRealtimeChatEntry message) {
    return AppSingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: message.userId == _currentUser?.id,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: message.reactions
            .map(
              (reaction) => Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: _buildChatReactionChip(message, reaction),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildChatReadReceiptButton(RoomRealtimeChatEntry message) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final receipt = _chatReceiptCache[message.id];
    final loading = _chatReceiptLoadingIds.contains(message.id);
    final mentionReceipt = receipt == null
        ? null
        : _mentionReadReceiptSummary(message, receipt);
    final hasMentions = _mentionedUsersForMessage(message, receipt).isNotEmpty;
    final text =
        mentionReceipt ??
        (receipt == null
            ? (hasMentions ? context.l10n.mentionRead : context.l10n.read)
            : context.l10n.readUnreadSummary(
                receipt.readerTotal,
                receipt.unreadTotal,
              ));
    final isMentionReceipt = mentionReceipt != null || hasMentions;
    final label = isMentionReceipt
        ? context.l10n.viewMentionReadDetails
        : context.l10n.viewReadDetails;
    return AppTooltip(
      message: label,
      child: Semantics(
        button: true,
        enabled: !loading,
        label: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: loading ? null : () => _showChatReadReceipts(message),
          child: AppPanelSurface(
            height: 32,
            color: isMentionReceipt
                ? scheme.primary.withValues(alpha: 0.11)
                : scheme.surfaceContainerHighest.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isMentionReceipt
                  ? scheme.primary.withValues(alpha: 0.28)
                  : scheme.outlineVariant.withValues(alpha: 0.58),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: AppLoadingIndicator(
                      size: AppLoadingSize.sm,
                      centered: false,
                    ),
                  )
                else
                  Icon(
                    isMentionReceipt
                        ? Icons.alternate_email_rounded
                        : Icons.visibility_outlined,
                    size: 13,
                    color: isMentionReceipt
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isMentionReceipt
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _mentionReadReceiptSummary(
    RoomRealtimeChatEntry message,
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
    if (readCount == 0 && unreadCount == 0) {
      return context.l10n.mentionRead;
    }
    if (mentionedUsers.length == 1) {
      return unreadCount == 0
          ? context.l10n.mentionRead
          : context.l10n.mentionUnread;
    }
    return context.l10n.mentionReadUnreadSummary(readCount, unreadCount);
  }

  List<SyncTvUser> _mentionedUsersForMessage(
    RoomRealtimeChatEntry message,
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
      for (final user in _members) {
        users[user.id] = user;
      }
      final currentUser = _currentUser;
      if (currentUser != null) users[currentUser.id] = currentUser;
    }
    return mentionedIds
        .map((id) => users[id])
        .whereType<SyncTvUser>()
        .where((user) => user.username.trim().isNotEmpty)
        .toList();
  }

  Future<void> _showChatReadReceipts(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty) return;
    ChatMessageReadReceiptsInfo? receipt = _chatReceiptCache[message.id];
    if (receipt == null) {
      setState(() => _chatReceiptLoadingIds.add(message.id));
      try {
        final loaded = await _chatGateway.getReadReceipts(
          widget.room.roomId,
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

  Future<void> _showChatReactionUsers(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) async {
    if (message.id.isEmpty) return;
    await showAppDialog<void>(
      context: context,
      builder: (context) => ChatReactionUsersDialog(
        roomId: widget.room.roomId,
        messageId: message.id,
        reactionKey: reaction.key,
        loadUsers: ({String cursor = ''}) => _chatGateway.listReactionUsers(
          widget.room.roomId,
          message.id,
          reaction.key,
          cursor: cursor,
        ),
      ),
    );
  }

  Widget _buildQuotedChatMessage(
    RoomRealtimeChatEntry? quote, {
    required String messageId,
    required bool isMine,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = isMine ? scheme.primary : scheme.secondary;
    final author = quote?.username.trim();
    final title = author == null || author.isEmpty
        ? context.l10n.quotedMessage
        : author;
    final preview = quote == null
        ? context.l10n.loadingQuotedMessage
        : _chatPreviewText(quote);
    return AppTooltip(
      message: context.l10n.jumpToQuotedMessage,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () => _jumpToChatMessage(messageId),
          child: AppPanelSurface(
            color: scheme.surface.withValues(alpha: isMine ? 0.5 : 0.62),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: accent.withValues(alpha: 0.22)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 3,
                  height: 31,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatReactionChip(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selected = reaction.reactedByMe;
    final background = selected
        ? scheme.primary.withValues(alpha: 0.14)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.7);
    final borderColor = selected
        ? scheme.primary.withValues(alpha: 0.42)
        : scheme.outlineVariant.withValues(alpha: 0.68);

    return AppTooltip(
      message: selected
          ? context.l10n.reactionSelectedHint
          : context.l10n.reactionUnselectedHint,
      child: InkWell(
        onTap: () => _toggleChatReaction(message, reaction),
        onLongPress: () => _showChatReactionUsers(message, reaction),
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 28,
          child: AppPanelSurface(
            color: background,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(reaction.key, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 3),
                Text(
                  '${reaction.count}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessageActionBar(
    RoomRealtimeChatEntry message,
    bool isMine, {
    bool showReactions = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final messageKey = message.dedupeKey;
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredChatMessageId = messageKey;
      }),
      onExit: (_) => setState(() => _expandedChatActionMessageId = null),
      child: Material(
        elevation: 2,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPanelSurface(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _chatMessageToolButtons(message, isMine),
              ),
            ),
            if (showReactions) ...[
              const SizedBox(height: 4),
              _buildChatReactionPicker(message),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _chatMessageToolButtons(
    RoomRealtimeChatEntry message,
    bool isMine,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return [
      _buildChatActionIcon(
        tooltip: context.l10n.react,
        icon: Icons.add_reaction_outlined,
        keepExpanded: true,
        onPressed: () => setState(() {
          final key = message.dedupeKey;
          _expandedChatActionMessageId = _expandedChatActionMessageId == key
              ? null
              : key;
          _hoveredChatMessageId = key;
        }),
      ),
      _buildChatActionIcon(
        tooltip: context.l10n.reply,
        icon: Icons.reply_rounded,
        onPressed: () => _replyToChatMessage(message),
      ),
      _buildChatActionIcon(
        tooltip: context.l10n.copy,
        icon: Icons.copy_rounded,
        onPressed: () => _copyChatMessageText(message),
      ),
      if (isMine)
        _buildChatActionIcon(
          tooltip: context.l10n.editMessage,
          icon: Icons.edit_outlined,
          onPressed: () => _editChatMessage(message),
        ),
      _buildChatActionIcon(
        tooltip: message.isPinned ? context.l10n.unpin : context.l10n.pin,
        icon: message.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        onPressed: () => _toggleChatPin(message),
      ),
      if (isMine || _canDeleteChatMessages)
        _buildChatActionIcon(
          tooltip: context.l10n.delete,
          icon: Icons.delete_outline_rounded,
          color: scheme.error,
          onPressed: () => _deleteChatMessage(message),
        ),
      if (!isMine && message.userId.isNotEmpty)
        _buildChatActionIcon(
          tooltip: context.l10n.blockUser,
          icon: Icons.person_off_outlined,
          color: scheme.error,
          onPressed: () =>
              _blockUser(userId: message.userId, username: message.username),
        ),
      _buildChatActionIcon(
        tooltip: context.l10n.report,
        icon: Icons.flag_outlined,
        onPressed: () => _showReportChatMessageDialog(message),
      ),
    ];
  }

  Widget _buildChatReactionPicker(RoomRealtimeChatEntry message) {
    final scheme = Theme.of(context).colorScheme;
    final messageKey = message.dedupeKey;
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredChatMessageId = messageKey;
        _expandedChatActionMessageId = messageKey;
      }),
      onExit: (_) => setState(() => _expandedChatActionMessageId = null),
      child: Material(
        elevation: 3,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: AppPanelSurface(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: commonChatReactionKeys
                .map((key) => _buildQuickReactionButton(message, key))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReactionButton(RoomRealtimeChatEntry message, String key) {
    final reactedByMe = _chatReactionReactedByMe(message, key);
    return AppTooltip(
      message: reactedByMe
          ? context.l10n.removeReaction(key)
          : context.l10n.addReaction(key),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          setState(() => _expandedChatActionMessageId = null);
          _setChatReaction(message, key, enabled: !reactedByMe);
        },
        child: SizedBox(
          width: 28,
          height: 28,
          child: Center(child: Text(key, style: const TextStyle(fontSize: 16))),
        ),
      ),
    );
  }

  Widget _buildQuickReactionButtonWithClose(
    RoomRealtimeChatEntry message,
    String key,
    VoidCallback onClose,
  ) {
    final reactedByMe = _chatReactionReactedByMe(message, key);
    return AppTooltip(
      message: reactedByMe
          ? context.l10n.removeReaction(key)
          : context.l10n.addReaction(key),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          onClose();
          _setChatReaction(message, key, enabled: !reactedByMe);
        },
        child: SizedBox(
          width: 28,
          height: 28,
          child: Center(child: Text(key, style: const TextStyle(fontSize: 17))),
        ),
      ),
    );
  }

  bool _chatReactionReactedByMe(RoomRealtimeChatEntry message, String key) {
    for (final reaction in message.reactions) {
      if (reaction.key == key) return reaction.reactedByMe;
    }
    return false;
  }

  Widget _buildChatActionIcon({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool keepExpanded = false,
  }) {
    return AppTooltip(
      message: tooltip,
      child: AppIconButton(
        tooltip: tooltip,
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        padding: EdgeInsets.zero,
        iconSize: 15,
        size: AppIconButtonSize.sm,
        style: color == null
            ? AppIconButtonStyle.ghost
            : AppIconButtonStyle.destructive,
        onPressed: () {
          if (!keepExpanded) {
            setState(() => _expandedChatActionMessageId = null);
          }
          onPressed();
        },
        icon: icon,
      ),
    );
  }

  Widget _buildContextActionIcon({
    required String tooltip,
    required IconData icon,
    required VoidCallback onClose,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return AppTooltip(
      message: tooltip,
      child: AppIconButton(
        tooltip: tooltip,
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        padding: EdgeInsets.zero,
        iconSize: 15,
        size: AppIconButtonSize.sm,
        style: color == null
            ? AppIconButtonStyle.ghost
            : AppIconButtonStyle.destructive,
        onPressed: () {
          onClose();
          onPressed();
        },
        icon: icon,
      ),
    );
  }

  Future<void> _showChatMessageContextMenu(
    RoomRealtimeChatEntry message,
    Offset position,
  ) async {
    final isMine = _currentUser != null && message.userId == _currentUser!.id;
    final screen = MediaQuery.sizeOf(context);
    final layout = calculateChatContextMenuLayout(
      viewportWidth: screen.width,
      viewportHeight: screen.height,
      anchorX: position.dx,
      anchorY: position.dy,
      reactionCount: commonChatReactionKeys.length,
      actionCount: isMine || _canDeleteChatMessages ? 6 : 5,
    );
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: context.l10n.closeMessageActions,
      barrierColor: Colors.transparent,
      pageBuilder: (dialogContext, _, _) {
        return Stack(
          children: [
            Positioned(
              left: layout.left,
              top: layout.top,
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: layout.width,
                  child: _buildChatContextActionPanel(
                    message,
                    isMine,
                    onClose: () => Navigator.pop(dialogContext),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    setState(() {
      _activeChatMessageId = null;
      _expandedChatActionMessageId = null;
    });
  }

  Widget _buildChatContextActionPanel(
    RoomRealtimeChatEntry message,
    bool isMine, {
    required VoidCallback onClose,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 8,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: AppPanelSurface(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 3,
              runSpacing: 3,
              children: commonChatReactionKeys
                  .map(
                    (key) => _buildQuickReactionButtonWithClose(
                      message,
                      key,
                      onClose,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 7),
            AppDivider(
              height: 1,
              color: scheme.outlineVariant.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: chatContextMenuItemSpacing,
              runSpacing: chatContextMenuItemSpacing,
              children: [
                _buildContextActionIcon(
                  tooltip: context.l10n.reply,
                  icon: Icons.reply_rounded,
                  onClose: onClose,
                  onPressed: () => _replyToChatMessage(message),
                ),
                _buildContextActionIcon(
                  tooltip: context.l10n.copy,
                  icon: Icons.copy_rounded,
                  onClose: onClose,
                  onPressed: () => _copyChatMessageText(message),
                ),
                if (isMine)
                  _buildContextActionIcon(
                    tooltip: context.l10n.editMessage,
                    icon: Icons.edit_outlined,
                    onClose: onClose,
                    onPressed: () => _editChatMessage(message),
                  ),
                _buildContextActionIcon(
                  tooltip: message.isPinned
                      ? context.l10n.unpin
                      : context.l10n.pin,
                  icon: message.isPinned
                      ? Icons.push_pin
                      : Icons.push_pin_outlined,
                  onClose: onClose,
                  onPressed: () => _toggleChatPin(message),
                ),
                if (isMine || _canDeleteChatMessages)
                  _buildContextActionIcon(
                    tooltip: context.l10n.delete,
                    icon: Icons.delete_outline_rounded,
                    color: scheme.error,
                    onClose: onClose,
                    onPressed: () => _deleteChatMessage(message),
                  ),
                if (!isMine && message.userId.isNotEmpty)
                  _buildContextActionIcon(
                    tooltip: context.l10n.blockUser,
                    icon: Icons.person_off_outlined,
                    color: scheme.error,
                    onClose: onClose,
                    onPressed: () => _blockUser(
                      userId: message.userId,
                      username: message.username,
                    ),
                  ),
                _buildContextActionIcon(
                  tooltip: context.l10n.report,
                  icon: Icons.flag_outlined,
                  onClose: onClose,
                  onPressed: () => _showReportChatMessageDialog(message),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleChatReaction(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) async {
    if (message.id.isEmpty) return;
    await _setChatReaction(
      message,
      reaction.key,
      enabled: !reaction.reactedByMe,
    );
  }

  Future<void> _setChatReaction(
    RoomRealtimeChatEntry message,
    String reactionKey, {
    required bool enabled,
  }) async {
    if (message.id.isEmpty) return;
    try {
      final updated = await _chatGateway.setReaction(
        widget.room.roomId,
        message.id,
        reactionKey,
        enabled: enabled,
      );
      if (!mounted) return;
      final entry = RoomRealtimeChatEntry.fromHistory(updated);
      setState(() {
        _messages.applyRealtimeEvent(
          entry,
          eventKind: RoomRealtimeChatEventKind.reactionsChanged,
          maxEntries: 100,
        );
        _indexChatMessage(entry);
      });
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.reactionFailed('$e'));
      }
    }
  }

  void _replyToChatMessage(RoomRealtimeChatEntry message) {
    setState(() {
      _replyingToMessage = message;
      _hoveredChatMessageId = null;
      _activeChatMessageId = null;
      _expandedChatActionMessageId = null;
    });
  }

  Future<void> _copyChatMessageText(RoomRealtimeChatEntry message) async {
    final text = message.content.trim();
    if (text.isEmpty) {
      AppNotifications.showInfo(context, context.l10n.noCopyableMessageText);
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      AppNotifications.showSuccess(context, context.l10n.messageCopied);
    }
  }

  Future<void> _toggleChatPin(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty || message.isDeleted) return;
    try {
      final event = message.isPinned
          ? await _chatGateway.unpin(widget.room.roomId, message.id)
          : await _chatGateway.pin(widget.room.roomId, message.id);
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

  Future<void> _deleteChatMessage(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty) return;
    final isMine = _currentUser != null && message.userId == _currentUser!.id;
    if (!isMine && !_canDeleteChatMessages) return;
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        icon: const Icon(Icons.delete_outline_rounded),
        title: context.l10n.deleteMessage,
        content: Text(context.l10n.confirmDeleteChatMessage),
        confirmLabel: context.l10n.delete,
        confirmIcon: Icons.delete_outline_rounded,
        destructive: true,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;

    try {
      await _chatGateway.delete(
        widget.room.roomId,
        message.id,
        expectedVersion: message.version,
        reason: 'user_deleted',
      );
      if (!mounted) return;
      setState(() {
        _messages.removeWhere((entry) => entry.dedupeKey == message.dedupeKey);
        _indexChatMessage(
          message.copyWith(
            content: '',
            images: const [],
            reactions: const [],
            reactionCount: 0,
            mentions: const [],
            version: message.version + 1,
            isDeleted: true,
            clearPin: true,
          ),
        );
        _chatReceiptCache.remove(message.id);
        if (_replyingToMessage?.id == message.id) {
          _replyingToMessage = null;
        }
      });
      AppNotifications.showSuccess(context, context.l10n.messageDeleted);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.deleteMessageFailed('$e'),
        );
      }
    }
  }

  Future<void> _editChatMessage(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty || message.isDeleted) return;
    final content = await AppDialogs.showStyledDialog<String>(
      context: context,
      title: context.l10n.editMessage,
      icon: const Icon(Icons.edit_outlined),
      content: _RoomChatMessageEditForm(initialContent: message.content),
      actions: const [],
    );
    if (content == null || content == message.content) return;

    try {
      final updated = await _chatGateway.edit(
        widget.room.roomId,
        message.id,
        content: content,
        expectedVersion: message.version,
      );
      if (!mounted) return;
      final entry = RoomRealtimeChatEntry.fromHistory(updated);
      setState(() {
        _messages.applyRealtimeEvent(
          entry,
          eventKind: RoomRealtimeChatEventKind.edited,
          maxEntries: 100,
        );
        _indexChatMessage(entry);
        _syncPinnedChatEntryFromRealtime(entry);
        if (_replyingToMessage?.id == entry.id) {
          _replyingToMessage = entry;
        }
      });
      AppNotifications.showSuccess(context, context.l10n.messageUpdated);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.editMessageFailed('$e'),
        );
      }
    }
  }

  Future<void> _showReportChatMessageDialog(
    RoomRealtimeChatEntry message,
  ) async {
    if (message.id.isEmpty) return;
    await _showReportContentDialog(
      title: context.l10n.reportMessage,
      submit: (reasonCode, reason) => _chatGateway.reportMessage(
        widget.room.roomId,
        message.id,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _showReportRoomMemberDialog(SyncTvUser member) async {
    if (member.id.isEmpty) return;
    await _showReportContentDialog(
      title: context.l10n.reportMember,
      targetLabel: member.username.isEmpty ? member.id : member.username,
      submit: (reasonCode, reason) => _chatGateway.reportMember(
        widget.room.roomId,
        member.id,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _showReportUserDialog(SyncTvUser member) async {
    if (member.id.isEmpty) return;
    await _showReportContentDialog(
      title: context.l10n.reportUser,
      targetLabel: member.username.isEmpty ? member.id : member.username,
      submit: (reasonCode, reason) => _chatGateway.reportUser(
        widget.room.roomId,
        member.id,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _blockUser({
    required String userId,
    required String username,
  }) async {
    if (userId.isEmpty || userId == _currentUser?.id) return;
    final name = username.trim().isEmpty ? userId : username.trim();
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        icon: const Icon(Icons.person_off_outlined),
        title: context.l10n.blockUser,
        content: Text(context.l10n.confirmBlockUser(name)),
        confirmLabel: context.l10n.blockUser,
        confirmIcon: Icons.person_off_outlined,
        destructive: true,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;

    try {
      await _accountGateway.blockUser(userId);
      if (!mounted) return;
      setState(() {
        _blockedUserIds.add(userId);
        _removeBlockedUserContent(userId);
      });
      AppNotifications.showSuccess(context, context.l10n.userBlocked);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.blockUserFailed('$e'));
      }
    }
  }

  Future<void> _unblockUserFromRoom(SyncTvUser user) async {
    if (user.id.isEmpty) return;
    final name = user.username.trim().isEmpty ? user.id : user.username.trim();
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        icon: const Icon(Icons.person_add_alt_1_outlined),
        title: context.l10n.unblockUser,
        content: Text(context.l10n.confirmUnblockUser(name)),
        confirmLabel: context.l10n.unblockUser,
        confirmIcon: Icons.person_add_alt_1_outlined,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;

    try {
      await _accountGateway.unblockUser(user.id);
      if (!mounted) return;
      setState(() => _blockedUserIds.remove(user.id));
      await Future.wait([_loadChatHistory(), _loadPinnedChatMessages()]);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.userUnblocked);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.unblockUserFailed('$e'),
        );
      }
    }
  }

  void _removeBlockedUserContent(String userId) {
    final removedEntries = <RoomRealtimeChatEntry>[
      ..._messages.where((entry) => entry.userId == userId),
      ..._pinnedMessages.where((entry) => entry.userId == userId),
      ..._chatMessageCache.values.where((entry) => entry.userId == userId),
    ];
    final messageIds = removedEntries
        .map((entry) => entry.id)
        .where((id) => id.isNotEmpty)
        .toSet();
    final dedupeKeys = removedEntries.map((entry) => entry.dedupeKey).toSet();

    _messages.removeWhere((entry) => entry.userId == userId);
    _pinnedMessages.removeWhere((entry) => entry.userId == userId);
    _chatMessageCache.removeWhere((_, entry) => entry.userId == userId);
    _chatMessageKeys.removeWhere((id, _) => messageIds.contains(id));
    _chatReceiptCache.removeWhere((id, _) => messageIds.contains(id));
    _loadingReplyMessageIds.removeAll(messageIds);
    _chatReceiptLoadingIds.removeAll(messageIds);
    _mentionCandidates.removeWhere((user) => user.id == userId);
    _pendingChatMentions.removeWhere((mention) => mention.userId == userId);
    if (_replyingToMessage?.userId == userId) _replyingToMessage = null;
    if (dedupeKeys.contains(_hoveredChatMessageId)) {
      _hoveredChatMessageId = null;
    }
    if (dedupeKeys.contains(_activeChatMessageId)) {
      _activeChatMessageId = null;
    }
    if (dedupeKeys.contains(_expandedChatActionMessageId)) {
      _expandedChatActionMessageId = null;
    }
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
              title: Text(context.l10n.reportMessage),
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

  Widget _buildChatImageThumb(StoredImageInfo image) {
    final url = _resourceUrlResolver.resolve(image.url);
    return AppImageThumbnail(
      url: url,
      width: 180,
      height: 120,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildVoiceControl(ThemeData theme) {
    if (_voiceChatManager == null || !_canUseVoiceChat) {
      return const SizedBox.shrink();
    }

    return AppInfoBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _voiceChatManager!.isConnected
          ? (_voiceChatManager!.isMuted ? Colors.red : Colors.green)
          : theme.disabledColor,
      backgroundColor: theme.cardColor,
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      icon: _voiceChatManager!.isConnected
          ? Icons.mic_rounded
          : Icons.mic_off_rounded,
      title: Text(
        _voiceChatManager!.isConnected
            ? (_voiceChatManager!.hasPeersConnected
                  ? (_voiceChatManager!.isMuted
                        ? context.l10n.voiceConnectedMuted(
                            _voiceChatManager!.participantCount,
                          )
                        : context.l10n.voiceConnected(
                            _voiceChatManager!.participantCount,
                          ))
                  : (_voiceChatManager!.isMuted
                        ? context.l10n.waitingToJoinVoiceMuted(1)
                        : context.l10n.waitingToJoinVoice(1)))
            : context.l10n.voiceChat,
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      trailing: _voiceChatManager!.isConnected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  icon: _voiceChatManager!.isMuted
                      ? Icons.mic_off_rounded
                      : Icons.mic_rounded,
                  onPressed: () => _voiceChatManager!.toggleMute(),
                  tooltip: _voiceChatManager!.isMuted
                      ? context.l10n.unmute
                      : context.l10n.mute,
                  size: AppIconButtonSize.sm,
                  style: _voiceChatManager!.isMuted
                      ? AppIconButtonStyle.destructive
                      : AppIconButtonStyle.tonal,
                ),
                AppIconButton(
                  icon: Icons.call_end_rounded,
                  onPressed: () => _voiceChatManager!.leave(),
                  tooltip: context.l10n.leaveVoice,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.destructive,
                ),
              ],
            )
          : AppActionButton(
              onPressed: _joinVoice,
              loading: _joiningVoice,
              icon: Icons.call_rounded,
              label: _joiningVoice ? context.l10n.joining : context.l10n.join,
              style: AppActionButtonStyle.tonal,
            ),
    );
  }

  Future<void> _joinVoice() async {
    final manager = _voiceChatManager;
    if (manager == null || _joiningVoice || !_canUseVoiceChat) return;
    final l10n = context.l10n;
    setState(() {
      _joiningVoice = true;
    });
    try {
      await manager
          .join(clientOperationId: newClientOperationId())
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException(l10n.joinVoiceTimeout),
          );
    } catch (e, stackTrace) {
      debugPrint('WebRTC voice join failed: $e');
      debugPrint('$stackTrace');
      if (mounted) {
        AppNotifications.showError(context, l10n.joinVoiceFailed('$e'));
      }
    } finally {
      if (mounted) {
        setState(() {
          _joiningVoice = false;
        });
      }
    }
  }

  Widget _buildPlaylistTab() {
    const primaryColor = Color(0xFF5D5FEF);
    final canAddMedia = _canAddMediaToCurrentPlaylist;
    final canSelectEntries = _canSelectCurrentPlaylistEntries;
    final selectionMode = _isSelectionMode && canSelectEntries;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  AppIconButton(
                    key: const Key('playlist-parent-button'),
                    icon: Icons.arrow_back_rounded,
                    onPressed: _playlistStack.isEmpty ? null : _exitPlaylist,
                    tooltip: context.l10n.parentPlaylist,
                    style: _playlistStack.isEmpty
                        ? AppIconButtonStyle.ghost
                        : AppIconButtonStyle.tonal,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _playlistStack.isEmpty
                          ? context.l10n.playlist
                          : _playlistNameStack.last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (_isRefreshingMediaEntries)
                    const SizedBox(
                      width: 36,
                      height: 36,
                      child: AppLoadingIndicator(
                        size: AppLoadingSize.sm,
                        centered: false,
                      ),
                    )
                  else
                    AppIconButton(
                      key: const Key('playlist-refresh-button'),
                      icon: Icons.refresh_rounded,
                      onPressed: _refreshCurrentPlaylist,
                      tooltip: _isInsideProviderTargetScope
                          ? context.l10n.refreshDynamicList
                          : context.l10n.refresh,
                    ),
                  _buildPlaylistViewModeMenu(),
                  if (canAddMedia)
                    AppIconButton(
                      icon: Icons.add_rounded,
                      onPressed: _showAddMediaDialog,
                      tooltip: context.l10n.add,
                    ),
                  if (_canClearCurrentPlaylistEntries && !selectionMode)
                    AppIconButton(
                      key: const Key('playlist-clear-button'),
                      icon: Icons.delete_sweep_outlined,
                      onPressed: _mediaEntries.isEmpty
                          ? null
                          : _clearCurrentPlaylistEntries,
                      tooltip: _playlistStack.isEmpty
                          ? context.l10n.clearMediaLibrary
                          : context.l10n.clearPlaylist,
                      style: AppIconButtonStyle.destructive,
                    ),
                  if (canSelectEntries)
                    AppIconButton(
                      icon: selectionMode
                          ? Icons.close_rounded
                          : Icons.checklist_rounded,
                      onPressed: () {
                        setState(() {
                          _isSelectionMode = !_isSelectionMode;
                          _selectedMediaEntryIds.clear();
                          _selectedMediaEntries.clear();
                        });
                      },
                      tooltip: selectionMode
                          ? context.l10n.cancelSelection
                          : context.l10n.batchManage,
                      style: selectionMode
                          ? AppIconButtonStyle.tonal
                          : AppIconButtonStyle.ghost,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              _buildPlaylistBreadcrumbs(),
              if (_mediaSupportsSearch || !_isInsideProviderTargetScope) ...[
                const SizedBox(height: 8),
                PlaylistSearchField(
                  key: const Key('playlist-search-field'),
                  controller: _mediaSearchController,
                  label: context.l10n.searchMediaOrPlaylist,
                  onSearch: _submitMediaSearch,
                ),
              ],
            ],
          ),
        ),
        if (selectionMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                AppActionButton(
                  onPressed: _selectAll,
                  label: context.l10n.selectAll,
                  style: AppActionButtonStyle.text,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.selectedCount(_selectedMediaEntryIds.length),
                  key: const Key('playlist-selection-count'),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const Spacer(),
                if (_canOfferSelectionDeletion)
                  AppActionButton(
                    onPressed: !_canDeleteCurrentSelection
                        ? null
                        : _deleteSelectedMediaEntries,
                    label: context.l10n.delete,
                    style: AppActionButtonStyle.tonal,
                  ),
              ],
            ),
          ),
        Expanded(
          child: _isLoadingMediaEntries
              ? const AppLoadingIndicator()
              : _mediaEntries.isEmpty
              ? PlaylistEmptyState(
                  onAdd: canAddMedia ? _showAddMediaDialog : null,
                  compact: true,
                )
              : _buildPlaylistEntries(primaryColor, selectionMode),
        ),
        if (!_isLoadingMediaEntries &&
            !_usesCursorPagination &&
            (_mediaEntries.isNotEmpty || _currentPage > 1))
          AppPaginationBar.page(
            context: context,
            page: _currentPage,
            pageSize: _pageSize,
            total: _mediaEntryTotal,
            onPrevious: _isRefreshingMediaEntries || _currentPage <= 1
                ? null
                : () => _observeCurrentPlaylist(page: _currentPage - 1),
            onNext: _isRefreshingMediaEntries || !_hasMoreMediaEntries
                ? null
                : () => _observeCurrentPlaylist(page: _currentPage + 1),
          ),
      ],
    );
  }

  Widget _buildPlaylistEntries(Color primaryColor, bool selectionMode) {
    return switch (_playlistViewMode) {
      _PlaylistViewMode.compact => AppListView.builder(
        controller: _mediaEntryScrollController,
        itemCount:
            _mediaEntries.length +
            (_usesCursorPagination && _hasMoreMediaEntries ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _mediaEntries.length) return _buildPlaylistLoadingRow();
          return _buildCompactPlaylistEntry(
            _mediaEntries[index],
            primaryColor,
            selectionMode,
          );
        },
      ),
      _PlaylistViewMode.detailed => AppListView.builder(
        controller: _mediaEntryScrollController,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        itemCount:
            _mediaEntries.length +
            (_usesCursorPagination && _hasMoreMediaEntries ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _mediaEntries.length) return _buildPlaylistLoadingRow();
          return _buildDetailedPlaylistEntry(
            _mediaEntries[index],
            primaryColor,
            selectionMode,
          );
        },
      ),
      _PlaylistViewMode.grid => AppGridView.builder(
        controller: _mediaEntryScrollController,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisExtent: 184,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount:
            _mediaEntries.length +
            (_usesCursorPagination && _hasMoreMediaEntries ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _mediaEntries.length) return _buildPlaylistLoadingCard();
          return _buildGridPlaylistEntry(
            _mediaEntries[index],
            primaryColor,
            selectionMode,
          );
        },
      ),
    };
  }

  (IconData, String) _playlistViewModePresentation(_PlaylistViewMode mode) {
    return switch (mode) {
      _PlaylistViewMode.compact => (
        Icons.view_headline_rounded,
        context.l10n.compactList,
      ),
      _PlaylistViewMode.detailed => (
        Icons.view_agenda_rounded,
        context.l10n.detailedList,
      ),
      _PlaylistViewMode.grid => (Icons.grid_view_rounded, context.l10n.grid),
    };
  }

  Widget _buildPlaylistViewModeMenu() {
    final (icon, tooltip) = _playlistViewModePresentation(_playlistViewMode);
    return AppPopupMenuButton<_PlaylistViewMode>(
      key: const Key('playlist-view-mode-menu'),
      tooltip: tooltip,
      initialValue: _playlistViewMode,
      onSelected: (mode) => setState(() => _playlistViewMode = mode),
      itemBuilder: (context) => _PlaylistViewMode.values
          .map((mode) {
            final (itemIcon, label) = _playlistViewModePresentation(mode);
            return PopupMenuItem<_PlaylistViewMode>(
              value: mode,
              child: Row(
                children: [
                  Icon(itemIcon, size: 19),
                  const SizedBox(width: 10),
                  Expanded(child: Text(label)),
                  if (_playlistViewMode == mode)
                    Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
            );
          })
          .toList(growable: false),
      child: AppTooltip(
        message: tooltip,
        child: AppPanelSurface(
          width: 36,
          height: 36,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(7),
          alignment: Alignment.center,
          child: Icon(icon, size: 19),
        ),
      ),
    );
  }

  Widget _buildPlaylistBreadcrumbs() {
    final theme = Theme.of(context);
    final crumbs = <(String, int)>[
      (context.l10n.playlist, 0),
      for (var index = 0; index < _playlistStack.length; index++)
        (_playlistNameStack[index + 1], index + 1),
    ];
    return SizedBox(
      height: 28,
      child: AppSingleChildScrollView(
        key: const Key('playlist-breadcrumbs'),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var index = 0; index < crumbs.length; index++) ...[
              if (index > 0)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 17,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: index == crumbs.length - 1
                    ? null
                    : () => _navigateToPlaylistDepth(crumbs[index].$2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index == 0) ...[
                        Icon(
                          Icons.video_library_outlined,
                          size: 15,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        crumbs[index].$1,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: index == crumbs.length - 1
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: index == crumbs.length - 1
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistLoadingRow() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: AppLoadingIndicator(centered: false),
      ),
    );
  }

  Widget _buildPlaylistLoadingCard() {
    return const AppPanelSurface(
      padding: EdgeInsets.all(12),
      child: Center(child: AppLoadingIndicator(centered: false)),
    );
  }

  Widget _buildCompactPlaylistEntry(
    RoomMediaEntry entry,
    Color primaryColor,
    bool selectionMode,
  ) {
    final isCurrent = _currentStatus?.entry?.id == entry.id;
    final isSelected = _selectedMediaEntryIds.contains(entry.id);

    return AppTile(
      selected: isSelected,
      prefix: Icon(
        _playlistEntryIcon(entry),
        color: _playlistEntryAccent(entry, isCurrent, primaryColor),
      ),
      title: Text(
        entry.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isCurrent ? primaryColor : null,
          fontWeight: isCurrent ? FontWeight.bold : null,
        ),
      ),
      subtitle: Text(
        _playlistEntryShortMeta(entry),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      suffix: _buildPlaylistSelectionIcon(
        isSelected,
        selectionMode,
        primaryColor,
      ),
      onPressed: _playlistEntryTapHandler(entry, selectionMode),
      onLongPress: _playlistEntryLongPressHandler(entry, selectionMode),
    );
  }

  Widget _buildDetailedPlaylistEntry(
    RoomMediaEntry entry,
    Color primaryColor,
    bool selectionMode,
  ) {
    final theme = Theme.of(context);
    final isCurrent = _currentStatus?.entry?.id == entry.id;
    final isSelected = _selectedMediaEntryIds.contains(entry.id);

    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.34)
          : theme.colorScheme.surface,
      border: Border.all(
        color: isCurrent
            ? primaryColor.withValues(alpha: 0.58)
            : theme.dividerColor.withValues(alpha: 0.12),
      ),
      child: InkWell(
        onTap: _playlistEntryTapHandler(entry, selectionMode),
        onLongPress: _playlistEntryLongPressHandler(entry, selectionMode),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlaylistArtwork(entry, isCurrent, primaryColor, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isCurrent ? primaryColor : null,
                              fontWeight: isCurrent
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isCurrent)
                          Icon(
                            Icons.graphic_eq_rounded,
                            size: 18,
                            color: primaryColor,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _playlistEntrySummary(entry),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _playlistEntryChips(entry)
                          .map((label) => _buildPlaylistMetaChip(label))
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
              if (selectionMode) ...[
                const SizedBox(width: 8),
                _buildPlaylistSelectionIcon(
                  isSelected,
                  selectionMode,
                  primaryColor,
                )!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridPlaylistEntry(
    RoomMediaEntry entry,
    Color primaryColor,
    bool selectionMode,
  ) {
    final theme = Theme.of(context);
    final isCurrent = _currentStatus?.entry?.id == entry.id;
    final isSelected = _selectedMediaEntryIds.contains(entry.id);

    return AppPanelSurface(
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.38)
          : theme.colorScheme.surface,
      border: Border.all(
        color: isCurrent
            ? primaryColor.withValues(alpha: 0.64)
            : theme.dividerColor.withValues(alpha: 0.12),
      ),
      child: InkWell(
        onTap: _playlistEntryTapHandler(entry, selectionMode),
        onLongPress: _playlistEntryLongPressHandler(entry, selectionMode),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildPlaylistArtwork(
                      entry,
                      isCurrent,
                      primaryColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _buildPlaylistMetaChip(
                      _playlistEntryTypeLabel(entry),
                    ),
                  ),
                  if (selectionMode)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: _buildPlaylistSelectionIcon(
                        isSelected,
                        selectionMode,
                        primaryColor,
                      )!,
                    ),
                  if (isCurrent)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        size: 20,
                        color: primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isCurrent ? primaryColor : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _playlistEntryShortMeta(entry),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildPlaylistArtwork(
    RoomMediaEntry entry,
    bool isCurrent,
    Color primaryColor, {
    double? size,
    BoxFit fit = BoxFit.cover,
  }) {
    final theme = Theme.of(context);
    final imageUrl = entry.coverUrl.isNotEmpty
        ? entry.coverUrl
        : entry.thumbnailUrl;
    final icon = Icon(
      _playlistEntryIcon(entry),
      size: size == null ? 38 : 24,
      color: _playlistEntryAccent(entry, isCurrent, primaryColor),
    );
    final placeholder = AppPanelSurface(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(size == null ? 0 : 8),
      child: Center(child: icon),
    );
    if (size != null) {
      if (imageUrl.isEmpty) {
        return SizedBox(width: size, height: size, child: placeholder);
      }
      return AppImageThumbnail(
        url: imageUrl,
        width: size,
        height: size,
        fit: fit,
        errorChild: placeholder,
        borderRadius: BorderRadius.circular(8),
        semanticLabel: entry.name,
      );
    }
    if (imageUrl.isEmpty) return placeholder;
    return LayoutBuilder(
      builder: (context, constraints) {
        return AppImageThumbnail(
          url: imageUrl,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          fit: fit,
          errorChild: placeholder,
          borderRadius: BorderRadius.zero,
          semanticLabel: entry.name,
        );
      },
    );
  }

  Widget _buildPlaylistMetaChip(String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.82,
        ),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall,
      ),
    );
  }

  Widget? _buildPlaylistSelectionIcon(
    bool isSelected,
    bool selectionMode,
    Color primaryColor,
  ) {
    if (!selectionMode) return null;
    return Icon(
      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
      color: isSelected ? primaryColor : Colors.grey,
    );
  }

  VoidCallback? _playlistEntryTapHandler(
    RoomMediaEntry entry,
    bool selectionMode,
  ) {
    final canActivate = PlaylistSelectionPolicy.canActivate(
      entry: entry,
      viewerId: _currentUser?.id ?? '',
      canControlPlayback: _canControlPlaybackState,
    );
    final intent = PlaylistSelectionPolicy.tapIntent(
      entry: entry,
      selectionMode: selectionMode,
      canActivate: canActivate,
    );
    return intent == null
        ? null
        : () => _applyPlaylistEntryIntent(entry, intent);
  }

  VoidCallback? _playlistEntryLongPressHandler(
    RoomMediaEntry entry,
    bool selectionMode,
  ) {
    final intent = PlaylistSelectionPolicy.longPressIntent(
      entry: entry,
      selectionMode: selectionMode,
      canSelectEntries: _canSelectCurrentPlaylistEntries,
    );
    return intent == null
        ? null
        : () => _applyPlaylistEntryIntent(entry, intent);
  }

  void _applyPlaylistEntryIntent(
    RoomMediaEntry entry,
    PlaylistEntryGestureIntent intent,
  ) {
    switch (intent) {
      case PlaylistEntryGestureIntent.activate:
        if (entry.isPlaylist) {
          _enterPlaylist(entry);
        } else {
          _switchMedia(entry);
        }
        return;
      case PlaylistEntryGestureIntent.enterSelection:
        _enterSelectionMode(entry);
        return;
      case PlaylistEntryGestureIntent.toggleSelection:
        _toggleSelection(entry);
        return;
    }
  }

  IconData _playlistEntryIcon(RoomMediaEntry entry) {
    final providerIcon = _playlistProviderIcon(entry);
    if (providerIcon != null) return providerIcon;
    if (entry.isPlaylist) {
      return entry.isDynamicPlaylist || entry.isProviderDynamicItem
          ? Icons.folder_special_rounded
          : Icons.folder_rounded;
    }
    if (entry.live) return Icons.sensors_rounded;
    if (entry.type.toLowerCase().contains('audio')) {
      return Icons.music_note_rounded;
    }
    return Icons.movie_rounded;
  }

  IconData? _playlistProviderIcon(RoomMediaEntry entry) {
    final provider = SourceConfigCodec.providerToString(entry.sourceProvider);
    if (provider.isEmpty) return null;
    final brand = mediaProviderBrand(provider);
    return brand.known ? brand.icon : null;
  }

  Color _playlistEntryAccent(
    RoomMediaEntry entry,
    bool isCurrent,
    Color primaryColor,
  ) {
    if (isCurrent) return primaryColor;
    if (!PlaylistSelectionPolicy.canActivate(
      entry: entry,
      viewerId: _currentUser?.id ?? '',
      canControlPlayback: _canControlPlaybackState,
    )) {
      return Theme.of(context).disabledColor;
    }
    final provider = SourceConfigCodec.providerToString(entry.sourceProvider);
    if (provider.isNotEmpty) {
      final brand = mediaProviderBrand(provider);
      if (brand.known) return brand.color;
    }
    if (entry.isPlaylist) return Colors.amber;
    if (entry.live) return Colors.redAccent;
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  String _playlistEntrySummary(RoomMediaEntry entry) {
    final description = entry.description.trim();
    if (description.isNotEmpty) return description;
    return _playlistEntryShortMeta(entry);
  }

  String _playlistEntryShortMeta(RoomMediaEntry entry) {
    final parts = <String>[_playlistEntryTypeLabel(entry)];
    if (!entry.isAvailable) {
      parts.add(context.l10n.creatorUnavailable);
    } else if (entry.isPlaylist &&
        !entry.canBrowsePlaylistFor(_currentUser?.id ?? '')) {
      parts.add(context.l10n.playlistBrowseAccessModeCreatorOnly);
    }
    if (entry.isPlaylist && entry.itemCount > 0) {
      parts.add(context.l10n.itemCount(entry.itemCount));
    }
    final provider = _playlistProviderLabel(entry);
    if (provider.isNotEmpty) parts.add(provider);
    parts.addAll(_playlistSourceDetails(entry).take(2));
    if (!entry.isPlaylist && entry.hasPlaybackChoices) {
      parts.add(context.l10n.multipleRoutes);
    }
    if (entry.proxy) parts.add(context.l10n.proxy);
    return parts.join(' · ');
  }

  List<String> _playlistEntryChips(RoomMediaEntry entry) {
    final chips = <String>[_playlistEntryTypeLabel(entry)];
    if (!entry.isAvailable) {
      chips.add(context.l10n.creatorUnavailable);
    } else if (entry.isPlaylist &&
        !entry.canBrowsePlaylistFor(_currentUser?.id ?? '')) {
      chips.add(context.l10n.playlistBrowseAccessModeCreatorOnly);
    }
    if (entry.isPlaylist) {
      if (entry.itemCount > 0) {
        chips.add(context.l10n.itemCount(entry.itemCount));
      } else if (entry.canBrowsePlaylistFor(_currentUser?.id ?? '')) {
        chips.add(context.l10n.openable);
      }
    }
    final provider = _playlistProviderLabel(entry);
    if (provider.isNotEmpty) chips.add(provider);
    chips.addAll(_playlistSourceDetails(entry));
    if (entry.live) chips.add(context.l10n.live);
    if (entry.proxy) chips.add(context.l10n.proxy);
    if (!entry.isPlaylist && entry.hasPlaybackChoices) {
      chips.add(context.l10n.multipleRoutes);
    }
    if (entry.version > 0) chips.add('v${entry.version}');
    return chips;
  }

  List<String> _playlistSourceDetails(RoomMediaEntry entry) {
    return playlistSourceFacts(entry)
        .map((fact) {
          return switch (fact.kind) {
            PlaylistSourceFactKind.instance =>
              '${context.l10n.instance}: ${fact.value}',
            PlaylistSourceFactKind.type =>
              '${context.l10n.sourceType}: ${localizedMediaVariant(context, fact.value)}',
            PlaylistSourceFactKind.path =>
              '${context.l10n.sourcePath}: ${fact.value}',
            PlaylistSourceFactKind.query =>
              '${context.l10n.sourceQuery}: ${fact.value}',
            PlaylistSourceFactKind.identifier =>
              '${context.l10n.identifier}: ${fact.value}',
            PlaylistSourceFactKind.host =>
              '${context.l10n.source}: ${fact.value}',
            PlaylistSourceFactKind.shared => context.l10n.sharedSource,
          };
        })
        .toList(growable: false);
  }

  String _playlistEntryTypeLabel(RoomMediaEntry entry) {
    if (entry.isDynamicPlaylist) return context.l10n.dynamicPlaylist;
    if (entry.isProviderDynamicItem && entry.isPlaylist) {
      return context.l10n.dynamicPlaylist;
    }
    if (entry.isProviderDynamicItem) return context.l10n.dynamicMedia;
    if (entry.isPlaylist) return context.l10n.playlist;
    if (entry.live) return context.l10n.live;
    final type = entry.type.trim();
    if (type.isEmpty) return context.l10n.media;
    return localizedMediaVariant(context, type);
  }

  String _playlistProviderLabel(RoomMediaEntry entry) {
    final sourceProvider = SourceConfigCodec.providerToString(
      entry.sourceProvider,
    );
    final provider = sourceProvider.isNotEmpty
        ? sourceProvider
        : entry.providerInstanceName.trim();
    if (provider.isEmpty) return '';
    final brand = mediaProviderBrand(provider);
    return brand.known ? brand.label : provider;
  }

  Widget _buildMembersTab() {
    final theme = Theme.of(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: AppTooltip(
                  message: context.l10n.roomPresenceSummary(
                    _onlineMemberCount,
                    _onlineGuestCount,
                  ),
                  child: Text(
                    context.l10n.roomOnlineTotal(
                      _onlineMemberCount + _onlineGuestCount,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AppBadge(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                borderRadius: BorderRadius.circular(20),
                icon: Icons.circle,
                iconSize: 8,
                color: Colors.green,
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                textStyle: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                label: Text(context.l10n.live),
              ),
            ],
          ),
        ),
        Expanded(
          child: AppRefreshIndicator(
            onRefresh: () async => _observeRoomMembers(),
            child: AppListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];

                final viewerIsCreator = _isRoomCreator;
                final viewerIsRoomAdmin =
                    _selfMember?.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN;
                final viewerIsSysAdmin = _capabilities.isSystemAdmin;
                int viewerLevel = 1;
                if (viewerIsCreator) {
                  viewerLevel = 3;
                } else if (viewerIsRoomAdmin) {
                  viewerLevel = 2;
                }
                if (viewerIsSysAdmin) {
                  viewerLevel = 4;
                }

                final isTargetCreator =
                    member.role.isRoomCreator ||
                    member.username == widget.room.creator;
                final isTargetAdmin = member.role.isRoomAdministrator;
                final isMe = _currentUser?.id == member.id;
                final isBlocked = _blockedUserIds.contains(member.id);
                final targetLevel = isTargetCreator
                    ? 3
                    : (isTargetAdmin ? 2 : 1);
                final canManageRole =
                    _canManageMemberPermissions && viewerLevel > targetLevel;
                final canKick = _canRemoveMembers && viewerLevel > targetLevel;

                final memberActions = <Widget>[
                  if (!isMe) ...[
                    if (!isTargetCreator &&
                        canManageRole &&
                        member.role.isRoomMember)
                      AppIconButton(
                        icon: Icons.admin_panel_settings_outlined,
                        tooltip: context.l10n.makeAdmin,
                        onPressed: () => _setRoomAdmin(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.tonal,
                      ),
                    if (!isTargetCreator && canManageRole && isTargetAdmin)
                      AppIconButton(
                        icon: Icons.remove_moderator_outlined,
                        tooltip: context.l10n.removeAdmin,
                        onPressed: () => _removeRoomAdmin(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.outlined,
                      ),
                    if (!isTargetCreator && canKick)
                      AppIconButton(
                        icon: Icons.remove_circle_outline,
                        tooltip: context.l10n.removeMember,
                        onPressed: () => _kickMember(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.destructive,
                      ),
                    AppIconButton(
                      icon: Icons.flag_outlined,
                      tooltip: context.l10n.reportMember,
                      onPressed: () => _showReportRoomMemberDialog(member),
                      size: AppIconButtonSize.sm,
                      iconSize: 18,
                      style: AppIconButtonStyle.outlined,
                    ),
                    AppIconButton(
                      icon: Icons.person_search_outlined,
                      tooltip: context.l10n.reportUser,
                      onPressed: () => _showReportUserDialog(member),
                      size: AppIconButtonSize.sm,
                      iconSize: 18,
                      style: AppIconButtonStyle.outlined,
                    ),
                    AppIconButton(
                      icon: Icons.person_off_outlined,
                      tooltip: isBlocked
                          ? context.l10n.unblockUser
                          : context.l10n.blockUser,
                      onPressed: isBlocked
                          ? () => _unblockUserFromRoom(member)
                          : () => _blockUser(
                              userId: member.id,
                              username: member.username,
                            ),
                      size: AppIconButtonSize.sm,
                      iconSize: 18,
                      style: isBlocked
                          ? AppIconButtonStyle.tonal
                          : AppIconButtonStyle.destructive,
                    ),
                  ],
                ];

                return AppPanelSurface(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            _RoomAvatarFrame(
                              highlighted: isTargetCreator,
                              color: primaryColor,
                              child: AppAvatar(
                                name: member.username,
                                backgroundColor: primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                foregroundColor: primaryColor,
                              ),
                            ),
                            if (isTargetCreator)
                              const Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 132,
                                    ),
                                    child: Text(
                                      member.username,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isMe)
                                    _RoomMiniBadge(
                                      label: context.l10n.me,
                                      color: theme.primaryColor,
                                    ),
                                  if (isBlocked)
                                    _RoomMiniBadge(
                                      label: context.l10n.userBlocked,
                                      color: theme.colorScheme.error,
                                    ),
                                  if (isTargetAdmin) ...[
                                    _RoomMiniBadge(
                                      label: context.l10n.administrator,
                                      color: Colors.blue,
                                      borderSide: BorderSide(
                                        color: Colors.blue.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                member.onlineCount > 0
                                    ? context.l10n.onlineConnections(
                                        member.connectionCount,
                                      )
                                    : context.l10n.offlineJoinedAt(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          member.createdAt * 1000,
                                        ).toString().substring(0, 10),
                                      ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: member.onlineCount > 0
                                      ? Colors.green
                                      : theme.disabledColor,
                                  fontSize: 12,
                                ),
                              ),
                              if (memberActions.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: memberActions,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _enterPlaylist(RoomMediaEntry playlist) {
    _invalidateMediaLibraryRequests();
    setState(() {
      _playlistStack.add(playlist);
      _playlistNameStack.add(playlist.name);
      _mediaSearchController.clear();
      _isLoadingMediaEntries = true;
    });
    _observeCurrentPlaylist();
  }

  void _exitPlaylist() {
    if (_playlistStack.isEmpty) return;
    _invalidateMediaLibraryRequests();
    setState(() {
      _playlistStack.removeLast();
      _playlistNameStack.removeLast();
      _mediaSearchController.clear();
      _isLoadingMediaEntries = true;
    });
    _observeCurrentPlaylist();
  }

  void _navigateToPlaylistDepth(int depth) {
    if (depth < 0 || depth >= _playlistStack.length) {
      if (depth != 0 || _playlistStack.isEmpty) return;
    }
    _invalidateMediaLibraryRequests();
    setState(() {
      _playlistStack.removeRange(depth, _playlistStack.length);
      _playlistNameStack.removeRange(depth + 1, _playlistNameStack.length);
      _mediaSearchController.clear();
      _isLoadingMediaEntries = true;
    });
    _observeCurrentPlaylist();
  }

  void _observeCurrentPlaylist({int? page}) {
    _invalidateMediaLibraryRequests();
    final parentPlaylist = _playlistStack.isNotEmpty
        ? _playlistStack.last
        : null;
    _selectionObservationScopeKey =
        '${parentPlaylist?.playbackPlaylistId ?? ''}::'
        '${parentPlaylist?.playbackTarget ?? ''}';
    if (page != null && page != _currentPage && mounted) {
      setState(() => _isLoadingMediaEntries = true);
    }
    try {
      _sendRealtimeMessage(
        _realtimeProtocol.encodePlaylistObservation(
          playlistId: parentPlaylist?.playbackPlaylistId ?? '',
          target: parentPlaylist?.playbackTarget,
          search: _mediaSearchController.text.trim(),
          page: page,
          pageSize: _pageSize,
        ),
      );
    } catch (e) {
      debugPrint('Observe playlist error: $e');
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.playlistSubscribeFailed,
        );
      }
    }
  }

  Future<void> _refreshCurrentPlaylist() async {
    if (_isRefreshingMediaEntries) return;
    _invalidateMediaLibraryRequests();
    final requestEpoch = _mediaLibraryStateEpoch.capture();
    final playlist = _playlistStack.isEmpty ? null : _playlistStack.last;
    setState(() => _isRefreshingMediaEntries = true);
    try {
      final mediaLibrary = await _mediaLibraryGateway.listMediaLibrary(
        widget.room.roomId,
        playlistId: playlist?.playbackPlaylistId ?? '',
        target: playlist?.playbackTarget,
        page: _usesCursorPagination ? null : _currentPage,
        search: _mediaSearchController.text.trim(),
        pageSize: _pageSize,
        refresh: _isInsideProviderTargetScope,
      );
      if (!mounted || !_mediaLibraryStateEpoch.isCurrent(requestEpoch)) return;
      _applyMediaLibrary(mediaLibrary);
    } catch (error) {
      if (!mounted || !_mediaLibraryStateEpoch.isCurrent(requestEpoch)) return;
      AppNotifications.showError(context, context.l10n.errorMessage('$error'));
    } finally {
      if (mounted && _mediaLibraryStateEpoch.isCurrent(requestEpoch)) {
        setState(() => _isRefreshingMediaEntries = false);
      }
    }
  }

  void _submitMediaSearch() {
    _invalidateMediaLibraryRequests();
    setState(() {
      _currentPage = 1;
      _nextCursor = '';
      _mediaEntryTotal = null;
      _usesCursorPagination = false;
      _hasMoreMediaEntries = false;
      _mediaEntries = const [];
      _isLoadingMediaEntries = true;
    });
    _sendRealtimeMessage(
      _realtimeProtocol.encodePlaylistObservation(
        playlistId: _playlistStack.isEmpty
            ? ''
            : _playlistStack.last.playbackPlaylistId,
        target: _playlistStack.isEmpty
            ? null
            : _playlistStack.last.playbackTarget,
        page: 1,
        pageSize: _pageSize,
        search: _mediaSearchController.text.trim(),
      ),
    );
  }

  void _invalidateMediaLibraryRequests() {
    _mediaLibraryStateEpoch.advance();
    _isLoadingMoreMediaEntries = false;
    _isRefreshingMediaEntries = false;
  }

  Future<void> _switchMedia(RoomMediaEntry entry) async {
    if (!_canControlPlaybackState) return;
    try {
      final currentPlaylist = _playlistStack.isEmpty
          ? null
          : _playlistStack.last;
      final playlistId = switch (entry.parentId) {
        final parentId? when parentId.isNotEmpty => parentId,
        _ => currentPlaylist?.playbackPlaylistId ?? '',
      };
      await _playbackGateway.switchMedia(
        widget.room.roomId,
        entry.id,
        subPath: entry.subPath,
        playlistId: playlistId,
      );
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.switchedAndPlaying);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.switchFailed('$e'));
      }
    }
  }

  void _enterSelectionMode(RoomMediaEntry entry) {
    if (!_canSelectCurrentPlaylistEntries) return;
    if (!PlaylistSelectionPolicy.isSelectable(entry)) return;
    setState(() {
      _isSelectionMode = true;
      _selectedMediaEntryIds.clear();
      _selectedMediaEntries.clear();
      _selectedMediaEntryIds.add(entry.id);
      _selectedMediaEntries[entry.id] = entry;
    });
  }

  void _toggleSelection(RoomMediaEntry entry) {
    if (!_canSelectCurrentPlaylistEntries) return;
    if (!PlaylistSelectionPolicy.isSelectable(entry)) return;
    setState(() {
      if (_selectedMediaEntryIds.contains(entry.id)) {
        _selectedMediaEntryIds.remove(entry.id);
        _selectedMediaEntries.remove(entry.id);
        if (_selectedMediaEntryIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedMediaEntryIds.add(entry.id);
        _selectedMediaEntries[entry.id] = entry;
      }
    });
  }

  void _selectAll() {
    if (!_canSelectCurrentPlaylistEntries) return;
    setState(() {
      final selectable = _mediaEntries
          .where(PlaylistSelectionPolicy.isSelectable)
          .map((entry) => entry.id)
          .toList();
      final allSelected =
          selectable.isNotEmpty &&
          selectable.every(_selectedMediaEntryIds.contains);
      if (allSelected) {
        for (final entry in _mediaEntries) {
          _selectedMediaEntryIds.remove(entry.id);
          _selectedMediaEntries.remove(entry.id);
        }
        if (_selectedMediaEntryIds.isEmpty) _isSelectionMode = false;
      } else {
        _isSelectionMode = true;
        for (final entry in _mediaEntries) {
          if (!selectable.contains(entry.id)) continue;
          _selectedMediaEntryIds.add(entry.id);
          _selectedMediaEntries[entry.id] = entry;
        }
      }
    });
  }

  bool get _isInsideProviderTargetScope {
    return _playlistStack.any(
      (playlist) =>
          playlist.isDynamicPlaylist ||
          (playlist.playbackTarget ?? '').isNotEmpty,
    );
  }

  String get _currentPersistedPlaylistId {
    if (_playlistStack.isEmpty || _isInsideProviderTargetScope) return '';
    final playlist = _playlistStack.last;
    return playlist.isPlaylist ? playlist.id : '';
  }

  bool get _canAddMediaToCurrentPlaylist =>
      _canManageOwnMedia && !_isInsideProviderTargetScope;

  bool get _canSelectCurrentPlaylistEntries => _canBrowseLibrary;

  bool get _canClearCurrentPlaylistEntries =>
      _canClearMedia && !_isInsideProviderTargetScope;

  bool get _canOfferSelectionDeletion =>
      _canDeleteMedia && !_isInsideProviderTargetScope;

  bool get _canDeleteCurrentSelection {
    if (!_canOfferSelectionDeletion || _selectedMediaEntryIds.isEmpty) {
      return false;
    }
    return _selectedMediaEntries.length == _selectedMediaEntryIds.length &&
        _selectedMediaEntries.values.every(
          (entry) => !entry.isProviderDynamicItem,
        );
  }

  Future<void> _deleteSelectedMediaEntries() async {
    if (!_canDeleteCurrentSelection) return;

    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteEntries,
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: Text(
        context.l10n.confirmDeleteMediaEntries(_selectedMediaEntryIds.length),
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );

    if (confirmed == true) {
      try {
        final selectedEntries = _selectedMediaEntries.values.toList();
        final mediaIds = selectedEntries
            .where((entry) => !entry.isPlaylist)
            .map((entry) => entry.id)
            .toList();
        final playlistIds = selectedEntries
            .where((entry) => entry.isPlaylist)
            .map((entry) => entry.id)
            .toList();
        if (mediaIds.isEmpty && playlistIds.isEmpty) {
          if (mounted) {
            AppNotifications.showInfo(
              context,
              context.l10n.dynamicPlaylistCannotDelete,
            );
          }
          return;
        }
        await _mediaLibraryGateway.deleteMediaLibraryEntries(
          widget.room.roomId,
          mediaIds: mediaIds,
          playlistIds: playlistIds,
        );

        setState(() {
          _isSelectionMode = false;
          _selectedMediaEntryIds.clear();
          _selectedMediaEntries.clear();
        });
        _observeCurrentPlaylist();
        if (mounted) AppNotifications.showInfo(context, context.l10n.deleted);
      } catch (e) {
        if (mounted) {
          AppNotifications.showError(
            context,
            context.l10n.deleteEntryFailed('$e'),
          );
        }
      }
    }
  }

  Future<void> _clearCurrentPlaylistEntries() async {
    if (!_canClearCurrentPlaylistEntries || _mediaEntries.isEmpty) return;
    final playlistId = _currentPersistedPlaylistId;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: playlistId.isEmpty
          ? context.l10n.clearMediaLibrary
          : context.l10n.clearPlaylist,
      icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
      content: Text(
        playlistId.isEmpty
            ? context.l10n.confirmClearMediaLibrary
            : context.l10n.confirmClearPlaylist,
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.clear,
        ),
      ],
    );
    if (confirmed != true) return;

    try {
      await _mediaLibraryGateway.clearMediaLibrary(
        widget.room.roomId,
        parentId: playlistId.isEmpty ? null : playlistId,
      );
      if (!mounted) return;
      setState(() {
        _isSelectionMode = false;
        _selectedMediaEntryIds.clear();
        _selectedMediaEntries.clear();
      });
      _observeCurrentPlaylist();
      AppNotifications.showSuccess(context, context.l10n.mediaLibraryCleared);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.clearFailed('$e'));
      }
    }
  }

  Future<void> _stopPlayback() async {
    if (!_canControlPlaybackState) return;
    try {
      await _playbackGateway.switchMedia(widget.room.roomId, '', subPath: '');
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.playbackStopped);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.stopPlaybackFailed('$e'),
        );
      }
    }
  }

  Future<void> _openRoomSettings() async {
    if (!_canManageRoom) {
      await _openFreeModeSettings();
      return;
    }
    showAppDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AppLoadingIndicator(),
    );

    try {
      final settings = await _roomGateway.getRoomSettings(widget.room.roomId);

      if (mounted) {
        Navigator.pop(context);

        final deleted = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => RoomSettingsPage(
              p2pMediaPreferences: widget.p2pMediaPreferences,
              roomId: widget.room.roomId,
              roomName: widget.room.roomName,
              creatorId: widget.room.creatorId,
              currentUserId: _currentUser?.id ?? '',
              isPublic: widget.room.isPublic,
              canViewPlaybackHistory: _canViewPlaybackHistory,
              canNavigatePlayback: _canNavigatePlayback,
              canManagePlaybackHistory: _canManageRoom,
              canUseWebRtc: _canUseVoiceChat || _canUseP2pMedia,
              currentSettings: settings,
              realtime: RoomRealtimeSession(
                send: _sendRealtimeMessage,
                messages: _realtimeMessageBus.stream,
                events: _realtimeEventBus.stream,
                reconnects: _realtimeReconnectBus.stream,
                disconnections: _realtimeDisconnectBus.stream,
              ),
            ),
          ),
        );
        if (!mounted) return;
        setState(() {
          _playbackModeConfig = _playbackModePreferences.value;
        });
        if (deleted == true) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showError(
          context,
          context.l10n.loadSettingsFailed('$e'),
        );
      }
    }
  }

  Future<void> _showAddMediaDialog() async {
    if (!_canAddMediaToCurrentPlaylist) return;
    await AddMediaDialog.show(
      context,
      widget.room.roomId,
      parentId: _currentPersistedPlaylistId.isEmpty
          ? null
          : _currentPersistedPlaylistId,
    );
    _observeCurrentPlaylist();
  }

  Future<void> _setRoomAdmin(SyncTvUser member) async {
    if (!_canManageMemberPermissions) return;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.makeAdmin,
      icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blue),
      content: Text(context.l10n.confirmMakeAdmin(member.username)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.confirm,
        ),
      ],
    );

    if (confirmed == true) {
      try {
        await _roomGateway.setRoomAdmin(widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) {
          AppNotifications.showSuccess(
            context,
            context.l10n.madeAdmin(member.username),
          );
        }
      } catch (e) {
        if (mounted) {
          AppNotifications.showError(context, context.l10n.settingFailed('$e'));
        }
      }
    }
  }

  Future<void> _removeRoomAdmin(SyncTvUser member) async {
    if (!_canManageMemberPermissions) return;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.removeAdmin,
      icon: const Icon(Icons.remove_moderator_rounded, color: Colors.orange),
      content: Text(context.l10n.confirmRemoveAdmin(member.username)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.confirm,
        ),
      ],
    );

    if (confirmed == true) {
      try {
        await _roomGateway.removeRoomAdmin(widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) {
          AppNotifications.showSuccess(
            context,
            context.l10n.removedAdmin(member.username),
          );
        }
      } catch (e) {
        if (mounted) {
          AppNotifications.showError(
            context,
            context.l10n.cancelActionFailed('$e'),
          );
        }
      }
    }
  }

  Future<void> _kickMember(SyncTvUser member) async {
    if (!_canRemoveMembers) return;
    final cooldown = await _askKickCooldownSeconds(member.username);
    if (cooldown == null) return;
    try {
      await _roomGateway.kickMember(
        widget.room.roomId,
        member.id,
        kickCooldownSeconds: cooldown,
      );
      _observeRoomMembers();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.memberKicked);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.kickMemberFailed('$e'),
        );
      }
    }
  }

  Future<int?> _askKickCooldownSeconds(String username) async {
    final controller = TextEditingController(text: '60');
    final value = await showAppDialog<int>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: Text(context.l10n.kickMember),
        icon: const Icon(Icons.remove_circle_outline),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.confirmKickMember(username)),
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
            label: context.l10n.kick,
            style: AppActionButtonStyle.destructive,
          ),
        ],
      ),
    );
    controller.dispose();
    return value;
  }

  Future<void> _pickChatImage() async {
    try {
      final image = await pickLocalImageUpload(context);
      if (image == null || !mounted) return;
      setState(() => _selectedChatImage = image);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.chooseImageFailed('$e'),
        );
      }
    }
  }

  Future<void> _sendMessage(String text) async {
    final content = text.trim();
    final selectedImage = _selectedChatImage;
    if (content.isEmpty && selectedImage == null) return;
    if (_sendingChatMessage) return;

    setState(() => _sendingChatMessage = true);
    try {
      final images = <StoredImageInfo>[];
      final replyToMessageId = _replyingToMessage?.id ?? '';
      if (selectedImage != null) {
        images.add(
          await _chatGateway.uploadImage(
            widget.room.roomId,
            selectedImage.upload,
          ),
        );
      }
      final message = await _chatGateway.send(
        widget.room.roomId,
        content: content,
        images: images,
        replyToMessageId: replyToMessageId,
        mentions: _pendingChatMentions,
      );
      final entry = RoomRealtimeChatEntry.fromHistory(message);
      _messageController.clear();
      if (mounted) {
        setState(() {
          _messages.applyRealtimeEvent(
            entry,
            eventKind: RoomRealtimeChatEventKind.created,
            maxEntries: 100,
          );
          _indexChatMessage(entry);
          _selectedChatImage = null;
          _replyingToMessage = null;
          _pendingChatMentions = [];
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Send message error: $e');
      if (mounted) {
        AppNotifications.showError(context, context.l10n.sendFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _sendingChatMessage = false);
    }
  }
}

class _RoomChatMessageEditForm extends StatefulWidget {
  const _RoomChatMessageEditForm({required this.initialContent});

  final String initialContent;

  @override
  State<_RoomChatMessageEditForm> createState() =>
      _RoomChatMessageEditFormState();
}

class _RoomChatMessageEditFormState extends State<_RoomChatMessageEditForm> {
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
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    Navigator.pop(context, content);
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

class _RoomMiniBadge extends StatelessWidget {
  final String label;
  final Color color;
  final BorderSide? borderSide;

  const _RoomMiniBadge({
    required this.label,
    required this.color,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      borderRadius: BorderRadius.circular(4),
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
      borderSide: borderSide,
      textStyle: TextStyle(fontSize: 10, color: color),
      label: Text(label),
    );
  }
}

class _RoomAvatarFrame extends StatelessWidget {
  final Widget child;
  final bool highlighted;
  final Color color;

  const _RoomAvatarFrame({
    required this.child,
    required this.highlighted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanelSurface(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(2),
      color: color.withValues(alpha: 0.1),
      shape: BoxShape.circle,
      border: Border.all(
        color: highlighted ? color : Colors.transparent,
        width: 2,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
