import 'package:flutter/material.dart';
import 'package:synctv_app/theme/app_theme.dart';

import '../test/support/oauth2_web_session_checks.dart';
import '../test/support/oauth2_dispatcher_checks.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _SessionChecks()));

class _SessionChecks extends StatefulWidget {
  const _SessionChecks();

  @override
  State<_SessionChecks> createState() => _SessionChecksState();
}

class _SessionChecksState extends State<_SessionChecks> {
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
    try {
      for (final scenario in oauth2DispatcherChecks) {
        runOAuth2DispatcherCheck(scenario);
        if (!mounted) return;
        setState(() => _results.add(scenario));
      }
      for (final scenario in oauth2WebSessionChecks) {
        await runOAuth2WebSessionCheck(scenario);
        if (!mounted) return;
        setState(() => _results.add(scenario));
      }
      if (mounted) {
        setState(
          () => _status =
              'All ${oauth2DispatcherChecks.length + oauth2WebSessionChecks.length} checks passed',
        );
      }
    } catch (error) {
      if (mounted) setState(() => _status = error.toString());
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('OAuth callback sessions')),
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
