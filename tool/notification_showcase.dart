import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        accessibleNavigation: const bool.fromEnvironment(
          'PREVIEW_ACCESSIBLE_NAVIGATION',
        ),
        textScaler: TextScaler.linear(
          double.parse(
            const String.fromEnvironment(
              'PREVIEW_TEXT_SCALE',
              defaultValue: '2',
            ),
          ),
        ),
      ),
      child: child!,
    ),
    home: const _Preview(),
  ),
);

class _Preview extends StatefulWidget {
  const _Preview();

  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  var _refreshes = 0;
  var _undos = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refreshes: $_refreshes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Undos: $_undos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AppActionButton(
                      label: 'Error',
                      icon: Icons.error_outline,
                      onPressed: () => AppNotifications.showError(
                        context,
                        'Could not initialize identity verification. The preview service is unavailable. Retry after checking the server connection. Reference: preview-request-1234.',
                        duration: const Duration(minutes: 2),
                      ),
                    ),
                    AppActionButton(
                      label: 'Save',
                      icon: Icons.save_outlined,
                      onPressed: () {
                        AppNotifications.showSuccess(
                          context,
                          'Settings updated',
                          duration: const Duration(seconds: 30),
                        );
                      },
                    ),
                    AppActionButton(
                      label: 'Warning',
                      icon: Icons.warning_amber_rounded,
                      onPressed: () => AppNotifications.showWarning(
                        context,
                        'Connection interrupted. Changes are not saved.',
                        duration: const Duration(minutes: 2),
                      ),
                    ),
                    AppActionButton(
                      label: 'Delete',
                      icon: Icons.delete_outline,
                      onPressed: () {
                        AppNotifications.showDelete(
                          context,
                          'Item deleted',
                          duration: const Duration(seconds: 30),
                          onUndo: () => setState(() => _undos++),
                        );
                      },
                    ),
                    AppActionButton(
                      label: 'Restore playlist',
                      icon: Icons.restore,
                      onPressed: () => AppNotifications.showInfo(
                        context,
                        'Playlist removed from this room',
                        duration: const Duration(seconds: 30),
                        action: SnackBarAction(
                          label: 'Restore the deleted playlist',
                          onPressed: () => setState(() => _undos++),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 70,
            child: Center(
              child: SizedBox(
                width: 280,
                height: 44,
                child: AppActionButton(
                  label: 'Refresh',
                  icon: Icons.refresh,
                  onPressed: () => setState(() => _refreshes++),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
