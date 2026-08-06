import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  testWidgets(
    'editing Apple provider preserves hidden secret for whitespace input',
    (tester) async {
      final gateway = _RuntimeSettingsAdminGateway();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyScope<AdminGateway>(
            value: gateway,
            child: buildThemedTestApp(context, child),
          ),
          home: const Scaffold(body: RuntimeSettingsSectionsTab()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('apple-main'), findsOneWidget);
      expect(find.textContaining('Apple'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      final secretField = find.descendant(
        of: find.widgetWithText(AppTextField, 'Client Secret'),
        matching: find.byType(TextFormField),
      );
      expect(secretField, findsOneWidget);
      await tester.enterText(secretField, '   ');
      await tester.tap(find.text('Save instance'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm changes').last);
      await tester.pumpAndSettle();

      expect(gateway.updatedSection, 'oauth2');
      expect(gateway.updatedKey, 'providers');
      final providers = gateway.updatedValue! as List<dynamic>;
      final provider = Map<String, dynamic>.from(providers.single as Map);
      expect(provider['name'], 'apple-main');
      expect(provider, contains('apple'));
      expect(provider, isNot(contains('oidc')));
      final apple = Map<String, dynamic>.from(provider['apple'] as Map);
      expect(apple['clientId'], 'com.example.synctv');
      expect(apple['redirectUrl'], 'https://example.com/oauth2/callback');
      expect(apple, isNot(contains('clientSecret')));
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    },
  );
}

final class _RuntimeSettingsAdminGateway implements AdminGateway {
  String? updatedSection;
  String? updatedKey;
  dynamic updatedValue;

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) async {
    return const RuntimeSettingsModel(
      sections: [
        RuntimeSettingsSection(
          name: 'oauth2',
          settings: {
            'providers': [
              {
                'name': 'apple-main',
                'enableSignup': true,
                'signupNeedReview': false,
                'apple': {
                  'clientId': 'com.example.synctv',
                  'redirectUrl': 'https://example.com/oauth2/callback',
                },
              },
            ],
          },
        ),
      ],
    );
  }

  @override
  Future<RuntimeSettingsSection> runtimeUpdateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) async {
    updatedSection = section;
    updatedKey = key;
    updatedValue = value;
    return RuntimeSettingsSection(name: section, settings: {key: value});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
