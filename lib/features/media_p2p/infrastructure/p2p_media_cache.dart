import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';

typedef P2pMediaCacheClock = DateTime Function();

class P2pMediaPersistentCache {
  P2pMediaPersistentCache({
    required this.directory,
    required int maxBytes,
    this.ttl = const Duration(minutes: 10),
    this.cleanupInterval = const Duration(minutes: 1),
    P2pMediaCacheClock? clock,
  }) : assert(maxBytes > 0),
       assert(ttl > Duration.zero),
       maxBytes = maxBytes,
       _clock = clock ?? DateTime.now {
    if (cleanupInterval > Duration.zero) {
      _cleanupTimer = Timer.periodic(
        cleanupInterval,
        (_) => unawaited(
          evictExpired().catchError((Object error) {
            debugPrint('P2P media cache cleanup failed: $error');
          }),
        ),
      );
    }
  }

  static const String _indexFileName = 'index.json';
  static const int _indexVersion = 1;
  static int _temporaryFileSequence = 0;
  static final Map<String, Future<void>> _replacementTails = {};

  final Directory directory;
  final Duration ttl;
  final Duration cleanupInterval;
  final P2pMediaCacheClock _clock;
  final Map<String, _PersistentCacheEntry> _entries = {};
  final SerialAsyncOperationCoordinator _operations =
      SerialAsyncOperationCoordinator();
  Future<void>? _initializing;
  Timer? _cleanupTimer;
  bool _closed = false;

  int maxBytes;
  int totalBytes = 0;

  Future<void> initialize() => _enqueue(_initializeUnlocked);

  Future<Uint8List?> get(String key) => _enqueue(() async {
    await _initializeUnlocked();
    final entry = _entries[key];
    if (entry == null) return null;
    final now = _clock();
    if (_isExpired(entry, now)) {
      await _removeEntry(entry);
      await _persistIndex();
      return null;
    }
    final file = File('${directory.path}/${entry.fileName}');
    try {
      final bytes = await file.readAsBytes();
      if (bytes.length != entry.size) {
        await _removeEntry(entry);
        await _persistIndex();
        return null;
      }
      entry.lastAccessed = now;
      await _persistIndex();
      return bytes;
    } on FileSystemException {
      await _removeEntry(entry);
      await _persistIndex();
      return null;
    }
  });

  Future<void> touch(String key) => _enqueue(() async {
    await _initializeUnlocked();
    final entry = _entries[key];
    if (entry == null) return;
    final now = _clock();
    if (_isExpired(entry, now)) {
      await _removeEntry(entry);
    } else {
      entry.lastAccessed = now;
    }
    await _persistIndex();
  });

  Future<void> put(String key, Uint8List bytes) => _enqueue(() async {
    await _initializeUnlocked();
    final existing = _entries[key];
    if (bytes.length > maxBytes) {
      if (existing != null) {
        await _removeEntry(existing);
        await _persistIndex();
      }
      return;
    }

    final fileName = '${sha256.convert(utf8.encode(key))}.piece';
    final destination = File('${directory.path}/$fileName');
    final temporary = _temporaryFileFor(destination);
    await temporary.writeAsBytes(bytes, flush: true);
    await _replaceFile(temporary, destination);

    if (existing != null) totalBytes -= existing.size;
    final entry = _PersistentCacheEntry(
      key: key,
      fileName: fileName,
      size: bytes.length,
      lastAccessed: _clock(),
    );
    _entries[key] = entry;
    totalBytes += bytes.length;
    await _evictUnlocked();
    await _persistIndex();
  });

  Future<void> resize(int value) => _enqueue(() async {
    if (value <= 0) throw ArgumentError.value(value, 'value');
    await _initializeUnlocked();
    maxBytes = value;
    await _evictUnlocked();
    await _persistIndex();
  });

  Future<void> evictExpired() {
    if (_closed) return Future.value();
    return _enqueue(() async {
      await _initializeUnlocked();
      await _evictUnlocked();
      await _persistIndex();
    });
  }

  Future<void> close() async {
    if (_closed) return;
    _cleanupTimer?.cancel();
    _closed = true;
    await _enqueue(() async {
      await _initializeUnlocked();
      await _evictUnlocked();
      await _persistIndex();
    }, allowClosed: true);
  }

  Future<T> _enqueue<T>(
    Future<T> Function() operation, {
    bool allowClosed = false,
  }) {
    if (_closed && !allowClosed) {
      return Future.error(StateError('P2P media cache is closed'));
    }
    return _operations.run(operation);
  }

  Future<void> _initializeUnlocked() async {
    final current = _initializing;
    if (current != null) return current;
    final initializing = _loadIndex();
    _initializing = initializing;
    await initializing;
  }

