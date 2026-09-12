import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  final gateway = _Gateway();
  runApp(
    MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) =>
          DependencyScope<AdminGateway>(value: gateway, child: child!),
      home: Scaffold(
        body: Column(
          children: [
            const Expanded(child: UserManagementTab()),
            Padding(
              padding: const EdgeInsets.all(8),
              child: AppActionButton(
                label: 'Resolve batch',
                onPressed: gateway.resolve,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Gateway implements AdminGateway {
  Completer<AdminBatchOperationResult>? _pending;
  List<String> _ids = [];

  void resolve() {
    final pending = _pending;
    if (pending == null || pending.isCompleted) return;
    final results = [
      for (final id in _ids)
        AdminBatchResult(
          id: id,
          success: id != 'user-1',
          error: id == 'user-1' ? 'Retry' : '',
        ),
    ];
    pending.complete(
      AdminBatchOperationResult(
        results: results,
        succeeded: results.where((item) => item.success).length,
        failed: results.where((item) => !item.success).length,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminListUsersPage) {
      return Future.value(
        AdminUsersPage(
          users: List.generate(
            3,
            (index) => SyncTvUser(
              id: 'user-$index',
              username: 'User $index',
              role: const AccountUserRole(common.UserRole.USER_ROLE_USER),
            ),
          ),
          total: 3,
        ),
      );
    }
    if (invocation.memberName == #adminBatchBanUsers ||
        invocation.memberName == #adminBatchDeleteUsers) {
      _ids = List<String>.from(invocation.positionalArguments.first as List);
      _pending = Completer<AdminBatchOperationResult>();
      return _pending!.future;
    }
    return super.noSuchMethod(invocation);
  }
}
