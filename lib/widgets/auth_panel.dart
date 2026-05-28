import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/services/opaque_authenticator_service.dart';
import 'package:synctv_app/services/passkey_authenticator_service.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/user_agreement_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPanel extends StatefulWidget {
  const AuthPanel({super.key, this.initialGuestRoomId});

  final String? initialGuestRoomId;

  @override
  State<AuthPanel> createState() => _AuthPanelState();
}

enum _LoginMethod { password, emailCode, passkey }

class _AuthPanelState extends State<AuthPanel> with TickerProviderStateMixin {
  final _loginIdentifierController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _emailTokenController = TextEditingController();
  final _registerUsernameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _passkeyNameController = TextEditingController();
  final _guestRoomController = TextEditingController();
  final _mfaTokenController = TextEditingController();
  late final TabController _tabController;
  late final OpaqueAuthenticatorService _opaqueAuthenticator;

  PublicSettingsInfo? _settings;
  List<OAuth2ProviderOption> _oauth2Providers = const [];
  MfaChallengeInfo? _mfaChallenge;
  bool _loading = false;
  bool _loadingOptions = true;
  bool _emailTokenRequested = false;
  bool _mfaEmailRequested = false;
  bool _passkeyAvailable = false;
  bool _agreedToTerms = false;
  bool _loginIdentifierConfirmed = false;
  bool _showOAuthProviders = false;
  _LoginMethod _loginMethod = _LoginMethod.password;
  String? _oauthProvider;
  int _oauthAttempt = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _opaqueAuthenticator = OpaqueAuthenticatorService();
    _guestRoomController.text = widget.initialGuestRoomId ?? '';
    _loadOptions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginIdentifierController.dispose();
    _loginPasswordController.dispose();
    _emailTokenController.dispose();
    _registerUsernameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _passkeyNameController.dispose();
    _guestRoomController.dispose();
    _mfaTokenController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    try {
      final results = await Future.wait<dynamic>([
        WatchTogetherService.getPublicSettings(),
        WatchTogetherService.listOAuth2Providers(),
        PasskeyAuthenticatorService.isSupported().catchError((_) => false),
      ]);
      if (!mounted) return;
      setState(() {
        _settings = results[0] as PublicSettingsInfo;
        _oauth2Providers = results[1] as List<OAuth2ProviderOption>;
        _passkeyAvailable = results[2] as bool;
        _loadingOptions = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingOptions = false);
      MessageUtils.showError(context, '加载认证配置失败: $e');
    }
  }

