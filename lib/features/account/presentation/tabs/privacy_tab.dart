part of '../account_center_page.dart';

mixin _AccountPrivacyTab on _AccountCenterPageBase {
  Widget _buildPrivacyTab(ThemeData theme) {
    final page = _blockedUsers;
    final loadError = _loadError(_AccountCenterPageBase._moduleBlockedUsers);
    final users = page?.users ?? const <BlockedUserInfo>[];
    final total = page?.total ?? 0;
    final maxPage = _blockedUsersMaxPage(total);

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SectionHeader(
                            title: context.l10n.blockedUsers,
                            subtitle: context.l10n.blockedUsersDescription,
                            icon: Icons.person_off_outlined,
                            dense: true,
                          ),
                        ),
                        AppIconButton(
                          onPressed: _loadingBlockedUsers
                              ? null
                              : _reloadBlockedUsers,
                          icon: Icons.refresh_rounded,
                          tooltip: context.l10n.refresh,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppSearchField(
                      controller: _blockedUserSearchController,
                      hintText: context.l10n.searchBlockedUsers,
                      enabled: !_loadingBlockedUsers,
                      onChanged: (value) {
                        if (value.isEmpty) _reloadBlockedUsersFromFirstPage();
                      },
                      onSubmitted: (_) => _reloadBlockedUsersFromFirstPage(),
                    ),
                    const SizedBox(height: 8),
                    AppPaginationBar(
                      padding: EdgeInsets.zero,
                      label: context.l10n.pageSizeTotalSummary(
                        _blockedUsersPage,
                        _AccountCenterPageBase._blockedUsersPageSize,
                        total,
                      ),
                      onPrevious: _loadingBlockedUsers || _blockedUsersPage <= 1
                          ? null
                          : () => _reloadBlockedUsers(
                              page: _blockedUsersPage - 1,
                            ),
                      onNext:
                          _loadingBlockedUsers || _blockedUsersPage >= maxPage
                          ? null
                          : () => _reloadBlockedUsers(
                              page: _blockedUsersPage + 1,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      body: _loadingBlockedUsers && page == null
          ? const AppLoadingIndicator()
          : loadError != null && page == null
          ? AppSingleChildScrollView(
              primary: true,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: _LoadErrorBanner(
                    title: context.l10n.blockedUsersTemporarilyUnavailable,
                    moduleInfo:
                        _moduleInfo[_AccountCenterPageBase._moduleBlockedUsers],
                    message: loadError,
                    onRetry: _reloadBlockedUsers,
                  ),
                ),
              ),
            )
          : users.isEmpty
          ? AppEmptyMessage(message: context.l10n.noBlockedUsers)
          : AppRefreshIndicator(
              onRefresh: _reloadBlockedUsers,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cap = _contentCap(constraints.maxWidth);
                  return AppListView.separated(
                    primary: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    itemCount: users.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final blockedUser = users[index];
                      final user = blockedUser.user;
                      final name = user.username.trim().isEmpty
                          ? user.id
                          : user.username.trim();
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: cap),
                          child: AppPanelSurface(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.6),
                            ),
                            child: AppTile(
                              prefix: AppAvatar(
                                name: name,
                                imageUrl: user.avatarUrl,
                                size: 42,
                              ),
                              title: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                context.l10n.blockedAt(
                                  formatTimestampSeconds(blockedUser.blockedAt),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              stackedSuffix: true,
                              suffix: AppActionButton(
                                onPressed: _loadingBlockedUsers
                                    ? null
                                    : () => _unblockUser(blockedUser),
                                icon: Icons.person_add_alt_1_outlined,
                                label: context.l10n.unblockUser,
                                wrapLabel: true,
                                style: AppActionButtonStyle.outlined,
                              ),
                            ),
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
