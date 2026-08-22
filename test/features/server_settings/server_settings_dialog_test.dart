import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/server_settings/presentation/server_settings_dialog.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/contracts/public_models.dart';

import '../../test_app.dart';

void main() {
  testWidgets('add server dialog forwards the insecure TLS preference', (
    tester,
  ) async {
    final gateway = _RecordingServerConnectionGateway();
    var serverChangedCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        builder: (context, child) => DependencyScope<ServerConnectionGateway>(
          value: gateway,
          child: buildThemedTestApp(context, child),
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showServerSettingsDialog(
                context: context,
                onServerChanged: () => serverChangedCalls++,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.textContaining('stale server info'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(
      tester.getSize(find.widgetWithText(AppActionButton, 'Add server')).height,
      tester.getSize(find.widgetWithText(AppActionButton, 'Done')).height,
    );
    await tester.tap(find.widgetWithText(AppActionButton, 'Add server'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'https://self-signed.example.test',
    );
    await tester.tap(find.text('Allow insecure TLS'));
    await tester.tap(find.widgetWithText(AppActionButton, 'Add'));
    await tester.pumpAndSettle();

    expect(gateway.address, 'https://self-signed.example.test');
    expect(gateway.allowInsecureTls, isTrue);
    expect(serverChangedCalls, 1);
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
    expect(find.text('Server address'), findsNothing);

    await tester.tap(find.widgetWithText(AppActionButton, 'Add server'));
    await tester.pumpAndSettle();
    expect(find.text('Server address'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AppDialogHeader),
        matching: find.byType(AppIconButton),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppActionButton, 'Add server'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppActionButton, 'Add server'), findsOneWidget);
  });

  testWidgets('rapid add server taps open one dialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        builder: (context, child) => DependencyScope<ServerConnectionGateway>(
          value: const _EmptyServerConnectionGateway(),
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

    final addServerButton = find.widgetWithText(AppActionButton, 'Add server');
    final openAddServer = tester
        .widget<AppActionButton>(addServerButton)
        .onPressed!;
    openAddServer();
    openAddServer();
    await tester.pumpAndSettle();

    expect(find.text('Server address'), findsOneWidget);
    expect(find.byType(AppDialogHeader, skipOffstage: false), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('slow server metadata does not block repeated server switches', (
    tester,
  ) async {
    final gateway = _SlowMetadataServerConnectionGateway();
    var serverChangedCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        builder: (context, child) => DependencyScope<ServerConnectionGateway>(
          value: gateway,
          child: buildThemedTestApp(context, child),
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showServerSettingsDialog(
                context: context,
                onServerChanged: () => serverChangedCalls++,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byIcon(Icons.login_rounded));
    await tester.pump();
    expect(gateway.activeServer.name, 'Second server');
    expect(serverChangedCalls, 1);
    expect(
      tester
          .widget<AppActionButton>(
            find.widgetWithText(AppActionButton, 'Add server'),
          )
          .onPressed,
      isNotNull,
    );
    expect(
      tester
          .widget<AppIconButton>(
            find.ancestor(
              of: find.byIcon(Icons.login_rounded),
              matching: find.byType(AppIconButton),
            ),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.byIcon(Icons.login_rounded));
    await tester.pump();
    expect(gateway.activeServer.name, 'First server');
    expect(serverChangedCalls, 2);

    gateway.completeBackgroundRequests();
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.widgetWithText(AppActionButton, 'Done'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('server list and add dialog stay distinct at mobile width', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        builder: (context, child) => DependencyScope<ServerConnectionGateway>(
          value: const _EmptyServerConnectionGateway(),
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
    expect(find.text('Server address'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.widgetWithText(AppActionButton, 'Add server'));
    await tester.pumpAndSettle();
    expect(find.text('Server address'), findsOneWidget);
    expect(tester.takeException(), isNull);
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

final class _SlowMetadataServerConnectionGateway
    implements ServerConnectionGateway {
  static const _first = ServerConnectionProfile(
    endpoint: 'https://first.example.test',
    declaredServerId: 'first',
    name: 'First server',
    isBuiltIn: false,
    allowInsecureTls: false,
  );
  static const _second = ServerConnectionProfile(
    endpoint: 'https://second.example.test',
    declaredServerId: 'second',
    name: 'Second server',
    isBuiltIn: false,
    allowInsecureTls: false,
  );

  final Completer<ServerInfo> _serverInfo = Completer<ServerInfo>();
  final Completer<void> _serverTime = Completer<void>();
  ServerConnectionProfile _activeServer = _first;

  @override
  ServerConnectionProfile get activeServer => _activeServer;

  @override
  String get serverBaseUrl => _activeServer.endpoint;

  @override
  List<ServerConnectionProfile> get servers => const [_first, _second];

  @override
  Future<ServerConnectionProfile> addServer(
    String address, {
    bool allowInsecureTls = false,
  }) => throw UnimplementedError();

  @override
  Future<void> activateServer(String endpoint) async {
    _activeServer = servers.firstWhere((server) => server.endpoint == endpoint);
  }

  @override
  Future<ServerInfo> getServerInfo({bool refresh = false}) =>
      _serverInfo.future;

  @override
  Future<void> removeServer(String endpoint) async {}

  @override
  Future<void> syncServerTime({bool refresh = false}) => _serverTime.future;

  void completeBackgroundRequests() {
    _serverInfo.complete(
      ServerInfo(
        serverId: _activeServer.declaredServerId,
        serverName: _activeServer.name,
      ),
    );
    _serverTime.complete();
  }
}
