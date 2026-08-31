import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/core/platform/device_display_name_service.dart';
import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/auth/presentation/auth_recovery_code_fallback.dart';
import 'package:synctv_app/features/auth/presentation/oauth_provider_widgets.dart';
import 'package:synctv_app/core/presentation/widgets/synctv_brand_mark.dart';
import 'package:synctv_app/features/auth/presentation/user_agreement_dialog.dart';

class AuthPanel extends StatefulWidget {
  const AuthPanel({
    super.key,
    required this.gateway,
    required this.passkeyClient,
    required this.opaqueAuthenticator,
    required this.oauth2Callbacks,
    required this.nativeAppleSignIn,
    this.initialGuestRoomId,
    this.startWithGuest = false,
  });

  final String? initialGuestRoomId;
  final bool startWithGuest;
  final AuthGateway gateway;
  final PasskeyClient passkeyClient;
  final OpaqueAuthenticatorService opaqueAuthenticator;
  final OAuth2CallbackClient oauth2Callbacks;
  final NativeAppleSignInClient nativeAppleSignIn;

  @override
  State<AuthPanel> createState() => _AuthPanelState();
}

enum _LoginMethod { password, emailCode, passkey }

enum _RegistrationMethod { passkey, password, emailVerification }

enum _MfaMethod { passkey, totp, email }

