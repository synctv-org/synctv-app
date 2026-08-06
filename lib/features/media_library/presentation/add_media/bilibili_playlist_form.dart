import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

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

typedef BilibiliPgcTimelineLoader =
    Future<BilibiliPgcTimelineInfo> Function(
      BilibiliPgcTimelineKind type,
      int beforeDays,
      int afterDays,
      String instanceName,
    );

typedef BilibiliPgcSeasonLoader =
    Future<BilibiliPgcSeasonPage> Function(
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

class BilibiliPlaylistForm extends StatefulWidget {
  const BilibiliPlaylistForm({
    super.key,
    required this.roomId,
    required this.parentId,
    required this.binds,
    required this.onDraftChanged,
    this.onLoadLiveAreas,
    this.onLoadFavoriteFolders,
    this.onLoadFollowedPgc,
    this.onLoadPgcTimeline,
    this.onLoadPgcSeasons,
    this.onPreview,
    this.onCreate,
  });

  final String roomId;
  final String parentId;
  final List<BilibiliBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
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
  final Future<RoomMediaLibraryPage> Function(
    Map<String, dynamic> sourceConfig,
    String instanceName,
  )?
  onPreview;
  final Future<void> Function(
    String name,
    Map<String, dynamic> sourceConfig,
    String instanceName,
  )?
  onCreate;

  @override
  State<BilibiliPlaylistForm> createState() => _BilibiliPlaylistFormState();
}

class _BilibiliPlaylistFormState extends State<BilibiliPlaylistForm> {
  final _nameController = TextEditingController();
  final _primaryController = TextEditingController();
  final _secondaryController = TextEditingController();
  final _keywordController = TextEditingController();
  final _pgcAreaController = TextEditingController();
  final _pgcYearController = TextEditingController();
  final _pgcStyleController = TextEditingController();
  BilibiliPlaylistMode _mode = BilibiliPlaylistMode.popular;
  String _instanceName = '';
  bool _shared = false;
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
  int _followedPgcPage = 0;
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
  int _pgcSeasonPage = 0;
  bool _pgcSeasonsHasMore = false;
  RoomMediaLibraryPage? _preview;

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
    _preview = null;
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
    final instances = {
      '',
      ...widget.binds.map((bind) => bind.providerInstanceName),
    }.toList();
    if (!instances.contains(_instanceName)) _instanceName = '';
    final items = _preview?.dynamicItems ?? const <RoomDynamicMediaEntry>[];
    return AppSingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<BilibiliPlaylistMode>(
            key: const Key('bilibili-playlist-mode'),
            initialValue: _mode,
            decoration: const InputDecoration(
              labelText: 'Source',
              prefixIcon: Icon(Icons.video_collection_outlined),
            ),
            items: BilibiliPlaylistMode.values
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode,
                    child: Text(_modeLabel(mode)),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (mode) {
                    if (mode == null) return;
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
                      unawaited(_loadFollowedPgc(reset: true));
                    }
                    if (mode == BilibiliPlaylistMode.pgcTimeline) {
                      unawaited(_loadPgcTimeline());
                    }
                    if (mode == BilibiliPlaylistMode.pgcIndex) {
                      unawaited(_loadPgcSeasons(reset: true));
                    }
                  },
          ),
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
              label: 'Keyword',
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
                decoration: const InputDecoration(
                  labelText: 'Live category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _parentAreas
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                decoration: const InputDecoration(
                  labelText: 'Live subcategory',
                  prefixIcon: Icon(Icons.live_tv_outlined),
                ),
                items: _childrenFor(_parentAreaId)
                    .map(
                      (area) => DropdownMenuItem(
                        value: area.id,
                        child: Text(
                          area.hot ? '${area.name} · Hot' : area.name,
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
              segments: const [
                ButtonSegment(
                  value: BilibiliHistoryFilter.all,
                  label: Text('All'),
                ),
                ButtonSegment(
                  value: BilibiliHistoryFilter.archive,
                  label: Text('Videos'),
                ),
                ButtonSegment(
                  value: BilibiliHistoryFilter.live,
                  label: Text('Live'),
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
          if (_mode == BilibiliPlaylistMode.pgcIndex)
            ..._buildPgcIndexControls(),
          if (_mode == BilibiliPlaylistMode.favoriteVideos) ...[
            const SizedBox(height: 12),
            if (_favoritesLoading)
              const AppLoadingIndicator(size: AppLoadingSize.sm)
            else
              DropdownButtonFormField<int>(
                key: const Key('bilibili-favorite-folder'),
                initialValue: _favoriteMediaId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Favorite folder',
                  prefixIcon: Icon(Icons.favorite_outline),
                ),
                items: _favoriteFolders
                    .map(
                      (folder) => DropdownMenuItem(
                        value: folder.mediaId,
                        child: Text(
                          '${folder.title} (${folder.mediaCount})'
                          '${folder.isPrivate ? ' · Private' : ''}',
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
                      ? 'Followed cinema'
                      : 'Followed anime',
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
              if (_followedPgcHasMore)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    key: const Key('bilibili-followed-load-more'),
                    onPressed: _followedPgcLoading
                        ? null
                        : () => _loadFollowedPgc(reset: false),
                    icon: _followedPgcLoading
                        ? const SizedBox.square(
                            dimension: 16,
                            child: AppLoadingIndicator(
                              size: AppLoadingSize.sm,
                              centered: false,
                            ),
                          )
                        : const Icon(Icons.expand_more),
                    label: const Text('Load more'),
                  ),
                ),
            ],
          ],
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('bilibili-playlist-name'),
            controller: _nameController,
            enabled: !_loading,
            label: 'Playlist name',
            prefixIcon: Icons.title,
            onChanged: (_) => _nameChanged(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _instanceName,
            decoration: const InputDecoration(
              labelText: 'Provider instance',
              prefixIcon: Icon(Icons.dns_outlined),
            ),
            items: instances
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.isEmpty ? 'Default' : value),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (value) {
                    _instanceName = value ?? '';
                    _changed();
                    if (_mode == BilibiliPlaylistMode.liveArea) {
                      unawaited(_loadLiveAreas());
                    }
                    if (_mode == BilibiliPlaylistMode.favoriteVideos) {
                      unawaited(_loadFavoriteFolders());
                    }
                    if (_mode == BilibiliPlaylistMode.followedAnime ||
                        _mode == BilibiliPlaylistMode.followedCinema) {
                      unawaited(_loadFollowedPgc(reset: true));
                    }
                    if (_mode == BilibiliPlaylistMode.pgcTimeline) {
                      unawaited(_loadPgcTimeline());
                    }
                    if (_mode == BilibiliPlaylistMode.pgcIndex) {
                      unawaited(_loadPgcSeasons(reset: true));
                    }
                  },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use room owner credential'),
            value: _shared,
            onChanged: _loading
                ? null
                : (value) {
                    _shared = value;
                    _changed();
                  },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                key: const Key('bilibili-playlist-preview'),
                onPressed: _loading || !_valid ? null : _loadPreview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                key: const Key('bilibili-playlist-create'),
                onPressed: _loading || !_valid || !_previewReady
                    ? null
                    : _create,
                icon: _loading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: AppLoadingIndicator(
                          size: AppLoadingSize.sm,
                          centered: false,
                        ),
                      )
                    : const Icon(Icons.playlist_add),
                label: const Text('Create'),
              ),
            ],
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...items.map(_previewTile),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildPgcTimelineControls() {
    return [
      const SizedBox(height: 12),
      DropdownButtonFormField<BilibiliPgcTimelineKind>(
        key: const Key('bilibili-pgc-timeline-kind'),
        initialValue: _timelineKind,
        decoration: const InputDecoration(
          labelText: 'Timeline',
          prefixIcon: Icon(Icons.calendar_month_outlined),
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
              decoration: const InputDecoration(labelText: 'Days before'),
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
              decoration: const InputDecoration(labelText: 'Days after'),
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
        ? (item.delayReason.isEmpty ? 'Delayed' : item.delayReason)
        : item.published
        ? 'Published'
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
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
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
                      unawaited(_loadPgcSeasons(reset: true));
                    },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<BilibiliPgcSeasonOrder>(
              key: const Key('bilibili-pgc-index-order'),
              initialValue: _pgcSeasonOrder,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Order',
                prefixIcon: Icon(Icons.sort),
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
                      unawaited(_loadPgcSeasons(reset: true));
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
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: false, child: Text('Ongoing')),
                DropdownMenuItem(value: true, child: Text('Finished')),
              ],
              onChanged: _loading || _pgcSeasonsLoading
                  ? null
                  : (value) {
                      _pgcFinished = value;
                      unawaited(_loadPgcSeasons(reset: true));
                    },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SwitchListTile(
              key: const Key('bilibili-pgc-index-ascending'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Ascending'),
              value: _pgcAscending,
              onChanged: _loading || _pgcSeasonsLoading
                  ? null
                  : (value) {
                      setState(() => _pgcAscending = value);
                      unawaited(_loadPgcSeasons(reset: true));
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
              label: 'Area',
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
              label: 'Year or range',
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
              label: 'Style ID',
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
                  : () => _loadPgcSeasons(reset: true),
              icon: const Icon(Icons.search),
              label: const Text('Search'),
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
        if (_pgcSeasonsHasMore)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              key: const Key('bilibili-pgc-index-load-more'),
              onPressed: _pgcSeasonsLoading
                  ? null
                  : () => _loadPgcSeasons(reset: false),
              icon: _pgcSeasonsLoading
                  ? const SizedBox.square(
                      dimension: 16,
                      child: AppLoadingIndicator(
                        size: AppLoadingSize.sm,
                        centered: false,
                      ),
                    )
                  : const Icon(Icons.expand_more),
              label: const Text('Load more'),
            ),
          ),
      ],
    ];
  }

  Widget _pgcSeasonTile(BilibiliPgcSeasonInfo season) {
    final selected = season.seasonId == _selectedPgcSeasonId;
    final details = [
      if (season.badge.isNotEmpty) season.badge,
      if (season.progress.isNotEmpty) season.progress,
      if (season.score.isNotEmpty) 'Score ${season.score}',
      season.finished ? 'Finished' : 'Ongoing',
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

  Widget _previewTile(RoomDynamicMediaEntry item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: item.coverUrl.isEmpty
          ? Icon(
              item.isPlaylist
                  ? Icons.video_library_outlined
                  : Icons.play_circle_outline,
            )
          : AppImageThumbnail(
              url: item.coverUrl,
              width: 72,
              height: 44,
              borderRadius: BorderRadius.circular(4),
            ),
      title: Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: item.isPlaylist
          ? const Icon(Icons.chevron_right)
          : const Icon(Icons.play_arrow),
    );
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

  bool get _previewReady => switch (_mode) {
    BilibiliPlaylistMode.pgcTimeline => _timeline != null,
    _ => _preview != null,
  };

  String? get _primaryLabel => switch (_mode) {
    BilibiliPlaylistMode.videoParts => 'Video BVID',
    BilibiliPlaylistMode.upVideos => 'UP mid',
    BilibiliPlaylistMode.collectionVideos ||
    BilibiliPlaylistMode.seriesVideos => 'UP mid',
    BilibiliPlaylistMode.pgcSeason => 'Season ID',
    _ => null,
  };

  String? get _secondaryLabel => switch (_mode) {
    BilibiliPlaylistMode.videoParts => 'Video AID (optional)',
    BilibiliPlaylistMode.collectionVideos => 'Collection season ID',
    BilibiliPlaylistMode.seriesVideos => 'Series ID',
    _ => null,
  };

  Map<String, dynamic> get _sourceConfig {
    final discovered = _discoveredSourceConfig;
    if (discovered != null) return discovered;
    final primary = int.tryParse(_primaryController.text.trim()) ?? 0;
    final secondary = int.tryParse(_secondaryController.text.trim()) ?? 0;
    final source = switch (_mode) {
      BilibiliPlaylistMode.videoParts => <String, dynamic>{
        'type': 'videoParts',
        'bvid': _primaryController.text.trim(),
        if (secondary > 0) 'aid': secondary,
      },
      BilibiliPlaylistMode.popular => <String, dynamic>{'type': 'popular'},
      BilibiliPlaylistMode.recommended => <String, dynamic>{
        'type': 'recommended',
      },
      BilibiliPlaylistMode.upVideos => <String, dynamic>{
        'type': 'upVideos',
        'mid': primary,
        if (_keywordController.text.trim().isNotEmpty)
          'keyword': _keywordController.text.trim(),
      },
      BilibiliPlaylistMode.favoriteVideos => <String, dynamic>{
        'type': 'favoriteVideos',
        'mediaId': _favoriteMediaId,
      },
      BilibiliPlaylistMode.collectionVideos => <String, dynamic>{
        'type': 'collectionVideos',
        'mid': primary,
        'seasonId': secondary,
      },
      BilibiliPlaylistMode.seriesVideos => <String, dynamic>{
        'type': 'seriesVideos',
        'mid': primary,
        'seriesId': secondary,
      },
      BilibiliPlaylistMode.watchLater => <String, dynamic>{
        'type': 'watchLater',
      },
      BilibiliPlaylistMode.pgcSeason => <String, dynamic>{
        'type': 'pgcSeason',
        'seasonId': primary,
      },
      BilibiliPlaylistMode.liveRecommended => <String, dynamic>{
        'type': 'liveRecommended',
      },
      BilibiliPlaylistMode.liveFollowed => <String, dynamic>{
        'type': 'liveFollowed',
      },
      BilibiliPlaylistMode.liveArea => <String, dynamic>{
        'type': 'liveArea',
        'parentAreaId': _parentAreaId,
        'areaId': _areaId,
      },
      BilibiliPlaylistMode.history => <String, dynamic>{
        'type': 'history',
        'historyType': switch (_historyFilter) {
          BilibiliHistoryFilter.all => 'all',
          BilibiliHistoryFilter.archive => 'archive',
          BilibiliHistoryFilter.live => 'live',
        },
      },
      BilibiliPlaylistMode.pgcTimeline => <String, dynamic>{
        'type': 'pgcTimeline',
        'timelineType': _timelineKind.name,
        'beforeDays': _timelineBeforeDays,
        'afterDays': _timelineAfterDays,
      },
      BilibiliPlaylistMode.pgcIndex => <String, dynamic>{},
      BilibiliPlaylistMode.followedAnime ||
      BilibiliPlaylistMode.followedCinema => <String, dynamic>{
        'type': 'pgcSeason',
        'seasonId': _followedSeasonId,
      },
    };
    return {'source': source, if (_shared) 'shared': true};
  }

  Map<String, dynamic>? get _discoveredSourceConfig {
    final config = switch (_mode) {
      BilibiliPlaylistMode.favoriteVideos =>
        _favoriteFolders
            .where((folder) => folder.mediaId == _favoriteMediaId)
            .firstOrNull
            ?.sourceConfig,
      BilibiliPlaylistMode.followedAnime ||
      BilibiliPlaylistMode.followedCinema =>
        _followedPgc
            .where((season) => season.seasonId == _followedSeasonId)
            .firstOrNull
            ?.sourceConfig,
      BilibiliPlaylistMode.pgcTimeline => _timeline?.sourceConfig,
      BilibiliPlaylistMode.pgcIndex =>
        _pgcSeasons
            .where((season) => season.seasonId == _selectedPgcSeasonId)
            .firstOrNull
            ?.sourceConfig,
      _ => null,
    };
    if (config == null) return null;
    final value = SourceConfigCodec.playlistSourceConfigToMap(config);
    value.remove('shared');
    if (_shared) value['shared'] = true;
    return value;
  }

  Future<void> _loadPreview() async {
    if (_mode == BilibiliPlaylistMode.pgcTimeline) {
      await _loadPgcTimeline();
      return;
    }
    setState(() => _loading = true);
    try {
      final preview = switch (widget.onPreview) {
        final callback? => await callback(_sourceConfig, _instanceName),
        null => await providerGateway.listMediaLibrary(
          widget.roomId,
          pageSize: 12,
          sourceProvider: 'bilibili',
          previewSourceConfig: _sourceConfig,
          providerInstanceName: _instanceName,
        ),
      };
      if (!mounted) return;
      setState(() => _preview = preview);
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
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

  Future<void> _loadFollowedPgc({required bool reset}) async {
    if (_followedPgcLoading) return;
    setState(() => _followedPgcLoading = true);
    try {
      final page = reset ? 1 : _followedPgcPage + 1;
      final cinema = _mode == BilibiliPlaylistMode.followedCinema;
      final result = switch (widget.onLoadFollowedPgc) {
        final callback? => await callback(cinema, page, _instanceName),
        null => await providerGateway.listBilibiliFollowedPgc(
          cinema: cinema,
          page: page,
          instanceName: _instanceName,
        ),
      };
      if (!mounted) return;
      setState(() {
        _followedPgc = reset
            ? result.items
            : [..._followedPgc, ...result.items];
        _followedPgcPage = page;
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

  Future<void> _loadPgcSeasons({required bool reset}) async {
    if (_pgcSeasonsLoading) return;
    setState(() => _pgcSeasonsLoading = true);
    try {
      final page = reset ? 1 : _pgcSeasonPage + 1;
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
        ),
      };
      if (!mounted) return;
      setState(() {
        _pgcSeasons = reset ? result.items : [..._pgcSeasons, ...result.items];
        _pgcSeasonPage = page;
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

  Future<void> _create() async {
    setState(() => _loading = true);
    try {
      final name = _nameController.text.trim().isEmpty
          ? _modeLabel(_mode)
          : _nameController.text.trim();
      switch (widget.onCreate) {
        case final callback?:
          await callback(name, _sourceConfig, _instanceName);
        case null:
          await providerGateway.createPlaylist(
            widget.roomId,
            name: name,
            parentId: widget.parentId,
            sourceProvider: 'bilibili',
            sourceConfig: _sourceConfig,
            providerInstanceName: _instanceName,
          );
      }
      if (!mounted) return;
      _nameController.clear();
      _primaryController.clear();
      _secondaryController.clear();
      _keywordController.clear();
      _preview = null;
      _timeline = null;
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, 'Bilibili playlist created');
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  static String _modeLabel(BilibiliPlaylistMode mode) => switch (mode) {
    BilibiliPlaylistMode.videoParts => 'Video Parts',
    BilibiliPlaylistMode.popular => 'Bilibili Popular',
    BilibiliPlaylistMode.recommended => 'Bilibili Recommended',
    BilibiliPlaylistMode.upVideos => 'UP Videos',
    BilibiliPlaylistMode.favoriteVideos => 'Favorite Videos',
    BilibiliPlaylistMode.collectionVideos => 'Collection',
    BilibiliPlaylistMode.seriesVideos => 'Series',
    BilibiliPlaylistMode.watchLater => 'Watch Later',
    BilibiliPlaylistMode.pgcSeason => 'PGC Season',
    BilibiliPlaylistMode.liveRecommended => 'Live Recommended',
    BilibiliPlaylistMode.liveFollowed => 'Followed Live Rooms',
    BilibiliPlaylistMode.liveArea => 'Live Area',
    BilibiliPlaylistMode.history => 'Playback History',
    BilibiliPlaylistMode.pgcTimeline => 'PGC Timeline',
    BilibiliPlaylistMode.pgcIndex => 'PGC Index',
    BilibiliPlaylistMode.followedAnime => 'Followed Anime',
    BilibiliPlaylistMode.followedCinema => 'Followed Cinema',
  };

  static String _timelineKindLabel(BilibiliPgcTimelineKind kind) =>
      switch (kind) {
        BilibiliPgcTimelineKind.anime => 'Anime',
        BilibiliPgcTimelineKind.cinema => 'Cinema',
        BilibiliPgcTimelineKind.guochuang => 'Guochuang',
      };

  static String _pgcSeasonKindLabel(BilibiliPgcSeasonKind kind) =>
      switch (kind) {
        BilibiliPgcSeasonKind.anime => 'Anime',
        BilibiliPgcSeasonKind.movie => 'Movie',
        BilibiliPgcSeasonKind.documentary => 'Documentary',
        BilibiliPgcSeasonKind.guochuang => 'Guochuang',
        BilibiliPgcSeasonKind.tv => 'TV',
        BilibiliPgcSeasonKind.variety => 'Variety',
      };

  static String _pgcSeasonOrderLabel(BilibiliPgcSeasonOrder order) =>
      switch (order) {
        BilibiliPgcSeasonOrder.updated => 'Updated',
        BilibiliPgcSeasonOrder.danmaku => 'Danmaku',
        BilibiliPgcSeasonOrder.play => 'Plays',
        BilibiliPgcSeasonOrder.follow => 'Followers',
        BilibiliPgcSeasonOrder.score => 'Score',
        BilibiliPgcSeasonOrder.started => 'Started',
        BilibiliPgcSeasonOrder.released => 'Released',
      };
}
