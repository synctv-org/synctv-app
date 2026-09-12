part of 'platform_binding_dialog.dart';

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
  bool _initialized = false;
  int _generation = 0;
  String _phone = '';

  bool get _busy => _starting || _sending || _loggingIn;
  bool get _isCurrent =>
      mounted && widget.active && ModalRoute.of(context)?.isCurrent == true;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_phoneChanged);
  }

  void _phoneChanged() {
    final next = _phoneController.text.trim();
    if (next == _phone) return;
    _phone = next;
    if (!_smsSent && !_busy) return;
    setState(_resetSession);
  }

  void _resetSession() {
    ++_generation;
    _session = null;
    _smsSent = false;
    _starting = false;
    _sending = false;
    _loggingIn = false;
    _statusText = widget.active
        ? context.l10n.enterPhoneForSecurityVerification
        : context.l10n.switchToCodePrompt;
    _codeController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    if (widget.active) _startSession();
  }

  @override
  void didUpdateWidget(covariant _BilibiliSmsLoginPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.instanceName != widget.instanceName ||
        oldWidget.active != widget.active) {
      _resetSession();
      if (widget.active) _startSession();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    if (!_isCurrent || _busy) return;
    final generation = ++_generation;
    setState(() {
      _starting = true;
      _smsSent = false;
      _session = null;
      _codeController.clear();
      _statusText = context.l10n.preparingSecurityVerification;
    });
    try {
      final session = await providerGateway.startBilibiliSmsLogin(
        instanceName: widget.instanceName,
      );
      if (!_isCurrent || generation != _generation) return;
      setState(() {
        _session = session;
        _starting = false;
        _statusText = context.l10n.enterPhoneForSecurityVerification;
      });
    } catch (e) {
      if (!_isCurrent || generation != _generation) return;
      setState(() {
        _starting = false;
        _statusText = context.l10n.prepareSecurityVerificationFailed('$e');
      });
    }
  }

  Future<void> _sendSms() async {
    if (!_isCurrent || _busy) return;
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterPhoneNumber);
      return;
    }
    var session = _session;
    var generation = _generation;
    if (session == null) {
      generation++;
      await _startSession();
      if (!mounted || !_isCurrent || _busy || generation != _generation) return;
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
      if (!_isCurrent || generation != _generation) return;
      final nextSession = await providerGateway.sendBilibiliSms(
        session: session,
        phone: phone,
        validate: result.validate,
      );
      if (!_isCurrent || generation != _generation) return;
      setState(() {
        _session = nextSession;
        _sending = false;
        _smsSent = true;
        _codeController.clear();
        _statusText = context.l10n.smsCodeSent;
      });
    } catch (e) {
      if (!_isCurrent || generation != _generation) return;
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
    if (!_isCurrent || _busy) return;
    final session = _session;
    final code = _codeController.text.trim();
    if (session == null || !_smsSent) {
      AppNotifications.showWarning(context, context.l10n.sendSmsFirst);
      return;
    }
    if (code.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterSmsCode);
      return;
    }

    final generation = _generation;
    setState(() {
      _loggingIn = true;
      _statusText = context.l10n.completingBilibiliBinding;
    });
    try {
      await providerGateway.loginBilibiliSms(
        sessionToken: session.sessionToken,
        code: code,
      );
      if (!_isCurrent || generation != _generation) return;
      widget.onSuccess();
    } catch (e) {
      if (!_isCurrent || generation != _generation) return;
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
            labelAbove: true,
            controller: _phoneController,
            hintText: context.l10n.bilibiliPhoneHint,
            prefixIcon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
            enabled: !_busy,
          ),
          const SizedBox(height: 8),
          AppDialogs.createFormField(
            context: context,
            label: context.l10n.smsVerificationCode,
            labelAbove: true,
            controller: _codeController,
            hintText: _smsSent
                ? context.l10n.enterReceivedCode
                : context.l10n.enterCodeAfterSms,
            prefixIcon: Icons.pin_rounded,
            keyboardType: TextInputType.number,
            enabled: !_busy,
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
                wrapLabel: true,
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
