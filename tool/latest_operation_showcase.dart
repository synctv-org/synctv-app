import 'package:flutter/material.dart';
import 'package:synctv_app/theme/app_theme.dart';

import '../test/support/latest_operation_checks.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _OperationChecks()));

class _OperationChecks extends StatefulWidget {
  const _OperationChecks();

  @override
  State<_OperationChecks> createState() => _OperationChecksState();
}

class _OperationChecksState extends State<_OperationChecks> {
  final _results = <String>[];
  bool _running = false;
  String _status = 'Ready';

  Future<void> _run() async {
    if (_running) return;
    setState(() {
      _running = true;
      _results.clear();
      _status = 'Running';
    });
    var failures = 0;
    for (final check in latestOperationChecks.entries) {
      var result = 'PASS ${check.key}';
      try {
        await check.value();
      } catch (error) {
        failures++;
        result = 'FAIL ${check.key}: $error';
      }
      if (!mounted) return;
      setState(() => _results.add(result));
    }
    if (!mounted) return;
    setState(() {
      _running = false;
      _status =
          '${_results.length - failures}/${_results.length} checks passed';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('SyncTV async operations')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Image.network(
            Uri.base.resolve('icons/Icon-192.png').toString(),
            width: 64,
            height: 64,
            semanticLabel: 'SyncTV',
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: _running ? null : _run,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Run checks'),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(liveRegion: true, child: Text(_status)),
        for (final result in _results)
          Padding(padding: const EdgeInsets.only(top: 16), child: Text(result)),
      ],
    ),
  );
}
