part of '../account_center_page.dart';

mixin _AccountOverviewTab on _AccountCenterPageBase {
  Widget _buildOverviewTab(ThemeData theme) {
    final layoutScale = (MediaQuery.textScalerOf(context).scale(14) / 14).clamp(
      1.0,
      double.infinity,
    );
    final preferences = _preferences;
    final rooms = _overviewRooms;
    final emailStatus = _emailStatusView(theme);
    final unread = _notifications?.unreadCount ?? 0;
    final roomCount = rooms?.total ?? 0;
    final activeFactors = preferences == null
        ? 0
        : [
            preferences.canUsePassword,
            preferences.canUseEmail && _user.hasEmail,
            preferences.canUsePasskey && _passkeyEnabled,
            preferences.canUseTotp,
          ].where((value) => value).length;

    return _responsiveList(
      children: [
        _AccountHero(
          user: _user,
          roleLabel: _userRoleLabel(_user.role),
          statusLabel: _userStatusLabel(_user.status),
          activeServerName:
              _gateway.activeServerName ?? context.l10n.noServerConnected,
          createdAtLabel: formatTimestampSeconds(_user.createdAt),
        ),
        if (_loadErrors.isNotEmpty) ...[
          const SizedBox(height: 12),
          _LoadErrorSummary(
            errors: _loadErrors,
            moduleInfo: _moduleInfo,
            onRetry: () => _load(refresh: true),
          ),
        ],
        const SizedBox(height: 12),
        AppResponsiveWrap(
          minItemWidth: 180 * layoutScale,
          maxColumns: _showEmailBindingControls ? 4 : 3,
          children: [
            _MetricTile(
              icon: Icons.meeting_room_outlined,
              label: context.l10n.myRooms,
              value: rooms == null ? '-' : '$roomCount',
              tone: theme.colorScheme.primary,
            ),
            _MetricTile(
              icon: Icons.notifications_none_rounded,
              label: context.l10n.unreadNotifications,
              value: _notifications == null ? '-' : '$unread',
              tone: AppColors.secondary,
            ),
            _MetricTile(
              icon: Icons.security_rounded,
              label: context.l10n.loginFactors,
              value: preferences == null ? '-' : '$activeFactors',
              tone: AppColors.warningDeep,
            ),
            if (_showEmailBindingControls)
              _MetricTile(
                icon: emailStatus.icon,
                label: context.l10n.emailStatus,
                value: emailStatus.label,
                tone: emailStatus.tone,
              ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840 * layoutScale;
            final panels = [
              _buildQuickProfilePanel(theme),
              _buildQuickSecurityPanel(theme),
              _buildRecentRoomsPanel(theme),
            ];
            if (!wide) {
              return Column(
                children: [
                  for (final panel in panels) ...[
                    panel,
                    if (panel != panels.last) const SizedBox(height: 12),
                  ],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: panels[0]),
                const SizedBox(width: 12),
                Expanded(child: panels[1]),
                const SizedBox(width: 12),
                Expanded(child: panels[2]),
              ],
            );
          },
        ),
      ],
    );
  }
}
