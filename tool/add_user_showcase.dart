import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/widgets/add_user_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => DependencyScope<AdminGateway>(
      value: _Gateway(),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(3)),
        child: child!,
      ),
    ),
    home: Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => AppActionButton(
            label: 'Add user',
            onPressed: () => showAppDialog<bool>(
              context: context,
              builder: (_) => const AddUserDialog(),
            ),
          ),
        ),
      ),
    ),
  ),
);

class _Gateway implements AdminGateway {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminAddUser) {
      return Future<void>.delayed(const Duration(seconds: 2));
    }
    return super.noSuchMethod(invocation);
  }
}
