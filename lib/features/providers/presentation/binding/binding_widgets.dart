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
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
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

class _BilibiliLoginDialogState extends State<_BilibiliLoginDialog>
    with SingleTickerProviderStateMixin {
  Timer? _pollTimer;
  late final TabController _loginTabController;
  String _url = '';
  String _key = '';
  String _statusText = '';
  bool _isLoading = false;
  bool _checkingStatus = false;
  bool _isExpired = false;
  bool _qrStarted = false;
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _loadingInstances = true;
  int _activeLoginTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loginTabController = TabController(length: 2, vsync: this);
    _loginTabController.addListener(_handleLoginTabChanged);
    _loadInstances();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _loginTabController
      ..removeListener(_handleLoginTabChanged)
      ..dispose();
    super.dispose();
  }

  void _handleLoginTabChanged() {
    final nextIndex = _loginTabController.index;
    if (nextIndex == _activeLoginTabIndex) return;
    _activeLoginTabIndex = nextIndex;
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
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(remoteInstances);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
      if (_loginTabController.index == 0 && !_qrStarted) {
        await _startLogin();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingInstances = false;
        _statusText = context.l10n.loadMediaSourceInstancesFailed('$e');
        _isLoading = false;
      });
    }
  }

  Future<void> _startLogin() async {
    _pauseQrPolling();
    setState(() {
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
      if (!mounted) return;
      setState(() {
        _url = response.url;
        _key = response.key;
        _statusText = context.l10n.completeBilibiliLogin;
        _isLoading = false;
      });
      _resumeQrPolling();
      await _checkStatus();
    } catch (e) {
      if (!mounted) return;
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
    if (!mounted ||
        _loginTabController.index != 0 ||
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
    if (_key.isEmpty ||
        _checkingStatus ||
        _loginTabController.index != 0 ||
        _isExpired) {
      return;
    }
    _checkingStatus = true;
    try {
      final status = await providerGateway.checkBilibiliQrLogin(
        _key,
        instanceName: _instanceName,
      );
      if (!mounted) return;
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
      if (!mounted) return;
      if (_isRateLimitError(e)) {
        _pollTimer?.cancel();
        setState(() => _statusText = context.l10n.bilibiliStatusRateLimited);
        return;
      }
      setState(() => _statusText = context.l10n.checkLoginStatusFailed('$e'));
    } finally {
      _checkingStatus = false;
    }
  }

  bool _isRateLimitError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('429') ||
        text.contains('too many requests') ||
        text.contains('rate limit');
  }

  Future<void> _openLoginUrl() async {
    if (_url.isEmpty) return;
    final uri = Uri.parse(_url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      AppNotifications.showError(context, context.l10n.openLoginLinkFailed);
    }
  }

  Future<void> _copyLoginUrl() async {
    if (_url.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _url));
    if (mounted) {
      AppNotifications.showSuccess(context, context.l10n.loginLinkCopied);
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
              if (value == _instanceName) return;
              _pauseQrPolling();
              setState(() {
                _instanceName = value;
                _qrStarted = false;
                _url = '';
                _key = '';
                _isExpired = false;
                _isLoading = false;
                _statusText = context.l10n.switchToQrPrompt;
              });
              if (_loginTabController.index == 0) _startLogin();
            },
          ),
          const SizedBox(height: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppPanelSurface(
                height: 48,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
                child: AppTabBar(
                  controller: _loginTabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      height: 48,
                      icon: const Icon(Icons.qr_code_2_rounded),
                      text: context.l10n.qrCode,
                    ),
                    Tab(
                      height: 48,
                      icon: const Icon(Icons.sms_rounded),
                      text: context.l10n.verificationCode,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 374,
                child: AppTabBarView(
                  controller: _loginTabController,
                  children: [
                    _buildQrLogin(Theme.of(context)),
                    AnimatedBuilder(
                      animation: _loginTabController,
                      builder: (context, _) {
                        return _BilibiliSmsLoginPanel(
                          key: ValueKey(_instanceName),
                          instanceName: _instanceName,
                          active: _loginTabController.index == 1,
                          onSuccess: () {
                            AppNotifications.showSuccess(
                              context,
                              context.l10n.boundSuccessfully,
                            );
                            widget.onSuccess();
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
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
                onTap: _url.isEmpty ? null : _copyLoginUrl,
              ),
              _SecondaryActionButton(
                icon: Icons.open_in_new_rounded,
                label: context.l10n.openLogin,
                onTap: _url.isEmpty ? null : _openLoginUrl,
              ),
              if (_isExpired)
                _SecondaryActionButton(
                  icon: Icons.refresh_rounded,
                  label: context.l10n.regenerate,
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

class _BilibiliSmsLoginPanel extends StatefulWidget {
  final String instanceName;
  final bool active;
  final VoidCallback onSuccess;

  const _BilibiliSmsLoginPanel({
    super.key,
    required this.instanceName,
    required this.active,
    required this.onSuccess,
  });

  @override
  State<_BilibiliSmsLoginPanel> createState() => _BilibiliSmsLoginPanelState();
}

class _BilibiliSmsLoginPanelState extends State<_BilibiliSmsLoginPanel> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  BilibiliSmsLoginInfo? _session;
  String _statusText = '';
  bool _starting = false;
  bool _sending = false;
  bool _loggingIn = false;
  bool _smsSent = false;

  bool get _busy => _starting || _sending || _loggingIn;

  @override
  void initState() {
    super.initState();
    if (widget.active) _startSession();
  }

  @override
  void didUpdateWidget(covariant _BilibiliSmsLoginPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.instanceName != widget.instanceName) {
      setState(() {
        _smsSent = false;
        _session = null;
        _statusText = widget.active
            ? context.l10n.preparingSecurityVerification
            : context.l10n.switchToCodePrompt;
        _starting = widget.active;
        _sending = false;
        _loggingIn = false;
      });
      if (widget.active) _startSession();
      return;
    }
    if (!oldWidget.active && widget.active && _session == null && !_starting) {
      _startSession();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    setState(() {
      _starting = true;
      _smsSent = false;
      _session = null;
      _statusText = context.l10n.preparingSecurityVerification;
    });
    try {
      final session = await providerGateway.startBilibiliSmsLogin(
        instanceName: widget.instanceName,
      );
      if (!mounted) return;
      setState(() {
        _session = session;
        _starting = false;
        _statusText = context.l10n.enterPhoneForSecurityVerification;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _statusText = context.l10n.prepareSecurityVerificationFailed('$e');
      });
    }
  }

  Future<void> _sendSms() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterPhoneNumber);
      return;
    }
    var session = _session;
    if (session == null) {
      await _startSession();
      if (!mounted) return;
      session = _session;
    }
    if (session == null) return;

    setState(() {
      _sending = true;
      _statusText = context.l10n.completeBilibiliSecurityVerification;
    });

    try {
      final result = await BilibiliGeetestService.verify(
        context,
        gt: session.gt,
        challenge: session.challenge,
      );
      final nextSession = await providerGateway.sendBilibiliSms(
        session: session,
        phone: phone,
        validate: result.validate,
      );
      if (!mounted) return;
      setState(() {
        _session = nextSession;
        _sending = false;
        _smsSent = true;
        _statusText = context.l10n.smsCodeSent;
      });
    } catch (e) {
      if (!mounted) return;
      final expired = _isExpiredSessionError(e);
      setState(() {
        _sending = false;
        if (expired) {
          _session = null;
          _smsSent = false;
          _statusText = context.l10n.verificationSessionExpired;
        } else {
          _statusText = context.l10n.sendSmsFailed('$e');
        }
      });
    }
  }

  Future<void> _login() async {
    final session = _session;
    final code = _codeController.text.trim();
    if (session == null) {
      AppNotifications.showWarning(context, context.l10n.sendSmsFirst);
      return;
    }
    if (code.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterSmsCode);
      return;
    }

    setState(() {
      _loggingIn = true;
      _statusText = context.l10n.completingBilibiliBinding;
    });
    try {
      await providerGateway.loginBilibiliSms(
        sessionToken: session.sessionToken,
        code: code,
      );
      if (!mounted) return;
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      final expired = _isExpiredSessionError(e);
      setState(() {
        _loggingIn = false;
        if (expired) {
          _session = null;
          _smsSent = false;
          _statusText = context.l10n.loginSessionExpired;
        } else {
          _statusText = context.l10n.bindingFailed('$e');
        }
      });
    }
  }

  bool _isExpiredSessionError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('invalid or expired') ||
        text.contains('expired') ||
        text.contains('session');
  }

  @override
  Widget build(BuildContext context) {
    return AppSingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInfoBanner(
            padding: const EdgeInsets.all(10),
            icon: Icons.sms_rounded,
            color: const Color(0xFFFB7299),
            backgroundColor: const Color(0xFFFB7299).withValues(alpha: 0.1),
            border: Border.all(
              color: const Color(0xFFFB7299).withValues(alpha: 0.2),
            ),
            iconSize: 22,
            title: Text(
              _statusText.isEmpty
                  ? context.l10n.switchToCodePrompt
                  : _statusText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: _busy
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
          AppDialogs.createFormField(
            context: context,
            label: context.l10n.phoneNumber,
            controller: _phoneController,
            hintText: context.l10n.bilibiliPhoneHint,
            prefixIcon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),
          AppDialogs.createFormField(
            context: context,
            label: context.l10n.smsVerificationCode,
            controller: _codeController,
            hintText: _smsSent
                ? context.l10n.enterReceivedCode
                : context.l10n.enterCodeAfterSms,
            prefixIcon: Icons.pin_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            children: [
              _SecondaryActionButton(
                icon: Icons.refresh_rounded,
                label: context.l10n.verifyAgain,
                onTap: _busy ? null : _startSession,
              ),
              _SecondaryActionButton(
                icon: Icons.send_to_mobile_rounded,
                label: context.l10n.sendSms,
                onTap: _busy ? null : _sendSms,
              ),
              AppActionButton(
                onPressed: _busy ? null : _login,
                icon: Icons.login_rounded,
                label: context.l10n.bind,
                loading: _loggingIn,
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
  final ValueChanged<String> onChanged;

  const _ProviderInstanceSelector({
    required this.instanceNames,
    required this.selected,
    required this.loading,
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
      prefixIcon: loading ? null : Icons.account_tree_rounded,
      options: {
        for (final instanceName in instanceNames)
          _providerInstanceLabel(instanceName, context.l10n.localInstance):
              instanceName,
      },
      enabled: !loading,
      onChanged: loading ? null : (value) => onChanged(value ?? ''),
    );
  }
}

class _AccountInfoView extends StatelessWidget {
  final List<(String, String)> rows;

  const _AccountInfoView({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows) ...[
          _InfoRow(label: row.$1, value: row.$2),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: TextStyle(color: theme.hintColor)),
        ),
        Expanded(
          child: AppSelectableText(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
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
          Text(
            label,
            style: TextStyle(
              color: enabled ? theme.primaryColor : theme.disabledColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
