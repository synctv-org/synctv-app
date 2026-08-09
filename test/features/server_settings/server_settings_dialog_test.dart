import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/server_settings/presentation/server_settings_dialog.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/contracts/public_models.dart';

import '../../test_app.dart';

void main() {
  testWidgets('server setup forwards the insecure TLS preference', (
    tester,
  ) async {
    final gateway = _RecordingServerConnectionGateway();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          FLocalizations.delegate,
        ],
        builder: (context, child) => DependencyScope<ServerConnectionGateway>(
          value: gateway,
          child: buildThemedTestApp(context, child),
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showServerSettingsDialog(context: context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.textContaining('stale server info'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'https://self-signed.example.test',
    );
    await tester.tap(find.text('Allow insecure TLS'));
    await tester.tap(find.widgetWithText(AppActionButton, 'Add'));
    await tester.pumpAndSettle();

    expect(gateway.address, 'https://self-signed.example.test');
    expect(gateway.allowInsecureTls, isTrue);
    expect(gateway.getServerInfoCalls, 2);
    expect(find.textContaining('stale server info'), findsNothing);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('required server setup cannot close without an active server', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          FLocalizations.delegate,
        ],
        builder: (context, child) => DependencyScope<ServerConnectionGateway>(
          value: const _EmptyServerConnectionGateway(),
          child: buildThemedTestApp(context, child),
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showServerSettingsDialog(
                context: context,
                requireServer: true,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final doneButton = tester.widget<AppActionButton>(
      find.widgetWithText(AppActionButton, 'Done'),
    );
    expect(doneButton.onPressed, isNull);

    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.text('Server address'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Server address'), findsOneWidget);
  });
}

final class _RecordingServerConnectionGateway
    implements ServerConnectionGateway {
  String? address;
  bool? allowInsecureTls;
  int getServerInfoCalls = 0;
  ServerConnectionProfile? _activeServer = const ServerConnectionProfile(
    endpoint: 'https://old.example.test',
    declaredServerId: 'old-server',
    name: 'Old server',
    isBuiltIn: false,
    allowInsecureTls: false,
  );

  @override
  ServerConnectionProfile? get activeServer => _activeServer;

  @override
  String get serverBaseUrl => _activeServer?.endpoint ?? '';

  @override
  List<ServerConnectionProfile> get servers => [?_activeServer];

  @override
  Future<ServerConnectionProfile> addServer(
    String address, {
    bool allowInsecureTls = false,
  }) async {
    this.address = address;
    this.allowInsecureTls = allowInsecureTls;
    return _activeServer = ServerConnectionProfile(
      endpoint: address,
      declaredServerId: 'server-1',
      name: 'Server',
      isBuiltIn: false,
      allowInsecureTls: allowInsecureTls,
    );
  }

  @override
  Future<void> activateServer(String endpoint) async {}

  @override
  Future<ServerInfo> getServerInfo({bool refresh = false}) async {
    getServerInfoCalls += 1;
    if (getServerInfoCalls == 1) {
      throw StateError('stale server info');
    }
    return const ServerInfo(serverId: 'server-1', serverName: 'Server');
  }

  @override
  Future<void> removeServer(String endpoint) async {}

  @override
  Future<void> syncServerTime({bool refresh = false}) async {}
}

final class _EmptyServerConnectionGateway implements ServerConnectionGateway {
  const _EmptyServerConnectionGateway();

  @override
  ServerConnectionProfile? get activeServer => null;

  @override
  String get serverBaseUrl => '';

  @override
  List<ServerConnectionProfile> get servers => const [];

  @override
  Future<ServerConnectionProfile> addServer(
    String address, {
    bool allowInsecureTls = false,
  }) => throw UnimplementedError();

  @override
  Future<void> activateServer(String endpoint) async {}

  @override
  Future<ServerInfo> getServerInfo({bool refresh = false}) =>
      throw UnimplementedError();

  @override
  Future<void> removeServer(String endpoint) async {}

  @override
  Future<void> syncServerTime({bool refresh = false}) async {}
}
