part of '../admin_settings_page.dart';

typedef _RoomMembersDialogResult = ({bool add, AdminRoomMember? member});

class _RoomMembersDialog extends StatefulWidget {
  const _RoomMembersDialog({required this.room, required this.initialData});
  final SyncTvRoom room;
  final AdminRoomMembersPage initialData;
  @override
  State<_RoomMembersDialog> createState() => _RoomMembersDialogState();
}

class _RoomMembersDialogState extends State<_RoomMembersDialog> {
  final searchController = TextEditingController();
  var page = 1;
  var pageSize = 20;
  var roleFilter = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED;
  var sortBy =
      admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT;
  var sortDirection = admin_enum.SortDirection.SORT_DIRECTION_DESC;
  late var members = widget.initialData.members;
  late var total = widget.initialData.total;
  late var onlineMemberCount = widget.initialData.onlineMemberCount;
  late var connectionCount = widget.initialData.connectionCount;
  var loading = false;
  var loadGeneration = 0;
  var _closing = false;
  final pendingMemberActions = <String>{};
  SyncTvRoom get room => widget.room;
  bool get closed =>
      !mounted || _closing || ModalRoute.of(context)?.isActive != true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _finish({bool add = false, AdminRoomMember? member}) {
    if (closed || ModalRoute.of(context)?.isCurrent != true) return;
    _closing = true;
    Navigator.pop<_RoomMembersDialogResult>(
      context,
      add || member != null ? (add: add, member: member) : null,
    );
  }

  Future<String?> _showRoomMemberTextDialog({
    required String title,
    required String label,
    required String initialValue,
    required IconData icon,
  }) => showAppDialog<String>(
    context: context,
    builder: (_) => RoomMemberTextDialog(
      title: title,
      label: label,
      initialValue: initialValue,
      icon: icon,
    ),
  );

  Future<int?> _askKickCooldownSeconds() => showAppDialog<int>(
    context: context,
    builder: (_) => const KickRoomMemberDialog(),
  );

  Future<void> runMemberAction(
    AdminRoomMember member,
    Future<void> Function() action,
    String Function(String) errorMessage,
  ) async {
    if (closed || !mounted || pendingMemberActions.contains(member.userId)) {
      return;
    }
    setState(() => pendingMemberActions.add(member.userId));
    try {
      await action();
    } catch (e) {
      if (closed || !mounted) return;
      AppNotifications.showError(context, errorMessage('$e'));
    } finally {
      pendingMemberActions.remove(member.userId);
      if (!closed && mounted) setState(() {});
    }
  }

  Future<void> loadMembers() async {
    if (closed || !mounted) return;
    final generation = ++loadGeneration;
    setState(() => loading = true);
    try {
      final next = await adminGateway.adminListRoomMembersPage(
        room.roomId,
        page: page,
        pageSize: pageSize,
        search: searchController.text.trim(),
        role:
            roleFilter ==
                common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED
            ? null
            : roleFilter,
        sortBy: sortBy,
        sortDirection: sortDirection,
      );
      if (closed || !mounted || generation != loadGeneration) {
        return;
      }
      setState(() {
        members = next.members;
        total = next.total;
        onlineMemberCount = next.onlineMemberCount;
        connectionCount = next.connectionCount;
        loading = false;
      });
    } catch (e) {
      if (closed || !mounted || generation != loadGeneration) {
        return;
      }
      setState(() => loading = false);
      AppNotifications.showError(context, context.l10n.loadMembersFailed('$e'));
    }
  }

  Future<void> updateMemberRemarkName(AdminRoomMember member) async {
    final value = await _showRoomMemberTextDialog(
      title: context.l10n.remarkName,
      label: context.l10n.remarkName,
      initialValue: member.remarkName,
      icon: Icons.drive_file_rename_outline_rounded,
    );
    if (closed || !mounted || value == null || value == member.remarkName) {
      return;
    }
    await adminGateway.adminUpdateRoomMemberRemarkName(
      room.roomId,
      member.userId,
      value,
    );
    await loadMembers();
    if (closed || !mounted) return;
    AppNotifications.showSuccess(context, context.l10n.remarkNameUpdated);
  }

