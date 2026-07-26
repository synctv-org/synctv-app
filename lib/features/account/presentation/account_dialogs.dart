part of 'account_center_page.dart';

enum _NotificationDetailAction { markRead, delete }

enum _PasswordUpdateMethod { currentPassword, emailToken, passkey }

class _TotpSetupDialog extends StatefulWidget {
  const _TotpSetupDialog({required this.setup});

  final TotpSetupInfo setup;

  @override
  State<_TotpSetupDialog> createState() => _TotpSetupDialogState();
}

class _TotpSetupDialogState extends State<_TotpSetupDialog> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _codeController.text.trim();
    if (code.length != 6 || int.tryParse(code) == null) {
      AppNotifications.showWarning(
        context,
        context.l10n.enterAuthenticatorCode,
      );
      return;
    }
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    return _AccountActionDialog(
      icon: Icons.shield_outlined,
      title: context.l10n.setupAuthenticatorApp,
      subtitle: context.l10n.setupAuthenticatorAppDescription,
      maxWidth: 540,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: AppPanelSurface(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              child: QrImageView(
                data: widget.setup.otpauthUri,
                size: 220,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: context.l10n.manualSetupKey,
            child: Row(
              children: [
                Expanded(child: AppSelectableText(widget.setup.secret)),
                AppIconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: widget.setup.secret),
                    );
                    if (!mounted) return;
                    AppNotifications.showSuccess(
                      this.context,
                      this.context.l10n.copied,
                    );
                  },
                  icon: Icons.copy_rounded,
                  tooltip: context.l10n.copy,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DialogTextField(
            controller: _codeController,
            autofocus: true,
            label: context.l10n.authenticatorCode,
            icon: Icons.password_rounded,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      primaryLabel: context.l10n.confirmSetup,
      onPrimary: _submit,
    );
  }
}

class _TotpRecoveryCodesDialog extends StatelessWidget {
  const _TotpRecoveryCodesDialog({required this.codes});

  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: AppDialogFrame(
        maxWidth: 520,
        child: AppInkSurface(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.saveRecoveryCodes,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.recoveryCodesShownOnce,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                AppPanelSurface(
                  padding: const EdgeInsets.all(16),
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  child: AppSelectableText(
                    codes.join('\n'),
                    monospace: true,
                    style: const TextStyle(height: 1.6),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    AppActionButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: codes.join('\n')),
                        );
                        if (context.mounted) {
                          AppNotifications.showSuccess(
                            context,
                            context.l10n.copied,
                          );
                        }
                      },
                      icon: Icons.copy_all_rounded,
                      label: context.l10n.copyAll,
                      style: AppActionButtonStyle.outlined,
                    ),
                    const Spacer(),
                    AppActionButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icons.check_rounded,
                      label: context.l10n.savedRecoveryCodes,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SensitiveOperationMethod { password, email, passkey, totp, recoveryCode }

class _PasswordUpdateInput {
  final _PasswordUpdateMethod method;
  final String currentPassword;
  final String emailToken;
  final String newPassword;

  const _PasswordUpdateInput({
    required this.method,
    this.currentPassword = '',
    this.emailToken = '',
    required this.newPassword,
  });
}

class _PasswordResetInput {
  final String token;
  final String newPassword;

  const _PasswordResetInput({required this.token, required this.newPassword});
}

class _PasswordUpdateDialog extends StatefulWidget {
  final bool canUseCurrentPassword;
  final bool canUseEmail;
  final bool canUsePasskey;

  const _PasswordUpdateDialog({
    required this.canUseCurrentPassword,
    required this.canUseEmail,
    required this.canUsePasskey,
  });

