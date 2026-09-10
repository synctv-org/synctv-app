import 'package:flutter/material.dart';
import 'package:synctv_app/theme/app_theme.dart';

import '../test/support/p2p_web_lifecycle_checks.dart';
import '../test/support/p2p_engine_owner_checks.dart';
import '../test/support/p2p_web_request_checks.dart';
import '../test/support/p2p_web_pending_request_checks.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _LifecycleChecks()));

class _LifecycleChecks extends StatefulWidget {
  const _LifecycleChecks();

  @override
  State<_LifecycleChecks> createState() => _LifecycleChecksState();
}

class _LifecycleChecksState extends State<_LifecycleChecks> {
  final _results = <String>[];
  var _running = false;
  String _status = 'Ready';

  Future<void> _run() async {
    if (_running) return;
    setState(() {
      _running = true;
      _status = 'Running';
      _results.clear();
    });
    try {
      for (final scenario in p2pWebLifecycleChecks) {
        await runP2pWebLifecycleCheck(scenario);
        if (!mounted) return;
        setState(() => _results.add(scenario));
      }
      for (final scenario in p2pEngineOwnerChecks) {
        await runP2pEngineOwnerCheck(scenario);
        if (!mounted) return;
        setState(() => _results.add(scenario));
      }
      for (final scenario in p2pWebRequestChecks) {
        await runP2pWebRequestCheck(scenario);
        if (!mounted) return;
        setState(() => _results.add(scenario));
      }
      for (final scenario in p2pWebPendingRequestChecks) {
        await runP2pWebPendingRequestCheck(scenario);
        if (!mounted) return;
        setState(() => _results.add(scenario));
      }
      if (mounted) setState(() => _status = 'All 34 checks passed');
    } catch (error) {
      if (mounted) setState(() => _status = error.toString());
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('P2P engine lifecycle')),
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
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(result)),
              ],
            ),
          ),
      ],
    ),
  );
}
