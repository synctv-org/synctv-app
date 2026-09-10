import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/services.dart';
import 'package:synctv_video_player_media_kit/src/web_video_playback_controller.dart';
import 'package:web/web.dart' as web;

const webVideoMountChecks = [
  'Interrupted pending play resumes after mounting',
  'Settled playback resumes after mounting',
  'Pause cancels pending mount recovery',
  'Disposal cancels pending mount recovery',
  'Permission denial stays visible without retry',
  'Unrelated abort stays visible without retry',
  'A failed recovery is not repeated',
  'Old failures preserve newer playback intent',
  'Automatic recovery errors reach the owner',
  'Unattached mounts stop waiting',
  'Completed playback is not restarted by mounting',
  'Native pause survives remounting',
];

Future<void> runWebVideoMountCheck(String scenario) async {
  final video = web.HTMLVideoElement()
    ..style.width = '32px'
    ..style.height = '32px'
    ..style.position = 'fixed'
    ..style.left = '-10000px';
  final host = web.HTMLDivElement();
  web.document.body!.append(video);
  final errors = <Object>[];
  final controller = WebVideoPlaybackController(
    video,
    onError: (error, _) => errors.add(error),
  );
  final promise = globalContext.getProperty<JSFunction>('Promise'.toJS);
  late JSFunction rejectFirst;
  final pending = promise.callAsConstructor<JSPromise<JSAny?>>(
    ((JSFunction resolve, JSFunction reject) {
      rejectFirst = reject;
    }).toJS,
  );
  var calls = 0;
  var paused = true;
  globalContext
      .getProperty<JSObject>('Object'.toJS)
      .callMethod<JSAny?>(
        'defineProperty'.toJS,
        video,
        'paused'.toJS,
        {'configurable': true, 'get': (() => paused.toJS).toJS}.jsify(),
      );
  final settled =
      scenario.startsWith('Settled') ||
      scenario.startsWith('Automatic') ||
      scenario.startsWith('Completed') ||
      scenario.startsWith('Native pause');
  video.setProperty(
    'play'.toJS,
    (() {
      calls++;
      paused = false;
      if (calls == 1 && !settled) return pending;
      if (calls > 1 &&
          (scenario.startsWith('A failed') ||
              scenario.startsWith('Automatic'))) {
        return promise.callMethod<JSPromise<JSAny?>>(
          'reject'.toJS,
          web.DOMException('Recovery failure', 'AbortError'),
        );
      }
      return promise.callMethod<JSPromise<JSAny?>>('resolve'.toJS);
    }).toJS,
  );
  video.setProperty(
    'pause'.toJS,
    (() {
      paused = true;
    }).toJS,
  );

  void expect(bool condition, String message) {
    if (!condition) throw StateError(message);
  }

  Future<Object?> outcome(Future<void> operation) => operation
      .then<Object?>((_) => null, onError: (Object error) => error)
      .timeout(const Duration(seconds: 5));
  Future<void> waitFor(bool Function() condition) async {
    final until = DateTime.now().add(const Duration(seconds: 2));
    while (!condition()) {
      if (DateTime.now().isAfter(until)) {
        throw StateError('Mount did not settle');
      }
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  }

  void attach() {
    host.append(video);
    web.document.body!.append(host);
  }

  void reject(String name) => rejectFirst.callAsFunction(
    null,
    web.DOMException('Injected interruption', name),
  );

  try {
    final initial = outcome(controller.play());
    if (settled) {
      expect(await initial == null, 'Initial playback failed');
      if (scenario.startsWith('Native pause')) {
        video.pause();
        controller.prepareForMount();
        attach();
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(calls == 1, 'Mount overrode a native pause');
        return;
      }
      if (scenario.startsWith('Completed')) {
        globalContext
            .getProperty<JSObject>('Object'.toJS)
            .callMethod<JSAny?>(
              'defineProperty'.toJS,
              video,
              'ended'.toJS,
              {'configurable': true, 'value': true}.jsify(),
            );
        controller.prepareForMount();
        attach();
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(calls == 1, 'Mount restarted completed media');
        return;
      }
      controller.prepareForMount();
      attach();
      await waitFor(
        () => scenario.startsWith('Automatic') ? errors.isNotEmpty : calls == 2,
      );
      expect(calls == 2, 'Mount recovery was duplicated');
      if (scenario.startsWith('Automatic')) {
        expect(errors.single is PlatformException, 'Recovery error was lost');
      } else {
        expect(errors.isEmpty, 'Unexpected owner error');
      }
      return;
    }
    if (scenario.startsWith('Old failures')) {
      await controller.play();
      reject('AbortError');
      expect(await initial == null, 'Superseded failure escaped');
      controller.prepareForMount();
      attach();
      await waitFor(() => calls == 3);
      expect(errors.isEmpty, 'Old error reached the owner');
      return;
    }
    if (!scenario.startsWith('Unrelated')) controller.prepareForMount();
    if (scenario.startsWith('Pause')) controller.pause();
    if (scenario.startsWith('Disposal')) controller.dispose();
    if (!scenario.startsWith('Unattached')) attach();
    final denied = scenario.startsWith('Permission');
    reject(denied ? 'NotAllowedError' : 'AbortError');
    final result = await initial;
    final cancelled =
        scenario.startsWith('Pause') || scenario.startsWith('Disposal');
    final fails =
        denied ||
        scenario.startsWith('Unrelated') ||
        scenario.startsWith('A failed') ||
        scenario.startsWith('Unattached');
    expect(
      fails ? result is PlatformException : result == null,
      'Unexpected playback result: $result',
    );
    if (denied) {
      expect(
        (result as PlatformException).code == 'NotAllowedError',
        'Permission error was changed',
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(
      calls ==
          (cancelled ||
                  denied ||
                  scenario.startsWith('Unrelated') ||
                  scenario.startsWith('Unattached')
              ? 1
              : 2),
      'Unexpected retry count: $calls',
    );
    expect(errors.isEmpty, 'Unexpected asynchronous owner error');
  } finally {
    controller.dispose();
    video.remove();
    host.remove();
  }
}
