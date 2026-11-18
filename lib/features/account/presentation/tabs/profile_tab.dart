part of '../account_center_page.dart';

mixin _AccountProfileTab on _AccountCenterPageBase {
  Widget _buildProfileTab(ThemeData theme) {
    final preferences = _preferences;
    final emailStatus = _emailStatusView(theme);
    final notifications =
        preferences?.notifications ?? NotificationPreferences.defaults();
    return _responsiveList(
      children: [
        _SectionHeader(
          title: context.l10n.personalProfile,
          subtitle: context.l10n.personalProfileDescription,
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 12),
        _Section(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide =
                  constraints.maxWidth >=
                  MediaQuery.textScalerOf(context).scale(620);
              final avatar = _EditableProfileAvatar(
                username: _user.username,
                avatarUrl: _user.avatarUrl,
                size: 68,
                updating: _updatingAvatar,
                onPick: _updateAvatar,
                onClear: _user.avatarUrl.isEmpty ? null : _clearAvatar,
              );
              final details = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user.username,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusPill(
                        icon: Icons.admin_panel_settings_outlined,
                        label: _userRoleLabel(_user.role),
                      ),
                      if (_showEmailBindingControls)
                        _StatusPill(
                          icon: emailStatus.icon,
                          label: context.l10n.emailWithStatus(
                            emailStatus.label,
                          ),
                          color: emailStatus.tone,
                        ),
                      if (_user.isBanned)
                        _StatusPill(
                          icon: Icons.block_rounded,
                          label: context.l10n.banned,
                          danger: true,
                        ),
                    ],
                  ),
                  if (_showEmailBindingControls) ...[
                    const SizedBox(height: 12),
                    Text(
                      _user.hasEmail
                          ? _user.email!
                          : context.l10n.emailNotBound,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ],
              );
              final action = AppActionButton(
                onPressed: _rename,
                icon: Icons.edit_rounded,
                label: context.l10n.edit,
                wrapLabel: true,
              );
              if (!wide) {
                final stackIdentity =
                    constraints.maxWidth <
                    MediaQuery.textScalerOf(context).scale(420);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (stackIdentity) ...[
                      avatar,
                      const SizedBox(height: 14),
                      SizedBox(width: double.infinity, child: details),
                    ] else
                      Row(
                        children: [
                          avatar,
                          const SizedBox(width: 14),
                          Expanded(child: details),
                        ],
                      ),
                    const SizedBox(height: 16),
                    SizedBox(width: double.infinity, child: action),
                  ],
                );
              }
              return Row(
                children: [
                  avatar,
                  const SizedBox(width: 18),
                  Expanded(flex: 2, child: details),
                  const SizedBox(width: 16),
                  Flexible(child: action),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _Section(
          title: context.l10n.accountInformation,
          child: _InfoGrid(
            entries: [
              _InfoEntry(context.l10n.userId, _user.id),
              _InfoEntry(
                context.l10n.accountStatus,
                _userStatusLabel(_user.status),
              ),
              _InfoEntry(
                context.l10n.createdAt,
                formatTimestampSeconds(_user.createdAt),
              ),
              _InfoEntry(
                context.l10n.updatedAt,
                formatTimestampSeconds(_user.updatedAt),
              ),
              _InfoEntry(
                context.l10n.onlineConnectionsLabel,
                '${_user.onlineCount}',
              ),
              if (_user.isBanned)
                _InfoEntry(context.l10n.banReason, _user.bannedReason),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (preferences != null)
          _Section(
            title: context.l10n.notificationPreferences,
            subtitle: context.l10n.notificationPreferencesDescription,
            child: AppResponsiveWrap(
              minItemWidth: 320,
              maxColumns: 2,
              runSpacing: 4,
              children: [
                _PreferenceSwitch(
                  title: context.l10n.roomInviteInAppNotifications,
                  value: notifications.roomInvitationInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                          notifications.copyWith(roomInvitationInApp: value),
                        ),
                ),
                _PreferenceSwitch(
                  title: context.l10n.roomEventInAppNotifications,
                  value: notifications.roomEventInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                          notifications.copyWith(roomEventInApp: value),
                        ),
                ),
                _PreferenceSwitch(
                  title: context.l10n.systemAnnouncementInAppNotifications,
                  value: notifications.systemAnnouncementInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                          notifications.copyWith(
                            systemAnnouncementInApp: value,
                          ),
                        ),
                ),
                if (_user.hasEmail && _emailFeatureEnabled)
                  _PreferenceSwitch(
                    title: context.l10n.roomInviteEmailNotifications,
                    value: notifications.roomInvitationEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                            notifications.copyWith(roomInvitationEmail: value),
                          ),
                  ),
                if (_user.hasEmail && _emailFeatureEnabled)
                  _PreferenceSwitch(
                    title: context.l10n.roomEventEmailNotifications,
                    value: notifications.roomEventEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                            notifications.copyWith(roomEventEmail: value),
                          ),
                  ),
                if (_user.hasEmail && _emailFeatureEnabled)
                  _PreferenceSwitch(
                    title: context.l10n.systemAnnouncementEmailNotifications,
                    value: notifications.systemAnnouncementEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                            notifications.copyWith(
                              systemAnnouncementEmail: value,
                            ),
                          ),
                  ),
              ],
            ),
          )
        else if (_loadError(_AccountCenterPageBase._moduleAccountPreferences) !=
            null)
          _LoadErrorBanner(
            title: context.l10n.notificationPreferencesUnavailable,
            moduleInfo:
                _moduleInfo[_AccountCenterPageBase._moduleAccountPreferences],
            message: _loadError(
              _AccountCenterPageBase._moduleAccountPreferences,
            )!,
            onRetry: () => _load(refresh: true),
          ),
      ],
    );
  }
}
