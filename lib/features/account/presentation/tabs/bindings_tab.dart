part of '../account_center_page.dart';

mixin _AccountBindingsTab on _AccountCenterPageBase {
  Widget _buildBindingsTab(ThemeData theme) {
    final browserAvailable = _oauth2Callbacks(context).canCreateSession;
    final nativeAvailable = _nativeAppleSignIn(context).isSupported;
    final bindableProviders = oauth2BindableProviders(_availableOAuth2)
        .where(
          (provider) => isOAuthProviderAvailable(
            provider,
            browserAvailable: browserAvailable,
            nativeAvailable: nativeAvailable,
          ),
        )
        .toList(growable: false);
    final oauth2Available = browserAvailable || nativeAvailable;
    final linkedError = _loadError(_AccountCenterPageBase._moduleOAuthLinks);
    final providersError = _loadError('OAuth2 Provider');
    final showLinkedOAuth2 = linkedError != null || _linkedOAuth2.isNotEmpty;
    final showBindableOAuth2 =
        providersError != null || bindableProviders.isNotEmpty;
    final showOAuth2Bindings = showLinkedOAuth2 || showBindableOAuth2;
    // _responsiveList caps the column on wide windows like every other tab.
    return _responsiveList(
      padding: const EdgeInsets.all(16),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.mediaSourceAccounts,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              context.l10n.mediaSourceAccountsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final layoutScale =
                    (MediaQuery.textScalerOf(context).scale(14) / 14).clamp(
                      1.0,
                      double.infinity,
                    );
                final cards = [
                  _MediaProviderBindCard(
                    label: 'AList',
                    description: context.l10n.alistAccountDescription,
                    icon: Icons.cloud_circle_rounded,
                    color: AppColors.warning,
                    onTap: () => widget.onOpenProviderBinding('alist'),
                  ),
                  _MediaProviderBindCard(
                    label: 'Cloudreve',
                    description: context.l10n.cloudreveAccountDescription,
                    icon: Icons.cloud_rounded,
                    color: Colors.teal,
                    onTap: () => widget.onOpenProviderBinding('cloudreve'),
                  ),
                  _MediaProviderBindCard(
                    label: 'Emby',
                    description: context.l10n.embyAccountDescription,
                    icon: Icons.video_library_rounded,
                    color: AppColors.success,
                    onTap: () => widget.onOpenProviderBinding('emby'),
                  ),
                  if (ProviderDistributionPolicy.current.allowsProvider(
                    'bilibili',
                  ))
                    _MediaProviderBindCard(
                      label: 'Bilibili',
                      description: context.l10n.bilibiliAccountDescription,
                      icon: Icons.tv_rounded,
                      color: AppColors.providerBilibili,
                      onTap: () => widget.onOpenProviderBinding('bilibili'),
                    ),
                  if (ProviderDistributionPolicy.current.allowsProvider(
                    'twitch',
                  ))
                    _MediaProviderBindCard(
                      label: 'Twitch',
                      description: context.l10n.twitchAccountDescription,
                      icon: Icons.live_tv_rounded,
                      color: AppColors.providerTwitch,
                      onTap: () => widget.onOpenProviderBinding('twitch'),
                    ),
                  _MediaProviderBindCard(
                    label: 'FNOS',
                    description: context.l10n.fnosAccountDescription,
                    icon: Icons.storage_rounded,
                    color: AppColors.providerFnos,
                    onTap: () => widget.onOpenProviderBinding('fnos'),
                  ),
                  _MediaProviderBindCard(
                    label: 'QNAP',
                    description: context.l10n.qnapAccountDescription,
                    icon: Icons.storage_rounded,
                    color: AppColors.providerQnap,
                    onTap: () => widget.onOpenProviderBinding('qnap'),
                  ),
                  _MediaProviderBindCard(
                    label: 'Synology DSM',
                    description: context.l10n.synologyAccountDescription,
                    icon: Icons.video_library_rounded,
                    color: AppColors.providerSynology,
                    onTap: () => widget.onOpenProviderBinding('synology'),
                  ),
                  _MediaProviderBindCard(
                    label: 'Nextcloud',
                    description: context.l10n.nextcloudAccountDescription,
                    icon: Icons.cloud_outlined,
                    color: AppColors.providerNextcloud,
                    onTap: () => widget.onOpenProviderBinding('nextcloud'),
                  ),
                  _MediaProviderBindCard(
                    label: 'Seafile',
                    description: context.l10n.seafileAccountDescription,
                    icon: Icons.cloud_queue_rounded,
                    color: AppColors.providerSeafile,
                    onTap: () => widget.onOpenProviderBinding('seafile'),
                  ),
                  _MediaProviderBindCard(
                    label: 'TrueNAS',
                    description: context.l10n.truenasAccountDescription,
                    icon: Icons.dns_rounded,
                    color: AppColors.providerTruenas,
                    onTap: () => widget.onOpenProviderBinding('truenas'),
                  ),
                  if (ProviderDistributionPolicy.current.allowsProvider(
                    'youtube',
                  ))
                    _MediaProviderBindCard(
                      label: 'YouTube',
                      description: context.l10n.youtubeAccountDescription,
                      icon: Icons.smart_display_rounded,
                      color: AppColors.providerYoutube,
                      onTap: () => widget.onOpenProviderBinding('youtube'),
                    ),
                  if (ProviderDistributionPolicy.current.allowsProvider(
                    'douyin',
                  ))
                    _MediaProviderBindCard(
                      label: 'Douyin',
                      description: context.l10n.douyinAccountDescription,
                      icon: Icons.music_video_rounded,
                      color: AppColors.providerDouyin,
                      onTap: () => widget.onOpenProviderBinding('douyin'),
                    ),
                  if (ProviderDistributionPolicy.current.allowsProvider(
                    'tiktok',
                  ))
                    _MediaProviderBindCard(
                      label: 'TikTok',
                      description: context.l10n.tiktokAccountDescription,
                      icon: Icons.music_video_rounded,
                      color: AppColors.providerTiktok,
                      onTap: () => widget.onOpenProviderBinding('tiktok'),
                    ),
                ];
                return AppResponsiveWrap(
                  minItemWidth: 280 * layoutScale,
                  children: cards,
                );
              },
            ),
          ],
        ),
        if (ProviderDistributionPolicy.current.allowsOAuth2 &&
            showOAuth2Bindings) ...[
          const SizedBox(height: 12),
          if (showLinkedOAuth2) ...[
            _Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.linkedOAuth2,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (linkedError != null)
                    _InlineModuleError(
                      moduleInfo:
                          _moduleInfo[_AccountCenterPageBase._moduleOAuthLinks],
                      message: linkedError,
                      onRetry: () => _load(refresh: true),
                    )
                  else
                    for (final account in _linkedOAuth2)
                      _LinkedOAuthAccountRow(
                        account: account,
                        description: [
                          if (account.providerUsername.isNotEmpty)
                            account.providerUsername,
                          if (account.providerUserId.isNotEmpty)
                            account.providerUserId,
                          if (account.providerIssuer.isNotEmpty)
                            account.providerIssuer,
                          formatTimestampSeconds(account.linkedAt),
                        ].join(' · '),
                        onUnlink: _unlinkingOAuth2 || _bindProvider != null
                            ? null
                            : () => _unlinkOAuth2(account),
                      ),
                ],
              ),
            ),
            if (showBindableOAuth2) const SizedBox(height: 12),
          ],
          if (showBindableOAuth2)
            _Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.bindNewAccount,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (providersError != null)
                    _InlineModuleError(
                      moduleInfo: _moduleInfo['OAuth2 Provider'],
                      message: providersError,
                      onRetry: () => _load(refresh: true),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final provider in bindableProviders) ...[
                          if (selectOAuth2AuthorizationMode(
                                    provider,
                                    platform: defaultTargetPlatform,
                                    browserAvailable: browserAvailable,
                                    nativeAvailable: nativeAvailable,
                                  ) ==
                                  OAuth2ClientAuthorizationMode.native &&
                              shouldUseAppleSignInButton(
                                provider,
                                defaultTargetPlatform,
                              ))
                            SizedBox(
                              width: 240,
                              child: AppleSignInButton(
                                enabled:
                                    _bindProvider == null && !_unlinkingOAuth2,
                                semanticLabel: context.l10n
                                    .continueWithProvider('Apple'),
                                onPressed: () => _startOAuth2Bind(provider),
                              ),
                            )
                          else
                            AppActionButton(
                              onPressed:
                                  _bindProvider == null &&
                                      !_unlinkingOAuth2 &&
                                      selectOAuth2AuthorizationMode(
                                            provider,
                                            platform: defaultTargetPlatform,
                                            browserAvailable: browserAvailable,
                                            nativeAvailable: nativeAvailable,
                                          ) !=
                                          null
                                  ? () => _startOAuth2Bind(provider)
                                  : null,
                              prefix: OAuthProviderIcon(
                                type: provider.type,
                                name: provider.name,
                              ),
                              label:
                                  '${oauthProviderDisplayName(type: provider.type, name: provider.name)} (${provider.name})',
                              wrapLabel: true,
                              style: AppActionButtonStyle.outlined,
                            ),
                        ],
                      ],
                    ),
                  if (!oauth2Available) ...[
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.oauthAppLinkUnavailable,
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ],
                  if (_bindProvider != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: AppLoadingIndicator(
                            size: AppLoadingSize.sm,
                            centered: false,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            context.l10n.waitingForAuthorizationCallback(
                              _bindProvider!,
                            ),
                            style: TextStyle(color: theme.hintColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppActionButton(
                        onPressed: () => setState(() {
                          _bindProvider = null;
                          _bindAttempt++;
                        }),
                        icon: Icons.close_rounded,
                        label: context.l10n.cancelBinding,
                        style: AppActionButtonStyle.text,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ],
    );
  }
}
