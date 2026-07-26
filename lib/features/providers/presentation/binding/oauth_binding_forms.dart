part of 'platform_binding_dialog.dart';

class YoutubeAccountBindingForm extends StatefulWidget {
  const YoutubeAccountBindingForm({
    super.key,
    required this.instanceNamesLoader,
    required this.onSuccess,
    this.onBind,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;
  final Future<void> Function({
    required String label,
    required String visitorData,
    required String poToken,
    required String cookie,
    required String instanceName,
  })?
  onBind;

  @override
  State<YoutubeAccountBindingForm> createState() =>
      _YoutubeAccountBindingFormState();
}

class _YoutubeAccountBindingFormState extends State<YoutubeAccountBindingForm> {
  final _labelController = TextEditingController(text: 'Browser session');
  final _visitorController = TextEditingController();
  final _poTokenController = TextEditingController();
  final _cookieController = TextEditingController();
  List<String> _instances = const [''];
  String _instanceName = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    widget.instanceNamesLoader().then((values) {
      if (mounted) setState(() => _instances = _mergeInstanceNames(values));
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _visitorController.dispose();
    _poTokenController.dispose();
    _cookieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('youtube-bind-label'),
          controller: _labelController,
          enabled: !_loading,
          label: 'Label',
          prefixIcon: Icons.label_outline,
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('youtube-bind-visitor-data'),
          controller: _visitorController,
          enabled: !_loading,
          label: 'Visitor Data',
          prefixIcon: Icons.fingerprint,
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('youtube-bind-po-token'),
          controller: _poTokenController,
          enabled: !_loading,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          label: 'PO Token',
          prefixIcon: Icons.key_outlined,
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('youtube-bind-cookie'),
          controller: _cookieController,
          enabled: !_loading,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          label: 'YouTube Cookie',
          prefixIcon: Icons.cookie_outlined,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _instanceName,
          decoration: const InputDecoration(
            labelText: 'Provider instance',
            prefixIcon: Icon(Icons.dns_outlined),
          ),
          items: _instances
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value.isEmpty ? 'Default' : value),
                ),
              )
              .toList(),
          onChanged: _loading
              ? null
              : (value) => setState(() => _instanceName = value ?? ''),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          key: const Key('youtube-bind-submit'),
          onPressed: _loading ? null : _bind,
          icon: _loading
              ? const SizedBox.square(
                  dimension: 18,
                  child: AppLoadingIndicator(
                    size: AppLoadingSize.sm,
                    centered: false,
                  ),
                )
              : const Icon(Icons.link),
          label: const Text('Bind YouTube'),
        ),
      ],
    );
  }

  Future<void> _bind() async {
    if (_labelController.text.trim().isEmpty ||
        (_visitorController.text.trim().isEmpty &&
            _poTokenController.text.trim().isEmpty &&
            _cookieController.text.trim().isEmpty)) {
      AppNotifications.showError(
        context,
        'Label and at least one YouTube credential are required',
      );
      return;
    }
    setState(() => _loading = true);
    try {
      if (widget.onBind case final bind?) {
        await bind(
          label: _labelController.text,
          visitorData: _visitorController.text,
          poToken: _poTokenController.text,
          cookie: _cookieController.text,
          instanceName: _instanceName,
        );
      } else {
        await providerGateway.bindYoutube(
          label: _labelController.text,
          visitorData: _visitorController.text,
          poToken: _poTokenController.text,
          cookie: _cookieController.text,
          instanceName: _instanceName,
        );
      }
      if (!mounted) return;
      widget.onSuccess();
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class DouyinAccountBindingForm extends StatefulWidget {
  const DouyinAccountBindingForm({
    super.key,
    required this.instanceNamesLoader,
    required this.onSuccess,
    this.onBind,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;
  final Future<void> Function({
    required String label,
    required String cookie,
    required String instanceName,
  })?
  onBind;

  @override
  State<DouyinAccountBindingForm> createState() =>
      _DouyinAccountBindingFormState();
}

class _DouyinAccountBindingFormState extends State<DouyinAccountBindingForm> {
  final _labelController = TextEditingController(text: 'Browser session');
  final _cookieController = TextEditingController();
  List<String> _instances = const [''];
  String _instanceName = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    widget.instanceNamesLoader().then((values) {
      if (mounted) setState(() => _instances = _mergeInstanceNames(values));
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _cookieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('douyin-bind-label'),
          controller: _labelController,
          enabled: !_loading,
          label: 'Label',
          prefixIcon: Icons.label_outline,
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('douyin-bind-cookie'),
          controller: _cookieController,
          enabled: !_loading,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          label: 'Douyin Cookie',
          prefixIcon: Icons.cookie_outlined,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _instanceName,
          decoration: const InputDecoration(
            labelText: 'Provider instance',
            prefixIcon: Icon(Icons.dns_outlined),
          ),
          items: _instances
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value.isEmpty ? 'Default' : value),
                ),
              )
              .toList(),
          onChanged: _loading
              ? null
              : (value) => setState(() => _instanceName = value ?? ''),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          key: const Key('douyin-bind-submit'),
          onPressed: _loading ? null : _bind,
          icon: _loading
              ? const SizedBox.square(
                  dimension: 18,
                  child: AppLoadingIndicator(
                    size: AppLoadingSize.sm,
                    centered: false,
                  ),
                )
              : const Icon(Icons.link),
          label: const Text('Bind Douyin'),
        ),
      ],
    );
  }

  Future<void> _bind() async {
    if (_labelController.text.trim().isEmpty ||
        _cookieController.text.trim().isEmpty) {
      AppNotifications.showError(
        context,
        'Label and Douyin Cookie are required',
      );
      return;
    }
    setState(() => _loading = true);
    try {
      if (widget.onBind case final bind?) {
        await bind(
          label: _labelController.text,
          cookie: _cookieController.text,
          instanceName: _instanceName,
        );
      } else {
        await providerGateway.bindDouyin(
          label: _labelController.text,
          cookie: _cookieController.text,
          instanceName: _instanceName,
        );
      }
      if (!mounted) return;
      widget.onSuccess();
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class TikTokAccountBindingForm extends StatefulWidget {
  const TikTokAccountBindingForm({
    super.key,
    required this.instanceNamesLoader,
    required this.onSuccess,
    this.onBind,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;
  final Future<void> Function({
    required String label,
    required String cookie,
    required String instanceName,
  })?
  onBind;

  @override
  State<TikTokAccountBindingForm> createState() =>
      _TikTokAccountBindingFormState();
}

class _TikTokAccountBindingFormState extends State<TikTokAccountBindingForm> {
  final _labelController = TextEditingController(text: 'Browser session');
  final _cookieController = TextEditingController();
  List<String> _instances = const [''];
  String _instanceName = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    widget.instanceNamesLoader().then((values) {
      if (mounted) setState(() => _instances = _mergeInstanceNames(values));
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _cookieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('tiktok-bind-label'),
          controller: _labelController,
          enabled: !_loading,
          label: 'Label',
          prefixIcon: Icons.label_outline,
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('tiktok-bind-cookie'),
          controller: _cookieController,
          enabled: !_loading,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          label: 'TikTok Cookie',
          prefixIcon: Icons.cookie_outlined,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _instanceName,
          decoration: const InputDecoration(
            labelText: 'Provider instance',
            prefixIcon: Icon(Icons.dns_outlined),
          ),
          items: _instances
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value.isEmpty ? 'Default' : value),
                ),
              )
              .toList(),
          onChanged: _loading
              ? null
              : (value) => setState(() => _instanceName = value ?? ''),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          key: const Key('tiktok-bind-submit'),
          onPressed: _loading ? null : _bind,
          icon: _loading
              ? const SizedBox.square(
                  dimension: 18,
                  child: AppLoadingIndicator(
                    size: AppLoadingSize.sm,
                    centered: false,
                  ),
                )
              : const Icon(Icons.link),
          label: const Text('Bind TikTok'),
        ),
      ],
    );
  }

  Future<void> _bind() async {
    if (_labelController.text.trim().isEmpty ||
        _cookieController.text.trim().isEmpty) {
      AppNotifications.showError(
        context,
        'Label and TikTok Cookie are required',
      );
      return;
    }
    setState(() => _loading = true);
    try {
      if (widget.onBind case final bind?) {
        await bind(
          label: _labelController.text,
          cookie: _cookieController.text,
          instanceName: _instanceName,
        );
      } else {
        await providerGateway.bindTikTok(
          label: _labelController.text,
          cookie: _cookieController.text,
          instanceName: _instanceName,
        );
      }
      if (!mounted) return;
      widget.onSuccess();
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class TwitchAccountBindingForm extends StatefulWidget {
  const TwitchAccountBindingForm({
    super.key,
    required this.instanceNamesLoader,
    required this.onSuccess,
    this.onBind,
  });

  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;
  final Future<void> Function({
    required String authToken,
    required String deviceId,
    required String clientIntegrity,
    required String instanceName,
  })?
  onBind;

  @override
  State<TwitchAccountBindingForm> createState() =>
      _TwitchAccountBindingFormState();
}

class _TwitchAccountBindingFormState extends State<TwitchAccountBindingForm> {
  final _tokenController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _integrityController = TextEditingController();
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
    _tokenController.dispose();
    _deviceIdController.dispose();
    _integrityController.dispose();
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
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }
    setState(() => _submitting = true);
    try {
      if (widget.onBind case final bind?) {
        await bind(
          authToken: token,
          deviceId: _deviceIdController.text,
          clientIntegrity: _integrityController.text,
          instanceName: _instanceName,
        );
      } else {
        await providerGateway.bindTwitch(
          authToken: token,
          deviceId: _deviceIdController.text,
          clientIntegrity: _integrityController.text,
          instanceName: _instanceName,
        );
      }
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
    const color = Color(0xFF9146FF);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProviderFormSection(
          icon: Icons.account_tree_outlined,
          title: context.l10n.connectionTarget,
          color: color,
          children: [
            _ProviderInstanceSelector(
              instanceNames: _instanceNames,
              selected: _instanceName,
              loading: _loadingInstances,
              onChanged: (value) => setState(() => _instanceName = value),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ProviderFormSection(
          icon: Icons.key_rounded,
          title: context.l10n.loginCredentials,
          color: color,
          children: [
            AppTextField(
              key: const Key('twitch-bind-token'),
              label: 'OAuth Token',
              controller: _tokenController,
              prefixIcon: Icons.key_rounded,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            const SizedBox(height: 12),
            AppTextField(
              key: const Key('twitch-bind-device-id'),
              label: 'Device ID',
              controller: _deviceIdController,
              prefixIcon: Icons.devices_rounded,
              enableSuggestions: false,
              autocorrect: false,
            ),
            const SizedBox(height: 12),
            AppTextField(
              key: const Key('twitch-bind-integrity'),
              label: 'Client Integrity',
              controller: _integrityController,
              prefixIcon: Icons.verified_user_outlined,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _DialogActions(
          isLoading: _submitting,
          onSubmit: _submit,
          submitText: context.l10n.login,
        ),
      ],
    );
  }
}
