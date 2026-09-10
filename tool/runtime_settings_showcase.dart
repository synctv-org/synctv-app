import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  final params = Uri.base.queryParameters;
  final scale = double.tryParse(params['scale'] ?? '') ?? 2;
  final gateway = _PreviewGateway(
    conflict: params['conflict'] == '1',
    smtp: params['smtp'] == '1',
  );
  runApp(
    MaterialApp(
      theme: AppTheme.light,
      locale: Locale(params['locale'] ?? 'en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => DependencyScope<AdminGateway>(
        value: gateway,
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
      home: const Scaffold(body: RuntimeSettingsSectionsTab()),
    ),
  );
}

class _PreviewGateway implements AdminGateway {
  _PreviewGateway({required this.conflict, required bool smtp}) {
    if (smtp) {
      _settings = const RuntimeSettingsModel(
        sections: [
          RuntimeSettingsSection(
            name: 'email',
            settings: {
              'smtpProxy': {
                'url': 'socks5://proxy.example.com:1080',
                'credentials': {'username': 'sender'},
              },
            },
          ),
        ],
      );
    }
  }
  final bool conflict;
  var _sendAttempts = 0;

  @override
  Future<String> adminSendTestEmail(String recipient) async {
    final attempt = ++_sendAttempts;
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (attempt == 1) throw StateError('SMTP unavailable');
    return '';
  }

  var _settings = const RuntimeSettingsModel(
    sections: [
      RuntimeSettingsSection(
        name: 'permissions',
        settings: {'adminDefaultPermissions': '18446744073709551615'},
      ),
      RuntimeSettingsSection(
        name: 'email',
        settings: {
          'enabled': false,
          'host': 'smtp.example.com',
          'smtpPort': 587,
        },
      ),
      RuntimeSettingsSection(
        name: 'oauth2',
        settings: {'providers': <String, dynamic>{}},
      ),
      RuntimeSettingsSection(
        name: 'chat',
        settings: {'maxMessagesPerRoom': '18446744073709551615'},
      ),
    ],
  );

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) async {
    if (refresh && conflict) {
      await Future<void>.delayed(const Duration(seconds: 12));
      _settings = _settings.replaceSection(
        const RuntimeSettingsSection(
          name: 'permissions',
          settings: {'adminDefaultPermissions': '0'},
        ),
      );
    }
    return _settings;
  }

  @override
  Future<RuntimeSettingsSection> runtimeUpdateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) async {
    final current = _settings.sections.firstWhere(
      (item) => item.name == section,
    );
    final updated = RuntimeSettingsSection(
      name: section,
      settings: {...current.settings, key: value},
    );
    _settings = _settings.replaceSection(updated);
    return updated;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
