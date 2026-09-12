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

  bool get _isCurrent => mounted && ModalRoute.of(context)?.isCurrent == true;

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
      if (!_isCurrent) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(names);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
    } catch (error) {
      if (!mounted || !_isCurrent) return;
      setState(() => _loadingInstances = false);
      AppNotifications.showError(
        context,
        context.l10n.loadMediaSourceInstancesFailed('$error'),
      );
    }
  }

  Future<void> _submit() async {
    if (!_isCurrent || _submitting || _loadingInstances) return;
    await switch (_mode) {
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
      if (mounted && _isCurrent) {
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
    final instanceName = _instanceName;
    if (endpoint.isEmpty) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }
    setState(() => _submitting = true);
    try {
      final flow = await providerGateway.startNextcloudLoginFlow(endpoint);
      if (!_isCurrent) return;
      final loginUri = Uri.parse(flow.loginUrl);
      final launched = await launchUrl(
        loginUri,
        mode: LaunchMode.externalApplication,
      );
      if (!_isCurrent) return;
      if (!launched) throw StateError('Unable to open Nextcloud login');

      Object? lastError;
      for (var attempt = 0; attempt < 90 && _isCurrent; attempt++) {
        try {
          await providerGateway.pollNextcloudLoginFlow(
            endpoint: endpoint,
            flow: flow,
            instanceName: instanceName,
          );
          _completeLogin();
          return;
        } catch (error) {
          if (!_isCurrent) return;
          lastError = error;
          await Future<void>.delayed(const Duration(seconds: 2));
        }
      }
      if (_isCurrent) {
        throw StateError('Nextcloud login timed out: $lastError');
      }
    } catch (error) {
      if (mounted && _isCurrent) {
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
    if (!_isCurrent) return;
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
                        enabled: !_submitting,
                        onChanged: (value) {
                          if (!_isCurrent || _submitting) return;
                          setState(() => _instanceName = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: context,
                        label: 'Nextcloud URL',
                        controller: _endpointController,
                        enabled: !_submitting,
                        labelAbove: true,
                        hintText: 'https://cloud.example.com',
                        prefixIcon: Icons.dns_outlined,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final vertical =
                          constraints.maxWidth <
                          MediaQuery.textScalerOf(context).scale(180) + 96;
                      Widget modeLabel(String text) => ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: vertical
                              ? (constraints.maxWidth - 80).clamp(
                                  0.0,
                                  double.infinity,
                                )
                              : double.infinity,
                        ),
                        child: Text(text),
                      );
                      return AppSegmentedControl<_NextcloudLoginMode>(
                        direction: vertical ? Axis.vertical : Axis.horizontal,
                        segments: [
                          ButtonSegment(
                            value: _NextcloudLoginMode.browser,
                            enabled: !_submitting,
                            icon: const Icon(Icons.open_in_browser_rounded),
                            label: modeLabel(context.l10n.browserLogin),
                          ),
                          ButtonSegment(
                            value: _NextcloudLoginMode.appPassword,
                            enabled: !_submitting,
                            icon: const Icon(Icons.key_rounded),
                            label: modeLabel(context.l10n.appPassword),
                          ),
                        ],
                        value: _mode,
                        onChanged: (value) {
                          if (!_isCurrent || _submitting) return;
                          setState(() => _mode = value);
                        },
                      );
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
                          enabled: !_submitting,
                          labelAbove: true,
                          prefixIcon: Icons.person_outline_rounded,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 12),
                        AppDialogs.createFormField(
                          context: context,
                          label: context.l10n.appPassword,
                          controller: _appPasswordController,
                          enabled: !_submitting,
                          labelAbove: true,
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),
                  _DialogActions(
                    isLoading: _submitting || _loadingInstances,
                    onSubmit: _submit,
                    submitText: _mode == _NextcloudLoginMode.browser
                        ? context.l10n.openBrowser
                        : context.l10n.login,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
