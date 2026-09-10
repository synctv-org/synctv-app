import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/l10n/l10n.dart';

const oauth2CallbackPath = '/oauth2/callback';

Route<dynamic>? generateOAuth2CallbackRoute(
  RouteSettings settings, {
  required OAuth2CallbackDispatcher dispatcher,
}) {
  final uri = Uri.tryParse(settings.name ?? '');
  if (uri?.path != oauth2CallbackPath) return null;

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (_) => OAuth2CallbackPage(dispatcher: dispatcher),
  );
}

class OAuth2CallbackPage extends StatefulWidget {
  const OAuth2CallbackPage({super.key, required this.dispatcher});

  final OAuth2CallbackDispatcher dispatcher;

  @override
  State<OAuth2CallbackPage> createState() => _OAuth2CallbackPageState();
}

class _OAuth2CallbackPageState extends State<OAuth2CallbackPage> {
  bool _dispatched = false;

  @override
  void initState() {
    super.initState();
    _dispatch();
  }

  void _dispatch() {
    try {
      widget.dispatcher.dispatch();
      _dispatched = true;
    } catch (_) {
      // Callback URLs can contain credentials; never render transport errors.
      _dispatched = false;
    }
  }

  void _retry() {
    if (!mounted || _dispatched || ModalRoute.of(context)?.isCurrent == false) {
      return;
    }
    setState(_dispatch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AppSingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _dispatched
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      size: 56,
                      color: _dispatched
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _dispatched
                          ? context.l10n.oauth2CallbackCompleteTitle
                          : context.l10n.oauth2CallbackDispatchFailedTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _dispatched
                          ? context.l10n.oauth2CallbackCompleteMessage
                          : context.l10n.oauth2CallbackDispatchFailedMessage,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (!_dispatched) ...[
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.refresh),
                        label: Text(context.l10n.retry),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
