import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room_invite/presentation/room_invite_flow.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  for (final suffix in [
    'rooms/join',
    'rooms/join?room_id=',
    'rooms/join?room_id=one&r=two',
  ]) {
    testWidgets('invalid invite never activates a server: $suffix', (
      tester,
    ) async {
      final gateway = _Gateway();
      late BuildContext page;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyScope<ServerConnectionGateway>(
            value: gateway,
            child: child!,
          ),
          home: Builder(
            builder: (context) {
              page = context;
              return const Scaffold(body: Text('Invite page'));
            },
          ),
        ),
      );
      final result = await parseInviteOrShowError(
        context: page,
        value: 'https://invite.example.test/sync/$suffix',
      );
      await tester.pump();
      expect(result, isNull);
      expect(gateway.activatedEndpoint, isNull);
      expect(gateway.clockCalls, 0);
      expect(find.text(page.l10n.roomIdOrInviteRequired), findsWidgets);
      expect(find.byType(AppDialog), findsNothing);
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    });
  }
  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 360)]) {
      testWidgets('missing invite layout $locale $size at 3x', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        late BuildContext inviteContext;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) =>
                DependencyScope<ServerConnectionGateway>(
                  value: _Gateway()..missing = true,
                  child: MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(3)),
                    child: child!,
                  ),
                ),
            home: Builder(
              builder: (context) {
                inviteContext = context;
                return const Scaffold(body: Text('Invite page'));
              },
            ),
          ),
        );
        final result = parseInviteOrShowError(
          context: inviteContext,
          value:
              'https://invite.example.test/sync/rooms/join?room_id=room_test',
        );
        await tester.pumpAndSettle();
        final title = find.text(inviteContext.l10n.serverRequiredForInvite);
        expect(tester.widget<Text>(title).maxLines, isNull);
        expect(tester.takeException(), isNull);
        final cancel = find.text(inviteContext.l10n.cancel);
        await tester.ensureVisible(cancel);
        await tester.tap(cancel);
        await tester.pumpAndSettle();
        expect(await result, isNull);
        expect(find.text('Invite page'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
  for (final action in ['duplicate', 'late after cancel']) {
    testWidgets('missing invite ignores $action callbacks', (tester) async {
      final gateway = _Gateway()..missing = true;
      late BuildContext inviteContext;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyScope<ServerConnectionGateway>(
            value: gateway,
            child: buildThemedTestApp(context, child),
          ),
          home: Builder(
            builder: (context) {
              inviteContext = context;
              return const Scaffold(body: Text('Invite page'));
            },
          ),
        ),
      );
      final result = parseInviteOrShowError(
        context: inviteContext,
        value: 'https://invite.example.test/sync/rooms/join?room_id=room_test',
      );
      await tester.pumpAndSettle();
      final add = tester
          .widget<AppActionButton>(
            find.ancestor(
              of: find.text('Add server'),
              matching: find.byType(AppActionButton),
            ),
          )
          .onPressed!;
      if (action == 'late after cancel') {
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      }
      add();
      add();
      await tester.pumpAndSettle();
      expect(
        find.byType(BottomSheet, skipOffstage: false),
        action == 'duplicate' ? findsOneWidget : findsNothing,
      );
      if (action == 'duplicate') {
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
      }
      expect(await result, isNull);
      expect(find.text('Invite page'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  for (final action in ['cancel', 'settings', 'add']) {
    testWidgets('missing invite server action=$action', (tester) async {
      final gateway = _Gateway()..missing = true;
      late BuildContext inviteContext;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyScope<ServerConnectionGateway>(
            value: gateway,
            child: buildThemedTestApp(context, child),
          ),
          home: Builder(
            builder: (context) {
              inviteContext = context;
              return const Scaffold(body: Text('Invite page'));
            },
          ),
        ),
      );
      final result = parseInviteOrShowError(
        context: inviteContext,
        value: 'https://invite.example.test/sync/rooms/join?room_id=room_test',
      );
      await tester.pumpAndSettle();
      expect(find.text('Add the invite server'), findsOneWidget);
      if (action != 'cancel') {
        await tester.tap(find.text('Add server'));
        await tester.pumpAndSettle();
        if (action == 'add') {
          gateway.activation.complete();
          gateway.clock.complete();
          await tester.tap(find.text('Add server').last);
          await tester.pumpAndSettle();
          expect(
            tester.widget<TextField>(find.byType(TextField)).controller!.text,
            'https://invite.example.test/sync',
          );
          await tester.tap(find.text('Add'));
          await tester.pumpAndSettle();
        }
        await tester.tap(find.text('Done'));
      } else {
        await tester.tap(find.text('Cancel'));
      }
      await tester.pumpAndSettle();
      expect(await result, action == 'add' ? 'room_test' : isNull);
      expect(find.text('Invite page'), findsOneWidget);
      expect(find.text('Add the invite server'), findsNothing);
      expect(
        gateway.activatedEndpoint,
        action == 'add' ? 'https://invite.example.test/sync' : isNull,
      );
      expect(gateway.clockCalls, action == 'add' ? 2 : 0);
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    });
  }
  for (final outcome in [
    'success',
    'activation failure',
    'clock failure',
    'disposed',
  ]) {
    testWidgets('invite activation handles $outcome', (tester) async {
      final gateway = _Gateway();
      late BuildContext inviteContext;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyScope<ServerConnectionGateway>(
            value: gateway,
            child: buildThemedTestApp(context, child),
          ),
          home: Builder(
            builder: (context) {
              inviteContext = context;
              return const Scaffold(body: Text('Invite page'));
            },
          ),
        ),
      );
      final result = parseInviteOrShowError(
        context: inviteContext,
        value: 'https://invite.example.test/sync/rooms/join?room_id=room_test',
      );
      expect(gateway.activatedEndpoint, 'https://invite.example.test/sync');
      if (outcome == 'disposed') {
        await tester.pumpWidget(const SizedBox.shrink());
      }
      if (outcome == 'activation failure') {
        gateway.activation.completeError(StateError('activation failed'));
      } else {
        gateway.activation.complete();
        await tester.pump();
        expect(gateway.clockCalls, 1);
        if (outcome == 'clock failure') {
          gateway.clock.completeError(StateError('clock failed'));
        } else {
          gateway.clock.complete();
        }
      }
      expect(await result, outcome == 'success' ? 'room_test' : isNull);
      if (outcome == 'activation failure') expect(gateway.clockCalls, 0);
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    });
  }
}

class _Gateway implements ServerConnectionGateway {
  @override
  Future<ServerConnectionProfile> addServer(
    String address, {
    bool allowInsecureTls = false,
  }) async {
    expect(address, 'https://invite.example.test/sync');
    expect(allowInsecureTls, isFalse);
    missing = false;
    return servers.single;
  }

  @override
  String get serverBaseUrl => '';
  bool missing = false;
  @override
  ServerConnectionProfile? get activeServer => null;
  final activation = Completer<void>();
  final clock = Completer<void>();
  String? activatedEndpoint;
  int clockCalls = 0;

  @override
  List<ServerConnectionProfile> get servers => missing
      ? const []
      : const [
          ServerConnectionProfile(
            endpoint: 'https://invite.example.test/sync',
            declaredServerId: 'test',
            name: 'Invite server',
            isBuiltIn: false,
            allowInsecureTls: false,
          ),
        ];

  @override
  Future<void> activateServer(String endpoint) {
    activatedEndpoint = endpoint;
    return activation.future;
  }

  @override
  Future<void> syncServerTime({bool refresh = false}) {
    clockCalls++;
    return clock.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
