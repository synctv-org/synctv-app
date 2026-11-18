part of '../account_center_page.dart';

mixin _AccountRoomsTab on _AccountCenterPageBase {
  Widget _buildRoomsTab(ThemeData theme) {
    final page = _myRooms;
    final loadError = _loadError(_AccountCenterPageBase._moduleRooms);
    final rooms = page?.rooms ?? const <SyncTvRoom>[];
    final total = page?.total ?? 0;
    final maxPage = _roomsMaxPage(total);

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionHeader(
                          title: context.l10n.myRooms,
                          subtitle: context.l10n.myRoomsDescription,
                          icon: Icons.meeting_room_outlined,
                          dense: true,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            AppActionButton(
                              onPressed: _createRoom,
                              icon: Icons.add_rounded,
                              label: context.l10n.createRoom,
                              wrapLabel: true,
                            ),
                            if (_loadingRooms)
                              const Padding(
                                padding: EdgeInsetsDirectional.only(start: 10),
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: AppLoadingIndicator(
                                    size: AppLoadingSize.sm,
                                    centered: false,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 760;
                        final search = AppSearchField(
                          controller: _roomSearchController,
                          hintText: context.l10n.searchRoomNameOrDescription,
                          onChanged: (value) {
                            if (value.isEmpty) _reloadRoomsFromFirstPage();
                          },
                          onSubmitted: (_) => _reloadRoomsFromFirstPage(),
                        );
                        final filters = Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _RelationChip(
                              label: context.l10n.all,
                              value: client_enum
                                  .MyRoomRelation
                                  .MY_ROOM_RELATION_ALL,
                              groupValue: _roomRelationFilter,
                              onSelected: _setRoomRelationFilter,
                            ),
                            _RelationChip(
                              label: context.l10n.createdByMe,
                              value: client_enum
                                  .MyRoomRelation
                                  .MY_ROOM_RELATION_CREATED,
                              groupValue: _roomRelationFilter,
                              onSelected: _setRoomRelationFilter,
                            ),
                            _RelationChip(
                              label: context.l10n.joinedByMe,
                              value: client_enum
                                  .MyRoomRelation
                                  .MY_ROOM_RELATION_PARTICIPATING,
                              groupValue: _roomRelationFilter,
                              onSelected: _setRoomRelationFilter,
                            ),
                            AppSelect<client_enum.MyRoomListSortBy>(
                              value: _roomSortBy,
                              options: {
                                context.l10n.frequentlyVisited: client_enum
                                    .MyRoomListSortBy
                                    .MY_ROOM_LIST_SORT_BY_FREQUENT,
                                context.l10n.recentlyVisited: client_enum
                                    .MyRoomListSortBy
                                    .MY_ROOM_LIST_SORT_BY_LAST_VISITED_AT,
                                context.l10n.recentActivity: client_enum
                                    .MyRoomListSortBy
                                    .MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                                context.l10n.updatedAt: client_enum
                                    .MyRoomListSortBy
                                    .MY_ROOM_LIST_SORT_BY_UPDATED_AT,
                                context.l10n.createdAt: client_enum
                                    .MyRoomListSortBy
                                    .MY_ROOM_LIST_SORT_BY_CREATED_AT,
                                context.l10n.name: client_enum
                                    .MyRoomListSortBy
                                    .MY_ROOM_LIST_SORT_BY_NAME,
                              },
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _roomSortBy = value);
                                _reloadRoomsFromFirstPage();
                              },
                            ),
                            AppIconButton(
                              onPressed: _reloadRooms,
                              icon: Icons.refresh_rounded,
                              tooltip: context.l10n.refreshRooms,
                            ),
                          ],
                        );
                        if (!wide) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              search,
                              const SizedBox(height: 10),
                              filters,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: search),
                            const SizedBox(width: 12),
                            Flexible(child: filters),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    AppPaginationBar(
                      padding: EdgeInsets.zero,
                      label: context.l10n.pageSizeTotalSummary(
                        _roomsPage,
                        _AccountCenterPageBase._roomsPageSize,
                        total,
                      ),
                      onPrevious: _loadingRooms || _roomsPage <= 1
                          ? null
                          : () => _reloadRooms(page: _roomsPage - 1),
                      onNext: _loadingRooms || _roomsPage >= maxPage
                          ? null
                          : () => _reloadRooms(page: _roomsPage + 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      body: _loadingRooms && page == null
          ? const AppLoadingIndicator()
          : loadError != null && page == null
          ? AppSingleChildScrollView(
              primary: true,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: _LoadErrorBanner(
                    title: context.l10n.myRoomsTemporarilyUnavailable,
                    moduleInfo:
                        _moduleInfo[_AccountCenterPageBase._moduleRooms],
                    message: loadError,
                    onRetry: _reloadRooms,
                  ),
                ),
              ),
            )
          : rooms.isEmpty
          ? AppEmptyMessage(message: context.l10n.noMatchingRooms)
          : AppRefreshIndicator(
              onRefresh: _reloadRooms,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = _contentCap(constraints.maxWidth);
                  return AppListView.separated(
                    primary: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    itemCount: rooms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: _RoomManagementTile(
                            room: room,
                            roleLabel: _roomRoleLabel(room.myRole),
                            relationLabel: _roomRelationLabel(room.myRelation),
                            updatedAtLabel: formatTimestampSeconds(
                              room.updatedAt,
                            ),
                            isOwner: _isMyCreatedRoom(room),
                            canManage: _canManageRoomFromListEntry(room),
                            onOpen: () => _openRoom(room),
                            onManage: () => _manageRoom(room),
                            onLeaveOrDelete: () => _leaveOrDeleteRoom(room),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
