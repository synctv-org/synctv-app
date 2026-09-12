import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(const _Showcase());

class _Showcase extends StatefulWidget {
  const _Showcase();

  @override
  State<_Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<_Showcase> {
  bool _dark = false;
  bool _loading = true;
  int _presses = 0;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: _dark ? AppTheme.dark : AppTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: SafeArea(
        child: AppSingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSwitchTile(
                    value: _dark,
                    onChanged: (value) => setState(() => _dark = value),
                    title: const Text('Dark theme'),
                  ),
                  AppSwitchTile(
                    value: _loading,
                    onChanged: (value) => setState(() => _loading = value),
                    title: const Text('Pending request'),
                  ),
                  for (final style in AppActionButtonStyle.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppActionButton(
                            onPressed: () => setState(() => _presses++),
                            label: style == AppActionButtonStyle.destructive
                                ? 'Delete'
                                : 'Save ${style.name}',
                            icon: Icons.save,
                            loading: _loading,
                            style: style,
                          ),
                          AppIconButton(
                            onPressed: () => setState(() => _presses++),
                            icon: Icons.save,
                            tooltip: 'Save ${style.name} icon',
                            loading: _loading,
                            style: switch (style) {
                              AppActionButtonStyle.filled =>
                                AppIconButtonStyle.filled,
                              AppActionButtonStyle.tonal =>
                                AppIconButtonStyle.tonal,
                              AppActionButtonStyle.outlined =>
                                AppIconButtonStyle.outlined,
                              AppActionButtonStyle.text =>
                                AppIconButtonStyle.ghost,
                              AppActionButtonStyle.destructive =>
                                AppIconButtonStyle.destructive,
                            },
                          ),
                        ],
                      ),
                    ),
                  Text('Actions: $_presses'),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
