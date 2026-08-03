import 'dart:async';

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
  testWidgets('slice cache tab renders stats and runs maintenance actions', (
    tester,
  ) async {
    final gateway = _CacheAdminGateway();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => DependencyScope<AdminGateway>(
          value: gateway,
          child: buildThemedTestApp(context, child),
        ),
        home: const Scaffold(body: AdminSliceCacheTab()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('node_a'), findsOneWidget);
    expect(find.text('512.0 MiB'), findsOneWidget);
    expect(find.text('18'), findsOneWidget);

    await tester.tap(find.text('Evict expired'));
    await tester.pumpAndSettle();
    expect(gateway.evictionCount, 1);

    await tester.tap(find.text('Purge cache'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Purge every cached slice'), findsOneWidget);
    await tester.tap(find.text('Purge cache').last);
    await tester.pumpAndSettle();
    expect(gateway.purgeCount, 1);
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'slice cache clears stale stats while refreshing and on failure',
    (tester) async {
      final gateway = _CacheAdminGateway();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyScope<AdminGateway>(
            value: gateway,
            child: buildThemedTestApp(context, child),
          ),
          home: const Scaffold(body: AdminSliceCacheTab()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('node_a'), findsOneWidget);

      final pendingStats = Completer<AdminSliceCacheStats>();
      gateway.nextStats = pendingStats;
      await tester.tap(find.byIcon(Icons.refresh_rounded));
      await tester.pump();

      expect(find.text('node_a'), findsNothing);
      final evictButton = tester.widget<AppActionButton>(
        find.widgetWithText(AppActionButton, 'Evict expired'),
      );
      expect(evictButton.onPressed, isNull);

      pendingStats.completeError(StateError('stats timeout'));
      await tester.pumpAndSettle();

      expect(find.text('node_a'), findsNothing);
      expect(
        find.text('No slice cache statistics are available'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('slice cache keeps all-node partial operation details', (
    tester,
  ) async {
    final gateway = _CacheAdminGateway(partialFailure: true);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => DependencyScope<AdminGateway>(
          value: gateway,
          child: buildThemedTestApp(context, child),
        ),
        home: const Scaffold(body: AdminSliceCacheTab()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('All nodes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Evict expired'));
    await tester.pumpAndSettle();

    expect(gateway.lastEvictionAllNodes, isTrue);
    expect(
      find.byKey(const ValueKey('slice-cache-operation-node-node_a')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('slice-cache-operation-failure-node_b')),
      findsOneWidget,
    );
    expect(find.text('node timeout'), findsOneWidget);
    expect(find.textContaining('2 expired cache entries'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });
}

final class _CacheAdminGateway implements AdminGateway {
  _CacheAdminGateway({this.partialFailure = false});

  final bool partialFailure;
  int evictionCount = 0;
  int purgeCount = 0;
  bool lastEvictionAllNodes = false;
  Completer<AdminSliceCacheStats>? nextStats;

  @override
  Future<AdminSliceCacheStats> adminGetSliceCacheStats({
    String nodeId = '',
    bool allNodes = false,
  }) async {
    final pending = nextStats;
    if (pending != null) {
      nextStats = null;
      return pending.future;
    }
    return const AdminSliceCacheStats(
      nodes: [
        AdminSliceCacheNodeStats(
          nodeId: 'node_a',
          config: AdminSliceCacheConfig(
            engineEnabled: true,
            backend: 'file',
            fileCacheDir: '/var/cache/synctv',
            sliceSize: 4194304,
            maxCacheSize: 1073741824,
            segmentTtlSeconds: 600,
            staleMaxAgeSeconds: 120,
            staleWhileRevalidate: true,
            evictionIntervalSeconds: 30,
            watermarkRatio: 0.75,
          ),
          currentSizeBytes: 536870912,
          entryCount: 18,
          metadataEntries: 16,
          updatingEntries: 1,
          lockCount: 2,
          usageRatio: 0.5,
        ),
      ],
      failures: [],
    );
  }

  @override
  Future<AdminSliceCacheOperationResult> adminEvictExpiredSliceCache({
    String nodeId = '',
    bool allNodes = false,
  }) async {
    evictionCount++;
    lastEvictionAllNodes = allNodes;
    return _result(removedEntries: 4);
  }

  @override
  Future<AdminSliceCacheOperationResult> adminPurgeSliceCache({
    String nodeId = '',
    bool allNodes = false,
  }) async {
    purgeCount++;
    return _result(removedEntries: 18, freedBytes: 536870912);
  }

  AdminSliceCacheOperationResult _result({
    required int removedEntries,
    int freedBytes = 0,
  }) {
    return AdminSliceCacheOperationResult(
      success: !partialFailure,
      removedEntries: removedEntries,
      freedBytes: freedBytes,
      stats: null,
      nodes: partialFailure
          ? const [
              AdminSliceCacheOperationNode(
                nodeId: 'node_a',
                success: true,
                removedEntries: 2,
                freedBytes: 0,
                stats: null,
              ),
            ]
          : const [],
      failures: partialFailure
          ? const [
              AdminSliceCacheFailure(nodeId: 'node_b', error: 'node timeout'),
            ]
          : const [],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
