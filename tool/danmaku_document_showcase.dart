import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/presentation/danmaku/acfun_danmaku_codec.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _Preview()));

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  List<String> results = const [];

  void load() {
    try {
      final items = decodeAcFunDanmakuDocument('''{"comments":[
        {"text":"First valid comment","positionMs":0},
        {"text":"Invalid timestamp","positionMs":1e999},
        {"text":"Recovered optional fields","positionMs":1000,"mode":1e999,"size":-1e999},
        {"text":"Out of range timestamp","positionMs":"9223372036854775807"},
        {"text":"Last valid comment","positionMs":2000}
      ]}''');
      setState(
        () => results = [
          for (final item in items!)
            '${item.text} · ${item.startTime.inMilliseconds} ms · ${item.fontSize.toInt()} px',
        ],
      );
    } catch (_) {
      setState(() => results = ['Document could not be loaded']);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Danmaku document recovery')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton(onPressed: load, child: const Text('Load mixed document')),
        const SizedBox(height: 16),
        for (final result in results) ListTile(title: Text(result)),
      ],
    ),
  );
}
