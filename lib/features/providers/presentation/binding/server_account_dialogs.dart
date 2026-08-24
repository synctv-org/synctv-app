part of 'platform_binding_dialog.dart';

enum _NextcloudLoginMode { browser, appPassword }

class _NextcloudAccountDialog extends StatefulWidget {
  const _NextcloudAccountDialog({
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  @override
  State<_NextcloudAccountDialog> createState() =>
      _NextcloudAccountDialogState();
}

class _NextcloudAccountDialogState extends State<_NextcloudAccountDialog> {
  final _endpointController = TextEditingController();
  final _usernameController = TextEditingController();
  final _appPasswordController = TextEditingController();
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  _NextcloudLoginMode _mode = _NextcloudLoginMode.browser;
  bool _loadingInstances = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _usernameController.dispose();
    _appPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadInstances() async {
    try {
      final names = await widget.instanceNamesLoader();
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(names);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingInstances = false);
      AppNotifications.showError(
        context,
        context.l10n.loadMediaSourceInstancesFailed('$error'),
      );
    }
  }

  Future<void> _submit() {
    return switch (_mode) {
      _NextcloudLoginMode.browser => _loginWithBrowser(),
      _NextcloudLoginMode.appPassword => _loginWithAppPassword(),
    };
  }

  Future<void> _loginWithAppPassword() async {
    if (_endpointController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _appPasswordController.text.isEmpty) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }
    setState(() => _submitting = true);
    try {
      await providerGateway.loginNextcloud(
        endpoint: _endpointController.text,
        username: _usernameController.text,
        appPassword: _appPasswordController.text,
        instanceName: _instanceName,
      );
      _completeLogin();
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.bindingFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _loginWithBrowser() async {
    final endpoint = _endpointController.text.trim();
    if (endpoint.isEmpty) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }
    setState(() => _submitting = true);
    try {
      final flow = await providerGateway.startNextcloudLoginFlow(endpoint);
      final loginUri = Uri.parse(flow.loginUrl);
      final launched = await launchUrl(
        loginUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) throw StateError('Unable to open Nextcloud login');

      Object? lastError;
      for (var attempt = 0; attempt < 90 && mounted; attempt++) {
        try {
          await providerGateway.pollNextcloudLoginFlow(
            endpoint: endpoint,
            flow: flow,
            instanceName: _instanceName,
          );
          _completeLogin();
          return;
        } catch (error) {
          lastError = error;
          await Future<void>.delayed(const Duration(seconds: 2));
        }
      }
      if (mounted) {
        throw StateError('Nextcloud login timed out: $lastError');
      }
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.bindingFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _completeLogin() {
    if (!mounted) return;
    Navigator.pop(context);
    AppNotifications.showSuccess(context, context.l10n.boundSuccessfully);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF0082C9);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 560),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppSingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProviderFormSection(
                    icon: Icons.hub_outlined,
                    title: context.l10n.connectionTarget,
                    color: color,
                    children: [
                      _ProviderInstanceSelector(
                        instanceNames: _instanceNames,
                        selected: _instanceName,
                        loading: _loadingInstances,
                        onChanged: (value) =>
                            setState(() => _instanceName = value),
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'Nextcloud URL',
                        controller: _endpointController,
                        hintText: 'https://cloud.example.com',
                        prefixIcon: Icons.dns_outlined,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppSegmentedControl<_NextcloudLoginMode>(
                    segments: const [
                      ButtonSegment(
                        value: _NextcloudLoginMode.browser,
                        icon: Icon(Icons.open_in_browser_rounded),
                        label: Text('Browser'),
                      ),
                      ButtonSegment(
                        value: _NextcloudLoginMode.appPassword,
                        icon: Icon(Icons.key_rounded),
                        label: Text('App password'),
                      ),
                    ],
                    value: _mode,
                    onChanged: (value) {
                      if (_submitting) return;
                      setState(() => _mode = value);
                    },
                  ),
                  if (_mode == _NextcloudLoginMode.appPassword) ...[
                    const SizedBox(height: 14),
                    _ProviderFormSection(
                      icon: Icons.key_rounded,
                      title: context.l10n.loginCredentials,
                      color: color,
                      children: [
                        AppDialogs.createFormField(
                          context: context,
                          label: context.l10n.username,
                          controller: _usernameController,
                          prefixIcon: Icons.person_outline_rounded,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 12),
                        AppDialogs.createFormField(
                          context: context,
                          label: 'App password',
                          controller: _appPasswordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _DialogActions(
            isLoading: _submitting,
            onSubmit: _submit,
            submitText: _mode == _NextcloudLoginMode.browser
                ? 'Open browser'
                : context.l10n.login,
          ),
        ],
      ),
    );
  }
}

class _SynologyAccountDialog extends StatefulWidget {
  const _SynologyAccountDialog({
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  @override
  State<_SynologyAccountDialog> createState() => _SynologyAccountDialogState();
}

class _SynologyAccountDialogState extends State<_SynologyAccountDialog> {
  final _endpointController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final _deviceController = TextEditingController(text: 'SyncTV');
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _loadingInstances = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _deviceController.dispose();
    super.dispose();
  }

  Future<void> _loadInstances() async {
    try {
      final names = await widget.instanceNamesLoader();
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(names);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingInstances = false);
      AppNotifications.showError(
        context,
        context.l10n.loadMediaSourceInstancesFailed('$error'),
      );
    }
  }

  Future<void> _submit() async {
    if (_endpointController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }
    setState(() => _submitting = true);
    try {
      await providerGateway.loginSynology(
        endpoint: _endpointController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        otpCode: _otpController.text,
        deviceName: _deviceController.text,
        instanceName: _instanceName,
      );
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, context.l10n.boundSuccessfully);
      widget.onSuccess();
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.bindingFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF1578D3);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 560),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppSingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProviderFormSection(
                    icon: Icons.hub_outlined,
                    title: context.l10n.connectionTarget,
                    color: color,
                    children: [
                      _ProviderInstanceSelector(
                        instanceNames: _instanceNames,
                        selected: _instanceName,
                        loading: _loadingInstances,
                        onChanged: (value) =>
                            setState(() => _instanceName = value),
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'DSM URL',
                        controller: _endpointController,
                        hintText: 'https://nas.example.com:5001',
                        prefixIcon: Icons.dns_outlined,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _ProviderFormSection(
                    icon: Icons.key_rounded,
                    title: context.l10n.loginCredentials,
                    color: color,
                    children: [
                      AppDialogs.createFormField(
                        context: context,
                        label: context.l10n.username,
                        controller: _usernameController,
                        prefixIcon: Icons.person_outline_rounded,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: context.l10n.password,
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'OTP',
                        controller: _otpController,
                        prefixIcon: Icons.password_rounded,
                        keyboardType: TextInputType.number,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'Device name',
                        controller: _deviceController,
                        prefixIcon: Icons.devices_rounded,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _DialogActions(
            isLoading: _submitting,
            onSubmit: _submit,
            submitText: context.l10n.login,
          ),
        ],
      ),
    );
  }
}

class _QnapAccountDialog extends StatefulWidget {
  const _QnapAccountDialog({
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  @override
  State<_QnapAccountDialog> createState() => _QnapAccountDialogState();
}

class _QnapAccountDialogState extends State<_QnapAccountDialog> {
  final _endpointController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _loadingInstances = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadInstances() async {
    try {
      final names = await widget.instanceNamesLoader();
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(names);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingInstances = false);
      AppNotifications.showError(
        context,
        context.l10n.loadMediaSourceInstancesFailed('$error'),
      );
    }
  }

  Future<void> _submit() async {
    if (_endpointController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }
    setState(() => _submitting = true);
    try {
      await providerGateway.loginQnap(
        endpoint: _endpointController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        instanceName: _instanceName,
      );
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, context.l10n.boundSuccessfully);
      widget.onSuccess();
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.bindingFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF0076A8);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 520),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppSingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProviderFormSection(
                    icon: Icons.hub_outlined,
                    title: context.l10n.connectionTarget,
                    color: color,
                    children: [
                      _ProviderInstanceSelector(
                        instanceNames: _instanceNames,
                        selected: _instanceName,
                        loading: _loadingInstances,
                        onChanged: (value) =>
                            setState(() => _instanceName = value),
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'QNAP URL',
                        controller: _endpointController,
                        hintText: 'https://nas.example.com:443',
                        prefixIcon: Icons.dns_outlined,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _ProviderFormSection(
                    icon: Icons.key_rounded,
                    title: context.l10n.loginCredentials,
                    color: color,
                    children: [
                      AppDialogs.createFormField(
                        context: context,
                        label: context.l10n.username,
                        controller: _usernameController,
                        prefixIcon: Icons.person_outline_rounded,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: context.l10n.password,
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _DialogActions(
            isLoading: _submitting,
            onSubmit: _submit,
            submitText: context.l10n.login,
          ),
        ],
      ),
    );
  }
}

class _FnosAccountDialog extends StatefulWidget {
  const _FnosAccountDialog({
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  @override
  State<_FnosAccountDialog> createState() => _FnosAccountDialogState();
}

class _FnosAccountDialogState extends State<_FnosAccountDialog> {
  final _endpointController = TextEditingController();
  final _webdavController = TextEditingController();
  final _mediaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _twoFactorController = TextEditingController();
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _loadingInstances = true;
  bool _submitting = false;
  bool _twoFactorRequired = false;
  bool _trustDevice = true;

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _webdavController.dispose();
    _mediaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _twoFactorController.dispose();
    super.dispose();
  }

  Future<void> _loadInstances() async {
    try {
      final names = await widget.instanceNamesLoader();
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(names);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingInstances = false);
      AppNotifications.showError(
        context,
        context.l10n.loadMediaSourceInstancesFailed('$error'),
      );
    }
  }

  Future<void> _submit() async {
    if (_endpointController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        (_twoFactorRequired && _twoFactorController.text.trim().length != 6)) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }
    setState(() => _submitting = true);
    try {
      final result = await providerGateway.loginFnos(
        endpoint: _endpointController.text,
        webdavEndpoint: _webdavController.text,
        mediaEndpoint: _mediaController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        twoFactorCode: _twoFactorController.text,
        trustDevice: _trustDevice,
        instanceName: _instanceName,
      );
      if (!mounted) return;
      switch (result) {
        case FnosAuthenticatedInfo():
          Navigator.pop(context);
          AppNotifications.showSuccess(context, context.l10n.boundSuccessfully);
          widget.onSuccess();
        case FnosTwoFactorRequiredInfo():
          setState(() => _twoFactorRequired = true);
      }
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.bindingFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF087F5B);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 620),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppSingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProviderFormSection(
                    icon: Icons.hub_outlined,
                    title: context.l10n.connectionTarget,
                    color: color,
                    children: [
                      _ProviderInstanceSelector(
                        instanceNames: _instanceNames,
                        selected: _instanceName,
                        loading: _loadingInstances,
                        onChanged: (value) =>
                            setState(() => _instanceName = value),
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'FNOS WebSocket / Host',
                        controller: _endpointController,
                        prefixIcon: Icons.dns_outlined,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'WebDAV URL',
                        controller: _webdavController,
                        prefixIcon: Icons.folder_shared_outlined,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'Media API URL',
                        controller: _mediaController,
                        prefixIcon: Icons.video_library_outlined,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _ProviderFormSection(
                    icon: Icons.key_rounded,
                    title: context.l10n.loginCredentials,
                    color: color,
                    children: [
                      AppDialogs.createFormField(
                        context: context,
                        label: context.l10n.username,
                        controller: _usernameController,
                        prefixIcon: Icons.person_outline_rounded,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: context.l10n.password,
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      if (_twoFactorRequired) ...[
                        const SizedBox(height: 12),
                        AppDialogs.createFormField(
                          context: context,
                          label: '2FA',
                          controller: _twoFactorController,
                          prefixIcon: Icons.shield_outlined,
                          keyboardType: TextInputType.number,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 8),
                        AppSwitchTile(
                          value: _trustDevice,
                          onChanged: (value) =>
                              setState(() => _trustDevice = value),
                          title: const Text('Trust device'),
                          prefix: const Icon(Icons.verified_user_outlined),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _DialogActions(
            isLoading: _submitting,
            onSubmit: _submit,
            submitText: context.l10n.login,
          ),
        ],
      ),
    );
  }
}

class EmbyAccountBindingForm extends StatelessWidget {
  const EmbyAccountBindingForm({
    super.key,
    required this.instanceNamesLoader,
    required this.onSuccess,
    this.onBind,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;
  final Future<void> Function({
    required String host,
    required String username,
    required String password,
    required String apiKey,
    required bool passwordless,
    required String instanceName,
  })?
  onBind;

  @override
  Widget build(BuildContext context) {
    return _PasswordAccountDialog(
      kind: _ProviderKind.emby,
      instanceNamesLoader: instanceNamesLoader,
      onSuccess: onSuccess,
      onLoginEmby: onBind,
    );
  }
}

class _PasswordAccountDialog extends StatefulWidget {
  final _ProviderKind kind;
  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;
  final Future<void> Function({
    required String host,
    required String username,
    required String password,
    required String apiKey,
    required bool passwordless,
    required String instanceName,
  })?
  onLoginEmby;

  const _PasswordAccountDialog({
    required this.kind,
    required this.instanceNamesLoader,
    required this.onSuccess,
    this.onLoginEmby,
  });

  @override
  State<_PasswordAccountDialog> createState() => _PasswordAccountDialogState();
}

class _PasswordAccountDialogState extends State<_PasswordAccountDialog> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secretController = TextEditingController();
  final _otpCodeController = TextEditingController();
  final _otpSecretController = TextEditingController();
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  _EmbyCredentialMode _embyCredentialMode = _EmbyCredentialMode.password;
  bool _loadingInstances = true;
  bool _isLoading = false;

  bool get _isAlist => widget.kind == _ProviderKind.alist;
  bool get _isEmby => widget.kind == _ProviderKind.emby;
  bool get _isCloudreve => widget.kind == _ProviderKind.cloudreve;
  bool get _isTrueNas => widget.kind == _ProviderKind.truenas;
  bool get _isEmbyCredentialMissing => switch (_embyCredentialMode) {
    _EmbyCredentialMode.password => _passwordController.text.isEmpty,
    _EmbyCredentialMode.apiKey => _secretController.text.trim().isEmpty,
    _EmbyCredentialMode.passwordless => false,
  };
  String get _label => switch (widget.kind) {
    _ProviderKind.alist => 'AList',
    _ProviderKind.cloudreve => 'Cloudreve',
    _ProviderKind.emby => 'Emby',
    _ProviderKind.bilibili => 'Bilibili',
    _ProviderKind.twitch => 'Twitch',
    _ProviderKind.fnos => 'FNOS',
    _ProviderKind.qnap => 'QNAP',
    _ProviderKind.synology => 'Synology DSM',
    _ProviderKind.nextcloud => 'Nextcloud',
    _ProviderKind.seafile => 'Seafile',
    _ProviderKind.truenas => 'TrueNAS',
    _ProviderKind.youtube => 'YouTube',
    _ProviderKind.douyin => 'Douyin',
    _ProviderKind.tiktok => 'TikTok',
  };

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _secretController.dispose();
    _otpCodeController.dispose();
    _otpSecretController.dispose();
    super.dispose();
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
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingInstances = false);
      AppNotifications.showError(
        context,
        context.l10n.loadMediaSourceInstancesFailed('$e'),
      );
    }
  }

  Future<void> _submit() async {
    final host = _normalizeProviderHost(
      _hostController.text,
      port: _portController.text,
    );
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final apiKey = _secretController.text.trim();
    final otpCode = _otpCodeController.text.trim();
    final otpSecret = _otpSecretController.text.trim();

    if (host.isEmpty ||
        (_isTrueNas
            ? apiKey.isEmpty
            : username.isEmpty ||
                  (_isEmby ? _isEmbyCredentialMissing : password.isEmpty))) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isAlist) {
        await providerGateway.loginAList(
          host,
          username,
          _hashAlistPassword(password),
          otpCode: otpCode,
          otpSecret: otpSecret,
          instanceName: _instanceName,
        );
      } else if (_isCloudreve) {
        await providerGateway.loginCloudreve(
          host,
          username,
          password,
          instanceName: _instanceName,
        );
      } else if (widget.kind == _ProviderKind.seafile) {
        await providerGateway.loginSeafile(
          endpoint: host,
          username: username,
          password: password,
          instanceName: _instanceName,
        );
      } else if (_isTrueNas) {
        await providerGateway.loginTrueNas(
          endpoint: host,
          apiKey: apiKey,
          instanceName: _instanceName,
        );
      } else if (_isEmby) {
        final passwordless =
            _embyCredentialMode == _EmbyCredentialMode.passwordless;
        final selectedApiKey = _embyCredentialMode == _EmbyCredentialMode.apiKey
            ? apiKey
            : '';
        if (widget.onLoginEmby case final login?) {
          await login(
            host: host,
            username: username,
            password: passwordless ? '' : password,
            apiKey: selectedApiKey,
            passwordless: passwordless,
            instanceName: _instanceName,
          );
        } else {
          await providerGateway.loginEmbyInfo(
            host,
            username,
            passwordless ? '' : password,
            apiKey: selectedApiKey,
            passwordless: passwordless,
            instanceName: _instanceName,
          );
        }
      }
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, context.l10n.boundSuccessfully);
      widget.onSuccess();
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.bindingFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _normalizeProviderHost(String value, {String port = ''}) {
    final input = value.trim();
    final normalized = switch (input) {
      final value when !value.contains('://') && value.isNotEmpty =>
        'http://$value',
      _ => input,
    };
    final parsed = Uri.tryParse(normalized);
    final trimmedPort = port.trim();
    if (trimmedPort.isEmpty || parsed == null || parsed.hasPort) {
      return normalized;
    }
    return parsed.replace(port: int.tryParse(trimmedPort)).toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final providerColor = _isTrueNas
        ? const Color(0xFF0095D5)
        : _isAlist
        ? Colors.amber
        : _isCloudreve
        ? Colors.teal
        : Colors.green;
    final availableHeight = AppMetrics.dialogMaxHeight(context, null);
    final maxHeight = (availableHeight * 0.70).clamp(
      420.0,
      _isAlist ? 540.0 : 500.0,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppSingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isAlist)
                    _ProviderNotice(
                      icon: Icons.warning_amber_rounded,
                      text: context.l10n.alistVersionRequirement,
                      color: Colors.amber,
                    ),
                  _ProviderFormSection(
                    icon: Icons.hub_outlined,
                    title: context.l10n.connectionTarget,
                    color: providerColor,
                    children: [
                      _ProviderInstanceSelector(
                        instanceNames: _instanceNames,
                        selected: _instanceName,
                        loading: _loadingInstances,
                        onChanged: (value) =>
                            setState(() => _instanceName = value),
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        key: _isEmby ? const Key('emby-bind-host') : null,
                        context: context,
                        label: context.l10n.providerAddress(_label),
                        controller: _hostController,
                        hintText: context.l10n.providerAddressHint,
                        prefixIcon: Icons.link_rounded,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        key: _isEmby ? const Key('emby-bind-port') : null,
                        context: context,
                        label: context.l10n.port,
                        controller: _portController,
                        hintText: _isTrueNas
                            ? '443'
                            : _isAlist
                            ? '5244'
                            : _isCloudreve
                            ? '5212'
                            : '8096',
                        prefixIcon: Icons.settings_ethernet_rounded,
                        keyboardType: TextInputType.number,
                        enableSuggestions: false,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _ProviderFormSection(
                    icon: Icons.person_outline_rounded,
                    title: context.l10n.loginCredentials,
                    color: providerColor,
                    children: [
                      if (!_isTrueNas) ...[
                        AppDialogs.createFormField(
                          key: _isEmby ? const Key('emby-bind-username') : null,
                          context: context,
                          label: _isCloudreve ? 'Email' : context.l10n.username,
                          controller: _usernameController,
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_isEmby) ...[
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 360;
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: AppSegmentedControl<_EmbyCredentialMode>(
                                key: const Key('emby-bind-credential-mode'),
                                segments: [
                                  ButtonSegment(
                                    value: _EmbyCredentialMode.password,
                                    icon: const Icon(
                                      Icons.lock_outline_rounded,
                                    ),
                                    label: compact
                                        ? null
                                        : Text(context.l10n.password),
                                    tooltip: context.l10n.password,
                                  ),
                                  ButtonSegment(
                                    value: _EmbyCredentialMode.apiKey,
                                    icon: const Icon(Icons.key_rounded),
                                    label: compact
                                        ? null
                                        : const Text('API Key'),
                                    tooltip: 'API Key',
                                  ),
                                  ButtonSegment(
                                    value: _EmbyCredentialMode.passwordless,
                                    icon: const Icon(Icons.lock_open_rounded),
                                    label: compact
                                        ? null
                                        : Text(context.l10n.noPassword),
                                    tooltip: context.l10n.noPassword,
                                  ),
                                ],
                                value: _embyCredentialMode,
                                onChanged: (selected) => setState(
                                  () => _embyCredentialMode = selected,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                      if ((_isEmby &&
                              _embyCredentialMode ==
                                  _EmbyCredentialMode.apiKey) ||
                          _isTrueNas)
                        AppDialogs.createFormField(
                          key: _isEmby ? const Key('emby-bind-api-key') : null,
                          context: context,
                          label: 'API Key',
                          controller: _secretController,
                          prefixIcon: Icons.key_rounded,
                          obscureText: true,
                        )
                      else if (!_isEmby ||
                          _embyCredentialMode == _EmbyCredentialMode.password)
                        AppDialogs.createFormField(
                          key: _isEmby ? const Key('emby-bind-password') : null,
                          context: context,
                          label: context.l10n.password,
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: true,
                        ),
                    ],
                  ),
                  if (_isAlist) ...[
                    const SizedBox(height: 14),
                    _ProviderFormSection(
                      icon: Icons.shield_outlined,
                      title: context.l10n.twoFactorAuthentication,
                      color: theme.colorScheme.secondary,
                      children: [
                        AppDialogs.createFormField(
                          context: context,
                          label: context.l10n.oneTimeCode,
                          controller: _otpCodeController,
                          hintText: context.l10n.oneTimeCodeHint,
                          prefixIcon: Icons.pin_outlined,
                        ),
                        const SizedBox(height: 12),
                        AppDialogs.createFormField(
                          context: context,
                          label: 'TOTP Secret',
                          controller: _otpSecretController,
                          hintText: context.l10n.totpSecretHint,
                          prefixIcon: Icons.shield_outlined,
                          obscureText: true,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          AppDivider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 2),
            child: _DialogActions(
              isLoading: _isLoading,
              onSubmit: _submit,
              submitText: context.l10n.login,
            ),
          ),
        ],
      ),
    );
  }
}
