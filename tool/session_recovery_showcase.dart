import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/app/app_startup.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/features/server_settings/presentation/server_settings_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({
    SyncTvSessionStore.serversKey: jsonEncode([
      {
        'endpoint': 'https://primary.example.test',
        'name': 'Primary',
        'declared_server_id': 'primary',
        'session': 42,
      },
      {
        'endpoint': 'https://secondary.example.test',
        'name': 'Secondary',
        'declared_server_id': 'secondary',
        'session': {'kind': 'account', 'access_token': 'fixture-access'},
      },
    ]),
    SyncTvSessionStore.activeServerKey: 'https://primary.example.test',
  });
  final store = SyncTvSessionStore(SyncTvSession(), builtInServerUrl: '');
  runApp(
    AppStartup(
      initialize: store.load,
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => DependencyScope<ServerConnectionGateway>(
          value: _Gateway(store),
          child: child!,
        ),
        home: _Preview(store: store),
      ),
    ),
  );
}

class _Preview extends StatefulWidget {
  const _Preview({required this.store});
  final SyncTvSessionStore store;
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.store.activeServer?.name ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            widget.store.session.hasAccessToken ? 'Signed in' : 'Signed out',
          ),
          const SizedBox(height: 16),
          AppActionButton(
            label: 'Servers',
            icon: Icons.dns_outlined,
            onPressed: () => showServerSettingsDialog(
              context: context,
              onServerChanged: () => setState(() {}),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Gateway implements ServerConnectionGateway {
  _Gateway(this.store);
  final SyncTvSessionStore store;
  ServerConnectionProfile _profile(SyncTvServerProfile value) =>
      ServerConnectionProfile(
        endpoint: value.endpoint,
        declaredServerId: value.declaredServerId,
        name: value.name,
        isBuiltIn: value.isBuiltIn,
        allowInsecureTls: value.allowInsecureTls,
      );
  @override
  String get serverBaseUrl => store.baseUrl;
  @override
  List<ServerConnectionProfile> get servers =>
      store.servers.map(_profile).toList();
  @override
  ServerConnectionProfile? get activeServer =>
      store.activeServer == null ? null : _profile(store.activeServer!);
  @override
  Future<ServerInfo> getServerInfo({bool refresh = false}) async => ServerInfo(
    serverId: activeServer!.declaredServerId,
    serverName: activeServer!.name,
  );
  @override
  Future<void> activateServer(String endpoint) =>
      store.activateServer(endpoint);
  @override
  Future<void> removeServer(String endpoint) => store.removeServer(endpoint);
  @override
  Future<void> syncServerTime({bool refresh = false}) async {}
  @override
  Future<ServerConnectionProfile> addServer(
    String address, {
    bool allowInsecureTls = false,
  }) async => _profile(
    await store.addOrUpdateServer(
      declaredServerId: 'preview',
      name: 'Preview',
      endpoint: address,
      allowInsecureTls: allowInsecureTls,
    ),
  );
}
