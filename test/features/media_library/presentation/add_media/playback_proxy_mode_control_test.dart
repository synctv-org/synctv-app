import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  for (final locale in ['en', 'zh']) {
    for (final width in [320.0, 1200.0]) {
      testWidgets('large text proxy control fits $locale at $width', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 900);
        addTearDown(tester.view.reset);
        var mode =
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(3)),
              child: child!,
            ),
            home: StatefulBuilder(
              builder: (context, setState) => Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: PlaybackProxyModeControl(
                    value: mode,
                    policy: _allModesPolicy(),
                    onChanged: (value) => setState(() => mode = value),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final dropdown = find.byKey(const Key('playback-proxy-mode-dropdown'));
        expect(dropdown, findsOneWidget);
        final l10n = AppLocalizations.of(tester.element(dropdown));
        final selected = find.text(l10n.playbackProxyDirectOnly).hitTestable();
        expect(selected, findsOneWidget);
        expect(
          tester
              .getRect(dropdown)
              .contains(tester.getRect(selected).bottomRight),
          isTrue,
        );
        await tester.ensureVisible(dropdown);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final option = find.text(l10n.playbackProxyOnly).last;
        await tester.ensureVisible(option);
        await tester.tap(option);
        await tester.pumpAndSettle();
        expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY);
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final locale in ['en', 'zh']) {
    testWidgets('disabled dropdown has named disabled semantics in $locale', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        late StateSetter update;
        var enabled = false;
        var changes = 0;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return Scaffold(
                  body: SizedBox(
                    width: 320,
                    child: PlaybackProxyModeControl(
                      value: source_enum
                          .PlaybackProxyMode
                          .PLAYBACK_PROXY_MODE_AUTO,
                      enabled: enabled,
                      policy: _allModesPolicy(),
                      onChanged: (_) => changes++,
                    ),
                  ),
                );
              },
            ),
          ),
        );
        final l10n = AppLocalizations.of(
          tester.element(find.byType(PlaybackProxyModeControl)),
        );
        final disabled = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.button == true &&
              widget.properties.enabled == false &&
              widget.properties.label == l10n.playbackProxyMode,
        );
        expect(disabled, findsOneWidget);
        final data = tester.getSemantics(disabled).getSemanticsData();
        expect(data.label, l10n.playbackProxyMode);
        expect(data.value, l10n.playbackProxyAuto);
        expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
        expect(data.hasAction(SemanticsAction.tap), isFalse);
        final dropdown = find.byKey(const Key('playback-proxy-mode-dropdown'));
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        expect(find.text(l10n.playbackProxyOnly), findsNothing);
        expect(changes, 0);
        update(() => enabled = true);
        await tester.pumpAndSettle();
        expect(disabled, findsNothing);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.playbackProxyOnly).last);
        await tester.pumpAndSettle();
        expect(changes, 1);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    });
  }

  for (final width in [360.0, 800.0]) {
    for (final change in ['disabled', 'policy', 'disposed', 'callback']) {
      testWidgets('saved selection respects $change at width $width', (
        tester,
      ) async {
        late StateSetter update;
        var enabled = true;
        var visible = true;
        var useNewCallback = false;
        var policy = _allModesPolicy();
        final oldChanges = <source_enum.PlaybackProxyMode>[];
        final newChanges = <source_enum.PlaybackProxyMode>[];
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return Scaffold(
                  body: SizedBox(
                    width: width,
                    child: visible
                        ? PlaybackProxyModeControl(
                            value: source_enum
                                .PlaybackProxyMode
                                .PLAYBACK_PROXY_MODE_AUTO,
                            enabled: enabled,
                            policy: policy,
                            onChanged: useNewCallback
                                ? newChanges.add
                                : oldChanges.add,
                          )
                        : const Text('Replacement'),
                  ),
                );
              },
            ),
          ),
        );
        late VoidCallback select;
        if (width < 640) {
          final callback = tester
              .widget<DropdownButtonFormField<source_enum.PlaybackProxyMode>>(
                find.byKey(const Key('playback-proxy-mode-dropdown')),
              )
              .onChanged!;
          select = () => callback(
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
          );
        } else {
          final callback = tester
              .widget<SegmentedButton<source_enum.PlaybackProxyMode>>(
                find.byKey(const Key('playback-proxy-mode')),
              )
              .onSelectionChanged!;
          select = () => callback({
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
          });
        }
        update(() {
          if (change == 'disabled') enabled = false;
          if (change == 'policy') policy = _proxyModesPolicy();
          if (change == 'disposed') visible = false;
          if (change == 'callback') useNewCallback = true;
        });
        await tester.pump();
        select();
        await tester.pump();
        expect(oldChanges, isEmpty);
        expect(
          newChanges,
          change == 'callback'
              ? [source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY]
              : isEmpty,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('selects every playback route mode and updates its description', (
    tester,
  ) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: SizedBox(
              width: 800,
              child: PlaybackProxyModeControl(
                value: mode,
                policy: _allModesPolicy(),
                onChanged: (value) => setState(() => mode = value),
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      find.text("Use the media source's default playback route"),
      findsOneWidget,
    );
    expect(
      find.text(
        'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.',
      ),
      findsNothing,
    );
    await tester.tap(find.text('Prefer proxy'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER);
    expect(
      find.text('Keep direct and proxy routes, selecting the proxy by default'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Prefer direct'));
    await tester.pump();
    expect(
      mode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
    );
    expect(
      find.text('Keep direct and proxy routes, selecting direct by default'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Direct only'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY);
    expect(find.text('Keep direct playback routes only'), findsOneWidget);

    await tester.tap(find.text('Proxy only'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY);
    expect(
      find.text('Keep routes that the SyncTV server can proxy'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.',
      ),
      findsNothing,
    );
  });

  testWidgets('uses a dropdown on narrow layouts and reports direct-only', (
    tester,
  ) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: SizedBox(
              width: 360,
              child: PlaybackProxyModeControl(
                value: mode,
                policy: _allModesPolicy(),
                onChanged: (value) => setState(() => mode = value),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('playback-proxy-mode')), findsNothing);
    await tester.tap(find.byKey(const Key('playback-proxy-mode-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Direct only').last);
    await tester.pumpAndSettle();

    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY);
    expect(find.text('Keep direct playback routes only'), findsOneWidget);
  });

  testWidgets('renders only modes returned by the provider policy', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: PlaybackProxyModeControl(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
              policy: _proxyModesPolicy(),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Prefer direct'), findsNothing);
    expect(find.text('Direct only'), findsNothing);
    expect(find.text('Prefer proxy'), findsOneWidget);
    expect(find.text('Proxy only'), findsOneWidget);
  });

  testWidgets('uses backend modes and shows the effective automatic policy', (
    tester,
  ) async {
    final policy = provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      autoPolicies: [
        provider_common.PlaybackProxyAutoPolicy(
          variant: 'video',
          mode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
          reason: provider_common_enum
              .PlaybackProxyAutoReason
              .PLAYBACK_PROXY_AUTO_REASON_SIGNED_RESOURCE,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: PlaybackProxyModeControl(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
              policy: policy,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Automatic'), findsOneWidget);
    expect(find.text('Proxy only'), findsOneWidget);
    expect(find.text('Prefer proxy'), findsNothing);
    expect(find.text('Prefer direct'), findsNothing);
    expect(find.text('Direct only'), findsNothing);
    expect(find.text('video: Proxy only (signed resource)'), findsOneWidget);
  });

  testWidgets('normalizes a mode excluded by the backend policy', (
    tester,
  ) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY;
    final policy = provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: SizedBox(
              width: 800,
              child: PlaybackProxyModeControl(
                value: mode,
                policy: policy,
                onChanged: (value) => setState(() => mode = value),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO);
    expect(find.text('Automatic'), findsOneWidget);
    expect(find.text('Direct only'), findsNothing);
    expect(
      find.text("Use the media source's default playback route"),
      findsOneWidget,
    );
  });

  testWidgets('shows a safe state for an empty provider policy', (
    tester,
  ) async {
    final policy = provider_common.PlaybackProxyPolicy(
      supportedModes: const [],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );
    var changes = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: PlaybackProxyModeControl(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
              policy: policy,
              onChanged: (_) => changes++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const Key('playback-proxy-mode-unavailable')),
      findsOneWidget,
    );
    expect(
      find.text(
        'No compatible playback route is available for this media source.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('playback-proxy-mode')), findsNothing);
    expect(changes, 0);
  });

  testWidgets('ignores taps while disabled', (tester) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PlaybackProxyModeControl(
            value: mode,
            enabled: false,
            policy: _allModesPolicy(),
            onChanged: (value) => mode = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Proxy only'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO);
  });
}

provider_common.PlaybackProxyPolicy _allModesPolicy() =>
    provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );

provider_common.PlaybackProxyPolicy _proxyModesPolicy() =>
    provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );
