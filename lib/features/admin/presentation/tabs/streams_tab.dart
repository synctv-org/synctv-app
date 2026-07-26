part of '../admin_settings_page.dart';

class AdminStreamsTab extends StatefulWidget {
  const AdminStreamsTab({super.key});

  @override
  State<AdminStreamsTab> createState() => _AdminStreamsTabState();
}

class _AdminStreamsTabState extends State<AdminStreamsTab> {
  bool _isLoading = true;
  String _search = '';
  String _roomId = '';
  String _userId = '';
  String _nodeId = '';
  int _page = 1;
  int _pageSize = 50;
  admin_enum.ActiveStreamListSortBy _sortBy =
      admin_enum.ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT;
  admin_enum.SortDirection _sortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  List<AdminActiveStream> _streams = const [];
  int _total = 0;
  final _searchController = TextEditingController();

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadStreams();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStreams({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final page = await adminGateway.adminListActiveStreamsPage(
        page: _page,
        pageSize: _pageSize,
        search: _search,
        roomId: _roomId.isNotEmpty
            ? _roomId
            : _search.startsWith('room_')
            ? _search
            : '',
        userId: _userId.isNotEmpty
            ? _userId
            : _search.startsWith('usr_')
            ? _search
            : '',
        nodeId: _nodeId,
        sortBy: _sortBy,
        sortDirection: _sortDirection,
      );
      if (!mounted) return;
      setState(() {
        _streams = page.streams;
        _total = page.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppNotifications.showError(
        context,
        context.l10n.loadActiveStreamsFailed('$e'),
      );
    }
  }

  Future<void> _kick(AdminActiveStream stream) async {
    try {
      await adminGateway.adminKickStream(stream);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.streamDisconnected);
      _loadStreams(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.operationFailed('$e'));
    }
  }

  void _applyStreamSearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _roomId = normalized.startsWith('room_') ? normalized : '';
      _userId = normalized.startsWith('usr_') ? normalized : '';
      _nodeId = normalized.startsWith('node_') ? normalized : '';
      _page = 1;
    });
    _loadStreams();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 240,
                child: AppSearchField(
                  controller: _searchController,
                  hintText: context.l10n.searchStreamsHint,
                  onChanged: (value) {
                    if (value.isEmpty && _search.isNotEmpty) {
                      _applyStreamSearch('');
                    }
                  },
                  onSubmitted: _applyStreamSearch,
                ),
              ),
              AppSelect<int>(
                value: _pageSize,
                options: {
                  context.l10n.itemsPerPage(20): 20,
                  context.l10n.itemsPerPage(50): 50,
                  context.l10n.itemsPerPage(100): 100,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _pageSize = value;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              AppSelect<admin_enum.ActiveStreamListSortBy>(
                value: _sortBy,
                options: {
                  context.l10n.startedAt: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
                  context.l10n.rooms: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_ROOM_ID,
                  context.l10n.media: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_MEDIA_ID,
                  context.l10n.users: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_USER_ID,
                  context.l10n.node: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_NODE_ID,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _sortBy = value;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              AppIconButton(
                tooltip:
                    _sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? context.l10n.descending
                    : context.l10n.ascending,
                icon:
                    _sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? Icons.south_rounded
                    : Icons.north_rounded,
                onPressed: () {
                  setState(() {
                    _sortDirection =
                        _sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                        : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              AppIconButton(
                tooltip: context.l10n.refresh,
                icon: Icons.refresh_rounded,
                onPressed: () => _loadStreams(silent: true),
              ),
            ],
          ),
        ),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadStreams();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadStreams();
                },
        ),
        Expanded(
          child: _isLoading
              ? const AppLoadingIndicator()
              : _streams.isEmpty
              ? Center(
                  child: Text(
                    context.l10n.noActiveStreams,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
              : AppListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _streams.length,
                  itemBuilder: (context, index) {
                    final stream = _streams[index];
                    return _AdminPanelCard(
                      isDark: isDark,
                      child: AppTile(
                        prefix: const Icon(Icons.podcasts_rounded),
                        title: Text(stream.mediaId),
                        subtitle: Text(
                          '${stream.roomId} · ${stream.userId}\nNode: ${stream.nodeId} · ${_formatTimestamp(stream.startedAt)}',
                        ),
                        suffix: AppIconButton(
                          tooltip: context.l10n.disconnectStream,
                          icon: Icons.power_settings_new_rounded,
                          style: AppIconButtonStyle.destructive,
                          onPressed: () => _kick(stream),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
