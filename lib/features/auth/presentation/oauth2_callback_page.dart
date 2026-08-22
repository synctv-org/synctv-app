import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    widget.dispatcher.dispatch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.oauth2CallbackCompleteTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.oauth2CallbackCompleteMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