  Future<void> _loadIndex() async {
    await directory.create(recursive: true);
    final index = File('${directory.path}/$_indexFileName');
    if (await index.exists()) {
      try {
        final decoded = jsonDecode(await index.readAsString());
        if (decoded case {
          'version': _indexVersion,
          'entries': final List<dynamic> entries,
        }) {
          for (final value in entries) {
            final entry = _PersistentCacheEntry.fromJson(value);
            if (entry != null) _entries[entry.key] = entry;
          }
        }
      } on Object {
        _entries.clear();
      }
    }

    totalBytes = 0;
    for (final entry in _entries.values.toList(growable: false)) {
      final file = File('${directory.path}/${entry.fileName}');
      try {
        final stat = await file.stat();
        if (stat.type != FileSystemEntityType.file || stat.size != entry.size) {
          await _removeEntry(entry);
        } else {
          totalBytes += entry.size;
        }
      } on FileSystemException {
        await _removeEntry(entry);
      }
    }
    await _removeOrphanFiles();
    await _evictUnlocked();
    await _persistIndex();
  }

  Future<void> _evictUnlocked() async {
    final now = _clock();
    for (final entry in _entries.values.toList(growable: false)) {
      if (_isExpired(entry, now)) await _removeEntry(entry);
    }
    if (totalBytes <= maxBytes) return;
    final oldest = _entries.values.toList(growable: false)
      ..sort((left, right) => left.lastAccessed.compareTo(right.lastAccessed));
    for (final entry in oldest) {
      if (totalBytes <= maxBytes) break;
      await _removeEntry(entry);
    }
  }

  bool _isExpired(_PersistentCacheEntry entry, DateTime now) =>
      now.difference(entry.lastAccessed) >= ttl;

  Future<void> _removeEntry(_PersistentCacheEntry entry) async {
    final removed = _entries.remove(entry.key);
    if (removed == null) return;
    totalBytes -= removed.size;
    if (totalBytes < 0) totalBytes = 0;
    final file = File('${directory.path}/${removed.fileName}');
    try {
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // A later maintenance pass retries orphan removal.
    }
  }

  Future<void> _removeOrphanFiles() async {
    final expected = _entries.values.map((entry) => entry.fileName).toSet();
    final now = _clock();
    await for (final entity in directory.list()) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      final isOrphanPiece = name.endsWith('.piece') && !expected.contains(name);
      var isStaleTemporary = false;
      if (name.contains('.tmp.')) {
        try {
          final stat = await entity.stat();
          isStaleTemporary = now.difference(stat.modified) >= ttl;
        } on FileSystemException {
          isStaleTemporary = true;
        }
      }
      if (isOrphanPiece || isStaleTemporary) {
        try {
          await entity.delete();
        } on FileSystemException {
          // A later maintenance pass retries orphan removal.
        }
      }
    }
  }

  Future<void> _persistIndex() async {
    final index = File('${directory.path}/$_indexFileName');
    final temporary = _temporaryFileFor(index);
    final body = jsonEncode({
      'version': _indexVersion,
      'entries': _entries.values.map((entry) => entry.toJson()).toList(),
    });
    await temporary.writeAsString(body, flush: true);
    await _replaceFile(temporary, index);
  }

  static File _temporaryFileFor(File destination) {
    final sequence = _temporaryFileSequence++;
    return File(
      '${destination.path}.tmp.$pid.'
      '${DateTime.now().microsecondsSinceEpoch}.$sequence',
    );
  }

  static Future<void> _replaceFile(File temporary, File destination) {
    final path = destination.path;
    final previous = _replacementTails[path] ?? Future.value();
    late final Future<void> operation;
    operation = previous
        .catchError((_) {})
        .then((_) async {
          if (await destination.exists()) await destination.delete();
          await temporary.rename(path);
        })
        .whenComplete(() {
          if (identical(_replacementTails[path], operation)) {
            _replacementTails.remove(path);
          }
        });
    _replacementTails[path] = operation;
    return operation;
  }
}

class _PersistentCacheEntry {
  _PersistentCacheEntry({
    required this.key,
    required this.fileName,
    required this.size,
    required this.lastAccessed,
  });

  final String key;
  final String fileName;
  final int size;
  DateTime lastAccessed;

  static _PersistentCacheEntry? fromJson(Object? value) {
    if (value case {
      'key': final String key,
      'file': final String fileName,
      'size': final int size,
      'last_accessed_millis': final int lastAccessedMillis,
    }) {
      if (key.isEmpty ||
          !RegExp(r'^[0-9a-f]{64}\.piece$').hasMatch(fileName) ||
          size < 0 ||
          lastAccessedMillis < 0) {
        return null;
      }
      return _PersistentCacheEntry(
        key: key,
        fileName: fileName,
        size: size,
        lastAccessed: DateTime.fromMillisecondsSinceEpoch(lastAccessedMillis),
      );
    }
    return null;
  }

  Map<String, Object> toJson() => {
    'key': key,
    'file': fileName,
    'size': size,
    'last_accessed_millis': lastAccessed.millisecondsSinceEpoch,
  };
}
