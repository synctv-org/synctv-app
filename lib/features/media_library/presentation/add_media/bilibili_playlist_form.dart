import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

enum BilibiliPlaylistMode {
  videoParts,
  popular,
  recommended,
  upVideos,
  favoriteVideos,
  collectionVideos,
  seriesVideos,
  watchLater,
  pgcSeason,
  liveRecommended,
  liveFollowed,
  liveArea,
  history,
  pgcTimeline,
  pgcIndex,
  followedAnime,
  followedCinema,
}

enum BilibiliHistoryFilter { all, archive, live }

typedef BilibiliPgcTimelineLoader = Future<BilibiliPgcTimelineInfo> Function(
  BilibiliPgcTimelineKind type,
  int beforeDays,
  int afterDays,
  String instanceName,
);

typedef BilibiliPgcSeasonLoader = Future<BilibiliPgcSeasonPage> Function(
  BilibiliPgcSeasonKind type,
  int page,
  BilibiliPgcSeasonOrder order,
  bool ascending,
  bool? finished,
  String? area,
  String? year,
  int? styleId,
  String instanceName,
);

typedef BilibiliPlaylistLoader = Future<BilibiliPlaylistListPage> Function(
  BilibiliPlaylistListIntent intent,
  int page,
  int pageSize,
  String? cursor,
  String instanceName,
  bool shared,
);

class BilibiliPlaylistForm extends StatefulWidget {
  const BilibiliPlaylistForm({
    super.key,
    required this.roomId,
    required this.parentId,
    required this.binds,
    required this.onDraftChanged,
    this.proxyMode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    this.onProxyModeChanged,
    this.leadingControls,
    this.target = ProviderAddTarget.media,
    this.onLoadLiveAreas,
    this.onLoadFavoriteFolders,
    this.onLoadFollowedPgc,
    this.onLoadPgcTimeline,
    this.onLoadPgcSeasons,
    this.loader,
  });

  final String roomId;
  final String parentId;
  final List<BilibiliBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
  final source_enum.PlaybackProxyMode proxyMode;
  final ValueChanged<source_enum.PlaybackProxyMode>? onProxyModeChanged;
  final Widget? leadingControls;
  final ProviderAddTarget target;
  final Future<List<BilibiliLiveAreaInfo>> Function(String instanceName)?
  onLoadLiveAreas;
  final Future<List<BilibiliFavoriteFolderInfo>> Function(String instanceName)?
  onLoadFavoriteFolders;
  final Future<BilibiliFollowedPgcPage> Function(
    bool cinema,
    int page,
    String instanceName,
  )?
  onLoadFollowedPgc;
  final BilibiliPgcTimelineLoader? onLoadPgcTimeline;
  final BilibiliPgcSeasonLoader? onLoadPgcSeasons;
  final BilibiliPlaylistLoader? loader;

  @override
  State<BilibiliPlaylistForm> createState() => _BilibiliPlaylistFormState();
}

class _BilibiliBrowseLocation {
  const _BilibiliBrowseLocation({required this.intent, required this.title});

  final BilibiliPlaylistListIntent intent;
  final String title;
}

class _BilibiliPlaylistFormState extends State<BilibiliPlaylistForm> {
  final _selection = DiscoverySelectionController();
  final _nameController = TextEditingController();
  final _primaryController = TextEditingController();
  final _secondaryController = TextEditingController();
  final _keywordController = TextEditingController();
  final _pgcAreaController = TextEditingController();
  final _pgcYearController = TextEditingController();
  final _pgcStyleController = TextEditingController();
  BilibiliPlaylistMode _mode = BilibiliPlaylistMode.popular;
  String _instanceName = '';
  String _selectedBindId = '';
  bool _shared = false;
  bool _showSettings = false;
  bool _loading = false;
  bool _areasLoading = false;
  List<BilibiliLiveAreaInfo> _liveAreas = const [];
  int? _parentAreaId;
  int? _areaId;
  bool _favoritesLoading = false;
  List<BilibiliFavoriteFolderInfo> _favoriteFolders = const [];
  int? _favoriteMediaId;
  bool _followedPgcLoading = false;
  List<BilibiliFollowedPgcInfo> _followedPgc = const [];
  int? _followedSeasonId;
  int _followedPgcPage = 1;
  int _followedPgcTotal = 0;
  bool _followedPgcHasMore = false;
  BilibiliHistoryFilter _historyFilter = BilibiliHistoryFilter.all;
  BilibiliPgcTimelineKind _timelineKind = BilibiliPgcTimelineKind.anime;
  int _timelineBeforeDays = 3;
  int _timelineAfterDays = 7;
  bool _timelineLoading = false;
  BilibiliPgcTimelineInfo? _timeline;
  BilibiliPgcSeasonKind _pgcSeasonKind = BilibiliPgcSeasonKind.anime;
  BilibiliPgcSeasonOrder _pgcSeasonOrder = BilibiliPgcSeasonOrder.updated;
  bool _pgcAscending = false;
  bool? _pgcFinished;
  bool _pgcSeasonsLoading = false;
  List<BilibiliPgcSeasonInfo> _pgcSeasons = const [];
  int? _selectedPgcSeasonId;
  int _pgcSeasonPage = 1;
  int _pgcSeasonTotal = 0;
  bool _pgcSeasonsHasMore = false;
  BilibiliPlaylistListPage? _preview;
  final List<_BilibiliBrowseLocation> _browsePath = [];
  int _previewRequestVersion = 0;

