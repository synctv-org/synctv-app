import 'package:flutter/material.dart';
import 'package:synctv_app/theme/app_theme.dart';

import '../test/support/synced_clock_checks.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _ClockChecks()));

class _ClockChecks extends StatefulWidget {
  const _ClockChecks();

  @override
  State<_ClockChecks> createState() => _ClockChecksState();
}

class _ClockChecksState extends State<_ClockChecks> {
  final _results = <String>[];
  String _status = 'Ready';

  void _run() {
    var passed = 0;
    final results = <String>[];
    for (final check in syncedClockChecks.entries) {
      try {
        check.value();
        passed++;
        results.add('PASS ${check.key}');
      } catch (error) {
        results.add('FAIL ${check.key}: $error');
      }
    }
    setState(() {
      _results
        ..clear()
        ..addAll(results);
      _status = '$passed/${results.length} checks passed';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('SyncTV clock samples')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(onPressed: _run, child: const Text('Run checks')),
        ),
        const SizedBox(height: 16),
        Semantics(liveRegion: true, child: Text(_status)),
        for (final result in _results)
          Padding(padding: const EdgeInsets.only(top: 12), child: Text(result)),
      ],
    ),
  );
}
