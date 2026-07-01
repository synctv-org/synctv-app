import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/services/opaque_authenticator_service.dart';
import 'package:synctv_app/services/passkey_authenticator_service.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
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
  final _registerIdentifierController = TextEditingController();
  final _registerUsernameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerEmailTokenController = TextEditingController();
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
  bool _registerEmailTokenRequested = false;
  bool _mfaEmailRequested = false;
  bool _passkeyAvailable = false;
  bool _agreedToTerms = kDebugMode;
  bool _loginIdentifierConfirmed = false;
  bool _registerIdentifierConfirmed = false;
  bool _registerIncludeEmail = false;
  bool _showOAuthProviders = false;
  _LoginMethod _loginMethod = _LoginMethod.password;
  String _confirmedLoginIdentifier = '';
  String? _oauthProvider;
  int _oauthAttempt = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChanged);
    _opaqueAuthenticator = OpaqueAuthenticatorService();
    _guestRoomController.text = widget.initialGuestRoomId ?? '';
    _loadOptions();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    _loginIdentifierController.dispose();
    _loginPasswordController.dispose();
    _emailTokenController.dispose();
    _registerIdentifierController.dispose();
    _registerUsernameController.dispose();
    _registerEmailController.dispose();
    _registerEmailTokenController.dispose();
    _registerPasswordController.dispose();
    _passkeyNameController.dispose();
    _guestRoomController.dispose();
    _mfaTokenController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadOptions() async {
    try {
      final results = await Future.wait<dynamic>([
        SyncTvService.getPublicSettings(),
        SyncTvService.listOAuth2Providers(),
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
    _normalizeControllerSelection(_loginPasswordController);
    final identifier = _effectiveLoginIdentifier();
    await _withLoading(() async {
      final isEmail = identifier.contains('@');
      final result = await SyncTvService.loginWithDirectPassword(
        username: isEmail ? '' : identifier,
        email: isEmail ? identifier : '',
        password: _loginPasswordController.text,
      );
      _finishAuth(result);
    });
  }

  Future<void> _requestEmailToken() async {
    if (!_ensureTermsAccepted()) return;
    final email = _effectiveLoginIdentifier();
    if (email.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱');
      return;
    }
    await _withLoading(() async {
      await SyncTvService.requestEmailLogin(email);
      if (!mounted) return;
      setState(() => _emailTokenRequested = true);
      MessageUtils.showSuccess(context, '验证码已发送');
    });
  }

  Future<void> _submitEmailLogin() async {
    if (!_ensureTermsAccepted()) return;
    final email = _effectiveLoginIdentifier();
    final token = _emailTokenController.text.trim();
    if (email.isEmpty || token.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱和验证码');
      return;
    }
    await _withLoading(() async {
      final result = await SyncTvService.confirmEmailLoginResult(email, token);
      _finishAuth(result);
    });
  }

  Future<void> _submitPasskeyLogin() async {
    if (!_ensureTermsAccepted()) return;
    final identifier = _effectiveLoginIdentifier();
    if (identifier.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱或用户名');
      return;
    }
    await _withLoading(() async {
      final start = await SyncTvService.startPasskeyLogin(
        email: identifier.contains('@') ? identifier : '',
        username: identifier.contains('@') ? '' : identifier,
      );
      final credential = await PasskeyAuthenticatorService.getCredential(
        start.options,
      );
      final result = await SyncTvService.finishPasskeyLogin(
        sessionId: start.sessionId,
        credential: credential,
      );
      _finishAuth(result);
    });
  }

  Future<void> _submitPasswordRegistration() async {
    if (!_ensureTermsAccepted()) return;
    final input = _registerIdentifierController.text.trim();
    if (!_registerIdentifierConfirmed || input.isEmpty) {
      MessageUtils.showWarning(context, '请先输入用户名或邮箱');
      return;
    }
    final registerByEmail = input.contains('@');
    final username = registerByEmail
        ? _registerUsernameController.text.trim()
        : input;
    final email = registerByEmail
        ? input
        : (_registerIncludeEmail ? _registerEmailController.text.trim() : '');
    if (username.isEmpty) {
      MessageUtils.showWarning(context, '请输入用户名');
      return;
    }
    await _withLoading(() async {
      final result = await _opaqueAuthenticator.register(
        username: username,
        email: email,
        password: _registerPasswordController.text,
      );
      _finishAuth(result);
    });
  }

  Future<void> _requestEmailRegistrationToken() async {
    if (!_ensureTermsAccepted()) return;
    final input = _registerIdentifierController.text.trim();
    if (!_registerIdentifierConfirmed || input.isEmpty) {
      MessageUtils.showWarning(context, '请先输入用户名或邮箱');
      return;
    }
    final registerByEmail = input.contains('@');
    final username = registerByEmail
        ? _registerUsernameController.text.trim()
        : input;
    final email = registerByEmail
        ? input
        : _registerEmailController.text.trim();
    if (username.isEmpty || email.isEmpty) {
      MessageUtils.showWarning(context, '请输入用户名和邮箱');
      return;
    }
    await _withLoading(() async {
      await SyncTvService.requestEmailRegistration(
        username: username,
        email: email,
      );
      if (!mounted) return;
      setState(() => _registerEmailTokenRequested = true);
      MessageUtils.showSuccess(context, '注册验证码已发送');
    });
  }

  Future<void> _submitEmailRegistration() async {
    if (!_ensureTermsAccepted()) return;
    final token = _registerEmailTokenController.text.trim();
    if (token.isEmpty || _registerPasswordController.text.isEmpty) {
      MessageUtils.showWarning(context, '请输入验证码和密码');
      return;
    }
    await _withLoading(() async {
      final result = await SyncTvService.confirmEmailRegistration(
        emailToken: token,
        password: _registerPasswordController.text,
      );
      _finishAuth(result);
    });
  }

  Future<void> _submitPasskeyRegistration() async {
    if (!_ensureTermsAccepted()) return;
    final input = _registerIdentifierController.text.trim();
    if (!_registerIdentifierConfirmed || input.isEmpty) {
      MessageUtils.showWarning(context, '请先输入用户名或邮箱');
      return;
    }
    final registerByEmail = input.contains('@');
    final username = registerByEmail
        ? _registerUsernameController.text.trim()
        : input;
    final email = registerByEmail
        ? input
        : (_registerIncludeEmail ? _registerEmailController.text.trim() : '');
    if (username.isEmpty) {
      MessageUtils.showWarning(context, '请输入用户名');
      return;
    }
    await _withLoading(() async {
      final start = await SyncTvService.startPasskeyRegistration(
        username: username,
        email: email,
        name: _passkeyNameController.text.trim(),
      );
      final credential = await PasskeyAuthenticatorService.createCredential(
        start.options,
      );
      final result = await SyncTvService.finishPasskeyRegistration(
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
      await SyncTvService.createGuestToken(roomId);
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _startOAuth2(OAuth2ProviderOption provider) async {
    if (!_ensureTermsAccepted()) return;
    await _withLoading(() async {
      final callbackSession = await OAuth2DeepLinkService.createSession();
      final start = await SyncTvService.startOAuth2Login(
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
        final opened =
            await canLaunchUrl(uri) &&
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!opened) throw StateError('无法打开授权页面');
        final parsed = await callbackSession.waitForCallback(
          expectedState: start.state,
        );
        if (!mounted || attempt != _oauthAttempt) return;
        final result = await SyncTvService.finishOAuth2Login(
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
      await SyncTvService.requestMfaEmailCode(challenge.sessionId);
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
      await SyncTvService.verifyMfaEmailCode(
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
      final start = await SyncTvService.startMfaPasskey(challenge.sessionId);
      final credential = await PasskeyAuthenticatorService.getCredential(
        start.options,
      );
      await SyncTvService.finishMfaPasskey(
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
        await showAppDialog<({String email, String token, String password})>(
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
    await showAppDialog<void>(
      context: context,
      builder: (context) =>
          const UserAgreementDialog(agreementContent: _agreementContent),
    );
  }

  void _normalizeControllerSelection(TextEditingController controller) {
    final value = controller.value;
    controller.value = value.copyWith(
      selection: TextSelection.collapsed(offset: value.text.length),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final media = MediaQuery.of(context);
    final size = media.size;
    final keyboardInset = media.viewInsets.bottom;
    final isDesktopSheet = size.width >= 720;
    final panelWidth = isDesktopSheet ? 520.0 : size.width;
    final maxPanelHeight = (size.height - keyboardInset - 24)
        .clamp(360.0, isDesktopSheet ? 680.0 : size.height * 0.92)
        .toDouble();
    final panelRadius = isDesktopSheet
        ? BorderRadius.circular(20)
        : const BorderRadius.vertical(top: Radius.circular(20));

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(
        isDesktopSheet ? 16 : 0,
        isDesktopSheet ? 16 : 0,
        isDesktopSheet ? 16 : 0,
        keyboardInset + (isDesktopSheet ? 16 : 0),
      ),
      child: AppSafeArea(
        top: isDesktopSheet,
        child: Align(
          alignment: isDesktopSheet ? Alignment.center : Alignment.bottomCenter,
          child: AppPanelSurface(
            width: panelWidth,
            constraints: BoxConstraints(maxHeight: maxPanelHeight),
            clipBehavior: Clip.antiAlias,
            color: theme.colorScheme.surface,
            borderRadius: panelRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.10),
                blurRadius: 28,
                offset: const Offset(0, -8),
              ),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                  child: Row(
                    children: [
                      const AppImageThumbnail.asset(
                        assetName: 'assets/icon/robot_3.png',
                        width: 38,
                        height: 38,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '连接 SyncTV',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              SyncTvService.activeServer?.name ?? '未连接服务器',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppIconButton(
                        tooltip: '关闭',
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.close_rounded,
                      ),
                    ],
                  ),
                ),
                if (_loadingOptions) const AppLinearProgress(minHeight: 2),
                if (_mfaChallenge == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AppTabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: theme.dividerColor.withValues(alpha: 0.45),
                      tabs: const [
                        Tab(icon: Icon(Icons.login_rounded), text: '登录'),
                        Tab(
                          icon: Icon(Icons.person_add_alt_1_rounded),
                          text: '注册',
                        ),
                        Tab(
                          icon: Icon(Icons.meeting_room_outlined),
                          text: '访客',
                        ),
                      ],
                    ),
                  ),
                Flexible(
                  fit: FlexFit.loose,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeOut,
                    child: _mfaChallenge == null
                        ? _PanelScroll(
                            key: ValueKey('tab-${_tabController.index}'),
                            child: _buildCurrentTab(theme),
                          )
                        : _PanelScroll(
                            key: const ValueKey('mfa'),
                            child: _buildMfaPanel(theme),
                          ),
                  ),
                ),
                if (_loading)
                  const AppLinearProgress(minHeight: 2)
                else
                  const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                  child: _AgreementRow(
                    agreed: _agreedToTerms,
                    isDark: isDark,
                    onChanged: (value) =>
                        setState(() => _agreedToTerms = value),
                    onOpenAgreement: _showUserAgreement,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTab(ThemeData theme) {
    switch (_tabController.index) {
      case 1:
        return _buildRegisterTab(theme);
      case 2:
        return _buildGuestTab(theme);
      default:
        return _buildLoginTab(theme);
    }
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
          icon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            setState(() {
              _loginIdentifierConfirmed = false;
              _confirmedLoginIdentifier = '';
              _emailTokenRequested = false;
              _emailTokenController.clear();
            });
          },
          onSubmitted: (_) => _confirmLoginIdentifier(),
        ),
        const SizedBox(height: 14),
        if (!_loginIdentifierConfirmed) ...[
          AppActionButton(
            onPressed: _loading ? null : _confirmLoginIdentifier,
            icon: Icons.arrow_forward_rounded,
            label: '继续',
            loading: _loading,
          ),
          if (_oauth2Providers.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildOAuth2Entry(theme),
          ],
        ] else ...[
          if (availableMethods.length > 1) ...[
            AppSegmentedControl<_LoginMethod>(
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
              value: selectedMethod,
              onChanged: (value) {
                if (_loading) return;
                setState(() => _loginMethod = value);
              },
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
                child: AppLoadingIndicator(
                  size: AppLoadingSize.sm,
                  centered: false,
                ),
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
      _confirmedLoginIdentifier = identifier;
      _loginMethod = methods.first;
    });
  }

  String _effectiveLoginIdentifier() {
    final current = _loginIdentifierController.text.trim();
    if (current.isNotEmpty) return current;
    return _confirmedLoginIdentifier;
  }

  void _confirmRegisterIdentifier() {
    final identifier = _registerIdentifierController.text.trim();
    if (!_hasAvailableRegistrationMethod()) {
      MessageUtils.showWarning(context, '当前服务器未开放账号注册');
      return;
    }
    if (identifier.isEmpty) {
      MessageUtils.showWarning(context, '请输入用户名或邮箱');
      return;
    }
    final emailSignupEnabled =
        _settings?.enableEmail == true && _settings?.enableEmailSignup == true;
    if (identifier.contains('@') && !emailSignupEnabled) {
      MessageUtils.showWarning(context, '当前服务器未开放邮箱注册');
      return;
    }
    setState(() {
      _registerIdentifierConfirmed = true;
      _registerIncludeEmail = identifier.contains('@');
      if (identifier.contains('@')) {
        _registerEmailController.text = identifier;
      } else {
        _registerUsernameController.text = '';
      }
      _registerPasswordController.clear();
      _passkeyNameController.clear();
    });
  }

  bool _hasAvailableRegistrationMethod() {
    return _settings?.enablePasswordSignup == true ||
        (_settings?.enableEmail == true &&
            _settings?.enableEmailSignup == true) ||
        (_passkeyAvailable &&
            _settings?.enableWebauthn == true &&
            _settings?.enableWebauthnSignup == true) ||
        _oauth2Providers.any((provider) => provider.signupEnabled);
  }

  List<_LoginMethod> _availableLoginMethods(String identifier) {
    final isEmail = identifier.trim().contains('@');
    final methods = <_LoginMethod>[_LoginMethod.password];
    if (isEmail && _settings?.enableEmail == true) {
      methods.add(_LoginMethod.emailCode);
    }
    if (_passkeyAvailable && _settings?.enableWebauthn == true) {
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
            AppActionButton(
              onPressed: _loading ? null : _submitPasswordLogin,
              icon: Icons.login_rounded,
              label: '登录',
              loading: _loading,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: AppActionButton(
                onPressed: _loading ? null : _resetPassword,
                icon: Icons.lock_reset_rounded,
                label: '忘记密码',
                style: AppActionButtonStyle.text,
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
                AppActionButton(
                  onPressed: _loading ? null : _requestEmailToken,
                  icon: Icons.send_outlined,
                  label: '发送',
                  loading: _loading,
                  style: AppActionButtonStyle.outlined,
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppActionButton(
              onPressed: _loading ? null : _submitEmailLogin,
              icon: Icons.mark_email_read_outlined,
              label: '验证码登录',
              loading: _loading,
            ),
          ],
        );
      case _LoginMethod.passkey:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppActionButton(
              onPressed: _loading ? null : _submitPasskeyLogin,
              icon: Icons.fingerprint_rounded,
              label: '使用 Passkey 登录',
              loading: _loading,
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

  Widget _buildEmailWhitelistSelector(TextEditingController controller) {
    final settings = _settings;
    if (settings == null ||
        !settings.emailWhitelistEnabled ||
        settings.emailWhitelistDomains.isEmpty ||
        !controller.text.contains('@')) {
      return const SizedBox.shrink();
    }

    final currentDomain = controller.text
        .split('@')
        .skip(1)
        .join('@')
        .trim()
        .toLowerCase();
    final domains = settings.emailWhitelistDomains
        .where(
          (domain) => currentDomain.isEmpty || domain.startsWith(currentDomain),
        )
        .take(8)
        .toList(growable: false);
    if (domains.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final domain in domains)
            AppChip(
              avatar: const Icon(Icons.alternate_email_rounded, size: 16),
              label: Text('@$domain'),
              onPressed: _loading
                  ? null
                  : () {
                      final local = controller.text.split('@').first;
                      controller.text = '$local@$domain';
                      controller.selection = TextSelection.collapsed(
                        offset: controller.text.length,
                      );
                      setState(() {});
                    },
            ),
        ],
      ),
    );
  }

  Widget _buildRegisterTab(ThemeData theme) {
    final passwordSignupEnabled = _settings?.enablePasswordSignup == true;
    final emailSignupEnabled =
        _settings?.enableEmail == true && _settings?.enableEmailSignup == true;
    final passkeySignupEnabled =
        _passkeyAvailable &&
        _settings?.enableWebauthn == true &&
        _settings?.enableWebauthnSignup == true;
    final oauthSignupProviders = _oauth2Providers
        .where((provider) => provider.signupEnabled)
        .toList(growable: false);
    final hasLocalRegistrationMethod =
        passwordSignupEnabled || emailSignupEnabled || passkeySignupEnabled;
    final hasRegistrationMethod =
        hasLocalRegistrationMethod || oauthSignupProviders.isNotEmpty;
    final identifier = _registerIdentifierController.text.trim();
    final registerByEmail = identifier.contains('@');

    if (!_loadingOptions && !hasRegistrationMethod) {
      return const AppEmptyState(
        icon: Icons.person_off_outlined,
        title: '当前服务器未开放账号注册',
        subtitle: '请联系管理员创建账号，或使用已有账号登录。',
        iconSize: 42,
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPolicyHints(theme),
        if (oauthSignupProviders.isNotEmpty) ...[
          _SectionLabel(
            icon: Icons.open_in_new_rounded,
            label: '第三方注册',
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          _buildOAuth2Buttons(theme, providers: oauthSignupProviders),
          if (hasLocalRegistrationMethod) const SizedBox(height: 18),
        ],
        if (hasLocalRegistrationMethod) ...[
          _SectionLabel(
            icon: Icons.person_add_alt_1_rounded,
            label: '账号注册',
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _registerIdentifierController,
            label: emailSignupEnabled ? '用户名或邮箱' : '用户名',
            icon: Icons.person_outline_rounded,
            keyboardType: emailSignupEnabled
                ? TextInputType.emailAddress
                : null,
            textInputAction: TextInputAction.done,
            enabled: !_registerIdentifierConfirmed,
            onChanged: (_) {
              setState(() {
                _registerIdentifierConfirmed = false;
                _registerIncludeEmail = false;
                _registerEmailTokenRequested = false;
                _registerEmailController.clear();
                _registerEmailTokenController.clear();
              });
            },
            onSubmitted: (_) => _confirmRegisterIdentifier(),
          ),
          if (emailSignupEnabled)
            _buildEmailWhitelistSelector(_registerIdentifierController),
          const SizedBox(height: 14),
          if (!_registerIdentifierConfirmed)
            AppActionButton(
              onPressed: _loading ? null : _confirmRegisterIdentifier,
              icon: Icons.arrow_forward_rounded,
              label: '继续',
              loading: _loading,
            )
          else ...[
            if (registerByEmail) ...[
              _buildTextField(
                controller: _registerUsernameController,
                label: '用户名',
                icon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
            ] else if (emailSignupEnabled) ...[
              AppCheckboxTile(
                value: _registerIncludeEmail,
                onChanged: _loading
                    ? null
                    : (value) => setState(() => _registerIncludeEmail = value),
                title: const Text('同时填写邮箱'),
                subtitle: const Text('可使用邮箱验证码完成注册。'),
              ),
              if (_registerIncludeEmail) ...[
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _registerEmailController,
                  label: '邮箱',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {
                    _registerEmailTokenRequested = false;
                    _registerEmailTokenController.clear();
                  }),
                ),
                _buildEmailWhitelistSelector(_registerEmailController),
                const SizedBox(height: 12),
              ],
            ],
            if (passwordSignupEnabled) ...[
              _buildTextField(
                controller: _registerPasswordController,
                label: '密码',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              AppActionButton(
                onPressed: _loading ? null : _submitPasswordRegistration,
                icon: Icons.person_add_alt_1_rounded,
                label: '创建账号',
                loading: _loading,
              ),
            ],
            if (emailSignupEnabled &&
                (registerByEmail || _registerIncludeEmail)) ...[
              if (passwordSignupEnabled) const SizedBox(height: 18),
              _SectionLabel(
                icon: Icons.mark_email_read_outlined,
                label: '邮箱验证码注册',
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _registerEmailTokenController,
                      label: _registerEmailTokenRequested ? '验证码' : '先获取验证码',
                      icon: Icons.pin_outlined,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppActionButton(
                    onPressed: _loading ? null : _requestEmailRegistrationToken,
                    icon: Icons.send_outlined,
                    label: '发送',
                    loading: _loading,
                    style: AppActionButtonStyle.outlined,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _registerPasswordController,
                label: '密码',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              AppActionButton(
                onPressed: _loading ? null : _submitEmailRegistration,
                icon: Icons.mark_email_read_outlined,
                label: '使用邮箱验证码创建账号',
                loading: _loading,
                style: passwordSignupEnabled
                    ? AppActionButtonStyle.outlined
                    : AppActionButtonStyle.filled,
              ),
            ],
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
              AppActionButton(
                onPressed: _loading ? null : _submitPasskeyRegistration,
                icon: Icons.fingerprint_rounded,
                label: '创建 Passkey 账号',
                loading: _loading,
                style: AppActionButtonStyle.outlined,
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: AppActionButton(
                onPressed: _loading
                    ? null
                    : () => setState(() {
                        _registerIdentifierConfirmed = false;
                        _registerIncludeEmail = false;
                        _registerEmailTokenRequested = false;
                        _registerEmailTokenController.clear();
                      }),
                icon: Icons.edit_outlined,
                label: '修改',
                style: AppActionButtonStyle.text,
              ),
            ),
          ],
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
        AppActionButton(
          onPressed: guestEnabled && !_loading ? _submitGuest : null,
          icon: Icons.door_front_door_outlined,
          label: '以访客身份进入',
          loading: _loading,
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
            AppActionButton(
              onPressed: challenge.supportsEmail && !_loading
                  ? _requestMfaEmailToken
                  : null,
              icon: Icons.send_outlined,
              label: '发送',
              loading: _loading,
              style: AppActionButtonStyle.outlined,
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppActionButton(
          onPressed: challenge.supportsEmail && !_loading
              ? _submitMfaEmailToken
              : null,
          icon: Icons.verified_user_outlined,
          label: '完成验证',
          loading: _loading,
        ),
        if (challenge.supportsPasskey &&
            _passkeyAvailable &&
            _settings?.enableWebauthn == true) ...[
          const SizedBox(height: 10),
          AppActionButton(
            onPressed: _loading ? null : _submitMfaPasskey,
            icon: Icons.fingerprint_rounded,
            label: '使用 Passkey 验证',
            loading: _loading,
            style: AppActionButtonStyle.outlined,
          ),
        ],
      ],
    );
  }

  Widget _buildOAuth2Entry(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppActionButton(
          onPressed: _loading
              ? null
              : () =>
                    setState(() => _showOAuthProviders = !_showOAuthProviders),
          icon: _showOAuthProviders
              ? Icons.expand_less_rounded
              : Icons.expand_more_rounded,
          label: '第三方登录',
          style: AppActionButtonStyle.text,
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

  Widget _buildOAuth2Buttons(
    ThemeData theme, {
    List<OAuth2ProviderOption>? providers,
  }) {
    final visibleProviders = providers ?? _oauth2Providers;
    if (visibleProviders.isEmpty) return const SizedBox.shrink();
    final oauth2Available = OAuth2DeepLinkService.canCreateSession;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final provider in visibleProviders) ...[
          AppActionButton(
            onPressed: _loading || !oauth2Available
                ? null
                : () => _startOAuth2(provider),
            icon: Icons.open_in_new_rounded,
            label: '使用 ${_oauth2ProviderLabel(provider)} 继续',
            style: AppActionButtonStyle.outlined,
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
    final display = provider.type.trim().isEmpty
        ? provider.name
        : provider.type;
    if (provider.signupNeedReview) return '$display（注册需审核）';
    if (!provider.signupEnabled) return '$display（仅登录）';
    return display;
  }

  Widget _buildPolicyHints(ThemeData theme) {
    final hints = _settings?.authPolicyHints ?? const <String>[];
    if (hints.isEmpty) return const SizedBox.shrink();
    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerHighest,
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
    return AppTextField(
      controller: controller,
      label: label,
      prefixIcon: icon,
      enabled: enabled && !_loading,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enableSuggestions: !obscureText,
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
    );
  }
}

class _PanelScroll extends StatelessWidget {
  const _PanelScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      children: [child],
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
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
    return AppCheckboxTile(
      value: agreed,
      onChanged: onChanged,
      semanticsLabel: '同意用户协议和隐私政策',
      contentPadding: EdgeInsets.zero,
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 2,
        children: [
          const Text('我已阅读并同意'),
          AppActionButton(
            onPressed: onOpenAgreement,
            label: '《用户协议》',
            style: AppActionButtonStyle.text,
            size: AppActionButtonSize.sm,
          ),
          const Text('和'),
          AppActionButton(
            onPressed: onOpenAgreement,
            label: '《隐私政策》',
            style: AppActionButtonStyle.text,
            size: AppActionButtonSize.sm,
          ),
        ],
      ),
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
      final message = await SyncTvService.requestPasswordReset(email);
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

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: const Text('重置密码'),
      body: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _emailController,
                    label: '邮箱',
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    smartDashesType: SmartDashesType.disabled,
                    smartQuotesType: SmartQuotesType.disabled,
                  ),
                ),
                const SizedBox(width: 8),
                AppActionButton(
                  onPressed: _requesting ? null : _requestResetEmail,
                  icon: Icons.send_outlined,
                  label: '发送',
                  loading: _requesting,
                  style: AppActionButtonStyle.outlined,
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _tokenController,
              label: '重置验证码',
              prefixIcon: Icons.pin_outlined,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordController,
              label: '新密码',
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _confirmController,
              label: '确认新密码',
              prefixIcon: Icons.check_circle_outline_rounded,
              obscureText: true,
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        AppActionButton(
          onPressed: () => Navigator.pop(context),
          label: '取消',
          style: AppActionButtonStyle.outlined,
        ),
        AppActionButton(
          onPressed: _submit,
          icon: Icons.lock_reset_rounded,
          label: '重置',
        ),
      ],
    );
  }
}

const String _agreementContent = '''
# SyncTV 用户服务协议与隐私政策

本应用是连接用户自有 SyncTV 服务器的客户端工具，不提供公共内容服务器，不存储、审核或运营用户服务器中的内容。

用户应确保接入的服务器、房间和媒体内容具备合法授权，并自行承担服务器安全、账号安全、内容合规和数据备份责任。

使用本应用登录、注册、访客访问或连接服务器，即表示你同意遵守相关法律法规，不利用本应用传播违法、有害、侵权或未授权内容。

应用可能在本地保存服务器地址、登录令牌、访客令牌和基础偏好，用于保持登录状态与多服务器切换。这些数据仅存储在当前设备上。

OAuth2 登录将跳转到浏览器或系统授权页面，并通过 App Link 或桌面本地回跳完成授权；应用不会要求用户手动填写回调地址或授权码。

如不同意以上条款，请停止使用本应用。
''';
