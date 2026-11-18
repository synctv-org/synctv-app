part of '../room_screen.dart';

mixin _RoomPlaylistTab on _RoomScreenBase {
  @override
  Widget _buildPlaylistTab() {
    const primaryColor = AppColors.playerAccent;
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
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
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
                      style: AppIconButtonStyle.destructiveSubtle,
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
              if (_playlistStack.isNotEmpty) ...[
                const SizedBox(height: 6),
                _buildPlaylistBreadcrumbs(),
              ],
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
      suffix: selectionMode
          ? _buildPlaylistSelectionIcon(entry, isSelected, true, primaryColor)
          : _buildRtmpPublishKeyButton(entry),
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
    final publishKeyButton = selectionMode
        ? null
        : _buildRtmpPublishKeyButton(entry);

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
                        if (publishKeyButton case final button?) ...[
                          const SizedBox(width: 4),
                          button,
                        ],
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
                  entry,
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
    final publishKeyButton = selectionMode
        ? null
        : _buildRtmpPublishKeyButton(entry);

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
                        entry,
                        isSelected,
                        selectionMode,
                        primaryColor,
                      )!,
                    ),
                  if (publishKeyButton case final button?)
                    Positioned(right: 6, top: 6, child: button),
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
    RoomMediaEntry entry,
    bool isSelected,
    bool selectionMode,
    Color primaryColor,
  ) {
    if (!selectionMode) return null;
    return AppCheckbox(
      value: isSelected,
      semanticsLabel: entry.name,
      activeColor: primaryColor,
      shape: const CircleBorder(),
      onChanged: PlaylistSelectionPolicy.isSelectable(entry)
          ? (_) => _toggleSelection(entry)
          : null,
    );
  }

  Widget? _buildRtmpPublishKeyButton(RoomMediaEntry entry) {
    final viewerId = _currentUser?.id ?? '';
    if (!canGenerateRtmpPublishKey(
      entry: entry,
      viewerId: viewerId,
      canManageLiveStreams: _canManageLiveStreams,
    )) {
      return null;
    }
    if (_rtmpPublishKeyLoadingIds.contains(entry.id)) {
      return const SizedBox.square(
        dimension: 36,
        child: Center(
          child: AppLoadingIndicator(size: AppLoadingSize.sm, centered: false),
        ),
      );
    }
    return AppIconButton(
      key: ValueKey('rtmp-publish-key-${entry.id}'),
      icon: Icons.key_rounded,
      size: AppIconButtonSize.sm,
      style: AppIconButtonStyle.tonal,
      onPressed: () => _generateRtmpPublishKey(entry),
      tooltip: context.l10n.generatePublishKey,
    );
  }

  Future<void> _generateRtmpPublishKey(RoomMediaEntry entry) async {
    final options = await showRtmpPublishKeyOptionsDialog(context);
    if (!mounted || options == null) return;

    setState(() => _rtmpPublishKeyLoadingIds.add(entry.id));
    try {
      final gateway = DependencyScope.read<ProviderGateway>(context);
      RoomStreamEntryInfo? streamInfo;
      try {
        streamInfo = await gateway.getRtmpStreamInfo(
          roomId: widget.room.roomId,
          mediaId: entry.id,
        );
      } on Object {
        // A failed optional status lookup must not prevent key generation.
      }
      if (!mounted) return;
      final publish = await gateway.createRtmpPublishKeyInfo(
        widget.room.roomId,
        entry.id,
        keyType: options.keyType,
        expiresAt: options.expiresAt,
      );
      if (!mounted) return;
      await showRtmpPublishCredentialsDialog(
        context,
        publish: publish,
        streamInfo: streamInfo,
      );
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.generatePublishKeyFailed('$error'),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _rtmpPublishKeyLoadingIds.remove(entry.id));
      }
    }
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
    if (entry.isPlaylist) return AppColors.warning;
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
    final selectedEntries = _selectedMediaEntries.values.toList();

    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteEntries,
      icon: const Icon(Icons.delete_outline, color: AppColors.danger),
      content: Text(
        context.l10n.confirmDeleteMediaEntries(selectedEntries.length),
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

    if (confirmed == true && mounted) {
      try {
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
        if (!mounted) return;
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
      icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.danger),
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
}
