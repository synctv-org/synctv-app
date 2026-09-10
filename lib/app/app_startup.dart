import 'package:flutter/material.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/widgets/synctv_brand_mark.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

class AppStartup extends StatefulWidget {
  const AppStartup({
    super.key,
    required this.initialize,
    required this.child,
    this.onReady,
  });

  final Future<void> Function() initialize;
  final Widget child;
  final VoidCallback? onReady;

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool _loading = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!mounted || _loading || _ready) return;
    setState(() => _loading = true);
    try {
      await widget.initialize();
      if (!mounted) return;
      setState(() => _ready = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onReady?.call();
      });
    } catch (error, stackTrace) {
      debugPrint('Application initialization failed: $error\n$stackTrace');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return widget.child;
    return ListenableBuilder(
      listenable: appLocaleController,
      builder: (_, _) => MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: appLocaleController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, _) => _buildStatus(context),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) => AppScaffold(
    body: SafeArea(
      child: Center(
        child: AppSingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SyncTvBrandMark(size: 64, semanticLabel: 'SyncTV'),
                const SizedBox(height: 16),
                Text(
                  'SyncTV',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                if (_loading) ...[
                  const AppLinearProgress(),
                  const SizedBox(height: 12),
                  Text(context.l10n.loading),
                ] else ...[
                  Text(context.l10n.startupFailed, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  AppActionButton(
                    label: context.l10n.retry,
                    icon: Icons.refresh_rounded,
                    onPressed: _initialize,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
