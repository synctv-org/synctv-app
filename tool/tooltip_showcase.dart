import 'package:flutter/material.dart';
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
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(3)),
      child: child!,
    ),
    home: const Scaffold(body: Center(child: _Controls())),
  ),
);

class _Controls extends StatefulWidget {
  const _Controls({this.inDialog = false});

  final bool inDialog;

  @override
  State<_Controls> createState() => _ControlsState();
}

class _ControlsState extends State<_Controls> {
  var _advanced = false;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppIconButton(
        icon: Icons.settings,
        tooltip: _advanced
            ? 'Advanced playback quality and synchronization settings'
            : 'Playback quality and synchronization settings',
        onPressed: () => setState(() => _advanced = !_advanced),
      ),
      const SizedBox(width: 16),
      AppIconButton(icon: Icons.refresh, tooltip: 'Refresh', onPressed: () {}),
      if (!widget.inDialog) ...[
        const SizedBox(width: 16),
        AppIconButton(
          icon: Icons.open_in_new,
          tooltip: 'Open settings',
          onPressed: () => showAppDialog<void>(
            context: context,
            builder: (context) => AppDialog(
              title: Text(
                'Player',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              body: const _Controls(inDialog: true),
              actions: [
                AppActionButton(
                  label: 'Close',
                  wrapLabel: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ],
    ],
  );
}
