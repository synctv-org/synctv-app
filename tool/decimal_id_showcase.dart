import 'package:flutter/material.dart';
import 'package:synctv_app/core/identifiers/decimal_int64.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _IdChecks()));

class _IdChecks extends StatefulWidget {
  const _IdChecks();

  @override
  State<_IdChecks> createState() => _IdChecksState();
}

class _IdChecksState extends State<_IdChecks> {
  var _results = <String>[];

  void _run() {
    final zeroes = '0' * 100000;
    final cases = <(String, String, String?)>[
      ('Exact maximum', '9223372036854775807', '9223372036854775807'),
      ('Above maximum', '9223372036854775808', null),
      ('Unsafe JS integer', '9007199254740993', '9007199254740993'),
      ('100,000 leading zeroes', '${zeroes}42', '42'),
      ('100,000 significant digits', '9' * 100000, null),
      ('Malformed padded value', '${zeroes}x', null),
    ];
    final results = <String>[];
    for (final (label, input, expected) in cases) {
      final watch = Stopwatch()..start();
      String? actual;
      for (var i = 0; i < 3; i++) {
        actual = normalizeInt64Decimal(input);
      }
      watch.stop();
      results.add(
        '${actual == expected ? 'PASS' : 'FAIL'} $label: ${watch.elapsedMicroseconds} µs / 3 calls',
      );
    }
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Decimal ID checks')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: _run,
            child: const Text('Run ID checks'),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Wall-clock samples include runtime noise; these are not production latency estimates.',
        ),
        for (final result in _results)
          Padding(padding: const EdgeInsets.only(top: 16), child: Text(result)),
      ],
    ),
  );
}
