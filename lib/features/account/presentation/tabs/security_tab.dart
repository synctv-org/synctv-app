part of '../account_center_page.dart';

mixin _AccountSecurityTab on _AccountCenterPageBase {
  Widget _buildSecurityTab(ThemeData theme) {
    final preferences = _preferences;
    final emailStatus = _emailStatusView(theme);
    final preferencesError = _loadError(
      _AccountCenterPageBase._moduleAccountPreferences,
    );
    final passkeyErrorKey = _loadError('Passkey') != null
        ? 'Passkey'
        : context.l10n.localPasskey;
    final passkeyError = _loadError(passkeyErrorKey);
    return _responsiveList(
      children: [
        _SectionHeader(
          title: context.l10n.accountSecurity,
          subtitle: context.l10n.accountSecurityDescription,
          icon: Icons.security_rounded,
        ),
        const SizedBox(height: 12),
        if (preferences != null)
          _Section(
            title: context.l10n.loginProtection,
            subtitle: context.l10n.loginProtectionDescription,
            child: Column(
              children: [
                AppSwitchTile(
                  value: preferences.twoFactorEnabled,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _toggleTwoFactor(value),
                  prefix: const Icon(Icons.enhanced_encryption_rounded),
                  title: Text(context.l10n.multiFactorAuthentication),
                  subtitle: Text(
                    context.l10n.availableFactors(
                      _factorLabels(preferences)
                          .join(context.l10n.listSeparator),
                    ),
                  ),
                ),
                if (_showEmailBindingControls) ...[
                  const AppDivider(height: 1),
                  AppTile(
                    contentPadding: EdgeInsets.zero,
                    prefix: Icon(emailStatus.icon, color: emailStatus.tone),
                    title: Text(context.l10n.email),
                    subtitle: Text(
                      _user.hasEmail
                          ? _user.email!
                          : context.l10n.bindEmailDescription,
                    ),
                    stackedSuffix: true,
                    suffix: _user.hasEmail
                        ? AppActionButton(
                            onPressed: _unbindEmail,
                            icon: Icons.link_off_rounded,
                            label: context.l10n.unbind,
                            wrapLabel: true,
                            style: AppActionButtonStyle.outlined,
                          )
                        : AppActionButton(
                            onPressed: _emailFeatureEnabled ? _bindEmail : null,
                            icon: Icons.add_link_rounded,
                            label: context.l10n.bind,
                            wrapLabel: true,
                            style: AppActionButtonStyle.tonal,
                          ),
                  ),
                ],
                const AppDivider(height: 1),
                AppTile(
                  contentPadding: EdgeInsets.zero,
                  prefix: const Icon(Icons.password_rounded),
                  title: Text(context.l10n.loginPassword),
                  subtitle: Text(context.l10n.opaquePasswordDescription),
                  stackedSuffix: true,
                  suffix: Wrap(
                    spacing: 8,
                    children: [
                      if (_user.hasEmail && _emailFeatureEnabled)
                        AppActionButton(
                          onPressed: _resetPasswordByEmail,
                          label: context.l10n.emailReset,
                          wrapLabel: true,
                          style: AppActionButtonStyle.outlined,
                        ),
                      AppActionButton(
                        onPressed: _changePassword,
                        label: context.l10n.edit,
                        wrapLabel: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else if (preferencesError != null)
          _LoadErrorBanner(
            title: context.l10n.loginProtectionUnavailable,
            moduleInfo:
                _moduleInfo[_AccountCenterPageBase._moduleAccountPreferences],
            message: preferencesError,
            onRetry: () => _load(refresh: true),
          ),
        const SizedBox(height: 12),
        if (preferences != null) ...[
          _Section(
            title: context.l10n.authenticatorApp,
            subtitle: context.l10n.authenticatorAppDescription,
            child: AppTile(
              contentPadding: EdgeInsets.zero,
              prefix: Icon(
                preferences.canUseTotp
                    ? Icons.verified_user_rounded
                    : Icons.shield_outlined,
                color: preferences.canUseTotp
                    ? AppColors.secondary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              title: Text(
                preferences.canUseTotp
                    ? context.l10n.authenticatorAppConfigured
                    : context.l10n.authenticatorAppNotConfigured,
              ),
              subtitle: Text(
                preferences.canUseTotp
                    ? context.l10n.recoveryCodesRemaining(
                        preferences.totpRecoveryCodesRemaining,
                      )
                    : context.l10n.authenticatorAppSetupHint,
              ),
              stackedSuffix: true,
              suffix: preferences.canUseTotp
                  ? Wrap(
                      spacing: 8,
                      children: [
                        AppActionButton(
                          onPressed: _regenerateTotpRecoveryCodes,
                          icon: Icons.refresh_rounded,
                          label: context.l10n.recoveryCodes,
                          wrapLabel: true,
                          style: AppActionButtonStyle.outlined,
                        ),
                        AppIconButton(
                          onPressed: _deleteTotp,
                          icon: Icons.delete_outline_rounded,
                          tooltip: context.l10n.removeAuthenticatorApp,
                          style: AppIconButtonStyle.destructive,
                        ),
                      ],
                    )
                  : AppActionButton(
                      onPressed: _setupTotp,
                      icon: Icons.add_rounded,
                      label: context.l10n.setup,
                      wrapLabel: true,
                      style: AppActionButtonStyle.tonal,
                    ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (_publicSettings?.enableWebauthn == true) ...[
          _Section(
            title: 'Passkey',
            subtitle: context.l10n.passkeyManagementDescription,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Passkey',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    AppActionButton(
                      onPressed: _passkeyAvailable ? _bindPasskey : null,
                      loading: _bindingPasskey,
                      icon: Icons.add_rounded,
                      label: context.l10n.bind,
                      wrapLabel: true,
                      style: AppActionButtonStyle.tonal,
                    ),
                    AppActionButton(
                      onPressed: () async {
                        final passkeys = await _gateway.listPasskeys();
                        if (mounted) setState(() => _passkeys = passkeys);
                      },
                      icon: Icons.refresh_rounded,
                      label: context.l10n.refresh,
                      wrapLabel: true,
                      style: AppActionButtonStyle.text,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (passkeyError != null)
                  _InlineModuleError(
                    moduleInfo: _moduleInfo[passkeyErrorKey],
                    message: passkeyError,
                    onRetry: () => _load(refresh: true),
                  )
                else if (_passkeys.isEmpty)
                  Text(
                    context.l10n.noPasskeys,
                    style: TextStyle(color: theme.hintColor),
                  )
                else
                  for (final credential in _passkeys)
                    AppTile(
                      contentPadding: EdgeInsets.zero,
                      prefix: const Icon(Icons.fingerprint_rounded),
                      title: Text(
                        credential.name.isEmpty
                            ? context.l10n.unnamedPasskey
                            : credential.name,
                      ),
                      subtitle: Text(
                        [
                          _shortCredentialId(credential.credentialId),
                          context.l10n.createdAtValue(
                            formatTimestampSeconds(credential.createdAt),
                          ),
                          if (credential.lastUsedAt > 0)
                            context.l10n.lastUsedAt(
                              formatTimestampSeconds(credential.lastUsedAt),
                            ),
                        ].join(' · '),
                      ),
                      suffix: AppIconButton(
                        onPressed: () => _deletePasskey(credential),
                        icon: Icons.delete_outline_rounded,
                        tooltip: context.l10n.deletePasskey,
                        style: AppIconButtonStyle.destructive,
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        _Section(
          title: context.l10n.dangerousActions,
          subtitle: context.l10n.dangerousActionsDescription,
          danger: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTile(
                contentPadding: EdgeInsets.zero,
                prefix: const Icon(
                  Icons.person_off_rounded,
                  color: AppColors.danger,
                ),
                title: Text(context.l10n.closeAccount),
                subtitle: Text(context.l10n.closeAccountTileDescription),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AppActionButton(
                  onPressed: _closingAccount ? null : _closeAccount,
                  icon: Icons.person_remove_rounded,
                  label: context.l10n.close,
                  wrapLabel: true,
                  style: AppActionButtonStyle.destructive,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