  Future<void> _withLoading(Future<void> Function() action) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await action();
    } catch (e) {
      if (mounted) MessageUtils.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _ensureTermsAccepted() {
    if (_agreedToTerms) return true;
    MessageUtils.showWarning(context, '请先阅读并同意用户协议和隐私政策');
    return false;
  }

  void _finishAuth(AuthResult result) {
    if (!mounted) return;
    if (result.requiresMfa) {
      setState(() {
        _mfaChallenge = result.mfa;
        _mfaEmailRequested = false;
        _mfaTokenController.clear();
      });
      return;
    }
    if (result.registrationReviewRequired) {
      final suffix = result.registrationReviewId.isEmpty
          ? ''
          : '（${result.registrationReviewId}）';
      MessageUtils.showInfo(context, '注册申请已提交，等待管理员审核$suffix');
      return;
    }
    Navigator.pop(context, true);
  }

  Future<void> _submitPasswordLogin() async {
    if (!_ensureTermsAccepted()) return;
    await _withLoading(() async {
      final result = await _opaqueAuthenticator.login(
        identifier: _loginIdentifierController.text,
        password: _loginPasswordController.text,
      );
      _finishAuth(result);
    });
  }

  Future<void> _requestEmailToken() async {
    if (!_ensureTermsAccepted()) return;
    final email = _loginIdentifierController.text.trim();
    if (email.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱');
      return;
    }
    await _withLoading(() async {
      await WatchTogetherService.requestEmailLogin(email);
      if (!mounted) return;
      setState(() => _emailTokenRequested = true);
      MessageUtils.showSuccess(context, '验证码已发送');
    });
  }

  Future<void> _submitEmailLogin() async {
    if (!_ensureTermsAccepted()) return;
    final email = _loginIdentifierController.text.trim();
    final token = _emailTokenController.text.trim();
    if (email.isEmpty || token.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱和验证码');
      return;
    }
    await _withLoading(() async {
      final result =
          await WatchTogetherService.confirmEmailLoginResult(email, token);
      _finishAuth(result);
    });
  }

  Future<void> _submitPasskeyLogin() async {
    if (!_ensureTermsAccepted()) return;
    final identifier = _loginIdentifierController.text.trim();
    if (identifier.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱或用户名');
      return;
    }
    await _withLoading(() async {
      final start = await WatchTogetherService.startPasskeyLogin(
        email: identifier.contains('@') ? identifier : '',
        username: identifier.contains('@') ? '' : identifier,
      );
      final credential =
          await PasskeyAuthenticatorService.getCredential(start.options);
      final result = await WatchTogetherService.finishPasskeyLogin(
        sessionId: start.sessionId,
        credential: credential,
      );
      _finishAuth(result);
    });
  }

  Future<void> _submitPasswordRegistration() async {
    if (!_ensureTermsAccepted()) return;
    await _withLoading(() async {
      final result = await _opaqueAuthenticator.register(
        username: _registerUsernameController.text,
        email: _registerEmailController.text,
        password: _registerPasswordController.text,
      );
      _finishAuth(result);
    });
  }

  Future<void> _submitPasskeyRegistration() async {
    if (!_ensureTermsAccepted()) return;
    final username = _registerUsernameController.text.trim();
    if (username.isEmpty) {
      MessageUtils.showWarning(context, '请输入用户名');
      return;
    }
    await _withLoading(() async {
      final start = await WatchTogetherService.startPasskeyRegistration(
        username: username,
        email: _registerEmailController.text.trim(),
        name: _passkeyNameController.text.trim(),
      );
      final credential =
          await PasskeyAuthenticatorService.createCredential(start.options);
      final result = await WatchTogetherService.finishPasskeyRegistration(
        sessionId: start.sessionId,
        credential: credential,
      );
      _finishAuth(result);
    });
  }

  Future<void> _submitGuest() async {
    if (!_ensureTermsAccepted()) return;
    final roomId = _guestRoomController.text.trim();
    if (roomId.isEmpty) {
      MessageUtils.showWarning(context, '请输入房间 ID');
      return;
    }
    await _withLoading(() async {
      await WatchTogetherService.createGuestToken(roomId);
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _startOAuth2(OAuth2ProviderOption provider) async {
    if (!_ensureTermsAccepted()) return;
    await _withLoading(() async {
      final callbackSession = await OAuth2DeepLinkService.createSession();
      final start = await WatchTogetherService.startOAuth2Login(
        provider.name,
        redirectUrl: callbackSession.redirectUrl,
      );
      try {
        setState(() {
          _oauthProvider = provider.name;
          _oauthAttempt++;
        });
        final attempt = _oauthAttempt;
        final uri = Uri.parse(start.authorizationUrl);
        final opened = await canLaunchUrl(uri) &&
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!opened) throw StateError('无法打开授权页面');
        final parsed = await callbackSession.waitForCallback(
          expectedState: start.state,
        );
        if (!mounted || attempt != _oauthAttempt) return;
        final result = await WatchTogetherService.finishOAuth2Login(
          provider: provider.name,
          code: parsed.code,
          state: parsed.state,
        );
        setState(() => _oauthProvider = null);
        _finishAuth(result);
      } finally {
        await callbackSession.close();
      }
    });
  }

  Future<void> _requestMfaEmailToken() async {
    final challenge = _mfaChallenge;
    if (challenge == null) return;
    if (!challenge.supportsEmail) {
      MessageUtils.showWarning(context, '当前账号不支持邮箱二次验证');
      return;
    }
    await _withLoading(() async {
      await WatchTogetherService.requestMfaEmailCode(challenge.sessionId);
      if (!mounted) return;
      setState(() => _mfaEmailRequested = true);
      MessageUtils.showSuccess(context, '二次验证码已发送');
    });
  }

  Future<void> _submitMfaEmailToken() async {
    final challenge = _mfaChallenge;
    final token = _mfaTokenController.text.trim();
    if (challenge == null || token.isEmpty) {
      MessageUtils.showWarning(context, '请输入二次验证码');
      return;
    }
    await _withLoading(() async {
      await WatchTogetherService.verifyMfaEmailCode(
        mfaSessionId: challenge.sessionId,
        emailToken: token,
      );
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _submitMfaPasskey() async {
    final challenge = _mfaChallenge;
    if (challenge == null) return;
    if (!challenge.supportsPasskey) {
      MessageUtils.showWarning(context, '当前账号没有可用的 Passkey');
      return;
    }
    await _withLoading(() async {
      final start = await WatchTogetherService.startMfaPasskey(
        challenge.sessionId,
      );
      final credential =
          await PasskeyAuthenticatorService.getCredential(start.options);
      await WatchTogetherService.finishMfaPasskey(
        mfaSessionId: challenge.sessionId,
        passkeySessionId: start.passkeySessionId,
        credential: credential,
      );
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _resetPassword() async {
    if (!_ensureTermsAccepted()) return;
    final reset =
        await showDialog<({String email, String token, String password})>(
      context: context,
      builder: (context) => _PasswordResetDialog(
        initialEmail: _loginIdentifierController.text.trim(),
      ),
    );
    if (reset == null) return;
    await _withLoading(() async {
      await _opaqueAuthenticator.resetWithEmailToken(
        email: reset.email,
        token: reset.token,
        newPassword: reset.password,
      );
      if (!mounted) return;
      _loginIdentifierController.text = reset.email;
      MessageUtils.showSuccess(context, '密码已重置，请使用新密码登录');
    });
  }

  Future<void> _showUserAgreement() async {
    await showDialog<void>(
      context: context,
      builder: (context) => const UserAgreementDialog(
        agreementContent: _agreementContent,
      ),
    );
  }

  Future<void> _pasteIntoController(TextEditingController controller) async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboard?.text;
    if (text == null || text.isEmpty) return;

    final value = controller.value;
    final selection = value.selection;
    final start = selection.isValid ? selection.start : value.text.length;
    final end = selection.isValid ? selection.end : value.text.length;
    final nextText = value.text.replaceRange(start, end, text);
    final offset = start + text.length;
    controller.value = value.copyWith(
      text: nextText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final panelWidth = width >= 720 ? 520.0 : width;

    return SafeArea(
      top: false,
      child: Container(
        width: panelWidth,
        constraints: const BoxConstraints(maxHeight: 720),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/icon/robot_3.png',
                      width: 44,
                      height: 44,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '连接看搭子',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          WatchTogetherService.activeServer?.name ??
                              WatchTogetherService.baseUrl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            if (_loadingOptions) const LinearProgressIndicator(minHeight: 2),
            if (_mfaChallenge == null)
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.login_rounded), text: '登录'),
                  Tab(icon: Icon(Icons.person_add_alt_1_rounded), text: '注册'),
                  Tab(icon: Icon(Icons.meeting_room_outlined), text: '访客'),
                ],
              ),
            Flexible(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _mfaChallenge == null
                    ? TabBarView(
                        key: const ValueKey('tabs'),
                        controller: _tabController,
                        children: [
                          _PanelScroll(child: _buildLoginTab(theme)),
                          _PanelScroll(child: _buildRegisterTab(theme)),
                          _PanelScroll(child: _buildGuestTab(theme)),
                        ],
                      )
                    : _PanelScroll(
                        key: const ValueKey('mfa'),
                        child: _buildMfaPanel(theme),
                      ),
              ),
            ),
            if (_loading)
              const LinearProgressIndicator(minHeight: 2)
            else
              const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
              child: _AgreementRow(
                agreed: _agreedToTerms,
                isDark: isDark,
                onChanged: (value) => setState(() => _agreedToTerms = value),
                onOpenAgreement: _showUserAgreement,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTab(ThemeData theme) {
    final identifier = _loginIdentifierController.text.trim();
    final availableMethods = _availableLoginMethods(identifier);
    final selectedMethod = availableMethods.contains(_loginMethod)
        ? _loginMethod
        : availableMethods.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: _loginIdentifierController,
          label: '邮箱或用户名',
          icon: Icons.alternate_email_rounded,
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            setState(() {
              _loginIdentifierConfirmed = false;
              _emailTokenRequested = false;
              _emailTokenController.clear();
            });
          },
          onSubmitted: (_) => _confirmLoginIdentifier(),
        ),
        const SizedBox(height: 14),
        if (!_loginIdentifierConfirmed) ...[
          FilledButton.icon(
            onPressed: _loading ? null : _confirmLoginIdentifier,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('继续'),
          ),
          if (_oauth2Providers.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildOAuth2Entry(theme),
          ],
        ] else ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  identifier,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _loading
                    ? null
                    : () => setState(() {
                          _loginIdentifierConfirmed = false;
                          _loginPasswordController.clear();
                          _emailTokenController.clear();
                          _emailTokenRequested = false;
                        }),
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text('修改'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (availableMethods.length > 1) ...[
            SegmentedButton<_LoginMethod>(
              segments: [
                if (availableMethods.contains(_LoginMethod.password))
                  const ButtonSegment(
                    value: _LoginMethod.password,
                    icon: Icon(Icons.lock_outline_rounded),
                    label: Text('密码'),
                  ),
                if (availableMethods.contains(_LoginMethod.emailCode))
                  const ButtonSegment(
                    value: _LoginMethod.emailCode,
                    icon: Icon(Icons.mark_email_read_outlined),
                    label: Text('验证码'),
                  ),
                if (availableMethods.contains(_LoginMethod.passkey))
                  const ButtonSegment(
                    value: _LoginMethod.passkey,
                    icon: Icon(Icons.fingerprint_rounded),
                    label: Text('Passkey'),
                  ),
              ],
              selected: {selectedMethod},
              onSelectionChanged: _loading
                  ? null
                  : (value) => setState(() => _loginMethod = value.first),
            ),
          ] else
            _SectionLabel(
              icon: _loginMethodIcon(selectedMethod),
              label: _loginMethodLabel(selectedMethod),
              color: theme.colorScheme.primary,
            ),
          const SizedBox(height: 14),
          _buildSelectedLoginMethod(selectedMethod),
          if (_oauth2Providers.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildOAuth2Entry(theme),
          ],
        ],
        if (_oauthProvider != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('等待 $_oauthProvider 授权完成')),
            ],
          ),
        ],
      ],
    );
  }

  void _confirmLoginIdentifier() {
    final identifier = _loginIdentifierController.text.trim();
    if (identifier.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱或用户名');
      return;
    }
    final methods = _availableLoginMethods(identifier);
    setState(() {
      _loginIdentifierConfirmed = true;
      _loginMethod = methods.first;
    });
  }

  List<_LoginMethod> _availableLoginMethods(String identifier) {
    final isEmail = identifier.trim().contains('@');
    final methods = <_LoginMethod>[_LoginMethod.password];
    if (isEmail && _settings?.enableEmailSignup == true) {
      methods.add(_LoginMethod.emailCode);
    }
    if (_passkeyAvailable) {
      methods.add(_LoginMethod.passkey);
    }
    return methods;
  }

  Widget _buildSelectedLoginMethod(_LoginMethod method) {
    switch (method) {
      case _LoginMethod.password:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _loginPasswordController,
              label: '密码',
              icon: Icons.lock_outline_rounded,
              obscureText: true,
              onSubmitted: (_) => _submitPasswordLogin(),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _loading ? null : _submitPasswordLogin,
              icon: const Icon(Icons.login_rounded),
              label: const Text('登录'),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _loading ? null : _resetPassword,
                icon: const Icon(Icons.lock_reset_rounded, size: 18),
                label: const Text('忘记密码'),
              ),
            ),
          ],
        );
      case _LoginMethod.emailCode:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _emailTokenController,
                    label: _emailTokenRequested ? '验证码' : '先获取验证码',
                    icon: Icons.pin_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _loading ? null : _requestEmailToken,
                  child: const Text('发送'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _loading ? null : _submitEmailLogin,
              icon: const Icon(Icons.mark_email_read_outlined),
              label: const Text('验证码登录'),
            ),
          ],
        );
      case _LoginMethod.passkey:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _loading ? null : _submitPasskeyLogin,
              icon: const Icon(Icons.fingerprint_rounded),
              label: const Text('使用 Passkey 登录'),
            ),
          ],
        );
    }
  }

  String _loginMethodLabel(_LoginMethod method) {
    switch (method) {
      case _LoginMethod.password:
        return '密码登录';
      case _LoginMethod.emailCode:
        return '邮箱验证码登录';
      case _LoginMethod.passkey:
        return 'Passkey 登录';
    }
  }

  IconData _loginMethodIcon(_LoginMethod method) {
    switch (method) {
      case _LoginMethod.password:
        return Icons.lock_outline_rounded;
      case _LoginMethod.emailCode:
        return Icons.mark_email_read_outlined;
      case _LoginMethod.passkey:
        return Icons.fingerprint_rounded;
    }
  }

  Widget _buildRegisterTab(ThemeData theme) {
    final passwordSignupEnabled = _settings?.enablePasswordSignup == true;
    final passkeySignupEnabled =
        _passkeyAvailable && _settings?.enableWebauthnSignup == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPolicyHints(theme),
        _buildTextField(
          controller: _registerUsernameController,
          label: '用户名',
          icon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _registerEmailController,
          label: '邮箱',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _registerPasswordController,
          label: '密码',
          icon: Icons.lock_outline_rounded,
          obscureText: true,
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: passwordSignupEnabled && !_loading
              ? _submitPasswordRegistration
              : null,
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: Text(passwordSignupEnabled ? '创建账号' : '服务器未开放密码注册'),
        ),
        if (passkeySignupEnabled) ...[
          const SizedBox(height: 18),
          _SectionLabel(
            icon: Icons.fingerprint_rounded,
            label: 'Passkey 注册',
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _passkeyNameController,
            label: '设备名称，例如 MacBook 或手机',
            icon: Icons.devices_rounded,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _loading ? null : _submitPasskeyRegistration,
            icon: const Icon(Icons.fingerprint_rounded),
            label: const Text('创建 Passkey 账号'),
          ),
        ],
      ],
    );
  }

  Widget _buildGuestTab(ThemeData theme) {
    final guestEnabled = _settings?.enableGuest == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '访客只用于进入指定房间。公开房间列表不需要登录，创建房间、账号中心和管理功能需要账号。',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 18),
        _buildTextField(
          controller: _guestRoomController,
          label: guestEnabled ? '房间 ID' : '服务器未开放访客访问',
          icon: Icons.meeting_room_outlined,
          enabled: guestEnabled && !_loading,
          onSubmitted: (_) => _submitGuest(),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: guestEnabled && !_loading ? _submitGuest : null,
          icon: const Icon(Icons.door_front_door_outlined),
          label: const Text('以访客身份进入'),
        ),
      ],
    );
  }

  Widget _buildMfaPanel(ThemeData theme) {
    final challenge = _mfaChallenge!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(
          icon: Icons.verified_user_outlined,
          label: '二次验证',
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          challenge.maskedEmail.isEmpty
              ? '当前账号需要额外验证。'
              : '验证码将发送到 ${challenge.maskedEmail}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _mfaTokenController,
                label: _mfaEmailRequested ? '二次验证码' : '先获取二次验证码',
                icon: Icons.pin_outlined,
                enabled: challenge.supportsEmail && !_loading,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: challenge.supportsEmail && !_loading
                  ? _requestMfaEmailToken
                  : null,
              child: const Text('发送'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: challenge.supportsEmail && !_loading
              ? _submitMfaEmailToken
              : null,
          child: const Text('完成验证'),
        ),
        if (challenge.supportsPasskey && _passkeyAvailable) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _loading ? null : _submitMfaPasskey,
            icon: const Icon(Icons.fingerprint_rounded),
            label: const Text('使用 Passkey 验证'),
          ),
        ],
      ],
    );
  }

  Widget _buildOAuth2Entry(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton.icon(
          onPressed: _loading
              ? null
              : () =>
                  setState(() => _showOAuthProviders = !_showOAuthProviders),
          icon: Icon(
            _showOAuthProviders
                ? Icons.expand_less_rounded
                : Icons.expand_more_rounded,
          ),
          label: const Text('第三方登录'),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildOAuth2Buttons(theme),
          crossFadeState: _showOAuthProviders
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 160),
          sizeCurve: Curves.easeOut,
        ),
      ],
    );
  }

  Widget _buildOAuth2Buttons(ThemeData theme) {
    if (_oauth2Providers.isEmpty) return const SizedBox.shrink();
    final oauth2Available = OAuth2DeepLinkService.canCreateSession;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final provider in _oauth2Providers) ...[
          OutlinedButton.icon(
            onPressed: _loading || !oauth2Available
                ? null
                : () => _startOAuth2(provider),
            icon: const Icon(Icons.open_in_new_rounded),
            label: Text(
              '使用 ${_oauth2ProviderLabel(provider)} 继续',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (!oauth2Available)
          Text(
            '当前构建未配置 App Link 或桌面回跳，暂不能使用 OAuth2。',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  String _oauth2ProviderLabel(OAuth2ProviderOption provider) {
    final display =
        provider.type.trim().isEmpty ? provider.name : provider.type;
    if (provider.signupNeedReview) return '$display（注册需审核）';
    if (!provider.signupEnabled) return '$display（仅登录）';
    return display;
  }

  Widget _buildPolicyHints(ThemeData theme) {
    final hints = _settings?.authPolicyHints ?? const <String>[];
    if (hints.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final hint in hints)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool enabled = true,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled && !_loading,
      obscureText: obscureText,
      enableInteractiveSelection: true,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: obscureText
            ? IconButton(
                tooltip: '粘贴',
                icon: const Icon(Icons.content_paste_rounded),
                onPressed: enabled && !_loading
                    ? () => _pasteIntoController(controller)
                    : null,
              )
            : null,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}

class _PanelScroll extends StatelessWidget {
  const _PanelScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.agreed,
    required this.isDark,
    required this.onChanged,
    required this.onOpenAgreement,
  });

  final bool agreed;
  final bool isDark;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpenAgreement;

  @override
  Widget build(BuildContext context) {
    final linkColor = isDark
        ? const Color(0xFF9EA0FF)
        : Theme.of(context).colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: agreed,
          onChanged: (value) => onChanged(value ?? false),
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('我已阅读并同意'),
              InkWell(
                onTap: onOpenAgreement,
                child: Text('《用户协议》', style: TextStyle(color: linkColor)),
              ),
              const Text('和'),
              InkWell(
                onTap: onOpenAgreement,
                child: Text('《隐私政策》', style: TextStyle(color: linkColor)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PasswordResetDialog extends StatefulWidget {
  const _PasswordResetDialog({required this.initialEmail});

  final String initialEmail;

  @override
  State<_PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<_PasswordResetDialog> {
  late final TextEditingController _emailController;
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _requestResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱');
      return;
    }
    setState(() => _requesting = true);
    try {
      final message = await WatchTogetherService.requestPasswordReset(email);
      if (!mounted) return;
      MessageUtils.showSuccess(
        context,
        message.isEmpty ? '密码重置邮件已发送' : message,
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '发送重置邮件失败: $e');
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  void _submit() {
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || token.isEmpty || password.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱、验证码和新密码');
      return;
    }
    if (password != _confirmController.text) {
      MessageUtils.showWarning(context, '两次输入的新密码不一致');
      return;
    }
    Navigator.pop(context, (email: email, token: token, password: password));
  }

  Future<void> _pasteIntoController(TextEditingController controller) async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboard?.text;
    if (text == null || text.isEmpty) return;

    final value = controller.value;
    final selection = value.selection;
    final start = selection.isValid ? selection.start : value.text.length;
    final end = selection.isValid ? selection.end : value.text.length;
    final nextText = value.text.replaceRange(start, end, text);
    final offset = start + text.length;
    controller.value = value.copyWith(
      text: nextText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('重置密码'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: '邮箱',
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _requesting ? null : _requestResetEmail,
                  child: _requesting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('发送'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: '重置验证码',
                prefixIcon: Icon(Icons.pin_outlined),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                labelText: '新密码',
                prefixIcon: const Icon(Icons.lock_reset_rounded),
                suffixIcon: IconButton(
                  tooltip: '粘贴',
                  icon: const Icon(Icons.content_paste_rounded),
                  onPressed: () => _pasteIntoController(_passwordController),
                ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              obscureText: true,
              enableInteractiveSelection: true,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: '确认新密码',
                prefixIcon: const Icon(Icons.check_circle_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: '粘贴',
                  icon: const Icon(Icons.content_paste_rounded),
                  onPressed: () => _pasteIntoController(_confirmController),
                ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('重置'),
        ),
      ],
    );
  }
}

const String _agreementContent = '''
# 看搭子用户服务协议与隐私政策

本应用是连接用户自有 SyncTV 服务器的客户端工具，不提供公共内容服务器，不存储、审核或运营用户服务器中的内容。

用户应确保接入的服务器、房间和媒体内容具备合法授权，并自行承担服务器安全、账号安全、内容合规和数据备份责任。

使用本应用登录、注册、访客访问或连接服务器，即表示你同意遵守相关法律法规，不利用本应用传播违法、有害、侵权或未授权内容。

应用可能在本地保存服务器地址、登录令牌、访客令牌和基础偏好，用于保持登录状态与多服务器切换。这些数据仅存储在当前设备上。

OAuth2 登录将跳转到浏览器或系统授权页面，并通过 App Link 或桌面本地回跳完成授权；应用不会要求用户手动填写回调地址或授权码。

如不同意以上条款，请停止使用本应用。
''';