  bool get _previewUsesCursor =>
      _currentIntent.mode == BilibiliPlaylistListMode.history;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isInstantPreviewMode) unawaited(_loadPreview());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _primaryController.dispose();
    _secondaryController.dispose();
    _keywordController.dispose();
    _pgcAreaController.dispose();
    _pgcYearController.dispose();
    _pgcStyleController.dispose();
    super.dispose();
  }

  void _changed() {
    _previewRequestVersion += 1;
    _preview = null;
    _browsePath.clear();
    _selection.clear();
    widget.onDraftChanged(
      _nameController.text.trim().isNotEmpty ||
          _primaryController.text.trim().isNotEmpty ||
          _secondaryController.text.trim().isNotEmpty ||
          _keywordController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  void _nameChanged() {
    widget.onDraftChanged(
      _nameController.text.trim().isNotEmpty ||
          _primaryController.text.trim().isNotEmpty ||
          _secondaryController.text.trim().isNotEmpty ||
          _keywordController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedBindId.isNotEmpty &&
        !widget.binds.any((bind) => bind.id == _selectedBindId)) {
      _selectedBindId = '';
      _instanceName = '';
    }
    final items = _preview?.items ?? const <BilibiliPlaylistListItemInfo>[];
    final controls = <Widget>[
      ?widget.leadingControls,
      _buildBrowseToolbar(context),
      if (_primaryLabel case final label?) ...[
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('bilibili-playlist-primary'),
          controller: _primaryController,
          enabled: !_loading,
          label: label,
          prefixIcon: Icons.tag,
          keyboardType: _mode == BilibiliPlaylistMode.videoParts
              ? TextInputType.text
              : TextInputType.number,
          onChanged: (_) => _changed(),
        ),
      ],
      if (_secondaryLabel case final label?) ...[
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('bilibili-playlist-secondary'),
          controller: _secondaryController,
          enabled: !_loading,
          label: label,
          prefixIcon: Icons.numbers,
          keyboardType: TextInputType.number,
          onChanged: (_) => _changed(),
        ),
      ],
      if (_mode == BilibiliPlaylistMode.upVideos) ...[
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('bilibili-playlist-keyword'),
          controller: _keywordController,
          enabled: !_loading,
          label: context.l10n.keyword,
          prefixIcon: Icons.search,
          onChanged: (_) => _changed(),
        ),
      ],
      if (_mode == BilibiliPlaylistMode.liveArea) ...[
        const SizedBox(height: 12),
        if (_areasLoading)
          const AppLoadingIndicator(size: AppLoadingSize.sm)
        else ...[
          DropdownButtonFormField<int>(
            key: const Key('bilibili-live-parent-area'),
            initialValue: _parentAreaId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.l10n.liveCategory,
              prefixIcon: const Icon(Icons.category_outlined),
            ),
            items: _parentAreas
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (value) {
                    final children = _childrenFor(value);
                    _parentAreaId = value;
                    _areaId = children.firstOrNull?.id;
                    _changed();
                  },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: const Key('bilibili-live-area'),
            initialValue: _areaId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.l10n.liveSubcategory,
              prefixIcon: const Icon(Icons.live_tv_outlined),
            ),
            items: _childrenFor(_parentAreaId)
                .map(
                  (area) => DropdownMenuItem(
                    value: area.id,
                    child: Text(
                      area.hot
                          ? '${area.name} · ${context.l10n.hotLabel}'
                          : area.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (value) {
                    _areaId = value;
                    _changed();
                  },
          ),
        ],
      ],
      if (_mode == BilibiliPlaylistMode.history) ...[
        const SizedBox(height: 12),
        SegmentedButton<BilibiliHistoryFilter>(
          segments: [
            ButtonSegment(
              value: BilibiliHistoryFilter.all,
              label: Text(context.l10n.all),
            ),
            ButtonSegment(
              value: BilibiliHistoryFilter.archive,
              label: Text(context.l10n.videos),
            ),
            ButtonSegment(
              value: BilibiliHistoryFilter.live,
              label: Text(context.l10n.live),
            ),
          ],
          selected: {_historyFilter},
          onSelectionChanged: _loading
              ? null
              : (value) {
                  _historyFilter = value.first;
                  _changed();
                },
        ),
      ],
      if (_mode == BilibiliPlaylistMode.pgcTimeline)
        ..._buildPgcTimelineControls(),
      if (_mode == BilibiliPlaylistMode.pgcIndex) ..._buildPgcIndexControls(),
      if (_mode == BilibiliPlaylistMode.favoriteVideos) ...[
        const SizedBox(height: 12),
        if (_favoritesLoading)
          const AppLoadingIndicator(size: AppLoadingSize.sm)
        else
          DropdownButtonFormField<int>(
            key: const Key('bilibili-favorite-folder'),
            initialValue: _favoriteMediaId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.l10n.favoriteFolder,
              prefixIcon: const Icon(Icons.favorite_outline),
            ),
            items: _favoriteFolders
                .map(
                  (folder) => DropdownMenuItem(
                    value: folder.mediaId,
                    child: Text(
                      '${folder.title} (${folder.mediaCount})'
                      '${folder.isPrivate ? ' · ${context.l10n.privateLabel}' : ''}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (value) {
                    _favoriteMediaId = value;
                    _changed();
                  },
          ),
      ],
      if (_mode == BilibiliPlaylistMode.followedAnime ||
          _mode == BilibiliPlaylistMode.followedCinema) ...[
        const SizedBox(height: 12),
        if (_followedPgcLoading && _followedPgc.isEmpty)
          const AppLoadingIndicator(size: AppLoadingSize.sm)
        else ...[
          DropdownButtonFormField<int>(
            key: const Key('bilibili-followed-pgc'),
            initialValue: _followedSeasonId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: _mode == BilibiliPlaylistMode.followedCinema
                  ? context.l10n.followedCinema
                  : context.l10n.followedAnime,
              prefixIcon: const Icon(Icons.subscriptions_outlined),
            ),
            items: _followedPgc
                .map(
                  (season) => DropdownMenuItem(
                    value: season.seasonId,
                    child: Text(
                      season.latestEpisode.isEmpty
                          ? season.title
                          : '${season.title} · ${season.latestEpisode}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (value) {
                    _followedSeasonId = value;
                    _changed();
                  },
          ),
          AppPaginationBar.page(
            key: const Key('bilibili-followed-pagination'),
            context: context,
            page: _followedPgcPage,
            pageSize: 30,
            total: _followedPgcTotal,
            onPrevious: _followedPgcLoading || _followedPgcPage <= 1
                ? null
                : () => _loadFollowedPgc(page: _followedPgcPage - 1),
            onNext: _followedPgcLoading || !_followedPgcHasMore
                ? null
                : () => _loadFollowedPgc(page: _followedPgcPage + 1),
          ),
        ],
      ],
      if (widget.onProxyModeChanged case final onProxyModeChanged?)
        if (_playbackPolicySource case final source?) ...[
          const SizedBox(height: 12),
          PlaybackProxyModeControl(
            key: const Key('bilibili-playback-proxy-mode'),
            value: widget.proxyMode,
            enabled: !_loading,
            source: source,
            onChanged: onProxyModeChanged,
          ),
        ],
      if (_showSettings) ...[
        const SizedBox(height: 10),
        _buildSettings(context),
      ],
    ];
    return ProviderWorkspace(
      controls: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: controls,
      ),
      results: _shouldShowBrowser
          ? _buildDiscoveryBrowser(context, items)
          : const SizedBox(),
      hasResults: _shouldShowBrowser,
    );
  }

  Widget _buildDiscoveryBrowser(
    BuildContext context,
    List<BilibiliPlaylistListItemInfo> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_browsePath.isNotEmpty) ...[
          Row(
            children: [
              AppIconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: _loading ? null : _goBack,
                icon: Icons.arrow_back_rounded,
                size: AppIconButtonSize.sm,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _browsePath.last.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Expanded(
          child: DiscoveryBrowser(
            key: ValueKey(
              'bilibili-discovery:${_currentIntent.mode.name}:'
              '${_browsePath.length}:${_shared ? 1 : 0}',
            ),
            items: [
              for (final item in items)
                DiscoveryBrowserEntry(
                  key: item.id,
                  title: item.title,
                  subtitle: item.description,
                  source: item.source,
                  isContainer: item.isContainer,
                  leading: item.cover.isEmpty
                      ? Icon(
                          item.isContainer
                              ? Icons.video_library_outlined
                              : Icons.play_circle_outline,
                        )
                      : AppImageThumbnail(
                          url: item.cover,
                          width: 48,
                          height: 48,
                          borderRadius: BorderRadius.circular(4),
                          errorIcon: Icons.play_circle_outline,
                        ),
                ),
            ],
            selectionController: _selection,
            selectionScope:
                '${_selectedBindId.isEmpty ? 'default' : _selectedBindId}:'
                '${widget.target.name}:${_browsePath.length}',
            onSelectionChanged: () => setState(() {}),
            loading: _loading,
            paginationMode: _previewUsesCursor
                ? DiscoveryPaginationMode.cursor
                : DiscoveryPaginationMode.page,
            page: _preview?.page ?? 1,
            pageSize: 30,
            hasMore: _preview?.hasMore ?? false,
            onLoadMore: _previewUsesCursor
                ? () => _loadPreview(loadMore: true)
                : null,
            onPreviousPage:
                _loading || _previewUsesCursor || (_preview?.page ?? 1) <= 1
                ? null
                : () => _loadPreview(page: _preview!.page - 1),
            onNextPage:
                _loading || _previewUsesCursor || _preview?.hasMore != true
                ? null
                : () => _loadPreview(page: _preview!.page + 1),
            onOpen: (entry) =>
                _openBrowse(items.firstWhere((item) => item.id == entry.key)),
            target: widget.target,
            onAddSelected: widget.target == ProviderAddTarget.media
                ? _addSelected
                : null,
            onAddCurrentList:
                widget.target == ProviderAddTarget.playlist && _previewReady
                ? _create
                : null,
            playlistActionLeading: widget.target == ProviderAddTarget.playlist
                ? AppTextField(
                    key: const Key('bilibili-playlist-name'),
                    controller: _nameController,
                    enabled: !_loading,
                    label: context.l10n.playlistName,
                    prefixIcon: Icons.title,
                    onChanged: (_) => _nameChanged(),
                  )
                : null,
            currentListLabel: context.l10n.addCurrentList,
            emptyIcon: Icons.video_collection_outlined,
            emptyTitle: context.l10n.noItems,
          ),
        ),
      ],
    );
  }

  Widget _buildBrowseToolbar(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: AppPopupMenuButton<BilibiliPlaylistMode>(
            key: const Key('bilibili-playlist-mode'),
            tooltip: context.l10n.source,
            initialValue: _mode,
            onSelected: _selectMode,
            itemBuilder: (context) => [
              _modeMenuLabel(context, '浏览'),
              ..._modeMenuItems(const [
                BilibiliPlaylistMode.popular,
                BilibiliPlaylistMode.recommended,
                BilibiliPlaylistMode.watchLater,
                BilibiliPlaylistMode.history,
                BilibiliPlaylistMode.liveRecommended,
                BilibiliPlaylistMode.liveFollowed,
              ]),
              const PopupMenuDivider(),
              _modeMenuLabel(context, '视频'),
              ..._modeMenuItems(const [
                BilibiliPlaylistMode.videoParts,
                BilibiliPlaylistMode.upVideos,
                BilibiliPlaylistMode.favoriteVideos,
                BilibiliPlaylistMode.collectionVideos,
                BilibiliPlaylistMode.seriesVideos,
              ]),
              const PopupMenuDivider(),
              _modeMenuLabel(context, '番剧与影视'),
              ..._modeMenuItems(const [
                BilibiliPlaylistMode.pgcSeason,
                BilibiliPlaylistMode.pgcTimeline,
                BilibiliPlaylistMode.pgcIndex,
                BilibiliPlaylistMode.followedAnime,
                BilibiliPlaylistMode.followedCinema,
                BilibiliPlaylistMode.liveArea,
              ]),
            ],
            child: Semantics(
              button: true,
              label: '${context.l10n.source}: ${_modeLabel(_mode)}',
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.72,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.video_collection_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _modeLabel(_mode),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        AppIconButton(
          key: const Key('bilibili-playlist-preview'),
          tooltip: context.l10n.refresh,
          onPressed: _loading || !_valid ? null : _loadPreview,
          loading: _loading,
          icon: Icons.refresh_rounded,
          size: AppIconButtonSize.sm,
        ),
        AppIconButton(
          key: const Key('bilibili-playlist-settings'),
          tooltip: context.l10n.settings,
          onPressed: () => setState(() => _showSettings = !_showSettings),
          icon: Icons.tune_rounded,
          selectedIcon: Icons.tune_rounded,
          selected: _showSettings,
          style: _showSettings
              ? AppIconButtonStyle.tonal
              : AppIconButtonStyle.ghost,
          size: AppIconButtonSize.sm,
        ),
      ],
    );
  }

  PopupMenuItem<BilibiliPlaylistMode> _modeMenuLabel(
    BuildContext context,
    String label,
  ) {
    return PopupMenuItem<BilibiliPlaylistMode>(
      enabled: false,
      height: 32,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  List<PopupMenuItem<BilibiliPlaylistMode>> _modeMenuItems(
    List<BilibiliPlaylistMode> modes,
  ) {
    return [
      for (final mode in modes)
        PopupMenuItem<BilibiliPlaylistMode>(
          value: mode,
          height: 40,
          child: Text(_modeLabel(mode)),
        ),
    ];
  }

  Widget _buildSettings(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProviderAccountSelector<BilibiliBindInfo>(
              accounts: widget.binds,
              selectedId: _selectedBindId,
              idOf: (bind) => bind.id,
              labelOf: (bind) => bind.providerInstanceName.isEmpty
                  ? context.l10n.bilibiliAccount
                  : '${context.l10n.bilibiliAccount} · ${bind.providerInstanceName}',
              includeDefault: true,
              enabled: !_loading,
              onChanged: _changeAccount,
            ),
            AppSwitchTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.shareMyCredentials),
              prefix: const Icon(Icons.key_rounded),
              semanticsLabel: context.l10n.shareMyCredentials,
              value: _shared,
              onChanged: _loading
                  ? null
                  : (value) {
                      _shared = value;
                      _changed();
                      _reloadPreviewWhenReady();
                    },
            ),
          ],
        ),
      ),
    );
  }

  provider_common.DiscoveredSource? get _playbackPolicySource {
    if (widget.target == ProviderAddTarget.media) {
      return _selection.entries.firstOrNull?.source ?? _preview?.source;
    }
    return _preview?.source;
  }

  void _selectMode(BilibiliPlaylistMode mode) {
    if (mode == _mode) return;
    setState(() {
      _mode = mode;
      _preview = null;
      _primaryController.clear();
      _secondaryController.clear();
      _keywordController.clear();
    });
    _changed();
    if (mode == BilibiliPlaylistMode.liveArea) {
      unawaited(_loadLiveAreas());
    }
    if (mode == BilibiliPlaylistMode.favoriteVideos) {
      unawaited(_loadFavoriteFolders());
    }
    if (mode == BilibiliPlaylistMode.followedAnime ||
        mode == BilibiliPlaylistMode.followedCinema) {
      unawaited(_loadFollowedPgc());
    }
    if (mode == BilibiliPlaylistMode.pgcTimeline) {
      unawaited(_loadPgcTimeline());
    }
    if (mode == BilibiliPlaylistMode.pgcIndex) {
      unawaited(_loadPgcSeasons());
    }
    _reloadPreviewWhenReady();
  }

  List<Widget> _buildPgcTimelineControls() {
    return [
      const SizedBox(height: 12),
      DropdownButtonFormField<BilibiliPgcTimelineKind>(
        key: const Key('bilibili-pgc-timeline-kind'),
        initialValue: _timelineKind,
        decoration: InputDecoration(
          labelText: context.l10n.timeline,
          prefixIcon: const Icon(Icons.calendar_month_outlined),
        ),
        items: BilibiliPgcTimelineKind.values
            .map(
              (kind) => DropdownMenuItem(
                value: kind,
                child: Text(_timelineKindLabel(kind)),
              ),
            )
            .toList(),
        onChanged: _loading || _timelineLoading
            ? null
            : (value) {
                if (value == null) return;
                setState(() {
                  _timelineKind = value;
                  _timeline = null;
                  _preview = null;
                });
                unawaited(_loadPgcTimeline());
              },
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              key: const Key('bilibili-pgc-timeline-before'),
              initialValue: _timelineBeforeDays,
              decoration: InputDecoration(labelText: context.l10n.daysBefore),
              items: List.generate(
                8,
                (days) => DropdownMenuItem(value: days, child: Text('$days')),
              ),
              onChanged: _loading || _timelineLoading
                  ? null
                  : (value) {
                      if (value == null) return;
                      setState(() {
                        _timelineBeforeDays = value;
                        _timeline = null;
                        _preview = null;
                      });
                      unawaited(_loadPgcTimeline());
                    },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<int>(
              key: const Key('bilibili-pgc-timeline-after'),
              initialValue: _timelineAfterDays,
              decoration: InputDecoration(labelText: context.l10n.daysAfter),
              items: List.generate(
                8,
                (days) => DropdownMenuItem(value: days, child: Text('$days')),
              ),
              onChanged: _loading || _timelineLoading
                  ? null
                  : (value) {
                      if (value == null) return;
                      setState(() {
                        _timelineAfterDays = value;
                        _timeline = null;
                        _preview = null;
                      });
                      unawaited(_loadPgcTimeline());
                    },
            ),
          ),
        ],
      ),
      if (_timelineLoading) ...[
        const SizedBox(height: 12),
        const AppLoadingIndicator(size: AppLoadingSize.sm),
      ] else if (_timeline case final timeline?) ...[
        const SizedBox(height: 8),
        ...timeline.items.map(_pgcTimelineTile),
      ],
    ];
  }

  Widget _pgcTimelineTile(BilibiliPgcTimelineItemInfo item) {
    final status = item.delayed
        ? (item.delayReason.isEmpty ? context.l10n.delayed : item.delayReason)
        : item.published
        ? context.l10n.published
        : _publishTimeLabel(item);
    final episode = item.episodeTitle.isEmpty
        ? item.title
        : '${item.title} · ${item.episodeTitle}';
    final cover = item.episodeCover.isEmpty ? item.cover : item.episodeCover;
    return ListTile(
      key: ValueKey('bilibili-timeline-${item.episodeId}'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: cover.isEmpty
          ? const Icon(Icons.ondemand_video_outlined)
          : AppImageThumbnail(
              url: cover,
              width: 72,
              height: 44,
              borderRadius: BorderRadius.circular(4),
            ),
      title: Text(episode, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(status, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Icon(
        item.delayed
            ? Icons.schedule_outlined
            : item.published
            ? Icons.play_circle_outline
            : Icons.event_outlined,
      ),
    );
  }

  List<Widget> _buildPgcIndexControls() {
    return [
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<BilibiliPgcSeasonKind>(
              key: const Key('bilibili-pgc-index-kind'),
              initialValue: _pgcSeasonKind,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.l10n.category,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: BilibiliPgcSeasonKind.values
                  .map(
                    (kind) => DropdownMenuItem(
                      value: kind,
                      child: Text(_pgcSeasonKindLabel(kind)),
                    ),
                  )
                  .toList(),
              onChanged: _loading || _pgcSeasonsLoading
                  ? null
                  : (value) {
                      if (value == null) return;
                      _pgcSeasonKind = value;
                      unawaited(_loadPgcSeasons());
                    },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<BilibiliPgcSeasonOrder>(
              key: const Key('bilibili-pgc-index-order'),
              initialValue: _pgcSeasonOrder,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.l10n.sortOrder,
                prefixIcon: const Icon(Icons.sort),
              ),
              items: BilibiliPgcSeasonOrder.values
                  .map(
                    (order) => DropdownMenuItem(
                      value: order,
                      child: Text(_pgcSeasonOrderLabel(order)),
                    ),
                  )
                  .toList(),
              onChanged: _loading || _pgcSeasonsLoading
                  ? null
                  : (value) {
                      if (value == null) return;
                      _pgcSeasonOrder = value;
                      unawaited(_loadPgcSeasons());
                    },
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<bool?>(
              key: const Key('bilibili-pgc-index-finished'),
              initialValue: _pgcFinished,
              decoration: InputDecoration(labelText: context.l10n.statusLabel),
              items: [
                DropdownMenuItem(value: null, child: Text(context.l10n.all)),
                DropdownMenuItem(
                  value: false,
                  child: Text(context.l10n.ongoing),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Text(context.l10n.finished),
                ),
              ],
              onChanged: _loading || _pgcSeasonsLoading
                  ? null
                  : (value) {
                      _pgcFinished = value;
                      unawaited(_loadPgcSeasons());
                    },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SwitchListTile(
              key: const Key('bilibili-pgc-index-ascending'),
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.ascending),
              value: _pgcAscending,
              onChanged: _loading || _pgcSeasonsLoading
                  ? null
                  : (value) {
                      setState(() => _pgcAscending = value);
                      unawaited(_loadPgcSeasons());
                    },
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppTextField(
              key: const Key('bilibili-pgc-index-area'),
              controller: _pgcAreaController,
              enabled: !_loading && !_pgcSeasonsLoading,
              label: context.l10n.area,
              prefixIcon: Icons.public,
              onChanged: (_) {
                _preview = null;
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppTextField(
              key: const Key('bilibili-pgc-index-year'),
              controller: _pgcYearController,
              enabled: !_loading && !_pgcSeasonsLoading,
              label: context.l10n.yearOrRange,
              prefixIcon: Icons.date_range_outlined,
              onChanged: (_) {
                _preview = null;
                setState(() {});
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppTextField(
              key: const Key('bilibili-pgc-index-style'),
              controller: _pgcStyleController,
              enabled: !_loading && !_pgcSeasonsLoading,
              label: context.l10n.styleId,
              prefixIcon: Icons.style_outlined,
              keyboardType: TextInputType.number,
              onChanged: (_) {
                _preview = null;
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              key: const Key('bilibili-pgc-index-search'),
              onPressed: _loading || _pgcSeasonsLoading
                  ? null
                  : () => _loadPgcSeasons(),
              icon: const Icon(Icons.search),
              label: Text(context.l10n.search),
            ),
          ),
        ],
      ),
      if (_pgcSeasonsLoading && _pgcSeasons.isEmpty) ...[
        const SizedBox(height: 12),
        const AppLoadingIndicator(size: AppLoadingSize.sm),
      ] else ...[
        const SizedBox(height: 8),
        ..._pgcSeasons.map(_pgcSeasonTile),
        AppPaginationBar.page(
          key: const Key('bilibili-pgc-index-pagination'),
          context: context,
          page: _pgcSeasonPage,
          pageSize: 30,
          total: _pgcSeasonTotal,
          onPrevious: _pgcSeasonsLoading || _pgcSeasonPage <= 1
              ? null
              : () => _loadPgcSeasons(page: _pgcSeasonPage - 1),
          onNext: _pgcSeasonsLoading || !_pgcSeasonsHasMore
              ? null
              : () => _loadPgcSeasons(page: _pgcSeasonPage + 1),
        ),
      ],
    ];
  }

  Widget _pgcSeasonTile(BilibiliPgcSeasonInfo season) {
    final selected = season.seasonId == _selectedPgcSeasonId;
    final details = [
      if (season.badge.isNotEmpty) season.badge,
      if (season.progress.isNotEmpty) season.progress,
      if (season.score.isNotEmpty) '${context.l10n.score} ${season.score}',
      season.finished ? context.l10n.finished : context.l10n.ongoing,
    ].join(' · ');
    return ListTile(
      key: ValueKey('bilibili-pgc-season-${season.seasonId}'),
      selected: selected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      onTap: _loading
          ? null
          : () {
              setState(() {
                _selectedPgcSeasonId = season.seasonId;
                _preview = null;
              });
            },
      leading: season.cover.isEmpty
          ? const Icon(Icons.video_library_outlined)
          : AppImageThumbnail(
              url: season.cover,
              width: 56,
              height: 72,
              borderRadius: BorderRadius.circular(4),
            ),
      title: Text(season.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(details, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Icon(
        selected ? Icons.check_circle : Icons.radio_button_unchecked,
      ),
    );
  }

  bool get _isInstantPreviewMode => switch (_mode) {
    BilibiliPlaylistMode.popular ||
    BilibiliPlaylistMode.recommended ||
    BilibiliPlaylistMode.watchLater ||
    BilibiliPlaylistMode.liveRecommended ||
    BilibiliPlaylistMode.liveFollowed ||
    BilibiliPlaylistMode.history => true,
    _ => false,
  };

  bool get _shouldShowBrowser =>
      _isInstantPreviewMode || _preview != null || _browsePath.isNotEmpty;

  void _reloadPreviewWhenReady() {
    if (_isInstantPreviewMode && _valid) unawaited(_loadPreview());
  }

  void _changeAccount(BilibiliBindInfo? bind) {
    _selectedBindId = bind?.id ?? '';
    _instanceName = bind?.providerInstanceName ?? '';
    _changed();
    if (_mode == BilibiliPlaylistMode.liveArea) {
      unawaited(_loadLiveAreas());
    }
    if (_mode == BilibiliPlaylistMode.favoriteVideos) {
      unawaited(_loadFavoriteFolders());
    }
    if (_mode == BilibiliPlaylistMode.followedAnime ||
        _mode == BilibiliPlaylistMode.followedCinema) {
      unawaited(_loadFollowedPgc());
    }
    if (_mode == BilibiliPlaylistMode.pgcTimeline) {
      unawaited(_loadPgcTimeline());
    }
    if (_mode == BilibiliPlaylistMode.pgcIndex) {
      unawaited(_loadPgcSeasons());
    }
    _reloadPreviewWhenReady();
  }

  bool get _valid {
    int positive(String value) => int.tryParse(value.trim()) ?? 0;
    return switch (_mode) {
      BilibiliPlaylistMode.videoParts =>
        _primaryController.text.trim().isNotEmpty,
      BilibiliPlaylistMode.popular ||
      BilibiliPlaylistMode.recommended ||
      BilibiliPlaylistMode.watchLater ||
      BilibiliPlaylistMode.liveRecommended ||
      BilibiliPlaylistMode.liveFollowed ||
      BilibiliPlaylistMode.history ||
      BilibiliPlaylistMode.pgcTimeline => true,
      BilibiliPlaylistMode.upVideos ||
      BilibiliPlaylistMode.pgcSeason => positive(_primaryController.text) > 0,
      BilibiliPlaylistMode.favoriteVideos => (_favoriteMediaId ?? 0) > 0,
      BilibiliPlaylistMode.collectionVideos ||
      BilibiliPlaylistMode.seriesVideos =>
        positive(_primaryController.text) > 0 &&
            positive(_secondaryController.text) > 0,
      BilibiliPlaylistMode.liveArea =>
        (_parentAreaId ?? 0) > 0 && (_areaId ?? 0) > 0,
      BilibiliPlaylistMode.followedAnime ||
      BilibiliPlaylistMode.followedCinema => (_followedSeasonId ?? 0) > 0,
      BilibiliPlaylistMode.pgcIndex => (_selectedPgcSeasonId ?? 0) > 0,
    };
  }

  bool get _previewReady => _preview != null;

  String? get _primaryLabel => switch (_mode) {
    BilibiliPlaylistMode.videoParts => context.l10n.videoBvid,
    BilibiliPlaylistMode.upVideos => context.l10n.creatorMid,
    BilibiliPlaylistMode.collectionVideos ||
    BilibiliPlaylistMode.seriesVideos => context.l10n.creatorMid,
    BilibiliPlaylistMode.pgcSeason => context.l10n.seasonId,
    _ => null,
  };

  String? get _secondaryLabel => switch (_mode) {
    BilibiliPlaylistMode.videoParts => context.l10n.videoAidOptional,
    BilibiliPlaylistMode.collectionVideos => context.l10n.collectionSeasonId,
    BilibiliPlaylistMode.seriesVideos => context.l10n.seriesId,
    _ => null,
  };

  BilibiliPlaylistListIntent get _rootIntent {
    final primary = int.tryParse(_primaryController.text.trim()) ?? 0;
    final secondary = int.tryParse(_secondaryController.text.trim()) ?? 0;
    return switch (_mode) {
      BilibiliPlaylistMode.videoParts => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.videoParts,
        bvid: _primaryController.text.trim(),
        aid: secondary > 0 ? secondary : null,
      ),
      BilibiliPlaylistMode.popular => const BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.popular,
      ),
      BilibiliPlaylistMode.recommended => const BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.recommended,
      ),
      BilibiliPlaylistMode.upVideos => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.upVideos,
        mid: primary,
        keyword: _keywordController.text.trim(),
      ),
      BilibiliPlaylistMode.favoriteVideos => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.favoriteVideos,
        mediaId: _favoriteMediaId ?? 0,
      ),
      BilibiliPlaylistMode.collectionVideos => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.collectionVideos,
        mid: primary,
        seasonId: secondary,
      ),
      BilibiliPlaylistMode.seriesVideos => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.seriesVideos,
        mid: primary,
        seriesId: secondary,
      ),
      BilibiliPlaylistMode.watchLater => const BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.watchLater,
      ),
      BilibiliPlaylistMode.pgcSeason => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.pgcSeason,
        seasonId: primary,
      ),
      BilibiliPlaylistMode.liveRecommended => const BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.liveRecommended,
      ),
      BilibiliPlaylistMode.liveFollowed => const BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.liveFollowed,
      ),
      BilibiliPlaylistMode.liveArea => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.liveArea,
        parentAreaId: _parentAreaId ?? 0,
        areaId: _areaId ?? 0,
      ),
      BilibiliPlaylistMode.history => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.history,
        historyType: switch (_historyFilter) {
          BilibiliHistoryFilter.all => BilibiliPlaylistHistoryType.all,
          BilibiliHistoryFilter.archive => BilibiliPlaylistHistoryType.archive,
          BilibiliHistoryFilter.live => BilibiliPlaylistHistoryType.live,
        },
      ),
      BilibiliPlaylistMode.pgcTimeline => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.pgcTimeline,
        timelineType: _timelineKind,
        beforeDays: _timelineBeforeDays,
        afterDays: _timelineAfterDays,
      ),
      BilibiliPlaylistMode.pgcIndex => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.pgcSeason,
        seasonId: _selectedPgcSeasonId ?? 0,
      ),
      BilibiliPlaylistMode.followedAnime ||
      BilibiliPlaylistMode.followedCinema => BilibiliPlaylistListIntent(
        mode: BilibiliPlaylistListMode.pgcSeason,
        seasonId: _followedSeasonId ?? 0,
      ),
    };
  }

  BilibiliPlaylistListIntent get _currentIntent =>
      _browsePath.lastOrNull?.intent ?? _rootIntent;

  Future<void> _loadPreview({bool loadMore = false, int? page}) async {
    if (_loading && loadMore) return;
    final requestVersion = ++_previewRequestVersion;
    final current = _preview;
    final intent = _currentIntent;
    final instanceName = _instanceName;
    final shared = _shared;
    setState(() => _loading = true);
    try {
      final targetPage = page ?? (loadMore ? (current?.page ?? 1) + 1 : 1);
      final cursor = _previewUsesCursor && loadMore ? current?.cursor : null;
      final preview = switch (widget.loader) {
        final loader? => await loader(
          intent,
          targetPage,
          30,
          cursor,
          instanceName,
          shared,
        ),
        null => await providerGateway.listBilibiliPlaylist(
          intent,
          page: targetPage,
          pageSize: 30,
          cursor: cursor,
          instanceName: instanceName,
          shared: shared,
        ),
      };
      if (!mounted || requestVersion != _previewRequestVersion) return;
      setState(() {
        _preview = _previewUsesCursor && loadMore && current != null
            ? BilibiliPlaylistListPage(
                items: [...current.items, ...preview.items],
                hasMore: preview.hasMore,
                page: preview.page,
                cursor: preview.cursor,
                source: preview.source,
              )
            : preview;
      });
    } catch (error) {
      if (mounted && requestVersion == _previewRequestVersion) {
        AppNotifications.showError(context, '$error');
      }
    } finally {
      if (mounted && requestVersion == _previewRequestVersion) {
        setState(() => _loading = false);
      }
    }
  }

  List<MapEntry<int, String>> get _parentAreas {
    final parents = <int, String>{};
    for (final area in _liveAreas) {
      parents[area.parentId] = area.parentName;
    }
    final entries = parents.entries.toList();
    entries.sort((left, right) => left.value.compareTo(right.value));
    return entries;
  }

  List<BilibiliLiveAreaInfo> _childrenFor(int? parentId) {
    final children = _liveAreas
        .where((area) => area.parentId == parentId)
        .toList();
    children.sort((left, right) {
      final hot = right.hot.toString().compareTo(left.hot.toString());
      return hot != 0 ? hot : left.name.compareTo(right.name);
    });
    return children;
  }

  Future<void> _loadLiveAreas() async {
    setState(() => _areasLoading = true);
    try {
      final areas = switch (widget.onLoadLiveAreas) {
        final callback? => await callback(_instanceName),
        null => await providerGateway.listBilibiliLiveAreas(
          instanceName: _instanceName,
          shared: _shared,
        ),
      };
      if (!mounted) return;
      setState(() {
        _liveAreas = areas;
        final parentIds = areas.map((area) => area.parentId).toSet();
        if (!parentIds.contains(_parentAreaId)) {
          _parentAreaId = _parentAreas.firstOrNull?.key;
        }
        final children = _childrenFor(_parentAreaId);
        if (!children.any((area) => area.id == _areaId)) {
          _areaId = children.firstOrNull?.id;
        }
        _preview = null;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _areasLoading = false);
    }
  }

  Future<void> _loadFavoriteFolders() async {
    setState(() => _favoritesLoading = true);
    try {
      final folders = switch (widget.onLoadFavoriteFolders) {
        final callback? => await callback(_instanceName),
        null => await providerGateway.listBilibiliFavoriteFolders(
          instanceName: _instanceName,
          shared: _shared,
        ),
      };
      if (!mounted) return;
      setState(() {
        _favoriteFolders = folders;
        if (!folders.any((folder) => folder.mediaId == _favoriteMediaId)) {
          _favoriteMediaId = folders.firstOrNull?.mediaId;
        }
        _preview = null;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _favoritesLoading = false);
    }
  }

  Future<void> _loadFollowedPgc({int page = 1}) async {
    if (_followedPgcLoading) return;
    setState(() => _followedPgcLoading = true);
    try {
      final cinema = _mode == BilibiliPlaylistMode.followedCinema;
      final result = switch (widget.onLoadFollowedPgc) {
        final callback? => await callback(cinema, page, _instanceName),
        null => await providerGateway.listBilibiliFollowedPgc(
          cinema: cinema,
          page: page,
          instanceName: _instanceName,
          shared: _shared,
        ),
      };
      if (!mounted) return;
      setState(() {
        _followedPgc = result.items;
        _followedPgcPage = page;
        _followedPgcTotal = result.total;
        _followedPgcHasMore = result.hasMore;
        if (!_followedPgc.any(
          (season) => season.seasonId == _followedSeasonId,
        )) {
          _followedSeasonId = _followedPgc.firstOrNull?.seasonId;
        }
        _preview = null;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _followedPgcLoading = false);
    }
  }

  Future<void> _loadPgcTimeline() async {
    if (_timelineLoading) return;
    setState(() => _timelineLoading = true);
    try {
      final timeline = switch (widget.onLoadPgcTimeline) {
        final callback? => await callback(
          _timelineKind,
          _timelineBeforeDays,
          _timelineAfterDays,
          _instanceName,
        ),
        null => await providerGateway.listBilibiliPgcTimeline(
          type: _timelineKind,
          beforeDays: _timelineBeforeDays,
          afterDays: _timelineAfterDays,
          instanceName: _instanceName,
          shared: _shared,
        ),
      };
      if (!mounted) return;
      setState(() {
        _timeline = timeline;
        _preview = null;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _timelineLoading = false);
    }
  }

  Future<void> _loadPgcSeasons({int page = 1}) async {
    if (_pgcSeasonsLoading) return;
    setState(() => _pgcSeasonsLoading = true);
    try {
      final area = _pgcAreaController.text.trim();
      final year = _pgcYearController.text.trim();
      final styleId = int.tryParse(_pgcStyleController.text.trim());
      final result = switch (widget.onLoadPgcSeasons) {
        final callback? => await callback(
          _pgcSeasonKind,
          page,
          _pgcSeasonOrder,
          _pgcAscending,
          _pgcFinished,
          area.isEmpty ? null : area,
          year.isEmpty ? null : year,
          styleId != null && styleId > 0 ? styleId : null,
          _instanceName,
        ),
        null => await providerGateway.listBilibiliPgcSeasons(
          type: _pgcSeasonKind,
          page: page,
          order: _pgcSeasonOrder,
          ascending: _pgcAscending,
          finished: _pgcFinished,
          area: area.isEmpty ? null : area,
          year: year.isEmpty ? null : year,
          styleId: styleId != null && styleId > 0 ? styleId : null,
          instanceName: _instanceName,
          shared: _shared,
        ),
      };
      if (!mounted) return;
      setState(() {
        _pgcSeasons = result.items;
        _pgcSeasonPage = page;
        _pgcSeasonTotal = result.total;
        _pgcSeasonsHasMore = result.hasMore;
        if (!_pgcSeasons.any(
          (season) => season.seasonId == _selectedPgcSeasonId,
        )) {
          _selectedPgcSeasonId = _pgcSeasons.firstOrNull?.seasonId;
        }
        _preview = null;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _pgcSeasonsLoading = false);
    }
  }

  String _publishTimeLabel(BilibiliPgcTimelineItemInfo item) {
    if (item.publishAt <= 0) return item.date;
    final time = DateTime.fromMillisecondsSinceEpoch(
      item.publishAt * 1000,
      isUtc: true,
    ).toLocal();
    final month = time.month.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '${time.year}-$month-$day $hour:$minute';
  }

  void _openBrowse(BilibiliPlaylistListItemInfo item) {
    final browse = item.browse;
    if (browse == null) return;
    setState(() {
      _browsePath.add(
        _BilibiliBrowseLocation(intent: browse, title: item.title),
      );
      _preview = null;
      _selection.clear();
    });
    _loadPreview();
  }

  void _goBack() {
    setState(() {
      _browsePath.removeLast();
      _preview = null;
      _selection.clear();
    });
    _loadPreview();
  }

  Future<void> _addSelected(List<DiscoveryBrowserEntry> entries) =>
      _runAdd(() async {
        for (final entry in entries) {
          await providerGateway.addDiscoveredSource(
            widget.roomId,
            playlistId: widget.parentId,
            source: entry.source.withPlaybackProxyMode(widget.proxyMode),
            name: entry.title,
          );
        }
      });

  Future<void> _create() => _runAdd(() async {
    final preview = _preview!;
    final defaultName = _browsePath.lastOrNull?.title ?? _modeLabel(_mode);
    final name = _nameController.text.trim().isEmpty
        ? defaultName
        : _nameController.text.trim();
    await providerGateway.addDiscoveredSource(
      widget.roomId,
      playlistId: widget.parentId,
      source: preview.source.withPlaybackProxyMode(widget.proxyMode),
      name: name,
    );
  });

  Future<void> _runAdd(Future<void> Function() action) async {
    setState(() => _loading = true);
    try {
      await action();
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _modeLabel(BilibiliPlaylistMode mode) => switch (mode) {
    BilibiliPlaylistMode.videoParts => context.l10n.videoParts,
    BilibiliPlaylistMode.popular => context.l10n.popular,
    BilibiliPlaylistMode.recommended => context.l10n.recommended,
    BilibiliPlaylistMode.upVideos => context.l10n.creatorVideos,
    BilibiliPlaylistMode.favoriteVideos => context.l10n.favoriteVideos,
    BilibiliPlaylistMode.collectionVideos => context.l10n.collectionVideos,
    BilibiliPlaylistMode.seriesVideos => context.l10n.seriesVideos,
    BilibiliPlaylistMode.watchLater => context.l10n.watchLater,
    BilibiliPlaylistMode.pgcSeason => context.l10n.pgcSeason,
    BilibiliPlaylistMode.liveRecommended => context.l10n.liveRecommended,
    BilibiliPlaylistMode.liveFollowed => context.l10n.liveFollowed,
    BilibiliPlaylistMode.liveArea => context.l10n.liveArea,
    BilibiliPlaylistMode.history => context.l10n.history,
    BilibiliPlaylistMode.pgcTimeline => context.l10n.pgcTimeline,
    BilibiliPlaylistMode.pgcIndex => context.l10n.pgcIndex,
    BilibiliPlaylistMode.followedAnime => context.l10n.followedAnime,
    BilibiliPlaylistMode.followedCinema => context.l10n.followedCinema,
  };

  String _timelineKindLabel(BilibiliPgcTimelineKind kind) => switch (kind) {
    BilibiliPgcTimelineKind.anime => context.l10n.anime,
    BilibiliPgcTimelineKind.cinema => context.l10n.cinema,
    BilibiliPgcTimelineKind.guochuang => context.l10n.guochuang,
  };

  String _pgcSeasonKindLabel(BilibiliPgcSeasonKind kind) => switch (kind) {
    BilibiliPgcSeasonKind.anime => context.l10n.anime,
    BilibiliPgcSeasonKind.movie => context.l10n.movie,
    BilibiliPgcSeasonKind.documentary => context.l10n.documentary,
    BilibiliPgcSeasonKind.guochuang => context.l10n.guochuang,
    BilibiliPgcSeasonKind.tv => context.l10n.television,
    BilibiliPgcSeasonKind.variety => context.l10n.variety,
  };

  String _pgcSeasonOrderLabel(BilibiliPgcSeasonOrder order) => switch (order) {
    BilibiliPgcSeasonOrder.updated => context.l10n.updated,
    BilibiliPgcSeasonOrder.danmaku => context.l10n.danmaku,
    BilibiliPgcSeasonOrder.play => context.l10n.plays,
    BilibiliPgcSeasonOrder.follow => context.l10n.followers,
    BilibiliPgcSeasonOrder.score => context.l10n.score,
    BilibiliPgcSeasonOrder.started => context.l10n.started,
    BilibiliPgcSeasonOrder.released => context.l10n.released,
  };
}
