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
  bool _notifications = false;
  bool _captions = false;
  int _changes = 0;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: SafeArea(
        child: AppSingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSwitch(
                    value: _notifications,
                    label: 'Notifications',
                    onChanged: (value) => setState(() {
                      _notifications = value;
                      _changes++;
                    }),
                  ),
                  const SizedBox(height: 16),
                  AppCheckbox(
                    value: _captions,
                    label: 'Captions',
                    onChanged: (value) => setState(() {
                      _captions = value;
                      _changes++;
                    }),
                  ),
                  const SizedBox(height: 16),
                  AppActionButton(label: 'Next', onPressed: () {}),
                  const SizedBox(height: 16),
                  Text('Changes: $_changes'),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