  @override
  State<_PasswordUpdateDialog> createState() => _PasswordUpdateDialogState();
}

class _PasswordUpdateDialogState extends State<_PasswordUpdateDialog> {
  late _PasswordUpdateMethod _method;
  final _currentPasswordController = TextEditingController();
  final _emailTokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _method = widget.canUseCurrentPassword
        ? _PasswordUpdateMethod.currentPassword
        : widget.canUseEmail
        ? _PasswordUpdateMethod.emailToken
        : _PasswordUpdateMethod.passkey;
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _emailTokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (newPassword.isEmpty || newPassword != confirmPassword) return;
    switch (_method) {
      case _PasswordUpdateMethod.currentPassword:
        final currentPassword = _currentPasswordController.text;
        if (currentPassword.isEmpty) return;
        Navigator.pop(
          context,
          _PasswordUpdateInput(
            method: _method,
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
        );
      case _PasswordUpdateMethod.emailToken:
        final emailToken = _emailTokenController.text.trim();
        if (emailToken.isEmpty) return;
        Navigator.pop(
          context,
          _PasswordUpdateInput(
            method: _method,
            emailToken: emailToken,
            newPassword: newPassword,
          ),
        );
      case _PasswordUpdateMethod.passkey:
        Navigator.pop(
          context,
          _PasswordUpdateInput(method: _method, newPassword: newPassword),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final methods = <ButtonSegment<_PasswordUpdateMethod>>[
      if (widget.canUseCurrentPassword)
        ButtonSegment(
          value: _PasswordUpdateMethod.currentPassword,
          icon: const Icon(Icons.password_rounded),
          label: Text(context.l10n.currentPassword),
        ),
      if (widget.canUseEmail)
        ButtonSegment(
          value: _PasswordUpdateMethod.emailToken,
          icon: const Icon(Icons.mark_email_read_rounded),
          label: Text(context.l10n.email),
        ),
      if (widget.canUsePasskey)
        const ButtonSegment(
          value: _PasswordUpdateMethod.passkey,
          icon: Icon(Icons.fingerprint_rounded),
          label: Text('Passkey'),
        ),
    ];
    final methodDescriptions = {
      _PasswordUpdateMethod.currentPassword:
          context.l10n.verifyWithCurrentPassword,
      _PasswordUpdateMethod.emailToken: context.l10n.verifyWithEmailCode,
      _PasswordUpdateMethod.passkey: context.l10n.verifyWithSystemPasskey,
    };
    return _AccountActionDialog(
      icon: Icons.lock_reset_rounded,
      title: context.l10n.changePassword,
      subtitle: context.l10n.changePasswordDescription,
      maxWidth: 560,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (methods.length > 1) ...[
            _DialogFieldGroup(
              title: context.l10n.verificationMethod,
              subtitle: methodDescriptions[_method] ?? '',
              child: AppSingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AppSegmentedControl<_PasswordUpdateMethod>(
                  segments: methods,
                  value: _method,
                  onChanged: (selected) => setState(() => _method = selected),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _DialogFieldGroup(
            title: context.l10n.identityVerification,
            children: [
              if (_method == _PasswordUpdateMethod.currentPassword)
                _DialogTextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  autofocus: true,
                  label: context.l10n.currentPassword,
                  icon: Icons.lock_outline_rounded,
                  textInputAction: TextInputAction.next,
                ),
              if (_method == _PasswordUpdateMethod.emailToken)
                _DialogTextField(
                  controller: _emailTokenController,
                  autofocus: true,
                  label: context.l10n.emailVerificationCode,
                  icon: Icons.mark_email_read_outlined,
                  textInputAction: TextInputAction.next,
                ),
              if (_method == _PasswordUpdateMethod.passkey)
                _DialogNotice(
                  icon: Icons.fingerprint_rounded,
                  title: context.l10n.passkeyVerification,
                  message: context.l10n.passkeyPasswordUpdateDescription,
                ),
            ],
          ),
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: context.l10n.newPassword,
            children: [
              _DialogTextField(
                controller: _newPasswordController,
                obscureText: true,
                label: context.l10n.newPassword,
                icon: Icons.lock_reset_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              _DialogTextField(
                controller: _confirmPasswordController,
                obscureText: true,
                label: context.l10n.confirmNewPassword,
                icon: Icons.check_circle_outline_rounded,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ],
      ),
      primaryLabel: context.l10n.savePassword,
      onPrimary: _submit,
    );
  }
}

class _PasswordResetDialog extends StatefulWidget {
  final String email;

  const _PasswordResetDialog({required this.email});

  @override
  State<_PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<_PasswordResetDialog> {
  AccountGateway get _gateway => _accountGateway(context);

  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _requesting = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _requestResetEmail() async {
    if (_requesting) return;
    setState(() => _requesting = true);
    try {
      final message = await _gateway.requestPasswordReset(widget.email);
      if (!mounted) return;
      AppNotifications.showSuccess(
        context,
        message.isEmpty ? context.l10n.passwordResetEmailSent : message,
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.passwordResetEmailFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  void _submit() {
    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (token.isEmpty || newPassword.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.codeAndNewPasswordRequired,
      );
      return;
    }
    if (newPassword != confirmPassword) {
      AppNotifications.showWarning(context, context.l10n.newPasswordsMismatch);
      return;
    }
    Navigator.pop(
      context,
      _PasswordResetInput(token: token, newPassword: newPassword),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AccountActionDialog(
      icon: Icons.mark_email_read_rounded,
      title: context.l10n.emailPasswordReset,
      subtitle: context.l10n.emailPasswordResetDescription,
      maxWidth: 560,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DialogFieldGroup(
            title: context.l10n.recipientEmail,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 420;
                final emailField = _DialogReadOnlyField(
                  label: context.l10n.email,
                  value: widget.email,
                  icon: Icons.email_outlined,
                );
                final sendButton = AppActionButton(
                  onPressed: _requestResetEmail,
                  loading: _requesting,
                  icon: Icons.send_rounded,
                  label: context.l10n.sendVerificationCode,
                  style: AppActionButtonStyle.outlined,
                );
                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      emailField,
                      const SizedBox(height: 10),
                      sendButton,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: emailField),
                    const SizedBox(width: 10),
                    SizedBox(height: 48, child: sendButton),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: context.l10n.verificationCode,
            children: [
              _DialogTextField(
                controller: _tokenController,
                autofocus: true,
                label: context.l10n.resetCode,
                icon: Icons.mark_email_read_outlined,
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: context.l10n.newPassword,
            children: [
              _DialogTextField(
                controller: _newPasswordController,
                obscureText: true,
                label: context.l10n.newPassword,
                icon: Icons.lock_reset_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              _DialogTextField(
                controller: _confirmPasswordController,
                obscureText: true,
                label: context.l10n.confirmNewPassword,
                icon: Icons.check_circle_outline_rounded,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ],
      ),
      primaryLabel: context.l10n.resetPassword,
      onPrimary: _submit,
    );
  }
}

class _EmailBindDialog extends StatefulWidget {
  final Future<String?> Function() verifySensitiveOperation;

  const _EmailBindDialog({required this.verifySensitiveOperation});

  @override
  State<_EmailBindDialog> createState() => _EmailBindDialogState();
}

class _EmailBindDialogState extends State<_EmailBindDialog> {
  AccountGateway get _gateway => _accountGateway(context);

  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  String _maskedEmail = '';
  bool _requesting = false;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _requestToken() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || _requesting) return;
    setState(() => _requesting = true);
    try {
      final maskedEmail = await _gateway.startEmailBind(email);
      if (!mounted) return;
      setState(() => _maskedEmail = maskedEmail);
      AppNotifications.showSuccess(context, context.l10n.bindingEmailSent);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.sendBindingEmailFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    if (email.isEmpty || token.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      final verificationId = await widget.verifySensitiveOperation();
      if (verificationId == null) return;
      final user = await _gateway.confirmEmailBind(
        email: email,
        token: token,
        verificationId: verificationId,
      );
      if (mounted) Navigator.pop(context, user);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.bindEmailFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AccountActionDialog(
      icon: Icons.alternate_email_rounded,
      title: context.l10n.bindEmail,
      subtitle: context.l10n.bindEmailBenefits,
      maxWidth: 560,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DialogFieldGroup(
            title: context.l10n.emailAddress,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 420;
                final emailField = _DialogTextField(
                  controller: _emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  label: context.l10n.email,
                  icon: Icons.email_outlined,
                  textInputAction: TextInputAction.next,
                );
                final sendButton = AppActionButton(
                  onPressed: _requestToken,
                  loading: _requesting,
                  icon: Icons.send_rounded,
                  label: context.l10n.sendVerificationCode,
                  style: AppActionButtonStyle.outlined,
                );
                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      emailField,
                      const SizedBox(height: 10),
                      sendButton,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: emailField),
                    const SizedBox(width: 10),
                    SizedBox(height: 48, child: sendButton),
                  ],
                );
              },
            ),
          ),
          if (_maskedEmail.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DialogNotice(
              icon: Icons.mark_email_read_rounded,
              title: context.l10n.confirmationEmailSent,
              message: context.l10n.codeSentTo(_maskedEmail),
            ),
          ],
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: context.l10n.confirmBinding,
            children: [
              _DialogTextField(
                controller: _tokenController,
                label: context.l10n.bindingCode,
                icon: Icons.mark_email_read_outlined,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ],
      ),
      primaryLabel: context.l10n.bindEmail,
      primaryLoading: _submitting,
      onPrimary: _submitting ? null : _submit,
    );
  }
}

class _SensitiveOperationDialog extends StatefulWidget {
  final bool passkeyAvailable;

  const _SensitiveOperationDialog({required this.passkeyAvailable});

  @override
  State<_SensitiveOperationDialog> createState() =>
      _SensitiveOperationDialogState();
}

class _SensitiveOperationDialogState extends State<_SensitiveOperationDialog> {
  AccountGateway get _gateway => _accountGateway(context);
  PasskeyClient get _passkeysClient => _passkeyClient(context);

  final _passwordController = TextEditingController();
  final _emailTokenController = TextEditingController();
  final _totpController = TextEditingController();
  final _recoveryCodeController = TextEditingController();
  SensitiveOperationVerificationChallengeInfo? _challenge;
  SensitiveOperationEmailCodeInfo? _emailCode;
  _SensitiveOperationMethod? _method;
  bool _loading = true;
  bool _requestingEmail = false;
  bool _submitting = false;
  Timer? _expirationTimer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _expirationTimer?.cancel();
    _passwordController.dispose();
    _emailTokenController.dispose();
    _totpController.dispose();
    _recoveryCodeController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _loading = true);
    try {
      final verification = await _gateway.startSensitiveOperationVerification();
      if (!mounted) return;
      switch (verification) {
        case SensitiveOperationVerificationComplete(:final verificationId):
          Navigator.pop(context, verificationId);
        case SensitiveOperationVerificationPending(:final challenge):
          if (challenge.isExpired) {
            await _start();
            return;
          }
          final method = _defaultMethod(challenge);
          setState(() {
            _challenge = challenge;
            _method = method;
            _loading = false;
          });
          _scheduleExpiration(challenge);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        AppNotifications.showError(
          context,
          context.l10n.initializeVerificationFailed('$e'),
        );
      }
    }
  }

  void _scheduleExpiration(
    SensitiveOperationVerificationChallengeInfo challenge,
  ) {
    _expirationTimer?.cancel();
    _expirationTimer = Timer(
      challenge.expiresAt.difference(DateTime.now()),
      _restartExpiredVerification,
    );
  }

  void _restartExpiredVerification() {
    if (!mounted) return;
    if (_submitting || _requestingEmail) {
      _expirationTimer = Timer(
        const Duration(seconds: 1),
        _restartExpiredVerification,
      );
      return;
    }
    _emailCode = null;
    _challenge = null;
    _method = null;
    _passwordController.clear();
    _emailTokenController.clear();
    _totpController.clear();
    _recoveryCodeController.clear();
    _start();
  }

  _SensitiveOperationMethod? _defaultMethod(
    SensitiveOperationVerificationChallengeInfo challenge,
  ) {
    if (_method != null &&
        _method != _SensitiveOperationMethod.recoveryCode &&
        _methodAvailable(challenge, _method!)) {
      return _method;
    }
    return switch (challenge.preferredMethodOnDevice(
      passkeyAvailable: widget.passkeyAvailable,
    )) {
      client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN =>
        _SensitiveOperationMethod.passkey,
      client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_TOTP =>
        _SensitiveOperationMethod.totp,
      client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD =>
        _SensitiveOperationMethod.password,
      client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL =>
        _SensitiveOperationMethod.email,
      _ => null,
    };
  }

  bool _methodAvailable(
    SensitiveOperationVerificationChallengeInfo challenge,
    _SensitiveOperationMethod method,
  ) {
    return challenge.supportsMethodOnDevice(
      _methodProto(method),
      passkeyAvailable: widget.passkeyAvailable,
    );
  }

  client_enum.SensitiveOperationVerificationMethod _methodProto(
    _SensitiveOperationMethod method,
  ) {
    return switch (method) {
      _SensitiveOperationMethod.password =>
        client_enum
            .SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD,
      _SensitiveOperationMethod.email =>
        client_enum
            .SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL,
      _SensitiveOperationMethod.passkey =>
        client_enum
            .SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN,
      _SensitiveOperationMethod.totp =>
        client_enum
            .SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_TOTP,
      _SensitiveOperationMethod.recoveryCode =>
        client_enum
            .SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_RECOVERY_CODE,
    };
  }

  List<ButtonSegment<_SensitiveOperationMethod>> _methodSegments(
    SensitiveOperationVerificationChallengeInfo challenge,
  ) {
    return [
      if (_methodAvailable(challenge, _SensitiveOperationMethod.password))
        ButtonSegment(
          value: _SensitiveOperationMethod.password,
          icon: const Icon(Icons.password_rounded),
          label: Text(context.l10n.password),
        ),
      if (_methodAvailable(challenge, _SensitiveOperationMethod.passkey))
        const ButtonSegment(
          value: _SensitiveOperationMethod.passkey,
          icon: Icon(Icons.fingerprint_rounded),
          label: Text('Passkey'),
        ),
      if (_methodAvailable(challenge, _SensitiveOperationMethod.totp))
        ButtonSegment(
          value: _SensitiveOperationMethod.totp,
          icon: const Icon(Icons.shield_outlined),
          label: Text(context.l10n.authenticatorApp),
        ),
      if (_methodAvailable(challenge, _SensitiveOperationMethod.email))
        ButtonSegment(
          value: _SensitiveOperationMethod.email,
          icon: const Icon(Icons.mark_email_read_rounded),
          label: Text(context.l10n.email),
        ),
    ];
  }

  Future<void> _requestEmailCode() async {
    final challenge = _challenge;
    if (challenge == null || _requestingEmail) return;
    if (challenge.isExpired) {
      _restartExpiredVerification();
      return;
    }
    setState(() => _requestingEmail = true);
    try {
      final info = await _gateway.requestSensitiveOperationEmailCode(
        challenge.sessionId,
      );
      if (!mounted) return;
      setState(() => _emailCode = info);
      AppNotifications.showSuccess(
        context,
        info.message.isEmpty ? context.l10n.verificationCodeSent : info.message,
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.sendCodeFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _requestingEmail = false);
    }
  }

  Future<void> _submit() async {
    final challenge = _challenge;
    final method = _method;
    if (challenge == null || method == null || _submitting) return;
    if (challenge.isExpired) {
      _restartExpiredVerification();
      return;
    }
    if (method == _SensitiveOperationMethod.password &&
        _passwordController.text.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterCurrentPassword);
      return;
    }
    if (method == _SensitiveOperationMethod.email &&
        _emailTokenController.text.trim().isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterEmailCode);
      return;
    }
    if (method == _SensitiveOperationMethod.totp &&
        _totpController.text.trim().length != 6) {
      AppNotifications.showWarning(
        context,
        context.l10n.enterAuthenticatorCode,
      );
      return;
    }
    if (method == _SensitiveOperationMethod.recoveryCode &&
        _recoveryCodeController.text.trim().isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterRecoveryCode);
      return;
    }
    final l10n = context.l10n;
    setState(() => _submitting = true);
    try {
      var passkeySessionId = '';
      Object? passkeyCredential;
      if (method == _SensitiveOperationMethod.passkey) {
        final passkey = await _gateway.startSensitiveOperationPasskey(
          challenge.sessionId,
        );
        if (passkey.passkeySessionId.isEmpty || passkey.options.isEmpty) {
          throw FormatException(l10n.passkeyChallengeMissing);
        }
        passkeySessionId = passkey.passkeySessionId;
        passkeyCredential = await _passkeysClient.getCredential(
          passkey.options,
          serverBaseUrl: _gateway.serverBaseUrl,
        );
      }
      final finished = await _gateway.finishSensitiveOperationVerification(
        sessionId: challenge.sessionId,
        method: _methodProto(method),
        password: _passwordController.text,
        emailToken: _emailTokenController.text.trim(),
        passkeySessionId: passkeySessionId,
        passkeyCredential: passkeyCredential,
        totpCode: _totpController.text.trim(),
        recoveryCode: _recoveryCodeController.text.trim(),
      );
      if (!mounted) return;
      switch (finished) {
        case SensitiveOperationVerificationComplete(:final verificationId):
          _expirationTimer?.cancel();
          Navigator.pop(context, verificationId);
        case SensitiveOperationVerificationPending(:final challenge):
          setState(() {
            _challenge = challenge;
            _method = _defaultMethod(challenge);
            _emailCode = null;
            _passwordController.clear();
            _emailTokenController.clear();
            _totpController.clear();
            _recoveryCodeController.clear();
          });
          _scheduleExpiration(challenge);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.identityVerificationFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = _challenge;
    final method = _method;
    final segments = challenge == null
        ? const <ButtonSegment<_SensitiveOperationMethod>>[]
        : _methodSegments(challenge);
    final recoveryAvailable =
        challenge != null &&
        _methodAvailable(challenge, _SensitiveOperationMethod.recoveryCode);
    final usingRecoveryCode = method == _SensitiveOperationMethod.recoveryCode;
    return _AccountActionDialog(
      icon: Icons.verified_user_rounded,
      title: context.l10n.identityVerification,
      subtitle: context.l10n.identityVerificationDescription,
      maxWidth: 560,
      content: _loading
          ? const SizedBox(
              height: 72,
              child: Center(child: AppLoadingIndicator()),
            )
          : challenge == null ||
                (method == null && !recoveryAvailable) ||
                (segments.isEmpty && !recoveryAvailable)
          ? _DialogNotice(
              icon: Icons.error_outline_rounded,
              title: context.l10n.noVerificationMethods,
              message: context.l10n.noVerificationMethodsDescription,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!usingRecoveryCode && segments.length > 1) ...[
                  _DialogFieldGroup(
                    title: context.l10n.verificationMethod,
                    child: AppSingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: AppSegmentedControl<_SensitiveOperationMethod>(
                        segments: segments,
                        value: method!,
                        onChanged: (selected) =>
                            setState(() => _method = selected),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (usingRecoveryCode)
                  AuthRecoveryCodeFallback(
                    active: true,
                    recoveryForm: _DialogFieldGroup(
                      title: context.l10n.verificationInformation,
                      child: _DialogTextField(
                        controller: _recoveryCodeController,
                        autofocus: true,
                        label: context.l10n.recoveryCode,
                        icon: Icons.key_rounded,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                    onOpen: null,
                    onBack: _submitting
                        ? null
                        : () => setState(() {
                            _recoveryCodeController.clear();
                            _method = _defaultMethod(challenge);
                          }),
                  )
                else ...[
                  if (method != null)
                    _DialogFieldGroup(
                      title: context.l10n.verificationInformation,
                      children: [
                        if (method == _SensitiveOperationMethod.password)
                          _DialogTextField(
                            controller: _passwordController,
                            autofocus: true,
                            obscureText: true,
                            label: context.l10n.currentPassword,
                            icon: Icons.lock_outline_rounded,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                          ),
                        if (method == _SensitiveOperationMethod.passkey)
                          _DialogNotice(
                            icon: Icons.fingerprint_rounded,
                            title: context.l10n.passkeyVerification,
                            message:
                                context.l10n.passkeyVerificationDescription,
                          ),
                        if (method == _SensitiveOperationMethod.totp)
                          _DialogTextField(
                            controller: _totpController,
                            autofocus: true,
                            label: context.l10n.authenticatorCode,
                            icon: Icons.shield_outlined,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                          ),
                        if (method == _SensitiveOperationMethod.email)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final compact = constraints.maxWidth < 420;
                              final field = _DialogTextField(
                                controller: _emailTokenController,
                                autofocus: true,
                                label: context.l10n.emailVerificationCode,
                                icon: Icons.mark_email_read_outlined,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submit(),
                              );
                              final sendButton = AppActionButton(
                                onPressed: _requestingEmail
                                    ? null
                                    : _requestEmailCode,
                                loading: _requestingEmail,
                                icon: Icons.send_rounded,
                                label: _emailCode == null
                                    ? context.l10n.sendVerificationCode
                                    : context.l10n.resend,
                                style: AppActionButtonStyle.outlined,
                              );
                              final maskedEmail = _emailCode?.maskedEmail ?? '';
                              final children = [
                                Expanded(child: field),
                                const SizedBox(width: 10),
                                SizedBox(height: 48, child: sendButton),
                              ];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (compact) ...[
                                    field,
                                    const SizedBox(height: 10),
                                    sendButton,
                                  ] else
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: children,
                                    ),
                                  if (maskedEmail.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      context.l10n.codeSentTo(maskedEmail),
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  if (recoveryAvailable) ...[
                    const SizedBox(height: 8),
                    AuthRecoveryCodeFallback(
                      active: false,
                      recoveryForm: const SizedBox.shrink(),
                      onOpen: _submitting
                          ? null
                          : () => setState(() {
                              _method = _SensitiveOperationMethod.recoveryCode;
                            }),
                      onBack: null,
                    ),
                  ],
                ],
              ],
            ),
      primaryLabel: context.l10n.verify,
      primaryLoading: _submitting,
      onPrimary: _loading || challenge == null || method == null
          ? null
          : _submit,
    );
  }
}

class _NotificationDetailSheet extends StatelessWidget {
  final UserNotificationItem notification;
  final String typeLabel;
  final String createdAtLabel;
  final String updatedAtLabel;

  const _NotificationDetailSheet({
    required this.notification,
    required this.typeLabel,
    required this.createdAtLabel,
    required this.updatedAtLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataText = notification.data.isEmpty
        ? ''
        : const JsonEncoder.withIndent('  ').convert(notification.data);

    return AppSafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: AppMetrics.dialogMaxHeight(context, null),
          ),
          child: AppSingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      notification.isRead
                          ? Icons.notifications_none_rounded
                          : Icons.notifications_active_rounded,
                      color: notification.isRead
                          ? theme.hintColor
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        notification.title.isEmpty
                            ? typeLabel
                            : notification.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppChip(label: Text(typeLabel)),
                    AppChip(
                      label: Text(
                        notification.isRead
                            ? context.l10n.read
                            : context.l10n.unread,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  [
                    context.l10n.createdAtValue(createdAtLabel),
                    if (updatedAtLabel != '-' &&
                        updatedAtLabel != createdAtLabel)
                      context.l10n.updatedAtValue(updatedAtLabel),
                  ].join(' · '),
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
                if (notification.content.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(notification.content, style: theme.textTheme.bodyLarge),
                ],
                if (dataText.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.data,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppPanelSurface(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    child: AppSelectableText(
                      dataText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppActionButton(
                        onPressed: notification.isRead
                            ? null
                            : () => Navigator.pop(
                                context,
                                _NotificationDetailAction.markRead,
                              ),
                        icon: Icons.mark_email_read_rounded,
                        label: context.l10n.markRead,
                        style: AppActionButtonStyle.outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppActionButton(
                        onPressed: () => Navigator.pop(
                          context,
                          _NotificationDetailAction.delete,
                        ),
                        icon: Icons.delete_outline_rounded,
                        label: context.l10n.delete,
                        style: AppActionButtonStyle.destructive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountActionDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget content;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool primaryLoading;
  final double maxWidth;

  const _AccountActionDialog({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryLoading = false,
    this.maxWidth = 520,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppDialogFrame(
      maxWidth: maxWidth,
      backgroundColor: Colors.transparent,
      child: AppInkSurface(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.72),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppIconBadge(
                    icon: icon,
                    color: theme.colorScheme.primary,
                    size: 42,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.62,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppIconButton(
                    tooltip: context.l10n.close,
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.close_rounded,
                  ),
                ],
              ),
            ),
            Flexible(
              child: AppSingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: content,
              ),
            ),
            AppPanelSurface(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.42,
              ),
              borderRadius: BorderRadius.zero,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  AppActionButton(
                    onPressed: primaryLoading
                        ? null
                        : () => Navigator.pop(context),
                    label: context.l10n.cancel,
                    style: AppActionButtonStyle.text,
                  ),
                  const SizedBox(width: 10),
                  AppActionButton(
                    onPressed: onPrimary,
                    loading: primaryLoading,
                    icon: Icons.check_rounded,
                    label: primaryLabel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SingleTextInputDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String label;
  final String hintText;
  final String initialValue;
  final String primaryLabel;

  const _SingleTextInputDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.label,
    required this.primaryLabel,
    this.hintText = '',
    this.initialValue = '',
  });

  @override
  State<_SingleTextInputDialog> createState() => _SingleTextInputDialogState();
}

class _SingleTextInputDialogState extends State<_SingleTextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, _controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return _AccountActionDialog(
      icon: widget.icon,
      title: widget.title,
      subtitle: widget.subtitle,
      primaryLabel: widget.primaryLabel,
      onPrimary: _submit,
      content: _DialogTextField(
        controller: _controller,
        label: widget.label,
        hintText: widget.hintText,
        icon: widget.icon,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
    );
  }
}

class _DialogFieldGroup extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? child;
  final List<Widget>? children;

  const _DialogFieldGroup({
    required this.title,
    this.subtitle,
    this.child,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body =
        child ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children ?? const [],
        );
    return AppPanelSurface(
      padding: const EdgeInsets.all(14),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.36),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.68),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
              ),
            ),
          ],
          const SizedBox(height: 12),
          body,
        ],
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _DialogTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hintText = '',
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hintText: hintText.isEmpty ? null : hintText,
      prefixIcon: icon,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
    );
  }
}

class _DialogReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DialogReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppReadOnlyField(label: label, value: value, prefixIcon: icon);
  }
}

class _DialogNotice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _DialogNotice({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInfoBanner(
      padding: const EdgeInsets.all(12),
      icon: icon,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      iconSize: 22,
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      message: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
        ),
      ),
    );
  }
}
