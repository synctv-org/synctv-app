import 'dart:async';
import 'dart:convert';
import 'dart:io';

const _watchRoots = ['lib', 'assets', 'pubspec.yaml'];

const _restartSuffixes = {'pubspec.yaml', 'pubspec.lock'};

Future<void> main(List<String> args) async {
  final device = args.isEmpty ? 'macos' : args.first;
  final flutterArgs = ['run', '-d', device, ...args.skip(1)];

  stdout.writeln('Starting: flutter ${flutterArgs.join(' ')}');
  final process = await Process.start(
    'flutter',
    flutterArgs,
    mode: ProcessStartMode.normal,
  );

  stdin.lineMode = false;
  stdin.echoMode = false;

  final inputSink = process.stdin;
  final ready = Completer<void>();
  final subscriptions = <StreamSubscription<dynamic>>[];

  void send(String key) {
    inputSink.write(key);
  }

  subscriptions.add(
    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
          stdout.writeln(line);
          if (!ready.isCompleted &&
              (line.contains('Flutter run key commands') ||
                  line.contains('To hot reload changes'))) {
            ready.complete();
          }
        }),
  );
  subscriptions.add(
    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(stderr.writeln),
  );

  subscriptions.add(
    stdin.listen((data) {
      inputSink.add(data);
    }),
  );

  final watcher = _HotReloadWatcher(
    onReload: () => send('r'),
    onRestart: () => send('R'),
  );
  await watcher.start();

  unawaited(
    process.exitCode.then((code) async {
      for (final subscription in subscriptions) {
        await subscription.cancel();
      }
      await watcher.dispose();
      stdin.lineMode = true;
      stdin.echoMode = true;
      exit(code);
    }),
  );

  await ready.future.timeout(const Duration(seconds: 90), onTimeout: () {});
  stdout.writeln('Auto reload watcher is active.');
}

class _HotReloadWatcher {
  _HotReloadWatcher({required this.onReload, required this.onRestart});

  final VoidCallback onReload;
  final VoidCallback onRestart;
  final _subscriptions = <StreamSubscription<FileSystemEvent>>[];
  Timer? _debounce;
  bool _restartQueued = false;

  Future<void> start() async {
    for (final root in _watchRoots) {
      final entityType = await FileSystemEntity.type(root);
      if (entityType == FileSystemEntityType.notFound) continue;
      final entity = entityType == FileSystemEntityType.directory
          ? Directory(root)
          : File(root);
      _subscriptions.add(
        entity.watch(recursive: entity is Directory).listen(_handleEvent),
      );
    }
  }

  Future<void> dispose() async {
    _debounce?.cancel();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
  }

  void _handleEvent(FileSystemEvent event) {
    final path = event.path;
    if (_shouldIgnore(path)) return;
    _restartQueued = _restartQueued || _requiresRestart(path);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (_restartQueued) {
        stdout.writeln('Change detected, hot restarting...');
        onRestart();
      } else {
        stdout.writeln('Change detected, hot reloading...');
        onReload();
      }
      _restartQueued = false;
    });
  }

  bool _shouldIgnore(String path) {
    return path.contains('/.dart_tool/') ||
        path.contains('/build/') ||
        path.endsWith('.tmp') ||
        path.endsWith('.swp');
  }

  bool _requiresRestart(String path) {
    return _restartSuffixes.any(path.endsWith) ||
        path.endsWith('.arb') ||
        path.endsWith('.json') ||
        path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.webp');
  }
}

typedef VoidCallback = void Function();
