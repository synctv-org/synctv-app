import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';

const _conflict =
    'This setting changed while you were editing. Reopen it to review the latest value.';

void main() {
  for (final kind in ['text', 'boolean', 'oauth', 'delete']) {
    for (final change in ['target', 'unrelated', 'removed']) {
      testWidgets('$kind draft handles $change refresh before saving', (
        tester,
      ) async {
        final gateway = _Gateway(kind);
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) =>
                DependencyScope<AdminGateway>(value: gateway, child: child!),
            home: const Scaffold(body: RuntimeSettingsSectionsTab()),
          ),
        );
        await tester.pumpAndSettle();
        tester
            .widget<AppIconButton>(
              find.ancestor(
                of: find.byIcon(Icons.sync_rounded),
                matching: find.byType(AppIconButton),
              ),
            )
            .onPressed!();
        await tester.pump();
        if (kind == 'boolean') {
          tester.widget<AppSwitch>(find.byType(AppSwitch)).onChanged!(true);
        } else {
          final icon = kind == 'delete'
              ? Icons.delete_outline_rounded
              : Icons.edit_outlined;
          tester
              .widget<AppIconButton>(
                find.ancestor(
                  of: find.byIcon(icon),
                  matching: find.byType(AppIconButton),
                ),
              )
              .onPressed!();
        }
        await tester.pumpAndSettle();
        if (kind == 'text') {
          await tester.enterText(find.byType(TextField), 'draft');
        }
        gateway.refresh.complete(gateway.snapshot(change: change));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(switch (kind) {
            'boolean' => 'Confirm changes',
            'delete' => 'Delete',
            _ => 'Save',
          }).last,
        );
        await tester.pumpAndSettle();
        if (kind == 'oauth') {
          await tester.tap(find.text('Confirm changes').last);
          await tester.pumpAndSettle();
        }
        expect(gateway.writes, change == 'unrelated' ? 1 : 0);
        expect(
          find.text(_conflict),
          change == 'unrelated' ? findsNothing : findsOneWidget,
        );
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      });
    }
  }
}

class _Gateway implements AdminGateway {
  _Gateway(this.kind);
  final String kind;
  final refresh = Completer<RuntimeSettingsModel>();
  var reads = 0;
  var writes = 0;

  RuntimeSettingsModel snapshot({String? change}) {
    if (change == 'removed') return const RuntimeSettingsModel(sections: []);
    final changed = change == 'target';
    final section = switch (kind) {
      'text' => RuntimeSettingsSection(
        name: 'test',
        settings: {
          'alpha': changed ? 'new value' : 'original',
          if (change == 'unrelated') 'other': true,
        },
      ),
      'boolean' => RuntimeSettingsSection(
        name: 'email',
        settings: {
          'enabled': changed,
          if (change == 'unrelated') 'host': 'new.example.com',
        },
      ),
      _ => RuntimeSettingsSection(
        name: 'oauth2',
        settings: {
          'providers': [
            {
              'name': 'apple-main',
              'apple': change == 'unrelated'
                  ? {
                      'nativeClientId': 'com.example.app',
                      'webClientId': 'com.example.web',
                    }
                  : {
                      'webClientId': changed ? 'changed' : 'com.example.web',
                      'nativeClientId': 'com.example.app',
                    },
            },
          ],
          if (change == 'unrelated') 'other': true,
        },
      ),
    };
    return RuntimeSettingsModel(sections: [section]);
  }

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({bool refresh = false}) =>
      ++reads == 1 ? Future.value(snapshot()) : this.refresh.future;

  @override
  Future<RuntimeSettingsSection> runtimeUpdateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) async {
    writes++;
    return RuntimeSettingsSection(name: section, settings: {key: value});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
