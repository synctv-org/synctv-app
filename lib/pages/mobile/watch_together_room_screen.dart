import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_app/models/direct_url_source_config.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/services/room_realtime_connection.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/pages/mobile/room_settings_page.dart';
import 'package:synctv_app/widgets/add_movie_dialog.dart';
import 'package:synctv_app/widgets/custom_video_player.dart';
import 'package:synctv_app/widgets/room_invite_actions.dart';
import 'package:synctv_app/widgets/chat_input_area.dart';
import 'package:synctv_app/managers/webrtc_manager.dart';
import 'package:synctv_app/models/danmaku_model.dart';
import 'package:synctv_app/services/smart_grip_service.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

class WatchTogetherRoomScreen extends StatefulWidget {
  final WRoom room;

  const WatchTogetherRoomScreen({super.key, required this.room});

  @override
  State<WatchTogetherRoomScreen> createState() =>
      _WatchTogetherRoomScreenState();
}

class _WatchTogetherRoomScreenState extends State<WatchTogetherRoomScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VideoPlayerController? _videoPlayerController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<RoomRealtimeChatEntry> _messages = [];
  Timer? _syncTimer;
  WPlaybackStatus? _currentStatus;
  RoomRealtimeConnection? _channel;
  List<WUser> _members = [];
  List<WMovie> _movies = [];
  bool _isLoadingMovies = true;

  // Pagination
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreMovies = true;
  bool _isLoadingMoreMovies = false;
  final ScrollController _movieScrollController = ScrollController();

  // Folder navigation
  final List<WMovie> _folderStack = [];
  final List<String> _folderNameStack = ['根目录'];

  WUser? _currentUser;

  // Sync state
  bool _isSyncing = false;
  Timer? _updateDebounce;
  bool _lastPlaying = false;
  double _lastRate = 1.0;
  double _lastPosition = 0.0;
  DateTime? _lastPlaybackSampleAt;
  DateTime? _lastProgressReportAt;
  final Set<String> _warnedPlaybackCredentialHeaderKeys = {};

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  StreamSubscription? _authErrorSubscription;
  StreamSubscription<RoomResourceWatchEvent<WPlaybackStatus>>?
      _playbackStateSubscription;
  StreamSubscription<RoomResourceWatchEvent<WPlaybackStatus>>?
      _playbackSnapshotSubscription;
  StreamSubscription<RoomResourceWatchEvent<RoomMediaLibraryPage>>?
      _playlistSubscription;
  StreamSubscription<RoomResourceWatchEvent<List<WUser>>>? _membersSubscription;
  String _playbackStateWatchVersion = '';
  String _playbackSnapshotWatchVersion = '';
  String _playlistWatchVersion = '';
  String _membersWatchVersion = '';

  WebRTCManager? _webrtcManager;

  // Danmaku Stream
  final DanmakuController _danmakuController = DanmakuController();

  bool _isSelectionMode = false;
  final Set<String> _selectedMovieIds = {};

  // Small Screen UI State
  bool _isPanelExpanded = false;

  bool get _isHarmony => Platform.operatingSystem.toLowerCase() == 'ohos';

  @override
  void initState() {
    super.initState();
    _authErrorSubscription = WatchTogetherService.onAuthError.listen((_) {
      if (mounted) {
        _disposeVideoController();
        _channel?.sink.close();
        _reconnectTimer?.cancel();
        _webrtcManager?.leave();

        // Pop to home screen
        Navigator.of(context).pop();
      }
    });
    _tabController = TabController(length: _isHarmony ? 2 : 3, vsync: this);

    // Initialize WebRTC Manager
    _webrtcManager = WebRTCManager(
      loadIceServers: () => _loadWebRtcIceServers(),
      onSignalingMessage: (type, data) {
        if (_channel != null) {
          try {
            final bytes = RoomRealtimeCodec.encodeWebRtcSignal(type, data);
            if (bytes.isNotEmpty) _channel!.sink.add(bytes);
          } catch (e) {
            debugPrint('WebRTC encode error: $e');
          }
        }
      },
      onStateChange: () {
        if (mounted) setState(() {});
      },
    );

    _movieScrollController.addListener(_onMovieScroll);
    _joinRoom();
  }

  Future<void> _joinRoom() async {
    _connectRealtime();
    _startPlaybackWatches();

    _syncState();

    Future.wait([
      _fetchCurrentUser(),
      _fetchMembers(),
      _fetchMovies(),
      _loadChatHistory(),
    ]).catchError((e) {
      debugPrint('Background data fetch error: $e');
      return <void>[];
    });
    _startRoomResourceWatches();
  }

  void _startPlaybackWatches() {
    _startPlaybackStateWatch();
    _startPlaybackSnapshotWatch();
  }

  void _startRoomResourceWatches() {
    _startPlaylistWatch();
    _startMembersWatch();
  }

  void _startPlaybackStateWatch() {
    _playbackStateSubscription?.cancel();
    _playbackStateSubscription = WatchTogetherService.watchPlaybackState(
      widget.room.roomId,
      version: _playbackStateWatchVersion,
    ).listen(
      _handlePlaybackStateWatchEvent,
      onError: (error) => _schedulePlaybackWatchReconnect(
        _startPlaybackStateWatch,
      ),
      cancelOnError: true,
    );
  }

  void _startPlaybackSnapshotWatch() {
    _playbackSnapshotSubscription?.cancel();
    final currentMovie = _currentStatus?.movie;
    _playbackSnapshotSubscription = WatchTogetherService.watchPlaybackSnapshot(
      widget.room.roomId,
      version: _playbackSnapshotWatchVersion,
      mediaId: currentMovie?.playbackWatchMediaId ?? '',
      playlistId: currentMovie?.playbackWatchPlaylistId ?? '',
      target: currentMovie?.playbackWatchTarget,
    ).listen(
      _handlePlaybackSnapshotWatchEvent,
      onError: (error) => _schedulePlaybackWatchReconnect(
        _startPlaybackSnapshotWatch,
      ),
      cancelOnError: true,
    );
  }

  void _schedulePlaybackWatchReconnect(VoidCallback reconnect) {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      reconnect();
    });
  }

  void _startPlaylistWatch() {
    _playlistSubscription?.cancel();
    final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
    _playlistSubscription = WatchTogetherService.watchPlaylistItems(
      widget.room.roomId,
      version: _playlistWatchVersion,
      playlistId: parentFolder?.playbackWatchPlaylistId ?? '',
      target: parentFolder?.playbackWatchTarget,
      page: 1,
      pageSize: _pageSize,
    ).listen(
      _handlePlaylistWatchEvent,
      onError: (error) => _schedulePlaybackWatchReconnect(_startPlaylistWatch),
      cancelOnError: true,
    );
  }

  void _startMembersWatch() {
    _membersSubscription?.cancel();
    _membersSubscription = WatchTogetherService.watchRoomUsers(
      widget.room.roomId,
      version: _membersWatchVersion,
    ).listen(
      _handleMembersWatchEvent,
      onError: (error) => _schedulePlaybackWatchReconnect(_startMembersWatch),
      cancelOnError: true,
    );
  }

  void _handlePlaylistWatchEvent(
    RoomResourceWatchEvent<RoomMediaLibraryPage> event,
  ) {
    if (!mounted) return;
    if (event.version.isNotEmpty) _playlistWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        if (event.changed) _fetchMovies();
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          _fetchMovies();
          return;
        }
        setState(() {
          _movies = snapshot.entries;
          _currentPage = 1;
          _hasMoreMovies = snapshot.total > _movies.length;
          _isLoadingMovies = false;
          _selectedMovieIds.removeWhere(
            (id) => !_movies.any((movie) => movie.id == id),
          );
          if (_selectedMovieIds.isEmpty) _isSelectionMode = false;
        });
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '播放列表监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _handleMembersWatchEvent(
    RoomResourceWatchEvent<List<WUser>> event,
  ) {
    if (!mounted) return;
    if (event.version.isNotEmpty) _membersWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        if (event.changed) _fetchMembers();
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          _fetchMembers();
          return;
        }
        _sortMembers(snapshot);
        setState(() => _members = snapshot);
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '成员监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _handlePlaybackStateWatchEvent(
    RoomResourceWatchEvent<WPlaybackStatus> event,
  ) {
    if (!mounted) return;
    if (event.version.isNotEmpty) _playbackStateWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        if (event.changed) _syncState();
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          _syncState();
          return;
        }
        final current = _currentStatus;
        final stateMovie = snapshot.movie;
        final currentMovie = current?.movie;
        final mergedMovie = stateMovie == null
            ? currentMovie
            : currentMovie != null &&
                    currentMovie.hasSamePlaybackIdentity(stateMovie)
                ? currentMovie
                : stateMovie;
        final merged = WPlaybackStatus(
          movie: mergedMovie,
          isPlaying: snapshot.isPlaying,
          currentTime: snapshot.currentTime,
          playbackRate: snapshot.playbackRate,
        );
        _applyPlaybackStatus(merged);
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '播放状态监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _handlePlaybackSnapshotWatchEvent(
    RoomResourceWatchEvent<WPlaybackStatus> event,
  ) {
    if (!mounted) return;
    if (event.version.isNotEmpty) _playbackSnapshotWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        if (event.changed) _syncState();
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          _syncState();
          return;
        }
        final current = _currentStatus;
        final merged = WPlaybackStatus(
          movie: snapshot.movie?.withPlaybackIdentityFrom(current?.movie),
          isPlaying: current?.isPlaying ?? false,
          currentTime: current?.currentTime ?? 0,
          playbackRate: current?.playbackRate ?? 1.0,
        );
        _applyPlaybackStatus(merged);
        _playbackSnapshotWatchVersion =
            snapshot.movie?.metadata['snapshot_version']?.toString() ??
                _playbackSnapshotWatchVersion;
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '播放资源监听失败' : event.errorMessage,
        );
        break;
    }
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await WatchTogetherService.getMe();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      debugPrint('Fetch user error: $e');
    }
  }

  Future<void> _fetchMembers() async {
    try {
      final members =
          await WatchTogetherService.getRoomMembers(widget.room.roomId);

      _sortMembers(members);

      if (mounted) {
        setState(() {
          _members = members;
        });
      }
    } catch (e) {
      debugPrint('Fetch members error: $e');
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      final page = await WatchTogetherService.getChatHistory(
        widget.room.roomId,
        limit: 100,
      );
      final history = page.messages
          .map(RoomRealtimeChatEntry.fromHistory)
          .toList()
          .reversed;
      if (mounted) {
        setState(() {
          _messages.prependUnique(history, maxEntries: 100);
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Fetch chat history error: $e');
    }
  }

  void _sortMembers(List<WUser> members) {
    members.sort((a, b) {
      if (a.id == widget.room.creatorId) return -1;
      if (b.id == widget.room.creatorId) return 1;
      final aAdmin =
          a.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
      final bAdmin =
          b.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
      if (aAdmin && !bAdmin) return -1;
      if (!aAdmin && bAdmin) return 1;
      return 0;
    });
  }

  Future<void> _fetchMovies() async {
    try {
      _currentPage = 1;
      _hasMoreMovies = true;

      final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
      final result = await WatchTogetherService.listMediaLibrary(
          widget.room.roomId,
          playlistId: parentFolder?.playbackWatchPlaylistId ?? '',
          target: parentFolder?.playbackWatchTarget,
          page: 1,
          pageSize: _pageSize);

      final movies = result.entries;
      final total = result.total;

      if (mounted) {
        setState(() {
          _movies = movies;
          _isLoadingMovies = false;
          _hasMoreMovies = _movies.length < total;
          _selectedMovieIds.removeWhere(
            (id) => !_movies.any((movie) => movie.id == id),
          );
          if (_selectedMovieIds.isEmpty) _isSelectionMode = false;
        });

        if (_movieScrollController.hasClients) {
          _movieScrollController.jumpTo(0);
        }
      }
    } catch (e) {
      debugPrint('Fetch movies error: $e');
      if (mounted) {
        setState(() => _isLoadingMovies = false);
      }
    }
  }

  Future<List<IceServerInfo>> _loadWebRtcIceServers() {
    return WatchTogetherService.getIceServers(widget.room.roomId);
  }

  void _onMovieScroll() {
    if (_movieScrollController.position.pixels >=
        _movieScrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMoreMovies && _hasMoreMovies) {
        _loadMoreMovies();
      }
    }
  }

  Future<void> _loadMoreMovies() async {
    if (_isLoadingMoreMovies) return;

    setState(() {
      _isLoadingMoreMovies = true;
    });

    try {
      final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
      final result = await WatchTogetherService.listMediaLibrary(
          widget.room.roomId,
          playlistId: parentFolder?.playbackWatchPlaylistId ?? '',
          target: parentFolder?.playbackWatchTarget,
          page: _currentPage + 1,
          pageSize: _pageSize);

      final movies = result.entries;
      final total = result.total;

      if (mounted) {
        setState(() {
          if (movies.isNotEmpty) {
            _movies.addAll(movies);
            _currentPage++;
            _hasMoreMovies = _movies.length < total;
          } else {
            _hasMoreMovies = false;
          }
          _isLoadingMoreMovies = false;
        });
      }
    } catch (e) {
      debugPrint('Load more movies error: $e');
      if (mounted) {
        setState(() {
          _isLoadingMoreMovies = false;
        });
      }
    }
  }

  Future<void> _connectRealtime() async {
    _reconnectTimer?.cancel();

    try {
      _channel = RoomRealtimeConnection.connect(widget.room.roomId);
      for (final bytes in RoomRealtimeCodec.encodeInitialObservations()) {
        _channel!.sink.add(bytes);
      }

      _channel!.stream.listen(
        (data) {
          _reconnectAttempts = 0;
          try {
            final message = RoomRealtimeCodec.decode(data);
            _handleRealtimeMessage(message);
          } catch (e) {
            debugPrint('Proto decode error: $e');
          }
        },
        onError: (error) {
          debugPrint('Realtime stream error: $error');
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint('Realtime stream closed');
          _scheduleReconnect();
        },
      );
    } catch (e) {
      debugPrint('Realtime stream connection error: $e');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (mounted) MessageUtils.showError(context, '连接断开，请退出重试');
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);
    debugPrint(
        'Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s');

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
      final username =
          message.senderUsername.isEmpty ? 'Unknown' : message.senderUsername;

      if (_videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized) {
        final currentPos = _videoPlayerController!.value.position;
        final danmaku = DanmakuItem(
          text: '$username: $content',
          startTime: currentPos,
          endTime: currentPos + const Duration(seconds: 8),
          color: Colors.white,
          type: DanmakuType.floating,
        );
        _danmakuController.add(danmaku);
      }

      if (mounted) {
        setState(() {
          _messages.appendUnique(
            RoomRealtimeChatEntry.fromMessage(message),
            maxEntries: 100,
          );
        });
        _scrollToBottom();
      }
    } else if (type == RoomRealtimeMessageKind.sync ||
        type == RoomRealtimeMessageKind.status ||
        type == RoomRealtimeMessageKind.checkStatus) {
      final status = message.status;
      if (status != null) {
        _performSync(
          status.isPlaying,
          status.currentTime,
          status.playbackRate,
        );

        if (type == RoomRealtimeMessageKind.sync) {
          debugPrint('Sync success');
        } else if (type == RoomRealtimeMessageKind.checkStatus) {
          debugPrint('Status check received');
        }
      }
    } else if (type == RoomRealtimeMessageKind.current) {
      _syncState();
    } else if (type == RoomRealtimeMessageKind.movies) {
      _fetchMovies();
    } else if (type == RoomRealtimeMessageKind.viewerCount) {
      _fetchMembers();
    } else if (type == RoomRealtimeMessageKind.error) {
      final errorMsg = message.error?.message ?? '';
      if (errorMsg.isNotEmpty && mounted) {
        MessageUtils.showError(context, '错误: $errorMsg');
      }
    } else if (type == RoomRealtimeMessageKind.expired) {
      if (mounted) {
        MessageUtils.showError(context, '登录已过期，请重新登录');
        Navigator.of(context).pop();
      }
    } else if (type == RoomRealtimeMessageKind.webrtcOffer ||
        type == RoomRealtimeMessageKind.webrtcAnswer ||
        type == RoomRealtimeMessageKind.webrtcIceCandidate ||
        type == RoomRealtimeMessageKind.webrtcJoin ||
        type == RoomRealtimeMessageKind.webrtcLeave) {
      if (_webrtcManager != null) {
        final signal = message.webRtc;
        if (signal == null) return;

        try {
          final signalType = signal.signalType;
          if (signalType.isNotEmpty) {
            _webrtcManager!.handleSignalingMessage(
              signalType,
              signal.payload(),
            );
          }
        } catch (e) {
          debugPrint('WebRTC signaling processing error: $e');
        }
      }
    }
  }

  Future<void> _performSync(
      bool isPlaying, double currentTime, double playbackRate) async {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    _isSyncing = true;

    try {
      if ((_videoPlayerController!.value.playbackSpeed - playbackRate).abs() >
          0.1) {
        await _videoPlayerController!.setPlaybackSpeed(playbackRate);
        _lastRate = playbackRate;
      }

      if (!isPlaying && _videoPlayerController!.value.isPlaying) {
        await _videoPlayerController!.pause();
        _lastPlaying = false;
      }

      final currentPos =
          _videoPlayerController!.value.position.inMilliseconds / 1000.0;
      if ((currentPos - currentTime).abs() > 1.0) {
        await _videoPlayerController!
            .seekTo(Duration(milliseconds: (currentTime * 1000).toInt()));
        _lastPosition = currentTime;
      }

      if (isPlaying && !_videoPlayerController!.value.isPlaying) {
        await _videoPlayerController!.play();
        _lastPlaying = true;
      }
    } catch (e) {
      debugPrint('Sync execution error: $e');
    } finally {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _isSyncing = false;
      });
    }
  }

  void _videoListener() {
    if (_isSyncing ||
        _videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    final value = _videoPlayerController!.value;
    final isPlaying = value.isPlaying;
    final position = value.position.inMilliseconds / 1000.0;
    final rate = value.playbackSpeed;
    final now = DateTime.now();
    final previousSampleAt = _lastPlaybackSampleAt;
    final previousPlaying = _lastPlaying;
    final previousRate = _lastRate;
    final previousPosition = _lastPosition;

    final isPlayPauseChanged = isPlaying != previousPlaying;
    final isRateChanged = rate != previousRate;
    var isSeekChanged = false;

    if (previousSampleAt != null) {
      final elapsedSeconds =
          now.difference(previousSampleAt).inMilliseconds / 1000.0;
      final expectedDelta =
          previousPlaying ? elapsedSeconds * previousRate : 0.0;
      final actualDelta = position - previousPosition;
      isSeekChanged = (actualDelta - expectedDelta).abs() > 2.0;
    } else if (position > 2.0) {
      isSeekChanged = true;
    }

    _lastPlaying = isPlaying;
    _lastRate = rate;
    _lastPosition = position;
    _lastPlaybackSampleAt = now;

    if (isPlayPauseChanged || isRateChanged || isSeekChanged) {
      if (_updateDebounce?.isActive ?? false) _updateDebounce!.cancel();
      if (isPlayPauseChanged && mounted && !_isSyncing) {
        _sendPlaybackUpdate(
          isPlaying ? PlaybackControlAction.play : PlaybackControlAction.pause,
          isPlaying,
          position,
          rate,
        );
        return;
      }

      if (isRateChanged && mounted && !_isSyncing) {
        _sendPlaybackUpdate(
          PlaybackControlAction.speed,
          isPlaying,
          position,
          rate,
        );
        return;
      }

      _updateDebounce = Timer(const Duration(milliseconds: 500), () {
        if (mounted && !_isSyncing) {
          final currentValue = _videoPlayerController!.value;
          _sendPlaybackUpdate(
              PlaybackControlAction.seek,
              currentValue.isPlaying,
              currentValue.position.inMilliseconds / 1000.0,
              currentValue.playbackSpeed);
        }
      });
      return;
    }

    if (isPlaying &&
        (_lastProgressReportAt == null ||
            now.difference(_lastProgressReportAt!).inSeconds >= 5)) {
      _lastProgressReportAt = now;
      _sendPlaybackProgress(isPlaying, position);
    }
  }

  void _sendPlaybackUpdate(
    PlaybackControlAction action,
    bool isPlaying,
    double position,
    double rate,
  ) {
    var sentRealtime = false;
    if (_channel != null) {
      try {
        final bytes = RoomRealtimeCodec.encodePlaybackUpdate(
          action,
          isPlaying: isPlaying,
          position: position,
          playbackRate: rate,
        );
        _channel!.sink.add(bytes);
        sentRealtime = true;
      } catch (e) {
        debugPrint('Send playback update error: $e');
      }
    }
    if (!sentRealtime) {
      WatchTogetherService.updatePlayback(
        widget.room.roomId,
        action: action,
        isPlaying: isPlaying,
        position: position,
        speed: rate,
      ).catchError((error) {
        debugPrint('HTTP playback update error: $error');
      });
    }
  }

  void _sendPlaybackProgress(bool isPlaying, double position) {
    if (_channel != null) {
      try {
        final bytes =
            RoomRealtimeCodec.encodePlaybackProgress(isPlaying, position);
        _channel!.sink.add(bytes);
      } catch (e) {
        debugPrint('Send playback progress error: $e');
      }
    }
  }

  Future<void> _syncState() async {
    try {
      final status =
          await WatchTogetherService.getCurrentMovie(widget.room.roomId);
      await _applyPlaybackStatus(status);
    } catch (e) {
      debugPrint('Sync state error: $e');
    }
  }

  Future<void> _applyPlaybackStatus(WPlaybackStatus status) async {
    if (!mounted) return;
    final oldMovieId = _currentStatus?.movie?.id;
    final nextMovieId = status.movie?.id;
    if (oldMovieId != nextMovieId) {
      _danmakuController.clear();
      _playbackSnapshotWatchVersion =
          status.movie?.metadata['snapshot_version']?.toString() ?? '';
      _startPlaybackSnapshotWatch();
    }

    setState(() {
      _currentStatus = status;
    });

    if (status.movie != null && status.movie!.url.isNotEmpty) {
      final newUrl = WatchTogetherService.resolveResourceUrl(status.movie!.url);

      if (_videoPlayerController == null ||
          _videoPlayerController!.dataSource != newUrl) {
        await _initVideo(newUrl, headers: status.movie!.headers);
        if (mounted &&
            _videoPlayerController != null &&
            _videoPlayerController!.value.isInitialized) {
          _performSync(
            status.isPlaying,
            status.currentTime,
            status.playbackRate,
          );
        }
      } else {
        _performSync(
          status.isPlaying,
          status.currentTime,
          status.playbackRate,
        );
      }

      final streamUrl = status.movie!.streamDanmu == null
          ? null
          : WatchTogetherService.resolveResourceUrl(status.movie!.streamDanmu!);
      final danmuUrl = status.movie!.danmu == null
          ? null
          : WatchTogetherService.resolveResourceUrl(status.movie!.danmu!);

      _danmakuController.updateConfig(
        danmakuUrl: danmuUrl,
        streamDanmakuUrl: streamUrl,
        controller: _videoPlayerController,
      );
    } else {
      if (_videoPlayerController != null) {
        _disposeVideoController();
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> _initVideo(String url, {Map<String, String>? headers}) async {
    if (url.isEmpty) return;
    _warnPlaybackCredentialHeaders(headers ?? const {});

    final newController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      httpHeaders: headers ?? {},
    );

    try {
      await newController.initialize();

      if (!mounted) {
        newController.dispose();
        return;
      }

      _disposeVideoController();

      _videoPlayerController = newController;
      _videoPlayerController!.addListener(_videoListener);

      if (mounted) setState(() {});
    } catch (e) {
      newController.dispose();
      debugPrint('Video init error: $e');
      if (mounted) MessageUtils.showError(context, '视频加载失败');
    }
  }

  void _warnPlaybackCredentialHeaders(Map<String, String> headers) {
    final key = DirectUrlSourceConfig.credentialHeaderRiskKey(headers);
    if (key.isEmpty || !_warnedPlaybackCredentialHeaderKeys.add(key)) return;
    final names =
        DirectUrlSourceConfig.credentialHeaderNames(headers).join('、');
    MessageUtils.showWarning(
      context,
      '当前播放地址携带 $names。此类凭据来自播放信息，房间成员可能获取并用于请求媒体资源。',
    );
  }

  void _disposeVideoController() {
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _updateDebounce?.cancel();
  }

  @override
  void dispose() {
    _authErrorSubscription?.cancel();
    _playbackStateSubscription?.cancel();
    _playbackSnapshotSubscription?.cancel();
    _playlistSubscription?.cancel();
    _membersSubscription?.cancel();
    _tabController.dispose();
    _disposeVideoController();
    _syncTimer?.cancel();
    _channel?.sink.close();
    _messageController.dispose();
    _chatScrollController.dispose();
    _movieScrollController.dispose();
    _webrtcManager?.dispose();
    _danmakuController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Detect small/square screens (like foldable outer screens)
    // Constraint 1: Aspect ratio close to 1:1 (0.8 to 1.3)
    // Constraint 2: Height is relatively small (avoid tablets)
    // Constraint 3: Exclude large screens (shortest side > 600)
    final bool isSquare = size.aspectRatio > 0.8 && size.aspectRatio < 1.3;
    final bool isSmallHeight = size.height < 700;
    final bool isNotTablet = size.shortestSide < 600;

    final bool isSmallScreen = (isSquare || isSmallHeight) && isNotTablet;

    final systemUiOverlayStyle = theme.brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    if (isSmallScreen) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light, // Small screen uses dark header
        child: _buildSmallScreenLayout(theme),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(theme),
                  _buildVideoPlayer(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildTabBar(theme),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              physics: const BouncingScrollPhysics(),
                              children: _isHarmony
                                  ? [
                                      // Wrap with Scaffold to handle bottom overflow
                                      Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: _buildPlaylistTab(),
                                      ),
                                      Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: _buildMembersTab(),
                                      ),
                                    ]
                                  : [
                                      _buildChatTab(),
                                      _buildPlaylistTab(),
                                      _buildMembersTab(),
                                    ],
                            ),
                          ),
                        ],
                      ),
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

  // Optimized layout for small/square screens (e.g. 980x980)
  Widget _buildSmallScreenLayout(ThemeData theme) {
    final size = MediaQuery.of(context).size;
    // Dynamic height based on video aspect ratio (16:9), capped at 60% of screen height
    final double videoHeight =
        (size.width / (16 / 9)).clamp(200.0, size.height * 0.6);

    // Bottom sheet calculations
    final double collapsedHeight = 60.0 + MediaQuery.of(context).padding.bottom;
    final double expandedHeight =
        size.height * 0.85; // Cover most of the screen when expanded

    // Use dark theme for header area because background is black
    final headerTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black, // Dark background for video focus
      body: Stack(
        children: [
          // Background Layer: Header + Video
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Theme(
                    data: headerTheme,
                    child: _buildHeader(headerTheme),
                  ),
                  SizedBox(
                    height: videoHeight,
                    child: _buildVideoPlayer(),
                  ),
                ],
              ),
            ),
          ),

          // Foreground Layer: Collapsible Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            left: 0,
            right: 0,
            bottom: 0,
            height: _isPanelExpanded ? expandedHeight : collapsedHeight,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // Drag down to collapse, drag up to expand
                if (details.primaryDelta! > 5) {
                  if (_isPanelExpanded) {
                    setState(() => _isPanelExpanded = false);
                  }
                } else if (details.primaryDelta! < -5) {
                  if (!_isPanelExpanded) {
                    setState(() => _isPanelExpanded = true);
                  }
                }
              },
              onTap: () {
                if (!_isPanelExpanded) setState(() => _isPanelExpanded = true);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.dividerColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),

                    // Tab Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildTabBar(theme),
                    ),

                    const SizedBox(height: 8),

                    // Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const BouncingScrollPhysics(),
                        children: _isHarmony
                            ? [
                                _buildPlaylistTab(),
                                _buildMembersTab(),
                              ]
                            : [
                                _buildChatTab(),
                                _buildPlaylistTab(),
                                _buildMembersTab(),
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.movie_filter_rounded,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : theme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.room.roomName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      GestureDetector(
                        onTap: () => copyRoomInviteLink(context, widget.room),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                'ID: ${widget.room.roomId}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.hintColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.copy_rounded,
                                size: 14, color: theme.hintColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (_currentStatus?.movie != null)
                  IconButton(
                    onPressed: _stopPlayback,
                    icon: const Icon(Icons.stop_circle_outlined,
                        color: Colors.red),
                    tooltip: '停止播放',
                    iconSize: 24,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              if ((_currentUser?.username == widget.room.creator) ||
                  _members.any((m) =>
                      m.id == _currentUser?.id &&
                      m.role ==
                          common_enum
                              .RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value))
                IconButton(
                  onPressed: _showRoomSettings,
                  icon: Icon(Icons.settings_rounded,
                      color: theme.iconTheme.color),
                  tooltip: '房间设置',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints(maxHeight: 240),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _videoPlayerController != null &&
                _videoPlayerController!.value.isInitialized
            ? CustomVideoPlayer(
                controller: _videoPlayerController!,
                title: _currentStatus?.movie?.name ?? '未知影片',
                danmakuController: _danmakuController,
                subtitles: _currentStatus?.movie?.subtitles,
                onToggleFullScreen: _toggleFullScreen,
                onSync: _handleSync,
              )
            : Container(
                color: Colors.black87,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.ondemand_video_rounded,
                          color: Colors.white54, size: 48),
                      SizedBox(height: 12),
                      Text('等待播放', style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _handleSync() {
    if (_channel != null) {
      try {
        final bytes = RoomRealtimeCodec.encodeSync();
        _channel!.sink.add(bytes);
        if (mounted) {
          MessageUtils.showInfo(context, '已发送同步请求',
              duration: const Duration(seconds: 1));
        }
      } catch (e) {
        debugPrint('Send SYNC error: $e');
      }
    }
  }

  void _toggleFullScreen() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CustomVideoPlayer(
          controller: _videoPlayerController!,
          title: _currentStatus?.movie?.name ?? '未知影片',
          danmakuController: _danmakuController,
          subtitles: _currentStatus?.movie?.subtitles,
          onToggleFullScreen: () async {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            await Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) Navigator.of(context).pop();
          },
          onSync: _handleSync,
          onSendDanmaku: _sendDanmaku,
          isFullScreen: true,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _sendDanmaku(String text) {
    if (text.trim().isEmpty) return;
    if (_channel != null) {
      try {
        final bytes = RoomRealtimeCodec.encodeChat(text);
        _channel!.sink.add(bytes);
      } catch (e) {
        debugPrint('Send danmaku error: $e');
        if (mounted) MessageUtils.showError(context, '弹幕发送失败: $e');
      }
    }
  }

  Widget _buildTabBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 46,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(23),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: isDark ? Colors.white : Colors.black,
        unselectedLabelColor: theme.hintColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
        tabs: _isHarmony
            ? const [
                Tab(text: '播放列表'),
                Tab(text: '成员'),
              ]
            : const [
                Tab(text: '聊天'),
                Tab(text: '播放列表'),
                Tab(text: '成员'),
              ],
      ),
    );
  }

  Widget _buildChatTab() {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildVoiceControl(theme),
        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          size: 48,
                          color: theme.disabledColor.withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      Text('暂无消息，打个招呼吧~',
                          style: TextStyle(color: theme.hintColor)),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _chatScrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final name = msg.username;
                    final content = msg.content;
                    final timeStr = msg.timeLabel;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                const Color(0xFF5D5FEF).withValues(alpha: 0.1),
                            child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: const TextStyle(
                                    color: Color(0xFF5D5FEF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(name,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: theme.hintColor,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 8),
                                    Text(timeStr,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: theme.disabledColor)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(16)
                                        .copyWith(topLeft: Radius.zero),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.02),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2)),
                                    ],
                                  ),
                                  child: Text(content,
                                      style: TextStyle(
                                          color: theme
                                              .textTheme.bodyMedium?.color)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        // Floating Chat Input
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ChatInputArea(
                  textController: _messageController,
                  isVoiceInputMode: false,
                  isLoading: false,
                  conversationType: 'watch_together',
                  onSendMessage: () => _sendMessage(_messageController.text),
                  onSwitchToVoiceMode: () {},
                  onShowImagePicker: () {},
                  onStartRecording: () {},
                  onStopRecording: () {},
                  onCancelRecording: () {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceControl(ThemeData theme) {
    if (_webrtcManager == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
            bottom:
                BorderSide(color: theme.dividerColor.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Icon(
            _webrtcManager!.isConnected
                ? Icons.mic_rounded
                : Icons.mic_off_rounded,
            color: _webrtcManager!.isConnected
                ? (_webrtcManager!.isMuted ? Colors.red : Colors.green)
                : theme.disabledColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _webrtcManager!.isConnected
                ? (_webrtcManager!.hasPeersConnected
                    ? (_webrtcManager!.isMuted
                        ? '语音已连接 (${_webrtcManager!.participantCount}人) (静音)'
                        : '语音已连接 (${_webrtcManager!.participantCount}人)')
                    : (_webrtcManager!.isMuted
                        ? '等待加入... (1人) (静音)'
                        : '等待加入... (1人)'))
                : '语音聊天',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          if (_webrtcManager!.isConnected) ...[
            IconButton(
              icon: Icon(
                _webrtcManager!.isMuted
                    ? Icons.mic_off_rounded
                    : Icons.mic_rounded,
                color:
                    _webrtcManager!.isMuted ? Colors.red : theme.primaryColor,
              ),
              onPressed: () => _webrtcManager!.toggleMute(),
              tooltip: _webrtcManager!.isMuted ? '取消静音' : '静音',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
            IconButton(
              icon: const Icon(Icons.call_end_rounded, color: Colors.red),
              onPressed: () => _webrtcManager!.leave(),
              tooltip: '退出语音',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
          ] else
            SizedBox(
              height: 32,
              child: ElevatedButton.icon(
                onPressed: () {
                  _webrtcManager!.join();
                },
                icon: const Icon(Icons.call_rounded, size: 14),
                label: const Text('加入'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.cardColor,
                  foregroundColor: theme.textTheme.bodyMedium?.color,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  elevation: 0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTab() {
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF5D5FEF);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Playlist Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: StreamBuilder<SmartGripStatus>(
              stream: SmartGripService().onStatusChanged,
              initialData: SmartGripService().currentStatus,
              builder: (context, snapshot) {
                final isLeftHand = snapshot.data == SmartGripStatus.leftHand;

                if (_isSelectionMode) {
                  final actions = [
                    IconButton(
                      onPressed: _exitSelectionMode,
                      icon: const Icon(Icons.close),
                      tooltip: '取消',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '已选择 ${_selectedMovieIds.length} 项',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _selectAll,
                      child: Text(_selectedMovieIds.length == _movies.length
                          ? '取消全选'
                          : '全选'),
                    ),
                  ];
                  return Row(
                    children: isLeftHand ? actions.reversed.toList() : actions,
                  );
                } else {
                  final actions = [
                    Text(
                      '播放列表 (${_movies.length})',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _showAddMovieDialog,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      tooltip: '添加影片',
                      color: isDark ? Colors.white : theme.primaryColor,
                    ),
                  ];
                  return Row(
                    children: isLeftHand ? actions.reversed.toList() : actions,
                  );
                }
              }),
        ),

        // Breadcrumb / Back
        if (_folderStack.isNotEmpty)
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: InkWell(
              onTap: _exitFolder,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_rounded,
                        size: 18,
                        color: isDark ? Colors.white : theme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      '返回上一级 | ${_folderNameStack.last}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : theme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),

        Expanded(
          child: _isLoadingMovies
              ? const Center(child: CircularProgressIndicator())
              : _movies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie_filter_outlined,
                              size: 64,
                              color:
                                  theme.disabledColor.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text('播放列表为空',
                              style: TextStyle(color: theme.hintColor)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _movieScrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      itemCount: _movies.length + (_hasMoreMovies ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _movies.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                                child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))),
                          );
                        }
                        final movie = _movies[index];
                        final isCurrent = _currentStatus?.movie?.id == movie.id;
                        final isFolder = movie.isFolder;
                        final isSelected = _selectedMovieIds.contains(movie.id);
                        final provider = movie.sourceProvider;
                        final isShared = movie.sourceConfig['shared'] == true;
                        final hasTags = movie.live ||
                            movie.proxy ||
                            isShared ||
                            provider.isNotEmpty;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.primaryColor.withValues(alpha: 0.1)
                                : theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: _isSelectionMode
                                ? null
                                : ((isCurrent && !isFolder)
                                    ? Border.all(
                                        color: primaryColor, width: 1.5)
                                    : null),
                            boxShadow: [
                              BoxShadow(
                                color: (isCurrent && !isFolder)
                                    ? primaryColor.withValues(alpha: 0.15)
                                    : Colors.black.withValues(alpha: 0.02),
                                blurRadius: (isCurrent && !isFolder) ? 8 : 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              if (_isSelectionMode) {
                                _toggleSelection(movie);
                              } else if (isFolder) {
                                _enterFolder(movie);
                              } else {
                                _switchMovie(movie);
                              }
                            },
                            onLongPress: () {
                              if (!_isSelectionMode &&
                                  _isPersistedLibraryEntry(movie)) {
                                _enterSelectionMode(movie);
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  if (_isSelectionMode)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: isSelected
                                            ? theme.primaryColor
                                            : theme.disabledColor,
                                        size: 24,
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 40,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: isFolder
                                            ? Colors.amber
                                                .withValues(alpha: 0.1)
                                            : theme.disabledColor
                                                .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        isFolder
                                            ? Icons.folder_rounded
                                            : Icons.movie_rounded,
                                        color: isFolder
                                            ? Colors.amber
                                            : (isCurrent
                                                ? primaryColor
                                                : theme.iconTheme.color
                                                    ?.withValues(alpha: 0.5)),
                                        size: 20,
                                      ),
                                    ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          movie.name,
                                          style: TextStyle(
                                            color: (isCurrent &&
                                                    !isFolder &&
                                                    !_isSelectionMode)
                                                ? primaryColor
                                                : theme
                                                    .textTheme.bodyLarge?.color,
                                            fontWeight: (isCurrent &&
                                                    !isFolder &&
                                                    !_isSelectionMode)
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (hasTags) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              if (movie.live)
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        color: Colors.blue
                                                            .withValues(
                                                                alpha: 0.3)),
                                                  ),
                                                  child: const Text('直播流',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.blue)),
                                                ),
                                              if (movie.proxy)
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        color: Colors.green
                                                            .withValues(
                                                                alpha: 0.3)),
                                                  ),
                                                  child: const Text('代理',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.green)),
                                                ),
                                              if (isShared)
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        color: Colors.orange
                                                            .withValues(
                                                                alpha: 0.3)),
                                                  ),
                                                  child: const Text('分享',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.orange)),
                                                ),
                                              if (provider == 'bilibili')
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFB7299)
                                                            .withValues(
                                                                alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        color: const Color(
                                                                0xFFFB7299)
                                                            .withValues(
                                                                alpha: 0.3)),
                                                  ),
                                                  child: const Text('Bilibili',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Color(
                                                              0xFFFB7299))),
                                                )
                                              else if (provider == 'alist')
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        color: Colors.indigo
                                                            .withValues(
                                                                alpha: 0.3)),
                                                  ),
                                                  child: const Text('AList',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.indigo)),
                                                )
                                              else if (provider == 'emby')
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: Colors.lightGreen
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        color: Colors.lightGreen
                                                            .withValues(
                                                                alpha: 0.3)),
                                                  ),
                                                  child: const Text('Emby',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors
                                                              .lightGreen)),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),

        // Selection Mode Bottom Bar
        if (_isSelectionMode)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _selectedMovieIds.isEmpty
                            ? null
                            : _deleteSelectedMovies,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('删除选中的影片'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          foregroundColor: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMembersTab() {
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF5D5FEF);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                '在线成员 (${_members.length})',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.green),
                    SizedBox(width: 6),
                    Text('Live',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchMembers,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 20),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];

                final myMemberInfo =
                    _members.where((m) => m.id == _currentUser?.id).firstOrNull;

                final viewerIsCreator =
                    _currentUser?.username == widget.room.creator;
                final viewerIsRoomAdmin = myMemberInfo?.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
                final viewerIsSysAdmin = _currentUser?.role ==
                        common_enum.UserRole.USER_ROLE_ROOT.value ||
                    _currentUser?.role ==
                        common_enum.UserRole.USER_ROLE_ADMIN.value;
                int viewerLevel = 1;
                if (viewerIsCreator) {
                  viewerLevel = 3;
                } else if (viewerIsRoomAdmin) {
                  viewerLevel = 2;
                }
                if (viewerIsSysAdmin) {
                  viewerLevel = 4;
                }

                final isTargetCreator = member.role ==
                        common_enum
                            .RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR.value ||
                    member.username == widget.room.creator;
                final isTargetAdmin = member.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
                final isMe = _currentUser?.id == member.id;
                final targetLevel =
                    isTargetCreator ? 3 : (isTargetAdmin ? 2 : 1);
                final canKick = viewerLevel > targetLevel;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: StreamBuilder<SmartGripStatus>(
                      stream: SmartGripService().onStatusChanged,
                      initialData: SmartGripService().currentStatus,
                      builder: (context, snapshot) {
                        final isLeftHand =
                            snapshot.data == SmartGripStatus.leftHand;
                        return Directionality(
                          textDirection: isLeftHand
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: isTargetCreator
                                            ? primaryColor
                                            : Colors.transparent,
                                        width: 2),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        primaryColor.withValues(alpha: 0.1),
                                    child: Text(
                                        member.username.isNotEmpty
                                            ? member.username[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                if (isTargetCreator)
                                  Positioned(
                                    right: isLeftHand ? null : 0,
                                    left: isLeftHand ? 0 : null,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                          color: Colors.amber,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.star,
                                          size: 10, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Text(member.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                if (member.onlineCount > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.green
                                              .withValues(alpha: 0.5)),
                                    ),
                                    child: Text('在线 (${member.onlineCount})',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.green)),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.disabledColor
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: theme.disabledColor
                                              .withValues(alpha: 0.5)),
                                    ),
                                    child: Text('离线',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: theme.disabledColor)),
                                  ),
                                if (isMe) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.dividerColor
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('我',
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                                if (isTargetAdmin) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.blue
                                              .withValues(alpha: 0.5)),
                                    ),
                                    child: const Text('管理员',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.blue)),
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Text(
                                '加入时间: ${DateTime.fromMillisecondsSinceEpoch(member.createdAt * 1000).toString().substring(0, 16)}'),
                            trailing: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!isMe && !isTargetCreator) ...[
                                    if ((viewerIsCreator ||
                                            viewerIsRoomAdmin) &&
                                        member.role ==
                                            common_enum.RoomMemberRole
                                                .ROOM_MEMBER_ROLE_MEMBER.value)
                                      IconButton(
                                        icon: const Icon(
                                            Icons.admin_panel_settings_rounded,
                                            color: Colors.blue),
                                        tooltip: '设为管理',
                                        onPressed: () => _setRoomAdmin(member),
                                      ),

                                    if (viewerIsCreator && isTargetAdmin)
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_moderator_rounded,
                                            color: Colors.orange),
                                        tooltip: '取消管理',
                                        onPressed: () =>
                                            _removeRoomAdmin(member),
                                      ),

                                    // Kick Member: Hierarchy check
                                    if (canKick)
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.redAccent),
                                        tooltip: '移除成员',
                                        onPressed: () => _kickMember(member),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _kickMember(WUser member) async {
    final theme = Theme.of(context);
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '踢出成员',
      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
      content: Text('确定要踢出 ${member.username} 吗？',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '确定'),
      ],
    );

    if (confirm == true) {
      try {
        await WatchTogetherService.kickMember(widget.room.roomId, member.id);
        _fetchMembers();
        if (mounted) MessageUtils.showSuccess(context, '已踢出成员');
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '踢出失败: $e');
      }
    }
  }

  Future<void> _setRoomAdmin(WUser member) async {
    final theme = Theme.of(context);
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '设为管理员',
      icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blue),
      content: Text('确定要将 ${member.username} 设为管理员吗？\n管理员拥有踢人、管理成员等权限。',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '确定'),
      ],
    );

    if (confirm == true) {
      try {
        await WatchTogetherService.setRoomAdmin(widget.room.roomId, member.id);
        _fetchMembers();
        if (mounted) {
          MessageUtils.showSuccess(context, '已将 ${member.username} 设为管理员');
        }
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '设置失败: $e');
      }
    }
  }

  Future<void> _removeRoomAdmin(WUser member) async {
    final theme = Theme.of(context);
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '取消管理员',
      icon: const Icon(Icons.remove_moderator_rounded, color: Colors.orange),
      content: Text('确定要取消 ${member.username} 的管理员权限吗？',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '确定'),
      ],
    );

    if (confirm == true) {
      try {
        await WatchTogetherService.removeRoomAdmin(
            widget.room.roomId, member.id);
        _fetchMembers();
        if (mounted) {
          MessageUtils.showSuccess(context, '已取消 ${member.username} 的管理员权限');
        }
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '取消失败: $e');
      }
    }
  }

  Future<void> _showRoomSettings() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final settings =
          await WatchTogetherService.getRoomSettings(widget.room.roomId);

      if (mounted) {
        Navigator.pop(context); // Pop loading

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomSettingsPage(
              roomId: widget.room.roomId,
              roomName: widget.room.roomName,
              currentSettings: settings,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Pop loading
        MessageUtils.showError(context, '获取设置失败: $e');
      }
    }
  }

  void _enterFolder(WMovie folder) {
    setState(() {
      _folderStack.add(folder);
      _folderNameStack.add(folder.name);
      _isLoadingMovies = true;
    });
    _playlistWatchVersion = '';
    _startPlaylistWatch();
    _fetchMovies();
  }

  void _exitFolder() {
    if (_folderStack.isEmpty) return;
    setState(() {
      _folderStack.removeLast();
      _folderNameStack.removeLast();
      _isLoadingMovies = true;
    });
    _playlistWatchVersion = '';
    _startPlaylistWatch();
    _fetchMovies();
  }

  Future<void> _switchMovie(WMovie movie) async {
    try {
      await WatchTogetherService.switchMovie(widget.room.roomId, movie.id,
          subPath: movie.subPath, playlistId: movie.parentId);
      if (mounted) MessageUtils.showSuccess(context, '已切换影片');
      await _syncState();
      // Auto play after switch
      if (mounted &&
          _videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized) {
        await _videoPlayerController!.play();
        _sendPlaybackUpdate(
            PlaybackControlAction.play,
            true,
            _videoPlayerController!.value.position.inMilliseconds / 1000.0,
            _videoPlayerController!.value.playbackSpeed);
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '切换失败: $e');
    }
  }

  void _enterSelectionMode(WMovie movie) {
    setState(() {
      _isSelectionMode = true;
      _selectedMovieIds.clear();
      _selectedMovieIds.add(movie.id);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedMovieIds.clear();
    });
  }

  void _toggleSelection(WMovie movie) {
    if (!_isPersistedLibraryEntry(movie)) return;
    setState(() {
      if (_selectedMovieIds.contains(movie.id)) {
        _selectedMovieIds.remove(movie.id);
        if (_selectedMovieIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedMovieIds.add(movie.id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      final selectable =
          _movies.where(_isPersistedLibraryEntry).map((m) => m.id).toList();
      if (_selectedMovieIds.length == selectable.length) {
        _selectedMovieIds.clear();
      } else {
        _selectedMovieIds.clear();
        _selectedMovieIds.addAll(selectable);
      }
    });
  }

  bool _isPersistedLibraryEntry(WMovie movie) {
    return movie.id.startsWith('med_') || movie.id.startsWith('pl_');
  }

  Future<void> _deleteSelectedMovies() async {
    if (_selectedMovieIds.isEmpty) return;

    final theme = Theme.of(context);
    final confirmed = await ChatUtils.showStyledDialog<bool>(
        context: context,
        title: '删除影片',
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        content: Text('确定要删除选中的 ${_selectedMovieIds.length} 个影片吗？',
            style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
        actions: [
          ChatUtils.createCancelButton(context),
          const SizedBox(width: 8),
          ChatUtils.createConfirmButton(
            context,
            () => Navigator.pop(context, true),
            text: '删除',
          ),
        ]);

    if (confirmed == true) {
      try {
        final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
        final canClearScope =
            parentFolder == null || parentFolder.id.startsWith('pl_');
        final selectableCount = _movies.where(_isPersistedLibraryEntry).length;
        final isAllLoadedSelected = _selectedMovieIds.length == selectableCount;
        final mediaIds =
            _selectedMovieIds.where((id) => id.startsWith('med_')).toList();
        final playlistIds =
            _selectedMovieIds.where((id) => id.startsWith('pl_')).toList();
        if (mediaIds.isEmpty && playlistIds.isEmpty) {
          if (mounted) MessageUtils.showInfo(context, '动态目录内容不能在房间内删除');
          return;
        }
        if (isAllLoadedSelected && !_hasMoreMovies && canClearScope) {
          await WatchTogetherService.clearMovies(widget.room.roomId,
              parentId: parentFolder?.id.startsWith('pl_') == true
                  ? parentFolder!.id
                  : null);
        } else {
          await WatchTogetherService.deleteMediaLibraryEntries(
            widget.room.roomId,
            mediaIds: mediaIds,
            playlistIds: playlistIds,
          );
        }

        _exitSelectionMode();
        _fetchMovies();
        if (mounted) MessageUtils.showInfo(context, '已删除');
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '删除失败: $e');
      }
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await WatchTogetherService.switchMovie(widget.room.roomId, '',
          subPath: '');
      if (mounted) {
        MessageUtils.showSuccess(context, '已停止播放');
        _disposeVideoController();
        setState(() {
          _currentStatus = null;
        });
      }
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, '停止播放失败: $e');
      }
    }
  }

  void _showAddMovieDialog() {
    AddMovieDialog.show(context, widget.room.roomId);
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    if (_channel != null) {
      try {
        final bytes = RoomRealtimeCodec.encodeChat(text);
        _channel!.sink.add(bytes);
      } catch (e) {
        debugPrint('Send message error: $e');
        if (mounted) MessageUtils.showError(context, '发送失败: $e');
      }
    }
    _messageController.clear();
  }
}
