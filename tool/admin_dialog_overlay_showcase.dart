import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/features/admin/presentation/widgets/add_room_member_dialog.dart';
import 'package:synctv_app/features/admin/presentation/widgets/send_test_email_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;

void main() => runApp(const _Preview());

class _Preview extends StatefulWidget {
  const _Preview();

  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  final _navigator = GlobalKey<NavigatorState>();
  late final _Gateway _gateway = _Gateway(_coverRequest);
  String _result = 'No result';

  void _coverRequest(Completer<String> request) {
    unawaited(
      showAppDialog<void>(
        context: _navigator.currentContext!,
        builder: (context) => _RequestOverlay(request: request),
      ),
    );
  }

  Future<void> _open(BuildContext context, bool email) async {
    setState(() => _result = 'Pending dialog');
    final result = await showAppDialog<Object>(
      context: context,
      builder: (_) => email
          ? const SendTestEmailDialog()
          : const AddRoomMemberDialog(roomId: 'preview-room'),
    );
    if (mounted) setState(() => _result = 'Result: $result');
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: _navigator,
    theme: AppTheme.light,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (_, child) =>
        DependencyScope<AdminGateway>(value: _gateway, child: child!),
    home: Scaffold(
      body: Uri.base.queryParameters['bans'] == '1'
          ? const AdminBanRecordsTab()
          : Uri.base.queryParameters['parent'] == '1'
          ? const RoomManagementTab()
          : Builder(
              builder: (context) => Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Controlled requests; no email or membership changes.',
                      ),
                      Text(_result),
                      AppActionButton(
                        label: 'Test email dialog',
                        wrapLabel: true,
                        onPressed: () => _open(context, true),
                      ),
                      AppActionButton(
                        label: 'Add member dialog',
                        wrapLabel: true,
                        onPressed: () => _open(context, false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    ),
  );
}

class _RequestOverlay extends StatefulWidget {
  const _RequestOverlay({required this.request});
  final Completer<String> request;

  @override
  State<_RequestOverlay> createState() => _RequestOverlayState();
}

class _RequestOverlayState extends State<_RequestOverlay> {
  void _resolve(bool success) {
    if (widget.request.isCompleted) return;
    setState(() {
      if (success) {
        widget.request.complete('Accepted');
      } else {
        widget.request.completeError(StateError('Controlled failure'));
      }
    });
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    title: const Text('Independent overlay'),
    body: Text(
      widget.request.isCompleted ? 'Request resolved' : 'Request pending',
    ),
    actions: [
      AppActionButton(
        label: 'Resolve success',
        wrapLabel: true,
        onPressed: widget.request.isCompleted ? null : () => _resolve(true),
      ),
      AppActionButton(
        label: 'Resolve failure',
        wrapLabel: true,
        onPressed: widget.request.isCompleted ? null : () => _resolve(false),
      ),
      AppActionButton(
        label: 'Close overlay',
        wrapLabel: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}

class _Gateway implements AdminGateway {
  _Gateway(this.onRequest);
  final void Function(Completer<String>) onRequest;
  int _memberReads = 0;
  bool _unbanned = false;
  bool _banPageShrunk = false;

  Future<String> _request() {
    final request = Completer<String>();
    scheduleMicrotask(() => onRequest(request));
    return request.future;
  }

  @override
  Future<String> adminSendTestEmail(String recipient) => _request();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminListBanRecordsPage) {
      final page = invocation.namedArguments[#page] as int;
      final shrink = Uri.base.queryParameters['shrink'] == '1';
      if (shrink && page > 1) _banPageShrunk = true;
      if (_banPageShrunk) {
        return Future.value(
          AdminBanRecordsPage(records: [], total: 0, page: page, pageSize: 50),
        );
      }
      return Future.value(
        AdminBanRecordsPage(
          records: [
            AdminBanRecord(
              id: 'ban-preview',
              targetType: admin_enum.BanTargetType.BAN_TARGET_TYPE_USER,
              userId: 'usr_preview',
              username: 'Preview user',
              roomId: '',
              roomName: '',
              bannedBy: 'usr_admin',
              bannedByUsername: 'Administrator',
              reason: 'Preview moderation record',
              startsAt: 1,
              endsAt: 0,
              revokedAt: 0,
              revokedBy: '',
              isActive: !_unbanned,
            ),
          ],
          total: shrink ? 51 : 1,
          page: page,
          pageSize: 50,
        ),
      );
    }
    if (invocation.memberName == #adminBanUser) {
      return _request().then<void>((_) => _unbanned = true);
    }
    if (invocation.memberName == #adminListRoomsPage) {
      return Future.value(
        AdminRoomsPage(
          rooms: [
            SyncTvRoom(
              roomId: 'preview-room',
              roomName: 'Preview room',
              creatorId: 'preview-user',
            ),
          ],
          total: 1,
        ),
      );
    }
    if (invocation.memberName == #adminListRoomCategories) {
      return Future.value(<RoomCategoryInfo>[]);
    }
    if (invocation.memberName == #adminListRoomLabels) {
      return Future.value(<RoomLabelInfo>[]);
    }
    if (invocation.memberName == #adminListRoomMembersPage) {
      final read = ++_memberReads;
      const page = AdminRoomMembersPage(members: [], total: 0);
      if (Uri.base.queryParameters['read'] == '1' && read == 2) {
        return _request().then((_) => page);
      }
      return Future.value(page);
    }
    if (invocation.memberName == #adminAddRoomMember) {
      return _request().then<void>((_) {});
    }
    return super.noSuchMethod(invocation);
  }
}