enum _AuthAction {
  identifyLogin,
  passwordLogin,
  requestEmailLogin,
  emailLogin,
  passkeyLogin,
  passwordRegistration,
  requestEmailRegistration,
  emailRegistration,
  passkeyRegistration,
  guestLogin,
  oauth2,
  requestMfaEmail,
  mfaEmail,
  mfaPasskey,
  mfaTotp,
  mfaRecoveryCode,
  passwordReset,
}

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
  final _mfaTotpController = TextEditingController();
  final _mfaRecoveryCodeController = TextEditingController();
  late final TabController _tabController;
  late final OpaqueAuthenticatorService _opaqueAuthenticator;
  final DeviceDisplayNameService _deviceDisplayNameService =
      DeviceDisplayNameService();

  PublicSettingsInfo? _settings;
  List<OAuth2ProviderOption> _oauth2Providers = const [];
  MfaChallengeInfo? _mfaChallenge;
  _AuthAction? _activeAction;
  bool _loadingPublicSettings = true;
  bool _loadingOAuth2Providers = true;
  bool _loadingPasskeySupport = true;
  bool _emailTokenRequested = false;
  bool _registerEmailTokenRequested = false;
  bool _mfaEmailRequested = false;
  bool _passkeyAvailable = false;
  bool _agreedToTerms = kDebugMode;
  bool _registerIdentifierConfirmed = false;
  bool _registerIncludeEmail = false;
  bool _mfaRecoveryCodeActive = false;
  _LoginMethod _loginMethod = _LoginMethod.password;
  _RegistrationMethod _registrationMethod = _RegistrationMethod.password;
  _MfaMethod _mfaMethod = _MfaMethod.totp;
  LoginStart? _loginStart;
  Timer? _loginSessionExpiryTimer;
  Timer? _mfaSessionExpiryTimer;
  String? _oauthProvider;
  String _suggestedPasskeyName = '';
  int _oauthAttempt = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.startWithGuest ? 2 : 0,
    );
    _tabController.addListener(_handleTabChanged);
    _opaqueAuthenticator = widget.opaqueAuthenticator;
    _guestRoomController.text = widget.initialGuestRoomId ?? '';
    _loadOptions();
  }

  @override
  void dispose() {
    _loginSessionExpiryTimer?.cancel();
    _mfaSessionExpiryTimer?.cancel();
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
    _mfaTotpController.dispose();
    _mfaRecoveryCodeController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (mounted) setState(() {});
  }

  bool get _loadingOptions =>
      _loadingPublicSettings ||
      _loadingOAuth2Providers ||
      _loadingPasskeySupport;

  bool get _loading => _activeAction != null;

  bool _isLoading(_AuthAction action) => _activeAction == action;

  void _loadOptions() {
    unawaited(_loadPublicSettings());
    if (ProviderDistributionPolicy.current.allowsOAuth2) {
      unawaited(_loadOAuth2Providers());
    } else {
      _loadingOAuth2Providers = false;
    }
    unawaited(_loadSuggestedPasskeyName());
  }

  Future<void> _loadSuggestedPasskeyName() async {
    final name = await _deviceDisplayNameService.suggestedPasskeyName();
    if (!mounted) return;
    _suggestedPasskeyName = name;
    if (_passkeyNameController.text.trim().isEmpty) {
      _passkeyNameController.text = name;
    }
  }

  Future<void> _loadPublicSettings() async {
    try {
      final settings = await widget.gateway.getPublicSettings();
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _loadingPublicSettings = false;
      });
      if (kDebugMode) {
        debugPrint(
          'Auth capabilities: webauthn=${settings.enableWebauthn}, '
          'rpId=${settings.webauthnRpId}',
        );
      }
      unawaited(_loadPasskeySupport(settings));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingPublicSettings = false;
        _loadingPasskeySupport = false;
      });
      AppNotifications.showError(
        context,
        context.l10n.authConfigLoadFailed(e.toString()),
      );
    }
  }

  Future<void> _loadOAuth2Providers() async {
    try {
      final providers = await widget.gateway.listOAuth2Providers();
      if (!mounted) return;
      setState(() {
        _oauth2Providers = providers;
        _loadingOAuth2Providers = false;
      });
    } catch (error) {
      debugPrint('Failed to load OAuth2 providers: $error');
      if (!mounted) return;
      setState(() => _loadingOAuth2Providers = false);
    }
  }

  Future<void> _loadPasskeySupport(PublicSettingsInfo settings) async {
    var available = false;
    try {
      if (settings.enableWebauthn) {
        available = await widget.passkeyClient.isSupported(
          serverBaseUrl: widget.gateway.serverBaseUrl,
          rpId: settings.webauthnRpId,
        );
      }
    } catch (error) {
      debugPrint('Failed to detect passkey support: $error');
    }
    if (!mounted) return;
    setState(() {
      _passkeyAvailable = available;
      _loadingPasskeySupport = false;
    });
  }

  Future<void> _withLoading(
    _AuthAction action,
    Future<void> Function() operation,
  ) async {
    if (_loading) return;
    setState(() => _activeAction = action);
    try {
      await operation();
    } catch (e) {
      if (mounted) AppNotifications.showError(context, e.toString());
    } finally {
      if (mounted && _activeAction == action) {
        setState(() => _activeAction = null);
      }
    }
  }

  bool _ensureTermsAccepted() {
    if (_agreedToTerms) return true;
    AppNotifications.showWarning(context, context.l10n.acceptTermsFirst);
    return false;
  }

  void _finishAuth(AuthResult result) {
    if (!mounted) return;
    switch (result) {
      case MfaRequired(:final challenge):
        final methods = _availableMfaMethods(challenge);
        setState(() {
          _resetLoginDiscovery();
          _resetMfaCredentials();
          _mfaChallenge = challenge;
          _mfaRecoveryCodeActive = false;
          if (methods.isNotEmpty) _mfaMethod = methods.first;
        });
        _scheduleMfaSessionExpiry(challenge);
      case RegistrationReviewPending(:final reviewId):
        final message = reviewId.isEmpty
            ? context.l10n.registrationSubmitted
            : context.l10n.registrationSubmittedWithId(reviewId);
        AppNotifications.showInfo(context, message);
      case Authenticated():
        AppNotifications.dismissAll();
        Navigator.pop(context, true);
    }
  }

  Future<void> _submitPasswordLogin() async {
    if (!_ensureTermsAccepted()) return;
    final login = _validLoginStart();
    if (login == null) {
      setState(_resetLoginDiscovery);
      AppNotifications.showWarning(context, context.l10n.enterIdentifierFirst);
      return;
    }
    _normalizeControllerSelection(_loginPasswordController);
    await _withLoading(_AuthAction.passwordLogin, () async {
      final result = await _opaqueAuthenticator.login(
        loginSessionId: login.sessionId,
        password: _loginPasswordController.text,
      );
      _finishAuth(result);
    });
  }

  Future<void> _requestEmailToken() async {
    if (!_ensureTermsAccepted()) return;
    final login = _validLoginStart();
    if (login == null) {
      setState(_resetLoginDiscovery);
      AppNotifications.showWarning(context, context.l10n.enterIdentifierFirst);
      return;
    }
    await _withLoading(_AuthAction.requestEmailLogin, () async {
      await widget.gateway.requestEmailLogin(login.sessionId);
      if (!mounted) return;
      setState(() => _emailTokenRequested = true);
      AppNotifications.showSuccess(context, context.l10n.verificationCodeSent);
    });
  }

  Future<void> _submitEmailLogin() async {
    if (!_ensureTermsAccepted()) return;
    final login = _validLoginStart();
    final token = _emailTokenController.text.trim();
    if (login == null) {
      setState(_resetLoginDiscovery);
      AppNotifications.showWarning(context, context.l10n.enterIdentifierFirst);
      return;
    }
    if (token.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.emailAndCodeRequired);
      return;
    }
    await _withLoading(_AuthAction.emailLogin, () async {
      final result = await widget.gateway.confirmEmailLogin(
        login.sessionId,
        token,
      );
      _finishAuth(result);
    });
  }

  Future<void> _submitPasskeyLogin() async {
    if (!_ensureTermsAccepted()) return;
    final login = _validLoginStart();
    if (login == null) {
      setState(_resetLoginDiscovery);
      AppNotifications.showWarning(context, context.l10n.enterIdentifierFirst);
      return;
    }
    await _withLoading(_AuthAction.passkeyLogin, () async {
      final start = await widget.gateway.startPasskeyLogin(
        loginSessionId: login.sessionId,
      );
      final credential = await widget.passkeyClient.getCredential(
        start.options,
        serverBaseUrl: widget.gateway.serverBaseUrl,
      );
      final result = await widget.gateway.finishPasskeyLogin(
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
      AppNotifications.showWarning(context, context.l10n.enterIdentifierFirst);
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
      AppNotifications.showWarning(context, context.l10n.usernameRequired);
      return;
    }
    await _withLoading(_AuthAction.passwordRegistration, () async {
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
      AppNotifications.showWarning(context, context.l10n.enterIdentifierFirst);
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
      AppNotifications.showWarning(
        context,
        context.l10n.usernameAndEmailRequired,
      );
      return;
    }
    await _withLoading(_AuthAction.requestEmailRegistration, () async {
      await widget.gateway.requestEmailRegistration(
        username: username,
        email: email,
      );
      if (!mounted) return;
      setState(() => _registerEmailTokenRequested = true);
      AppNotifications.showSuccess(context, context.l10n.registrationCodeSent);
    });
  }

  Future<void> _submitEmailRegistration() async {
    if (!_ensureTermsAccepted()) return;
    final token = _registerEmailTokenController.text.trim();
    if (token.isEmpty || _registerPasswordController.text.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.codeAndPasswordRequired,
      );
      return;
    }
    await _withLoading(_AuthAction.emailRegistration, () async {
      final result = await widget.gateway.confirmEmailRegistration(
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
      AppNotifications.showWarning(context, context.l10n.enterIdentifierFirst);
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
      AppNotifications.showWarning(context, context.l10n.usernameRequired);
      return;
    }
    await _withLoading(_AuthAction.passkeyRegistration, () async {
      final start = await widget.gateway.startPasskeyRegistration(
        username: username,
        email: email,
        name: _passkeyNameController.text.trim(),
      );
      final credential = await widget.passkeyClient.createCredential(
        start.options,
        serverBaseUrl: widget.gateway.serverBaseUrl,
      );
      final result = await widget.gateway.finishPasskeyRegistration(
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
      AppNotifications.showWarning(context, context.l10n.roomIdRequired);
      return;
    }
    await _withLoading(_AuthAction.guestLogin, () async {
      await widget.gateway.createGuestSession(roomId);
      if (mounted) {
        AppNotifications.dismissAll();
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _startOAuth2(OAuth2ProviderOption provider) async {
    if (!_ensureTermsAccepted()) return;
    final authorizationMode = selectOAuth2AuthorizationMode(
      provider,
      platform: defaultTargetPlatform,
      browserAvailable: widget.oauth2Callbacks.canCreateSession,
      nativeAvailable: widget.nativeAppleSignIn.isSupported,
    );
    if (authorizationMode == OAuth2ClientAuthorizationMode.native) {
      await _startNativeAppleOAuth2(provider);
      return;
    }
    if (authorizationMode != OAuth2ClientAuthorizationMode.browser) return;
    await _withLoading(_AuthAction.oauth2, () async {
      try {
        await withOAuth2CallbackSession(widget.oauth2Callbacks, (
          callbackSession,
        ) async {
          final start = await widget.gateway.startOAuth2Login(
            provider.name,
            redirectUrl: callbackSession.redirectUrl,
          );
          if (!mounted) return;
          setState(() {
            _oauthProvider = provider.name;
            _oauthAttempt++;
          });
          final attempt = _oauthAttempt;
          final authorizationUrl = start.authorizationUrl;
          if (authorizationUrl == null || authorizationUrl.isEmpty) {
            throw StateError('Browser authorization URL is missing');
          }
          final uri = Uri.parse(authorizationUrl);
          late final OAuth2CallbackPayload parsed;
          try {
            parsed = await callbackSession.authorize(
              authorizationUrl: uri,
              expectedState: start.state,
            );
          } on OAuth2AuthorizationCanceled {
            return;
          } on OAuth2AuthorizationTimedOut {
            if (mounted) {
              AppNotifications.showError(
                context,
                context.l10n.oauthAuthorizationTimedOut,
              );
            }
            return;
          }
          if (!mounted || attempt != _oauthAttempt) return;
          final result = await widget.gateway.finishOAuth2Login(
            code: parsed.code,
            state: parsed.state,
          );
          if (!mounted || attempt != _oauthAttempt) return;
          setState(() => _oauthProvider = null);
          _finishAuth(result);
        });
      } finally {
        if (mounted && _oauthProvider != null) {
          setState(() => _oauthProvider = null);
        }
      }
    });
  }

  Future<void> _startNativeAppleOAuth2(OAuth2ProviderOption provider) async {
    await _withLoading(_AuthAction.oauth2, () async {
      try {
        final start = await widget.gateway.startOAuth2Login(
          provider.name,
          native: true,
        );
        final nonce = start.nonce;
        if (nonce == null || nonce.isEmpty) {
          throw StateError('Apple authorization nonce is missing');
        }
        if (!mounted) return;
        setState(() {
          _oauthProvider = provider.name;
          _oauthAttempt++;
        });
        final attempt = _oauthAttempt;
        final parsed = await widget.nativeAppleSignIn.authorize(
          expectedState: start.state,
          nonce: nonce,
        );
        if (!mounted || attempt != _oauthAttempt) return;
        final result = await widget.gateway.finishOAuth2Login(
          code: parsed.code,
          state: parsed.state,
        );
        if (!mounted || attempt != _oauthAttempt) return;
        setState(() => _oauthProvider = null);
        _finishAuth(result);
      } on OAuth2AuthorizationCanceled {
        return;
      } on OAuth2AuthorizationTimedOut {
        if (mounted) {
          AppNotifications.showError(
            context,
            context.l10n.oauthAuthorizationTimedOut,
          );
        }
      } finally {
        if (mounted && _oauthProvider != null) {
          setState(() => _oauthProvider = null);
        }
      }
    });
  }

  Future<void> _requestMfaEmailToken() async {
    final challenge = _mfaChallenge;
    if (challenge == null) return;
    if (!challenge.supportsEmail) {
      AppNotifications.showWarning(context, context.l10n.mfaEmailUnsupported);
      return;
    }
    await _withLoading(_AuthAction.requestMfaEmail, () async {
      await widget.gateway.requestMfaEmailCode(challenge.sessionId);
      if (!mounted) return;
      setState(() => _mfaEmailRequested = true);
      AppNotifications.showSuccess(context, context.l10n.mfaCodeSent);
    });
  }

  Future<void> _submitMfaEmailToken() async {
    final challenge = _mfaChallenge;
    final token = _mfaTokenController.text.trim();
    if (challenge == null || token.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.mfaCodeRequired);
      return;
    }
    await _withLoading(_AuthAction.mfaEmail, () async {
      await widget.gateway.verifyMfaEmailCode(
        mfaSessionId: challenge.sessionId,
        emailToken: token,
      );
      if (mounted) {
        AppNotifications.dismissAll();
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _submitMfaPasskey() async {
    final challenge = _mfaChallenge;
    if (challenge == null) return;
    if (!challenge.supportsPasskey) {
      AppNotifications.showWarning(context, context.l10n.mfaPasskeyUnavailable);
      return;
    }
    await _withLoading(_AuthAction.mfaPasskey, () async {
      final start = await widget.gateway.startMfaPasskey(challenge.sessionId);
      final credential = await widget.passkeyClient.getCredential(
        start.options,
        serverBaseUrl: widget.gateway.serverBaseUrl,
      );
      await widget.gateway.finishMfaPasskey(
        mfaSessionId: challenge.sessionId,
        passkeySessionId: start.passkeySessionId,
        credential: credential,
      );
      if (mounted) {
        AppNotifications.dismissAll();
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _submitMfaTotp() async {
    final challenge = _mfaChallenge;
    final code = _mfaTotpController.text.trim();
    if (challenge == null || code.length != 6) {
      AppNotifications.showWarning(
        context,
        context.l10n.enterAuthenticatorCode,
      );
      return;
    }
    await _withLoading(_AuthAction.mfaTotp, () async {
      await widget.gateway.verifyMfaTotp(
        mfaSessionId: challenge.sessionId,
        code: code,
      );
      if (mounted) {
        AppNotifications.dismissAll();
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _submitMfaRecoveryCode() async {
    final challenge = _mfaChallenge;
    final code = _mfaRecoveryCodeController.text.trim();
    if (challenge == null || code.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterRecoveryCode);
      return;
    }
    await _withLoading(_AuthAction.mfaRecoveryCode, () async {
      await widget.gateway.verifyMfaRecoveryCode(
        mfaSessionId: challenge.sessionId,
        recoveryCode: code,
      );
      if (mounted) {
        AppNotifications.dismissAll();
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _resetPassword() async {
    if (!_ensureTermsAccepted()) return;
    final reset =
        await showAppDialog<({String email, String token, String password})>(
          context: context,
          builder: (context) => _PasswordResetDialog(
            initialEmail: _loginIdentifierController.text.trim(),
            gateway: widget.gateway,
          ),
        );
    if (reset == null) return;
    await _withLoading(_AuthAction.passwordReset, () async {
      await _opaqueAuthenticator.resetWithEmailToken(
        email: reset.email,
        token: reset.token,
        newPassword: reset.password,
      );
      if (!mounted) return;
      _loginIdentifierController.text = reset.email;
      AppNotifications.showSuccess(context, context.l10n.passwordResetSuccess);
    });
  }

  Future<void> _showUserAgreement() async {
    await showAppDialog<void>(
      context: context,
      builder: (context) =>
          UserAgreementDialog(agreementContent: context.l10n.agreementContent),
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
    final l10n = context.l10n;
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
                      SyncTvBrandMark(
                        semanticLabel: l10n.appTitle,
                        size: 38,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.connectToSyncTv,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              widget.gateway.activeServerName ??
                                  l10n.noServerConnected,
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
                        tooltip: l10n.close,
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
                      tabs: [
                        Tab(
                          icon: const Icon(Icons.login_rounded),
                          text: l10n.login,
                        ),
                        Tab(
                          icon: const Icon(Icons.person_add_alt_1_rounded),
                          text: l10n.register,
                        ),
                        Tab(
                          icon: const Icon(Icons.meeting_room_outlined),
                          text: l10n.guest,
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
    final l10n = context.l10n;
    final login = _validLoginStart();
    final availableMethods = login == null
        ? const <_LoginMethod>[_LoginMethod.password]
        : _availableLoginMethods(login);
    final selectedMethod = availableMethods.contains(_loginMethod)
        ? _loginMethod
        : availableMethods.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: _loginIdentifierController,
          label: l10n.emailOrUsername,
          icon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(_resetLoginDiscovery),
          onSubmitted: (_) => _confirmLoginIdentifier(),
        ),
        const SizedBox(height: 14),
        if (login == null) ...[
          AppActionButton(
            onPressed: _loading ? null : _confirmLoginIdentifier,
            icon: Icons.arrow_forward_rounded,
            label: l10n.continueAction,
            loading: _isLoading(_AuthAction.identifyLogin),
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
                  ButtonSegment(
                    value: _LoginMethod.password,
                    icon: const Icon(Icons.lock_outline_rounded),
                    label: Text(l10n.password),
                  ),
                if (availableMethods.contains(_LoginMethod.emailCode))
                  ButtonSegment(
                    value: _LoginMethod.emailCode,
                    icon: const Icon(Icons.mark_email_read_outlined),
                    label: Text(l10n.verificationCode),
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
              Expanded(
                child: Text(l10n.waitingForAuthorization(_oauthProvider!)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _confirmLoginIdentifier() async {
    final identifier = _loginIdentifierController.text.trim();
    if (identifier.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.emailOrUsernameRequired,
      );
      return;
    }
    await _withLoading(_AuthAction.identifyLogin, () async {
      final login = await widget.gateway.startLogin(identifier);
      if (!mounted) return;
      final methods = _availableLoginMethods(login);
      if (methods.isEmpty) {
        AppNotifications.showWarning(
          context,
          context.l10n.noLoginMethodAvailable,
        );
        return;
      }
      setState(() {
        _resetLoginCredentials();
        _loginStart = login;
        _loginMethod = methods.first;
      });
      _scheduleLoginSessionExpiry(login);
    });
  }

  LoginStart? _validLoginStart() {
    final login = _loginStart;
    if (login == null || login.expiresAt.isBefore(DateTime.now().toUtc())) {
      return null;
    }
    return login;
  }

  void _scheduleLoginSessionExpiry(LoginStart login) {
    _loginSessionExpiryTimer?.cancel();
    final delay = login.expiresAt.difference(DateTime.now().toUtc());
    _loginSessionExpiryTimer = Timer(
      delay.isNegative ? Duration.zero : delay,
      () {
        if (!mounted || _loginStart?.sessionId != login.sessionId) return;
        setState(_resetLoginDiscovery);
      },
    );
  }

  void _resetLoginDiscovery() {
    _loginSessionExpiryTimer?.cancel();
    _loginSessionExpiryTimer = null;
    _loginStart = null;
    _resetLoginCredentials();
  }

  void _resetLoginCredentials() {
    _loginPasswordController.clear();
    _emailTokenRequested = false;
    _emailTokenController.clear();
  }

  void _scheduleMfaSessionExpiry(MfaChallengeInfo challenge) {
    _mfaSessionExpiryTimer?.cancel();
    final delay = challenge.expiresAt.difference(DateTime.now().toUtc());
    _mfaSessionExpiryTimer = Timer(
      delay.isNegative ? Duration.zero : delay,
      () {
        if (!mounted || _mfaChallenge?.sessionId != challenge.sessionId) {
          return;
        }
        setState(() {
          _mfaChallenge = null;
          _resetMfaCredentials();
        });
        AppNotifications.showWarning(
          context,
          context.l10n.authenticationSessionExpired,
        );
      },
    );
  }

  void _resetMfaCredentials() {
    _mfaEmailRequested = false;
    _mfaRecoveryCodeActive = false;
    _mfaTokenController.clear();
    _mfaTotpController.clear();
    _mfaRecoveryCodeController.clear();
  }

  void _confirmRegisterIdentifier() {
    final identifier = _registerIdentifierController.text.trim();
    if (!_hasAvailableRegistrationMethod()) {
      AppNotifications.showWarning(context, context.l10n.registrationDisabled);
      return;
    }
    if (identifier.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.usernameOrEmail);
      return;
    }
    final emailSignupEnabled =
        _settings?.enableEmail == true && _settings?.enableEmailSignup == true;
    if (identifier.contains('@') && !emailSignupEnabled) {
      AppNotifications.showWarning(
        context,
        context.l10n.emailRegistrationDisabled,
      );
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
      _registrationMethod = _availableRegistrationMethods().first;
      _registerPasswordController.clear();
      _registerEmailTokenRequested = false;
      _registerEmailTokenController.clear();
      _passkeyNameController.text = _suggestedPasskeyName;
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

  List<_RegistrationMethod> _availableRegistrationMethods() {
    return [
      if (_passkeyAvailable &&
          _settings?.enableWebauthn == true &&
          _settings?.enableWebauthnSignup == true)
        _RegistrationMethod.passkey,
      if (_settings?.enablePasswordSignup == true) _RegistrationMethod.password,
      if (_settings?.enableEmail == true &&
          _settings?.enableEmailSignup == true)
        _RegistrationMethod.emailVerification,
    ];
  }

  void _selectRegistrationMethod(_RegistrationMethod method) {
    setState(() {
      _registrationMethod = method;
      _registerEmailTokenRequested = false;
      _registerEmailTokenController.clear();
      _registerPasswordController.clear();
      if (method == _RegistrationMethod.emailVerification) {
        _registerIncludeEmail = true;
      }
    });
  }

  String _registrationMethodLabel(_RegistrationMethod method) {
    return switch (method) {
      _RegistrationMethod.passkey => context.l10n.passkeyRegistration,
      _RegistrationMethod.password => context.l10n.password,
      _RegistrationMethod.emailVerification =>
        context.l10n.emailCodeRegistration,
    };
  }

  IconData _registrationMethodIcon(_RegistrationMethod method) {
    return switch (method) {
      _RegistrationMethod.passkey => Icons.fingerprint_rounded,
      _RegistrationMethod.password => Icons.lock_outline_rounded,
      _RegistrationMethod.emailVerification => Icons.mark_email_read_outlined,
    };
  }

  List<_LoginMethod> _availableLoginMethods(LoginStart login) {
    final methods = <_LoginMethod>[];
    if (_passkeyAvailable && login.supportsPasskey) {
      methods.add(_LoginMethod.passkey);
    }
    if (login.supportsPassword) methods.add(_LoginMethod.password);
    if (login.supportsEmailCode) methods.add(_LoginMethod.emailCode);
    return methods;
  }

  Widget _buildSelectedLoginMethod(_LoginMethod method) {
    final l10n = context.l10n;
    switch (method) {
      case _LoginMethod.password:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _loginPasswordController,
              label: l10n.password,
              icon: Icons.lock_outline_rounded,
              obscureText: true,
              onSubmitted: (_) => _submitPasswordLogin(),
            ),
            const SizedBox(height: 14),
            AppActionButton(
              onPressed: _loading ? null : _submitPasswordLogin,
              icon: Icons.login_rounded,
              label: l10n.login,
              loading: _isLoading(_AuthAction.passwordLogin),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: AppActionButton(
                onPressed: _loading ? null : _resetPassword,
                icon: Icons.lock_reset_rounded,
                label: l10n.forgotPassword,
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
                    label: _emailTokenRequested
                        ? l10n.verificationCode
                        : l10n.getCodeFirst,
                    icon: Icons.pin_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                AppActionButton(
                  onPressed: _loading ? null : _requestEmailToken,
                  icon: Icons.send_outlined,
                  label: l10n.send,
                  loading: _isLoading(_AuthAction.requestEmailLogin),
                  style: AppActionButtonStyle.outlined,
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppActionButton(
              onPressed: _loading ? null : _submitEmailLogin,
              icon: Icons.mark_email_read_outlined,
              label: l10n.emailCodeLogin,
              loading: _isLoading(_AuthAction.emailLogin),
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
              label: l10n.passkeyLogin,
              loading: _isLoading(_AuthAction.passkeyLogin),
            ),
          ],
        );
    }
  }

  String _loginMethodLabel(_LoginMethod method) {
    final l10n = context.l10n;
    switch (method) {
      case _LoginMethod.password:
        return l10n.passwordLogin;
      case _LoginMethod.emailCode:
        return l10n.emailCodeLogin;
      case _LoginMethod.passkey:
        return l10n.passkeyLogin;
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
    final l10n = context.l10n;
    final emailSignupEnabled =
        _settings?.enableEmail == true && _settings?.enableEmailSignup == true;
    final registrationMethods = _availableRegistrationMethods();
    final oauthSignupProviders = _oauth2Providers
        .where((provider) => provider.signupEnabled)
        .toList(growable: false);
    final hasLocalRegistrationMethod = registrationMethods.isNotEmpty;
    final hasRegistrationMethod =
        hasLocalRegistrationMethod || oauthSignupProviders.isNotEmpty;
    final identifier = _registerIdentifierController.text.trim();
    final registerByEmail = identifier.contains('@');
    final selectedMethod = registrationMethods.contains(_registrationMethod)
        ? _registrationMethod
        : registrationMethods.firstOrNull;

    if (!_loadingOptions && !hasRegistrationMethod) {
      return AppEmptyState(
        icon: Icons.person_off_outlined,
        title: l10n.registrationDisabled,
        subtitle: l10n.registrationDisabled,
        iconSize: 42,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPolicyHints(theme),
        if (oauthSignupProviders.isNotEmpty) ...[
          _SectionLabel(
            icon: Icons.open_in_new_rounded,
            label: l10n.thirdPartyRegistration,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          _buildOAuth2Buttons(theme, providers: oauthSignupProviders),
          if (hasLocalRegistrationMethod) const SizedBox(height: 18),
        ],
        if (hasLocalRegistrationMethod) ...[
          _SectionLabel(
            icon: Icons.person_add_alt_1_rounded,
            label: l10n.accountRegistration,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _registerIdentifierController,
            label: emailSignupEnabled ? l10n.usernameOrEmail : l10n.username,
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
              label: l10n.continueAction,
            )
          else ...[
            if (registerByEmail) ...[
              _buildTextField(
                controller: _registerUsernameController,
                label: l10n.username,
                icon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
            ],
            if (selectedMethod != null && registrationMethods.length > 1) ...[
              _SectionLabel(
                icon: Icons.how_to_reg_rounded,
                label: l10n.registrationMethod,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 10),
              AppSingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AppSegmentedControl<_RegistrationMethod>(
                  key: const ValueKey('registration-method-selector'),
                  segments: [
                    if (registrationMethods.contains(
                      _RegistrationMethod.passkey,
                    ))
                      const ButtonSegment(
                        value: _RegistrationMethod.passkey,
                        icon: Icon(Icons.fingerprint_rounded),
                        label: Text('Passkey'),
                      ),
                    if (registrationMethods.contains(
                      _RegistrationMethod.password,
                    ))
                      ButtonSegment(
                        value: _RegistrationMethod.password,
                        icon: const Icon(Icons.lock_outline_rounded),
                        label: Text(l10n.password),
                      ),
                    if (registrationMethods.contains(
                      _RegistrationMethod.emailVerification,
                    ))
                      ButtonSegment(
                        value: _RegistrationMethod.emailVerification,
                        icon: const Icon(Icons.mark_email_read_outlined),
                        label: Text(l10n.emailCodeRegistration),
                      ),
                  ],
                  value: selectedMethod,
                  onChanged: (method) {
                    if (_loading) return;
                    _selectRegistrationMethod(method);
                  },
                ),
              ),
              const SizedBox(height: 14),
            ] else if (selectedMethod != null) ...[
              _SectionLabel(
                icon: _registrationMethodIcon(selectedMethod),
                label: _registrationMethodLabel(selectedMethod),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 10),
            ],
            if (!registerByEmail &&
                emailSignupEnabled &&
                selectedMethod != _RegistrationMethod.emailVerification) ...[
              AppCheckboxTile(
                value: _registerIncludeEmail,
                onChanged: _loading
                    ? null
                    : (value) => setState(() {
                        _registerIncludeEmail = value;
                        if (!value) {
                          _registerEmailController.clear();
                          _registerEmailTokenController.clear();
                          _registerEmailTokenRequested = false;
                        }
                      }),
                title: Text(l10n.includeEmail),
                subtitle: Text(l10n.includeEmailDescription),
              ),
            ],
            if (!registerByEmail &&
                emailSignupEnabled &&
                (selectedMethod == _RegistrationMethod.emailVerification ||
                    _registerIncludeEmail)) ...[
              const SizedBox(height: 8),
              _buildTextField(
                controller: _registerEmailController,
                label: l10n.email,
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
            if (selectedMethod == _RegistrationMethod.password) ...[
              _buildTextField(
                key: const ValueKey('password-registration-field'),
                controller: _registerPasswordController,
                label: l10n.password,
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              AppActionButton(
                onPressed: _loading ? null : _submitPasswordRegistration,
                icon: Icons.person_add_alt_1_rounded,
                label: l10n.createAccount,
                loading: _isLoading(_AuthAction.passwordRegistration),
              ),
            ] else if (selectedMethod ==
                _RegistrationMethod.emailVerification) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      key: const ValueKey('email-registration-code-field'),
                      controller: _registerEmailTokenController,
                      label: _registerEmailTokenRequested
                          ? l10n.verificationCode
                          : l10n.getCodeFirst,
                      icon: Icons.pin_outlined,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppActionButton(
                    onPressed: _loading ? null : _requestEmailRegistrationToken,
                    icon: Icons.send_outlined,
                    label: l10n.send,
                    loading: _isLoading(_AuthAction.requestEmailRegistration),
                    style: AppActionButtonStyle.outlined,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _registerPasswordController,
                label: l10n.password,
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              AppActionButton(
                onPressed: _loading ? null : _submitEmailRegistration,
                icon: Icons.mark_email_read_outlined,
                label: l10n.createAccountWithEmailCode,
                loading: _isLoading(_AuthAction.emailRegistration),
              ),
            ] else if (selectedMethod == _RegistrationMethod.passkey) ...[
              _buildTextField(
                key: const ValueKey('passkey-registration-name-field'),
                controller: _passkeyNameController,
                label: l10n.deviceNameHint,
                icon: Icons.devices_rounded,
              ),
              const SizedBox(height: 12),
              AppActionButton(
                onPressed: _loading ? null : _submitPasskeyRegistration,
                icon: Icons.fingerprint_rounded,
                label: l10n.createPasskeyAccount,
                loading: _isLoading(_AuthAction.passkeyRegistration),
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
                        _registerPasswordController.clear();
                        _registerEmailTokenController.clear();
                      }),
                icon: Icons.edit_outlined,
                label: l10n.edit,
                style: AppActionButtonStyle.text,
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildGuestTab(ThemeData theme) {
    final l10n = context.l10n;
    final guestEnabled = _settings?.enableGuest == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.guestAccessDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 18),
        _buildTextField(
          controller: _guestRoomController,
          label: guestEnabled ? l10n.roomId : l10n.guestAccessDisabled,
          icon: Icons.meeting_room_outlined,
          enabled: guestEnabled && !_loading,
          onSubmitted: (_) => _submitGuest(),
        ),
        const SizedBox(height: 14),
        AppActionButton(
          onPressed: guestEnabled && !_loading ? _submitGuest : null,
          icon: Icons.door_front_door_outlined,
          label: l10n.enterAsGuest,
          loading: _isLoading(_AuthAction.guestLogin),
        ),
      ],
    );
  }

  Widget _buildMfaPanel(ThemeData theme) {
    final l10n = context.l10n;
    final challenge = _mfaChallenge!;
    final methods = _availableMfaMethods(challenge);
    final selectedMethod = methods.contains(_mfaMethod)
        ? _mfaMethod
        : methods.firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(
          icon: Icons.verified_user_outlined,
          label: l10n.twoFactorVerification,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          selectedMethod == _MfaMethod.email &&
                  _mfaEmailRequested &&
                  challenge.maskedEmail.isNotEmpty
              ? l10n.codeSentTo(challenge.maskedEmail)
              : l10n.additionalVerificationRequired,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        if (_mfaRecoveryCodeActive)
          AuthRecoveryCodeFallback(
            active: true,
            recoveryForm: _buildMfaRecoveryCodeForm(),
            onOpen: null,
            onBack: _loading
                ? null
                : () => setState(() {
                    _mfaRecoveryCodeActive = false;
                    _mfaRecoveryCodeController.clear();
                  }),
          )
        else ...[
          if (methods.length > 1) ...[
            AppSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppSegmentedControl<_MfaMethod>(
                segments: [
                  for (final method in methods)
                    ButtonSegment(
                      value: method,
                      icon: Icon(_mfaMethodIcon(method)),
                      label: Text(_mfaMethodLabel(method)),
                    ),
                ],
                value: selectedMethod!,
                onChanged: (method) {
                  if (_loading) return;
                  setState(() => _mfaMethod = method);
                },
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (selectedMethod != null)
            _buildSelectedMfaMethod(selectedMethod)
          else if (!challenge.supportsRecoveryCode)
            Text(
              l10n.noVerificationMethodsDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            )
          else
            const SizedBox.shrink(),
          if (challenge.supportsRecoveryCode) ...[
            const SizedBox(height: 8),
            AuthRecoveryCodeFallback(
              active: false,
              recoveryForm: const SizedBox.shrink(),
              onOpen: _loading
                  ? null
                  : () => setState(() => _mfaRecoveryCodeActive = true),
              onBack: null,
            ),
          ],
        ],
      ],
    );
  }

  List<_MfaMethod> _availableMfaMethods(MfaChallengeInfo challenge) {
    return [
      if (challenge.supportsPasskey &&
          _passkeyAvailable &&
          _settings?.enableWebauthn == true)
        _MfaMethod.passkey,
      if (challenge.supportsTotp) _MfaMethod.totp,
      if (challenge.supportsEmail) _MfaMethod.email,
    ];
  }

  Widget _buildMfaRecoveryCodeForm() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          key: const ValueKey('mfa-recovery-code-field'),
          controller: _mfaRecoveryCodeController,
          label: l10n.recoveryCode,
          icon: Icons.key_rounded,
          enabled: !_loading,
          onSubmitted: (_) => _submitMfaRecoveryCode(),
        ),
        const SizedBox(height: 10),
        AppActionButton(
          onPressed: _loading ? null : _submitMfaRecoveryCode,
          icon: Icons.key_rounded,
          label: l10n.verifyWithRecoveryCode,
          loading: _isLoading(_AuthAction.mfaRecoveryCode),
        ),
      ],
    );
  }

  Widget _buildSelectedMfaMethod(_MfaMethod method) {
    final l10n = context.l10n;
    return switch (method) {
      _MfaMethod.passkey => AppActionButton(
        onPressed: _loading ? null : _submitMfaPasskey,
        icon: Icons.fingerprint_rounded,
        label: l10n.verifyWithPasskey,
        loading: _isLoading(_AuthAction.mfaPasskey),
      ),
      _MfaMethod.totp => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _mfaTotpController,
            label: l10n.authenticatorCode,
            icon: Icons.password_rounded,
            enabled: !_loading,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitMfaTotp(),
          ),
          const SizedBox(height: 10),
          AppActionButton(
            onPressed: _loading ? null : _submitMfaTotp,
            icon: Icons.shield_outlined,
            label: l10n.verifyWithAuthenticator,
            loading: _isLoading(_AuthAction.mfaTotp),
          ),
        ],
      ),
      _MfaMethod.email => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _mfaTokenController,
                  label: _mfaEmailRequested
                      ? l10n.verificationCode
                      : l10n.getMfaCodeFirst,
                  icon: Icons.pin_outlined,
                  enabled: !_loading,
                ),
              ),
              const SizedBox(width: 8),
              AppActionButton(
                onPressed: _loading ? null : _requestMfaEmailToken,
                icon: Icons.send_outlined,
                label: l10n.send,
                loading: _isLoading(_AuthAction.requestMfaEmail),
                style: AppActionButtonStyle.outlined,
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppActionButton(
            onPressed: _loading ? null : _submitMfaEmailToken,
            icon: Icons.mark_email_read_outlined,
            label: l10n.verifyWithEmail,
            loading: _isLoading(_AuthAction.mfaEmail),
          ),
        ],
      ),
    };
  }

  String _mfaMethodLabel(_MfaMethod method) {
    return switch (method) {
      _MfaMethod.passkey => 'Passkey',
      _MfaMethod.totp => context.l10n.authenticatorApp,
      _MfaMethod.email => context.l10n.email,
    };
  }

  IconData _mfaMethodIcon(_MfaMethod method) {
    return switch (method) {
      _MfaMethod.passkey => Icons.fingerprint_rounded,
      _MfaMethod.totp => Icons.shield_outlined,
      _MfaMethod.email => Icons.mark_email_read_outlined,
    };
  }

  Widget _buildOAuth2Entry(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: AppDivider(color: theme.dividerColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                context.l10n.thirdPartyLogin,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(child: AppDivider(color: theme.dividerColor)),
          ],
        ),
        const SizedBox(height: 10),
        _buildOAuth2Buttons(theme),
      ],
    );
  }

  Widget _buildOAuth2Buttons(
    ThemeData theme, {
    List<OAuth2ProviderOption>? providers,
  }) {
    final browserAvailable = widget.oauth2Callbacks.canCreateSession;
    final nativeAvailable = widget.nativeAppleSignIn.isSupported;
    final visibleProviders = (providers ?? _oauth2Providers)
        .where(
          (provider) => isOAuthProviderAvailable(
            provider,
            browserAvailable: browserAvailable,
            nativeAvailable: nativeAvailable,
          ),
        )
        .toList(growable: false);
    if (visibleProviders.isEmpty) return const SizedBox.shrink();
    final orderedProviders = [
      ...visibleProviders.where(isAppleOAuthProvider),
      ...visibleProviders.where((provider) => !isAppleOAuthProvider(provider)),
    ];
    final buttons = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final provider in orderedProviders) ...[
          if (selectOAuth2AuthorizationMode(
                    provider,
                    platform: defaultTargetPlatform,
                    browserAvailable: browserAvailable,
                    nativeAvailable: nativeAvailable,
                  ) ==
                  OAuth2ClientAuthorizationMode.native &&
              shouldUseAppleSignInButton(provider, defaultTargetPlatform)) ...[
            AppleSignInButton(
              enabled: !_loading,
              semanticLabel: context.l10n.continueWithProvider('Apple'),
              onPressed: () => _startOAuth2(provider),
            ),
            if (_oauth2ProviderLabel(provider) != 'Apple') ...[
              const SizedBox(height: 4),
              Text(
                _oauth2ProviderLabel(provider),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ] else
            AppActionButton(
              onPressed: _loading || !browserAvailable
                  ? null
                  : () => _startOAuth2(provider),
              prefix: OAuthProviderIcon(
                type: provider.type,
                name: provider.name,
              ),
              label: context.l10n.continueWithProvider(
                _oauth2ProviderLabel(provider),
              ),
              style: AppActionButtonStyle.outlined,
            ),
          const SizedBox(height: 8),
        ],
        if (!browserAvailable && !nativeAvailable)
          Text(
            context.l10n.oauthCallbackUnavailable,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
    if (!supportsNativeAppleSignInButton(defaultTargetPlatform)) return buttons;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 375),
        child: buttons,
      ),
    );
  }

  String _oauth2ProviderLabel(OAuth2ProviderOption provider) {
    final display = oauthProviderDisplayName(
      type: provider.type,
      name: provider.name,
    );
    if (provider.signupNeedReview) {
      return context.l10n.providerReviewRequired(display);
    }
    if (!provider.signupEnabled) {
      return context.l10n.providerLoginOnly(display);
    }
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
    Key? key,
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
      key: key ?? ObjectKey(controller),
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
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
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
      semanticsLabel: context.l10n.acceptTermsSemantics,
      contentPadding: EdgeInsets.zero,
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 2,
        children: [
          Text(context.l10n.termsPrefix),
          AppActionButton(
            onPressed: onOpenAgreement,
            label: context.l10n.userAgreementLink,
            style: AppActionButtonStyle.text,
            size: AppActionButtonSize.sm,
          ),
          Text(context.l10n.and),
          AppActionButton(
            onPressed: onOpenAgreement,
            label: context.l10n.privacyPolicyLink,
            style: AppActionButtonStyle.text,
            size: AppActionButtonSize.sm,
          ),
        ],
      ),
    );
  }
}

class _PasswordResetDialog extends StatefulWidget {
  const _PasswordResetDialog({
    required this.initialEmail,
    required this.gateway,
  });

  final String initialEmail;
  final AuthGateway gateway;

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
      AppNotifications.showWarning(context, context.l10n.emailRequired);
      return;
    }
    setState(() => _requesting = true);
    try {
      final message = await widget.gateway.requestPasswordReset(email);
      if (!mounted) return;
      AppNotifications.showSuccess(
        context,
        message.isEmpty ? context.l10n.passwordResetEmailSent : message,
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.passwordResetEmailFailed(e.toString()),
        );
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  void _submit() {
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || token.isEmpty || password.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.resetFieldsRequired);
      return;
    }
    if (password != _confirmController.text) {
      AppNotifications.showWarning(context, context.l10n.newPasswordsMismatch);
      return;
    }
    Navigator.pop(context, (email: email, token: token, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Text(context.l10n.resetPassword),
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
                    label: context.l10n.email,
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
                  label: context.l10n.send,
                  loading: _requesting,
                  style: AppActionButtonStyle.outlined,
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _tokenController,
              label: context.l10n.resetCode,
              prefixIcon: Icons.pin_outlined,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordController,
              label: context.l10n.newPassword,
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _confirmController,
              label: context.l10n.confirmNewPassword,
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
          label: context.l10n.cancel,
          style: AppActionButtonStyle.outlined,
        ),
        AppActionButton(
          onPressed: _submit,
          icon: Icons.lock_reset_rounded,
          label: context.l10n.reset,
        ),
      ],
    );
  }
}
