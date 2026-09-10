import 'package:flutter/material.dart';
import 'package:synctv_app/theme/app_theme.dart';

import '../test/support/playback_expiry_checks.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _Checks()));

class _Checks extends StatefulWidget {
  const _Checks();
  @override
  State<_Checks> createState() => _ChecksState();
}

class _ChecksState extends State<_Checks> {
  final results = <String>[];
  int passed = 0;

  void run() {
    results.clear();
    passed = 0;
    for (final check in playbackExpiryChecks.entries) {
      try {
        check.value();
        passed++;
        results.add('PASS ${check.key}');
      } catch (error) {
        results.add('FAIL ${check.key}: $error');
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Playback expiry')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: run,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Run checks'),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          liveRegion: true,
          child: Text('$passed/${playbackExpiryChecks.length} checks passed'),
        ),
        for (final result in results)
          Padding(padding: const EdgeInsets.only(top: 16), child: Text(result)),
      ],
    ),
  );
}