  Future<void> updateMemberDisplayTag(AdminRoomMember member) async {
    final value = await _showRoomMemberTextDialog(
      title: context.l10n.displayLabel,
      label: context.l10n.displayLabel,
      initialValue: member.displayTag,
      icon: Icons.sell_outlined,
    );
    if (closed || !mounted || value == null || value == member.displayTag) {
      return;
    }
    await adminGateway.adminUpdateRoomMemberDisplayTag(
      room.roomId,
      member.userId,
      value,
    );
    await loadMembers();
    if (closed || !mounted) return;
    AppNotifications.showSuccess(context, context.l10n.displayLabelUpdated);
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    title: Text(context.l10n.roomMembers),
    icon: const Icon(Icons.group_rounded),
    body: SizedBox(width: 620, height: 560, child: _buildContent()),
    actions: [
      AppActionButton(
        onPressed: _finish,
        label: context.l10n.close,
        style: AppActionButtonStyle.text,
      ),
    ],
  );

  Widget _buildContent() {
    final totalPages = total <= 0 ? 1 : ((total - 1) ~/ pageSize) + 1;
    final canPrev = page > 1;
    final canNext = page < totalPages;

    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 190,
              child: AppSearchField(
                controller: searchController,
                hintText: context.l10n.searchMembers,
                onChanged: (value) {
                  if (value.isEmpty) {
                    page = 1;
                    loadMembers();
                  }
                },
                onSubmitted: (_) {
                  page = 1;
                  loadMembers();
                },
              ),
            ),
            AppSelect<common_enum.RoomMemberRole>(
              value: roleFilter,
              options: {
                context.l10n.allRoles:
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED,
                context.l10n.creator:
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
                context.l10n.administrator:
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                context.l10n.member:
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                context.l10n.guest:
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
              },
              onChanged: (value) {
                if (value == null) return;
                roleFilter = value;
                page = 1;
                loadMembers();
              },
            ),
            AppSelect<admin_enum.RoomMemberListSortBy>(
              value: sortBy,
              options: {
                context.l10n.joinedAt: admin_enum
                    .RoomMemberListSortBy
                    .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                context.l10n.username: admin_enum
                    .RoomMemberListSortBy
                    .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                context.l10n.role: admin_enum
                    .RoomMemberListSortBy
                    .ROOM_MEMBER_LIST_SORT_BY_ROLE,
              },
              onChanged: (value) {
                if (value == null) return;
                sortBy = value;
                page = 1;
                loadMembers();
              },
            ),
            AppIconButton(
              tooltip:
                  sortDirection == admin_enum.SortDirection.SORT_DIRECTION_DESC
                  ? context.l10n.descending
                  : context.l10n.ascending,
              icon:
                  sortDirection == admin_enum.SortDirection.SORT_DIRECTION_DESC
                  ? Icons.south_rounded
                  : Icons.north_rounded,
              onPressed: () {
                sortDirection =
                    sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                    : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                page = 1;
                loadMembers();
              },
            ),
            AppSelect<int>(
              value: pageSize,
              options: {
                context.l10n.itemsPerPage(20): 20,
                context.l10n.itemsPerPage(50): 50,
                context.l10n.itemsPerPage(100): 100,
              },
              onChanged: (value) {
                if (value == null) return;
                pageSize = value;
                page = 1;
                loadMembers();
              },
            ),
            AppIconButton(
              tooltip: context.l10n.refresh,
              icon: Icons.refresh_rounded,
              onPressed: loadMembers,
            ),
            AppActionButton(
              onPressed: () => _finish(add: true),
              icon: Icons.person_add_alt_rounded,
              label: context.l10n.addMember,
              style: AppActionButtonStyle.text,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            context.l10n.memberAdminSummary(
              total,
              onlineMemberCount,
              connectionCount,
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: loading
              ? const AppLoadingIndicator()
              : members.isEmpty
              ? AppEmptyMessage(message: context.l10n.noMembers)
              : AppListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    final busy = pendingMemberActions.contains(member.userId);
                    final remarkName = member.remarkName.trim();
                    final displayTag = member.displayTag.trim();
                    final username = member.username.isEmpty
                        ? member.userId
                        : member.username;
                    final title = remarkName.isEmpty ? username : remarkName;
                    final subtitleParts = [
                      if (remarkName.isNotEmpty) username,
                      member.userId,
                      _roomMemberRoleText(context, member.role),
                      if (displayTag.isNotEmpty) displayTag,
                      member.isOnline
                          ? context.l10n.roomConnections(member.connectionCount)
                          : context.l10n.offline,
                      _formatTimestamp(member.joinedAt),
                    ];
                    return _AdminRecordTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      prefix: Icon(
                        member.isOnline
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: member.isOnline ? Colors.green : null,
                      ),
                      title: Text(title),
                      subtitle: Text(subtitleParts.join(' · ')),
                      actions: [
                        AppIconButton(
                          tooltip: context.l10n.remarkName,
                          icon: Icons.drive_file_rename_outline_rounded,
                          onPressed: busy
                              ? null
                              : () => runMemberAction(
                                  member,
                                  () => updateMemberRemarkName(member),
                                  context.l10n.updateRemarkNameFailed,
                                ),
                        ),
                        AppIconButton(
                          tooltip: context.l10n.displayLabel,
                          icon: Icons.sell_outlined,
                          onPressed: busy
                              ? null
                              : () => runMemberAction(
                                  member,
                                  () => updateMemberDisplayTag(member),
                                  context.l10n.updateDisplayLabelFailed,
                                ),
                        ),
                        AppIconButton(
                          tooltip: context.l10n.toggleAdministrator,
                          icon: Icons.admin_panel_settings_outlined,
                          onPressed: busy
                              ? null
                              : () => runMemberAction(member, () async {
                                  final nextRole =
                                      member.role ==
                                          common_enum
                                              .RoomMemberRole
                                              .ROOM_MEMBER_ROLE_ADMIN
                                      ? common_enum
                                            .RoomMemberRole
                                            .ROOM_MEMBER_ROLE_MEMBER
                                      : common_enum
                                            .RoomMemberRole
                                            .ROOM_MEMBER_ROLE_ADMIN;
                                  await adminGateway.adminSetRoomMemberRole(
                                    room.roomId,
                                    member.userId,
                                    nextRole,
                                  );
                                  await loadMembers();
                                }, context.l10n.updateRoleFailed),
                        ),
                        AppIconButton(
                          tooltip: context.l10n.permissionOverrides,
                          icon: Icons.tune_rounded,
                          onPressed: busy
                              ? null
                              : () => _finish(member: member),
                        ),
                        AppIconButton(
                          tooltip: context.l10n.kick,
                          icon: Icons.logout_rounded,
                          style: AppIconButtonStyle.destructive,
                          onPressed: busy
                              ? null
                              : () => runMemberAction(member, () async {
                                  final cooldown =
                                      await _askKickCooldownSeconds();
                                  if (closed ||
                                      !context.mounted ||
                                      cooldown == null) {
                                    return;
                                  }
                                  await adminGateway.adminKickRoomMember(
                                    room.roomId,
                                    member.userId,
                                    kickCooldownSeconds: cooldown,
                                  );
                                  await loadMembers();
                                }, context.l10n.kickMemberFailed),
                        ),
                      ],
                    );
                  },
                ),
        ),
        const SizedBox(height: 8),
        AppPaginationBar(
          padding: EdgeInsets.zero,
          label: context.l10n.memberPageSummary(total, page, totalPages),
          onPrevious: canPrev
              ? () {
                  page -= 1;
                  loadMembers();
                }
              : null,
          onNext: canNext
              ? () {
                  page += 1;
                  loadMembers();
                }
              : null,
        ),
      ],
    );
  }
}
