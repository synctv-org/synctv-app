part of 'platform_binding_dialog.dart';

class _ProviderNotice extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ProviderNotice({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppInfoBanner(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      icon: icon,
      iconSize: 18,
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
      border: Border.all(color: color.withValues(alpha: 0.24)),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ProviderFormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<Widget> children;

  const _ProviderFormSection({
    required this.icon,
    required this.title,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _BilibiliLoginDialog extends StatefulWidget {
  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  const _BilibiliLoginDialog({
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  @override
  State<_BilibiliLoginDialog> createState() => _BilibiliLoginDialogState();
}

class _BilibiliLoginDialogState extends State<_BilibiliLoginDialog> {
  Timer? _pollTimer;
  String _url = '';
  String _key = '';
  String _statusText = '';
  bool _isLoading = false;
  bool _checkingStatus = false;
  int _loginGeneration = 0;
  bool _isExpired = false;
  bool _qrStarted = false;
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _loadingInstances = true;
  int _activeLoginTabIndex = 0;
  int _linkActionGeneration = 0;
  bool _openingLink = false;
  bool _copyingLink = false;

  bool get _isCurrent => mounted && ModalRoute.of(context)?.isCurrent == true;

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _handleLoginTabChanged(int nextIndex) {
    if (!_isCurrent) return;
    if (nextIndex == _activeLoginTabIndex) return;
    setState(() {
      _activeLoginTabIndex = nextIndex;
      _invalidateLinkActions();
    });
    if (nextIndex == 0) {
      if (!_qrStarted && !_loadingInstances) {
        _startLogin();
      } else {
        _resumeQrPolling();
      }
    } else {
      _pauseQrPolling();
    }
  }

  Future<void> _loadInstances() async {
    try {
      final remoteInstances = await widget.instanceNamesLoader();
      if (!_isCurrent) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(remoteInstances);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
      if (_activeLoginTabIndex == 0 && !_qrStarted) {
        await _startLogin();
      }
    } catch (e) {
      if (!_isCurrent) return;
      setState(() {
        _loadingInstances = false;
        _statusText = context.l10n.loadMediaSourceInstancesFailed('$e');
        _isLoading = false;
      });
    }
  }

  Future<void> _startLogin() async {
    if (!_isCurrent || _loadingInstances || _isLoading) return;
    final generation = ++_loginGeneration;
    _checkingStatus = false;
    _pauseQrPolling();
    setState(() {
      _invalidateLinkActions();
      _qrStarted = true;
      _url = '';
      _key = '';
      _statusText = context.l10n.creatingLoginLink;
      _isLoading = true;
      _isExpired = false;
    });

    try {
      final response = await providerGateway.startBilibiliQrLogin(
        instanceName: _instanceName,
      );
      if (!_isCurrent || generation != _loginGeneration) return;
      setState(() {
        _url = response.url;
        _key = response.key;
        _statusText = context.l10n.completeBilibiliLogin;
        _isLoading = false;
      });
      _resumeQrPolling();
      await _checkStatus();
    } catch (e) {
      if (!_isCurrent || generation != _loginGeneration) return;
      setState(() {
        _statusText = context.l10n.createLoginLinkFailed('$e');
        _isLoading = false;
      });
    }
  }

  void _pauseQrPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void _resumeQrPolling() {
    if (!_isCurrent ||
        _activeLoginTabIndex != 0 ||
        _key.isEmpty ||
        _isExpired ||
        _pollTimer != null) {
      return;
    }
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkStatus(),
    );
  }

  Future<void> _checkStatus() async {
    if (!_isCurrent ||
        _key.isEmpty ||
        _checkingStatus ||
        _activeLoginTabIndex != 0 ||
        _isExpired) {
      return;
    }
    _checkingStatus = true;
    final generation = _loginGeneration;
    try {
      final status = await providerGateway.checkBilibiliQrLogin(
        _key,
        instanceName: _instanceName,
      );
      if (!mounted ||
          !_isCurrent ||
          generation != _loginGeneration ||
          _activeLoginTabIndex != 0) {
        return;
      }
      switch (status) {
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_SUCCESS:
          _pollTimer?.cancel();
          AppNotifications.showSuccess(context, context.l10n.boundSuccessfully);
          widget.onSuccess();
          Navigator.pop(context);
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_EXPIRED:
          _pollTimer?.cancel();
          setState(() {
            _statusText = context.l10n.loginLinkExpired;
            _isExpired = true;
          });
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_SCANNED:
          setState(() => _statusText = context.l10n.qrScannedConfirmLogin);
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_NOT_SCANNED:
          setState(() => _statusText = context.l10n.waitingForQrScan);
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_UNSPECIFIED:
          setState(() => _statusText = context.l10n.waitingForBilibiliStatus);
      }
    } catch (e) {
      if (!_isCurrent ||
          generation != _loginGeneration ||
          _activeLoginTabIndex != 0) {
        return;
      }
      if (_isRateLimitError(e)) {
        _pollTimer?.cancel();
        setState(() => _statusText = context.l10n.bilibiliStatusRateLimited);
        return;
      }
      setState(() => _statusText = context.l10n.checkLoginStatusFailed('$e'));
    } finally {
      if (generation == _loginGeneration) _checkingStatus = false;
    }
  }

  bool _isRateLimitError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('429') ||
        text.contains('too many requests') ||
        text.contains('rate limit');
  }

  void _invalidateLinkActions() {
    ++_linkActionGeneration;
    _openingLink = false;
    _copyingLink = false;
  }

  bool _isCurrentLinkAction(int generation) =>
      _isCurrent &&
      _activeLoginTabIndex == 0 &&
      generation == _linkActionGeneration;

  Future<void> _openLoginUrl() async {
    if (!_isCurrentLinkAction(_linkActionGeneration) ||
        _url.isEmpty ||
        _openingLink) {
      return;
    }
    final generation = _linkActionGeneration;
    setState(() => _openingLink = true);
    try {
      final opened = await launchUrl(
        Uri.parse(_url),
        mode: LaunchMode.externalApplication,
      );
      if (mounted && !opened && _isCurrentLinkAction(generation)) {
        AppNotifications.showError(context, context.l10n.openLoginLinkFailed);
      }
    } catch (_) {
      if (mounted && _isCurrentLinkAction(generation)) {
        AppNotifications.showError(context, context.l10n.openLoginLinkFailed);
      }
    } finally {
      if (mounted && generation == _linkActionGeneration) {
        setState(() => _openingLink = false);
      }
    }
  }

  Future<void> _copyLoginUrl() async {
    if (!_isCurrentLinkAction(_linkActionGeneration) ||
        _url.isEmpty ||
        _copyingLink) {
      return;
    }
    final generation = _linkActionGeneration;
    setState(() => _copyingLink = true);
    try {
      await Clipboard.setData(ClipboardData(text: _url));
      if (mounted && _isCurrentLinkAction(generation)) {
        AppNotifications.showSuccess(context, context.l10n.loginLinkCopied);
      }
    } catch (error) {
      if (mounted && _isCurrentLinkAction(generation)) {
        AppNotifications.showError(
          context,
          context.l10n.actionFailed(context.l10n.copyLink, '$error'),
        );
      }
    } finally {
      if (mounted && generation == _linkActionGeneration) {
        setState(() => _copyingLink = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProviderInstanceSelector(
            instanceNames: _instanceNames,
            selected: _instanceName,
            loading: _loadingInstances,
            onChanged: (value) {
              if (!_isCurrent || _loadingInstances) return;
              if (value == _instanceName) return;
              ++_loginGeneration;
              _checkingStatus = false;
              _pauseQrPolling();
              setState(() {
                _invalidateLinkActions();
                _instanceName = value;
                _qrStarted = false;
                _url = '';
                _key = '';
                _isExpired = false;
                _isLoading = false;
                _statusText = context.l10n.switchToQrPrompt;
              });
              if (_activeLoginTabIndex == 0) _startLogin();
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final vertical =
                  constraints.maxWidth < 400 ||
                  MediaQuery.textScalerOf(context).scale(14) > 20;
              Widget modeLabel(String text) => ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: vertical
                      ? (constraints.maxWidth - 80).clamp(0.0, double.infinity)
                      : double.infinity,
                ),
                child: Text(text),
              );
              return AppSegmentedControl<int>(
                direction: vertical ? Axis.vertical : Axis.horizontal,
                value: _activeLoginTabIndex,
                onChanged: _handleLoginTabChanged,
                segments: [
                  ButtonSegment(
                    value: 0,
                    icon: const Icon(Icons.qr_code_2_rounded),
                    label: modeLabel(context.l10n.qrCode),
                  ),
                  ButtonSegment(
                    value: 1,
                    icon: const Icon(Icons.sms_rounded),
                    label: modeLabel(context.l10n.verificationCode),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Visibility(
            visible: _activeLoginTabIndex == 0,
            maintainState: true,
            child: _buildQrLogin(Theme.of(context)),
          ),
          Visibility(
            visible: _activeLoginTabIndex == 1,
            maintainState: true,
            child: _BilibiliSmsLoginPanel(
              key: ValueKey(_instanceName),
              instanceName: _instanceName,
              active: _activeLoginTabIndex == 1,
              onSuccess: () {
                if (!_isCurrent || _activeLoginTabIndex != 1) return;
                AppNotifications.showSuccess(
                  context,
                  context.l10n.boundSuccessfully,
                );
                widget.onSuccess();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrLogin(ThemeData theme) {
    return AppSingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInfoBanner(
            padding: const EdgeInsets.all(10),
            icon: _isExpired ? Icons.refresh_rounded : Icons.qr_code_2_rounded,
            color: const Color(0xFFFB7299),
            backgroundColor: const Color(0xFFFB7299).withValues(alpha: 0.1),
            border: Border.all(
              color: const Color(0xFFFB7299).withValues(alpha: 0.2),
            ),
            iconSize: 22,
            title: Text(
              _statusText.isEmpty ? context.l10n.switchToQrPrompt : _statusText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: AppLoadingIndicator(
                      size: AppLoadingSize.sm,
                      centered: false,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 10),
          if (_url.isNotEmpty)
            AppPanelSurface(
              padding: const EdgeInsets.all(10),
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  AppPanelSurface(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    padding: const EdgeInsets.all(8),
                    child: QrImageView(
                      data: _url,
                      version: QrVersions.auto,
                      size: 144,
                      gapless: false,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppSelectableText(
                    _url,
                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            children: [
              _SecondaryActionButton(
                icon: Icons.copy_rounded,
                label: context.l10n.copyLink,
                onTap: _url.isEmpty || _copyingLink ? null : _copyLoginUrl,
              ),
              _SecondaryActionButton(
                icon: Icons.open_in_new_rounded,
                label: context.l10n.openLogin,
                onTap: _url.isEmpty || _openingLink ? null : _openLoginUrl,
              ),
              if (_isExpired || (_qrStarted && !_isLoading && _url.isEmpty))
                _SecondaryActionButton(
                  icon: Icons.refresh_rounded,
                  label: _isExpired
                      ? context.l10n.regenerate
                      : context.l10n.retry,
                  onTap: _startLogin,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: AppDialogs.createCancelButton(context),
          ),
        ],
      ),
    );
  }
}

class _ProviderInstanceSelector extends StatelessWidget {
  final List<String> instanceNames;
  final String selected;
  final bool loading;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _ProviderInstanceSelector({
    required this.instanceNames,
    required this.selected,
    required this.loading,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final value = instanceNames.contains(selected)
        ? selected
        : (instanceNames.isEmpty ? '' : instanceNames.first);
    return AppSelect<String>(
      value: value,
      label: context.l10n.mediaSourceInstance,
      labelAbove: true,
      wrapText: true,
      options: providerInstanceOptions(instanceNames, context.l10n),
      enabled: !loading && enabled,
      onChanged: loading || !enabled ? null : (value) => onChanged(value ?? ''),
    );
  }
}

class _DialogActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;
  final String submitText;

  const _DialogActions({
    required this.isLoading,
    required this.onSubmit,
    required this.submitText,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        AppDialogs.createCancelButton(context),
        isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: AppLoadingIndicator(
                  size: AppLoadingSize.sm,
                  centered: false,
                ),
              )
            : AppDialogs.createConfirmButton(
                context,
                onSubmit,
                text: submitText,
              ),
      ],
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SecondaryActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final theme = Theme.of(context);
    return AppInkSurface(
      color: enabled
          ? theme.primaryColor.withValues(alpha: 0.08)
          : theme.disabledColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: enabled ? theme.primaryColor : theme.disabledColor,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: enabled ? theme.primaryColor : theme.disabledColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
