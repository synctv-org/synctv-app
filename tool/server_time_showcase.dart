import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SyncTvService.init();
  runApp(MaterialApp(theme: AppTheme.light, home: const _ServerTimeChecks()));
}

class _ServerTimeChecks extends StatefulWidget {
  const _ServerTimeChecks();

  @override
  State<_ServerTimeChecks> createState() => _ServerTimeChecksState();
}

class _ServerTimeChecksState extends State<_ServerTimeChecks> {
  var _running = false;
  var _results = <String>[];

  Future<void> _run() async {
    if (_running) return;
    setState(() {
      _running = true;
      _results = [];
    });
    final results = <String>[];
    try {
      await SyncTvService.setBaseUrl(Uri.base.origin);
      for (final mode in ['mismatch', 'near-mismatch']) {
        for (final previous in [false, true]) {
          await _setMode(mode);
          SyncedClock.reset();
          if (previous) {
            final sent = SyncedClock.localUnixNanos();
            SyncedClock.updateFromServerTime(
              clientSentAtNanos: sent,
              clientReceivedAtNanos: sent + 100000000,
              serverReceivedAtNanos: sent + 2050000000,
              serverSentAtNanos: sent + 2050000000,
            );
          }
          final syncedAt = SyncedClock.syncedAt;
          final latency = SyncedClock.estimatedLatency;
          await SyncTvService.syncServerTime(refresh: true);
          final valid =
              SyncedClock.isSynced == previous &&
              SyncedClock.syncedAt == syncedAt &&
              SyncedClock.estimatedLatency == latency;
          results.add(
            '${valid ? 'PASS' : 'FAIL'} $mode reply / '
            '${previous ? 'preserve calibration' : 'remain unsynced'}',
          );
        }
      }
      await _setMode('matched');
      SyncedClock.reset();
      await SyncTvService.syncServerTime(refresh: true);
      results.add(
        '${SyncedClock.isSynced ? 'PASS' : 'FAIL'} matching reply calibrates',
      );
    } catch (error) {
      results.add('FAIL request: $error');
    } finally {
      SyncedClock.reset();
      if (mounted) {
        setState(() {
          _running = false;
          _results = results;
        });
      }
    }
  }

  Future<void> _setMode(String mode) async {
    final response = await http.post(
      Uri.base.resolve('/fixture/time-mode'),
      body: mode,
    );
    if (response.statusCode != 204) {
      throw StateError('Unable to configure fixture response');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('SyncTV time reply checks')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: _running ? null : _run,
            child: Text(_running ? 'Running' : 'Run HTTP checks'),
          ),
        ),
        for (final result in _results)
          Padding(padding: const EdgeInsets.only(top: 16), child: Text(result)),
      ],
    ),
  );
}
