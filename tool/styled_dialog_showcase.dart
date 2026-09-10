import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
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
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(3)),
      child: child!,
    ),
    home: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          body: Center(
            child: Builder(
              builder: (context) => AppActionButton(
                label: 'Open',
                onPressed: () => AppDialogs.showStyledDialog<void>(
                  context: context,
                  title: 'Confirm this room configuration change',
                  icon: const Icon(Icons.settings_outlined),
                  content: const Text('Changes'),
                  actions: [
                    AppDialogs.createCancelButton(context),
                    Builder(
                      builder: (dialogContext) =>
                          AppDialogs.createConfirmButton(
                            dialogContext,
                            () => Navigator.pop(dialogContext),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);
