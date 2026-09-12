import 'package:flutter/material.dart';
import 'package:synctv_app/app/app_viewport.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room_invite/presentation/room_invite_flow.dart';
import 'package:synctv_app/features/room/presentation/join_room_dialog.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/features/server_settings/presentation/server_settings_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(const _Showcase());

class _Showcase extends StatelessWidget {
  const _Showcase();

  static const _invite = bool.fromEnvironment('PREVIEW_INVITE');

  Future<void> _open(BuildContext context) async {
    switch (Uri.base.queryParameters['dialog']) {
      case 'join':
        await showJoinRoomDialog(
          context: context,
          onSubmitted: (dialogContext, value) async {
            await parseInviteOrShowError(context: dialogContext, value: value);
          },
        );
      case 'password':
        await showRoomPasswordDialog(
          context: context,
          roomName: 'Friday Film Club with a longer room name',
          onSubmitted: (_) async => throw RoomPasswordRejectedException(
            StateError('Preview password rejected'),
          ),
        );
      default:
        if (_invite) {
          await parseInviteOrShowError(context: context, value: _inviteValue);
        } else {
          await showAddServerDialog(context: context);
        }
    }
  }

  String get _inviteValue => switch (Uri.base.queryParameters['invite']) {
    'legacy' =>
      Uri.base
          .replace(path: '/sync/rooms/preview-room', query: '', fragment: '')
          .toString(),
    'empty' =>
      Uri.base.replace(path: '/rooms/join', query: '', fragment: '').toString(),
    'conflict' =>
      Uri.base
          .replace(
            path: '/rooms/join',
            queryParameters: {'room_id': 'preview-room', 'r': 'other-room'},
            fragment: '',
          )
          .toString(),
    _ =>
      Uri.base
          .replace(
            path: '/rooms/join',
            queryParameters: {'room_id': 'preview-room'},
            fragment: '',
          )
          .toString(),
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => DependencyScope<ServerConnectionGateway>(
      value: _PreviewGateway(),
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(_invite ? 3 : 2)),
        child: AppViewport(child: child!),
      ),
    ),
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: AppActionButton(
            label: context.l10n.addServer,
            icon: Icons.add_link_rounded,
            wrapLabel: true,
            onPressed: () => _open(context),
          ),
        ),
      ),
    ),
  );
}

class _PreviewGateway implements ServerConnectionGateway {
  @override
  List<ServerConnectionProfile> get servers => const [];

  @override
  ServerConnectionProfile? get activeServer => null;

  @override
  String get serverBaseUrl => '';

  @override
  Future<ServerConnectionProfile> addServer(
    String address, {
    bool allowInsecureTls = false,
  }) async => ServerConnectionProfile(
    endpoint: address,
    declaredServerId: 'preview',
    name: 'Preview',
    isBuiltIn: false,
    allowInsecureTls: allowInsecureTls,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
