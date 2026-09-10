import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/content_reports/application/content_reports_gateway.dart';
import 'package:synctv_app/features/content_reports/presentation/content_reports_view.dart';
import 'package:synctv_app/features/content_reports/presentation/report_disposition_dialog.dart';
import 'package:synctv_app/features/content_reports/presentation/report_filters_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;

import '../../../test_app.dart';

void main() {
  testWidgets('message ID survives query, edit, reopen and removal', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    gateway.onList = (_) async => _page('Initial room');
    await _pumpReports(
      tester,
      gateway,
      reportsView: ContentReportsView(
        gateway: gateway,
        showTargetTypeTabs: false,
        initialTargetChatMessageId: '9007199254740993',
      ),
    );
    expect(gateway.queries.single.targetChatMessageId, '9007199254740993');
    await tester.tap(byAppTooltip('Report filters'));
    await tester.pumpAndSettle();
    final field = find.widgetWithText(AppTextField, 'Message ID');
    expect(
      tester.widget<AppTextField>(field).controller.text,
      '9007199254740993',
    );
    final input = find.descendant(of: field, matching: find.byType(TextField));
    await tester.ensureVisible(input);
    await tester.enterText(input, '009223372036854775807');
    await tester.ensureVisible(find.text('Apply'));
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(gateway.queries.last.targetChatMessageId, '9223372036854775807');
    expect(find.text('Message #9223372036854775807'), findsOneWidget);
    await tester.tap(byAppTooltip('Report filters'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppTextField>(field).controller.text,
      '9223372036854775807',
    );
    await tester.ensureVisible(find.text('Cancel'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Message #9223372036854775807'));
    await tester.pumpAndSettle();
    expect(gateway.queries.last.targetChatMessageId, '0');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'nonadjacent tab animation rejects details before transition ends',
    (tester) async {
      final gateway = _ControlledContentReportsGateway();
      final inner = TabController(length: 2, vsync: tester);
      final parent = TabController(length: 3, vsync: tester);
      addTearDown(inner.dispose);
      addTearDown(parent.dispose);
      await _pumpTabbedReports(tester, gateway, inner, parent);
      tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
      await tester.pump();
      parent.animateTo(2, duration: const Duration(seconds: 1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      gateway.detail.complete(_report('Initial room'));
      await tester.pump();
      expect(parent.indexIsChanging, isTrue);
      expect(find.byType(AppDialogFrame, skipOffstage: false), findsNothing);
      await tester.pumpAndSettle();
      expect(find.text('Other outer tab'), findsOneWidget);
      expect(find.byType(AppDialogFrame, skipOffstage: false), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final outer in [false, true]) {
    for (final failure in [false, true]) {
      testWidgets(
        'hidden nested report tab ignores detail outer=$outer failure=$failure',
        (tester) async {
          final gateway = _ControlledContentReportsGateway();
          final inner = TabController(length: 2, vsync: tester);
          final parent = TabController(length: 2, vsync: tester);
          addTearDown(inner.dispose);
          addTearDown(parent.dispose);
          await _pumpTabbedReports(tester, gateway, inner, parent);
          final open = tester
              .widget<AppTile>(find.byType(AppTile).last)
              .onPressed!;
          open();
          await tester.pump();
          (outer ? parent : inner).index = 1;
          await tester.pump();
          if (failure) {
            gateway.detail.completeError(StateError('hidden detail'));
          } else {
            gateway.detail.complete(_report('Initial room'));
          }
          await tester.pumpAndSettle();
          expect(
            find.byType(AppDialogFrame, skipOffstage: false),
            findsNothing,
          );
          open();
          await tester.pumpAndSettle();
          expect(gateway.detailRequests, 1);
          (outer ? parent : inner).index = 0;
          await tester.pumpAndSettle();
          tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
          await tester.pumpAndSettle();
          expect(gateway.detailRequests, 2);
          expect(find.byType(AppDialogFrame), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final action in ['Report filters', 'Resolve']) {
    testWidgets('hiding report tab dismisses owned $action dialog', (
      tester,
    ) async {
      final gateway = _ControlledContentReportsGateway();
      final inner = TabController(length: 2, vsync: tester);
      final parent = TabController(length: 2, vsync: tester);
      addTearDown(inner.dispose);
      addTearDown(parent.dispose);
      await _pumpTabbedReports(tester, gateway, inner, parent);
      await tester.tap(byAppTooltip(action));
      await tester.pumpAndSettle();
      expect(find.byType(AppDialog), findsOneWidget);
      parent.index = 1;
      await tester.pumpAndSettle();
      expect(find.byType(AppDialog, skipOffstage: false), findsNothing);
      expect(gateway.updates, 0);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'explicit user filter sends one ID constraint and preserves search',
    (tester) async {
      final gateway = _ControlledContentReportsGateway();
      gateway.onList = (_) async => _page('Initial room');
      await _pumpReports(
        tester,
        gateway,
        reportsView: ContentReportsView(
          gateway: gateway,
          showTargetTypeTabs: false,
          initialSearch: 'spam',
        ),
      );
      await tester.tap(byAppTooltip('Report filters'));
      await tester.pumpAndSettle();
      final user = find.descendant(
        of: find.widgetWithText(AppTextField, 'Reported user ID'),
        matching: find.byType(TextField),
      );
      await tester.ensureVisible(user);
      await tester.enterText(user, '  usr_target  ');
      await tester.ensureVisible(find.text('Apply'));
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(gateway.queries, hasLength(2));
      final query = gateway.queries.last;
      expect(query.search, 'spam');
      expect(query.targetUserId, 'usr_target');
      expect(query.reporterUserId, isEmpty);
      expect(query.targetMemberUserId, isEmpty);
      expect(find.text('Reported user usr_target'), findsOneWidget);
      await tester.tap(find.text('Reported user usr_target'));
      await tester.pumpAndSettle();
      expect(gateway.queries.last.targetUserId, isEmpty);
      expect(gateway.queries.last.search, 'spam');
    },
  );

  testWidgets('resetting filter draft then cancelling preserves active scope', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    await _pumpReports(
      tester,
      gateway,
      reportsView: ContentReportsView(
        gateway: gateway,
        showTargetTypeTabs: false,
        initialReporterUserId: 'usr_context',
      ),
    );
    await tester.tap(byAppTooltip('Report filters'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Reset'));
    await tester.tap(find.text('Reset'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(gateway.queries, hasLength(1));
    expect(find.text('Reporter usr_context'), findsOneWidget);
    await tester.tap(byAppTooltip('Report filters'));
    await tester.pumpAndSettle();
    final reporter = tester.widget<AppTextField>(
      find.widgetWithText(AppTextField, 'Reporter user ID'),
    );
    expect(reporter.controller.text, 'usr_context');
    await tester.ensureVisible(find.text('Reset'));
    await tester.tap(find.text('Reset'));
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(gateway.queries.last.reporterUserId, isEmpty);
  });

  testWidgets(
    'source replacement dismisses filters and rejects retained apply',
    (tester) async {
      final old = _ControlledContentReportsGateway();
      final current = _ControlledContentReportsGateway();
      final source = ValueNotifier((
        gateway: old as ContentReportsGateway,
        room: '',
      ));
      addTearDown(source.dispose);
      await _pumpReportSource(tester, source);
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Report filters'));
      await tester.pumpAndSettle();
      final apply = tester
          .widgetList<AppActionButton>(find.byType(AppActionButton))
          .singleWhere((button) => button.label == 'Apply')
          .onPressed!;
      source.value = (gateway: current, room: '');
      await tester.pumpAndSettle();
      expect(
        find.byType(ReportFiltersDialog, skipOffstage: false),
        findsNothing,
      );
      apply();
      await tester.pumpAndSettle();
      expect(current.queries, hasLength(1));
      expect(current.queries.single.reporterUserId, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('text search and clearing preserve report context filters', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    gateway.onList = (_) async => _page('Initial room');
    await _pumpReports(
      tester,
      gateway,
      reportsView: ContentReportsView(
        gateway: gateway,
        showTargetTypeTabs: false,
        initialReporterUserId: 'usr_reporter',
        initialTargetUserId: 'usr_target',
        initialScope:
            admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_TARGET_USER,
        initialTargetType:
            admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_USER,
      ),
    );
    for (final search in ['spam', '']) {
      await tester.enterText(find.byType(TextField), search);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      final query = gateway.queries.last;
      expect(query.search, search);
      expect(query.reporterUserId, 'usr_reporter');
      expect(query.targetUserId, 'usr_target');
      expect(
        query.scope,
        admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_TARGET_USER,
      );
    }
  });

  for (final search in ['usr_example', 'room_example', '123']) {
    testWidgets(
      'literal search does not invent conflicting ID filters: $search',
      (tester) async {
        final gateway = _ControlledContentReportsGateway();
        await _pumpReports(tester, gateway);
        await tester.enterText(find.byType(TextField), search);
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        final query = gateway.queries.last;
        expect(query.search, search);
        expect(query.reporterUserId, isEmpty);
        expect(query.roomId, isEmpty);
        expect(query.targetRoomId, isEmpty);
        expect(query.targetUserId, isEmpty);
        expect(query.targetMemberRoomId, isEmpty);
        expect(query.targetMemberUserId, isEmpty);
        expect(query.targetChatMessageId, '0');
      },
    );
  }

  testWidgets('long report previews leave the row action reachable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final gateway = _ControlledContentReportsGateway();
    gateway.onList = (_) async => AdminContentReportsPage(
      reports: [
        _report(
          'Screening room',
          reason: List.filled(400, 'A long report reason.').join(' '),
        ),
      ],
      total: 1,
      page: 1,
      pageSize: 50,
    );
    await _pumpReports(tester, gateway);
    expect(tester.getSize(find.byType(AppTile).last).height, lessThan(568));
    await tester.ensureVisible(byAppTooltip('Resolve'));
    await tester.tap(byAppTooltip('Resolve'));
    await tester.pumpAndSettle();
    expect(find.byType(ReportDispositionDialog), findsOneWidget);
  });

  for (final language in ['en', 'zh']) {
    for (final width in [320.0, 1200.0]) {
      testWidgets(
        'report list and long details remain usable at $language/3x/$width',
        (tester) async {
          tester.view.physicalSize = Size(width, width == 320 ? 568 : 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final gateway = _ControlledContentReportsGateway();
          final report = _report(
            'Screening room',
            reason: List.filled(20, 'A detailed report reason.').join(' '),
            metadata: {
              'context': List.filled(80, 'long_metadata_value').join(),
            },
          );
          gateway.onList = (_) async => AdminContentReportsPage(
            reports: [report],
            total: 1,
            page: 1,
            pageSize: 50,
          );
          await _pumpReports(
            tester,
            gateway,
            locale: Locale(language),
            textScale: 3,
          );
          expect(tester.takeException(), isNull);
          await tester.scrollUntilVisible(
            find.byType(AppTile),
            200,
            scrollable: find
                .byWidgetPredicate(
                  (widget) =>
                      widget is Scrollable &&
                      widget.axisDirection == AxisDirection.down,
                )
                .first,
          );
          tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
          gateway.detail.complete(report);
          await tester.pumpAndSettle();
          final l10n = AppLocalizations.of(
            tester.element(find.byType(AppDialogFrame)),
          );
          await tester.ensureVisible(find.text(l10n.resolve));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final action = find.widgetWithText(AppActionButton, l10n.resolve);
          expect(tester.getRect(action).right, lessThanOrEqualTo(width));
          await tester.tap(action);
          await tester.pumpAndSettle();
          expect(find.byType(ReportDispositionDialog), findsOneWidget);
          await tester.ensureVisible(find.text(l10n.cancel));
          await tester.tap(find.text(l10n.cancel));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('pending report detail can be cancelled without a response', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    await _pumpReports(tester, gateway);
    tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
    await tester.pump();
    expect(byAppTooltip('Cancel'), findsOneWidget);
    await tester.tap(byAppTooltip('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AppLoadingIndicator), findsNothing);
    expect(
      tester.widget<AppTile>(find.byType(AppTile).last).onPressed,
      isNotNull,
    );
    await tester.tap(byAppTooltip('Resolve'));
    await tester.pumpAndSettle();
    expect(find.byType(ReportDispositionDialog), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  for (final failure in [false, true]) {
    testWidgets(
      'cancelled detail cannot complete or cancel a retry failure=$failure',
      (tester) async {
        final gateway = _ControlledContentReportsGateway();
        final original = gateway.detail;
        await _pumpReports(tester, gateway);
        tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
        await tester.pump();
        expect(byAppTooltip('Cancel'), findsOneWidget);
        final cancel = tester
            .widgetList<AppIconButton>(find.byType(AppIconButton))
            .singleWhere((button) => button.tooltip == 'Cancel')
            .onPressed!;
        await tester.tap(byAppTooltip('Cancel'));
        await tester.pumpAndSettle();
        gateway.detail = Completer<AdminContentReport>();
        tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
        await tester.pump();
        cancel();
        if (failure) {
          original.completeError(StateError('cancelled detail failed'));
        } else {
          original.complete(_report('Cancelled room'));
        }
        await tester.pump();
        expect(find.byType(AppDialogFrame), findsNothing);
        expect(find.byType(AppLoadingIndicator), findsOneWidget);
        expect(
          tester.widget<AppTile>(find.byType(AppTile).last).onPressed,
          isNull,
        );
        gateway.detail.complete(_report('Current room'));
        await tester.pumpAndSettle();
        expect(gateway.detailRequests, 2);
        expect(find.byType(AppDialogFrame), findsOneWidget);
        expect(find.textContaining('Cancelled room'), findsNothing);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('room target dropdown represents and restores all targets', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    final source = ValueNotifier((
      gateway: gateway as ContentReportsGateway,
      room: 'room',
    ));
    addTearDown(source.dispose);
    await _pumpReportSource(tester, source);
    await tester.pumpAndSettle();
    expect(find.text('All targets'), findsOneWidget);
    await tester.tap(find.text('All targets'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Members').last);
    await tester.pumpAndSettle();
    expect(
      gateway.queries.last.targetType,
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER,
    );
    await tester.tap(find.text('Members'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All targets').last);
    await tester.pumpAndSettle();
    expect(
      gateway.queries.last.targetType,
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    );
  });

  testWidgets(
    'unchanged source rebuild preserves search without another query',
    (tester) async {
      final gateway = _ControlledContentReportsGateway();
      gateway.onList = (_) async => _page('Initial room');
      final source = ValueNotifier((
        gateway: gateway as ContentReportsGateway,
        room: '',
      ));
      addTearDown(source.dispose);
      await _pumpReportSource(tester, source);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'retained search');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await _pumpReportSource(tester, source);
      await tester.pumpAndSettle();
      expect(gateway.queries, hasLength(2));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'retained search',
      );
    },
  );

  testWidgets(
    'source replacement closes disposition and its open status menu',
    (tester) async {
      final old = _ControlledContentReportsGateway();
      final current = _ControlledContentReportsGateway();
      final source = ValueNotifier((
        gateway: old as ContentReportsGateway,
        room: '',
      ));
      addTearDown(source.dispose);
      await _pumpReportSource(tester, source);
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Resolve'));
      await tester.pumpAndSettle();
      final save = tester
          .widgetList<AppActionButton>(find.byType(AppActionButton))
          .singleWhere((button) => button.label == 'Save')
          .onPressed!;
      await tester.tap(find.text('Reviewing'));
      await tester.pumpAndSettle();
      expect(find.text('Resolved'), findsOneWidget);
      source.value = (gateway: current, room: '');
      await tester.pumpAndSettle();
      expect(
        find.byType(ReportDispositionDialog, skipOffstage: false),
        findsNothing,
      );
      expect(find.text('Resolved'), findsNothing);
      save();
      await tester.pumpAndSettle();
      expect(old.updates, 0);
      expect(current.updates, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('retained report entry callbacks cannot act on a new source', (
    tester,
  ) async {
    final old = _ControlledContentReportsGateway();
    final current = _ControlledContentReportsGateway();
    final source = ValueNotifier((
      gateway: old as ContentReportsGateway,
      room: '',
    ));
    addTearDown(source.dispose);
    await _pumpReportSource(tester, source);
    await tester.pumpAndSettle();
    final detail = tester.widget<AppTile>(find.byType(AppTile).last).onPressed!;
    final resolve = tester
        .widgetList<AppIconButton>(find.byType(AppIconButton))
        .singleWhere((button) => button.tooltip == 'Resolve')
        .onPressed!;
    source.value = (gateway: current, room: '');
    await tester.pumpAndSettle();
    resolve();
    await tester.pumpAndSettle();
    expect(find.byType(ReportDispositionDialog), findsNothing);
    detail();
    await tester.pump();
    expect(current.detailRequests, 0);
    expect(old.detailRequests, 0);
  });

  for (final failure in [false, true]) {
    testWidgets(
      'source replacement ignores pending disposition failure=$failure',
      (tester) async {
        final old = _ControlledContentReportsGateway();
        final current = _ControlledContentReportsGateway();
        current.onList = (_) async => _page('Current room');
        final source = ValueNotifier((
          gateway: old as ContentReportsGateway,
          room: '',
        ));
        addTearDown(source.dispose);
        await _pumpReportSource(tester, source);
        await tester.pumpAndSettle();
        await tester.tap(byAppTooltip('Resolve'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Save'));
        await tester.pump();
        source.value = (gateway: current, room: '');
        await tester.pumpAndSettle();
        expect(find.byType(ReportDispositionDialog), findsNothing);
        if (failure) {
          old.update.completeError(StateError('obsolete mutation failure'));
        } else {
          old.update.complete(_report('Obsolete room'));
        }
        await tester.pumpAndSettle();
        expect(current.queries, hasLength(1));
        expect(find.textContaining('Current room'), findsOneWidget);
        expect(find.textContaining('Obsolete room'), findsNothing);
        expect(find.textContaining('obsolete mutation failure'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final injection in ['direct', 'scope', 'registry']) {
    testWidgets(
      'report source replacement reloads $injection and ignores old response',
      (tester) async {
        final old = _ControlledContentReportsGateway();
        final pending = Completer<AdminContentReportsPage>();
        old.onList = (_) => pending.future;
        final current = _ControlledContentReportsGateway();
        current.onList = (_) async => _page('Current room');
        final source = ValueNotifier((
          gateway: old as ContentReportsGateway,
          room: '',
        ));
        addTearDown(source.dispose);
        await _pumpReportSource(tester, source, injection: injection);
        source.value = (gateway: current, room: '');
        await tester.pumpAndSettle();
        expect(current.queries, hasLength(1));
        expect(find.textContaining('Current room'), findsOneWidget);
        pending.complete(_page('Obsolete room'));
        await tester.pumpAndSettle();
        expect(find.textContaining('Obsolete room'), findsNothing);
        expect(find.textContaining('Current room'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'room scope replacement clears old results and resets page and tabs',
    (tester) async {
      final gateway = _ControlledContentReportsGateway();
      final pending = Completer<AdminContentReportsPage>();
      gateway.onList = (query) => query.roomScopeId == 'next-room'
          ? pending.future
          : Future.value(
              AdminContentReportsPage(
                reports: [_report('Old room')],
                total: 51,
                page: query.page,
                pageSize: 50,
              ),
            );
      final source = ValueNotifier((
        gateway: gateway as ContentReportsGateway,
        room: '',
      ));
      addTearDown(source.dispose);
      await _pumpReportSource(tester, source, tabs: true);
      await tester.pumpAndSettle();
      tester.widget<AppPaginationBar>(find.byType(AppPaginationBar)).onNext!();
      await tester.pumpAndSettle();
      source.value = (gateway: gateway, room: 'next-room');
      await tester.pump();
      expect(gateway.queries.last.roomScopeId, 'next-room');
      expect(gateway.queries.last.roomId, 'next-room');
      expect(gateway.queries.last.page, 1);
      expect(find.textContaining('Old room'), findsNothing);
      pending.complete(_page('New room'));
      await tester.pumpAndSettle();
      expect(find.textContaining('New room'), findsOneWidget);
      source.value = (gateway: gateway, room: '');
      await tester.pumpAndSettle();
      expect(gateway.queries.last.roomScopeId, '');
      expect(tester.takeException(), isNull);
    },
  );

  for (final failure in [false, true]) {
    testWidgets(
      'old detail completion cannot open on a replacement source failure=$failure',
      (tester) async {
        final old = _ControlledContentReportsGateway();
        final current = _ControlledContentReportsGateway();
        current.onList = (_) async => _page('Current room');
        final source = ValueNotifier((
          gateway: old as ContentReportsGateway,
          room: '',
        ));
        addTearDown(source.dispose);
        await _pumpReportSource(tester, source);
        await tester.pumpAndSettle();
        tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
        await tester.pump();
        source.value = (gateway: current, room: '');
        await tester.pumpAndSettle();
        tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
        await tester.pump();
        if (failure) {
          old.detail.completeError(StateError('old detail failed'));
        } else {
          old.detail.complete(_report('Obsolete room'));
        }
        await tester.pump();
        expect(find.byType(AppDialogFrame), findsNothing);
        expect(current.detailRequests, 1);
        expect(
          tester.widget<AppTile>(find.byType(AppTile).last).onPressed,
          isNull,
        );
        current.detail.complete(_report('Current room'));
        await tester.pumpAndSettle();
        expect(find.byType(AppDialogFrame), findsOneWidget);
        expect(find.textContaining('Obsolete room'), findsNothing);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      },
    );
  }

  for (final details in [false, true]) {
    testWidgets(
      'source replacement removes only its owned dialog details=$details',
      (tester) async {
        final old = _ControlledContentReportsGateway();
        final current = _ControlledContentReportsGateway();
        final source = ValueNotifier((
          gateway: old as ContentReportsGateway,
          room: '',
        ));
        final navigator = GlobalKey<NavigatorState>();
        addTearDown(source.dispose);
        await _pumpReportSource(tester, source, navigator: navigator);
        await tester.pumpAndSettle();
        if (details) {
          tester.widget<AppTile>(find.byType(AppTile).last).onPressed!();
          old.detail.complete(_report('Initial room'));
        } else {
          await tester.tap(byAppTooltip('Resolve'));
        }
        await tester.pumpAndSettle();
        navigator.currentState!.push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Covering page')),
          ),
        );
        await tester.pumpAndSettle();
        source.value = (gateway: current, room: '');
        await tester.pumpAndSettle();
        expect(find.text('Covering page'), findsOneWidget);
        expect(
          find.byType(ReportDispositionDialog, skipOffstage: false),
          findsNothing,
        );
        expect(find.byType(AppDialogFrame, skipOffstage: false), findsNothing);
        navigator.currentState!.pop();
        await tester.pumpAndSettle();
        expect(find.byType(ContentReportsView), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('disposition reloads filtered reports and server total', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    final refreshed = Completer<AdminContentReportsPage>();
    gateway.onList = (query) => gateway.queries.length == 1
        ? Future.value(_page('Initial room'))
        : refreshed.future;
    await _pumpReports(tester, gateway);
    await tester.tap(byAppTooltip('Resolve'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    gateway.update.complete(_report('Initial room'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(gateway.queries, hasLength(2));
    expect(
      gateway.queries.last.status,
      admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN,
    );
    expect(find.byType(AppLinearProgress), findsOneWidget);
    refreshed.complete(
      const AdminContentReportsPage(
        reports: [],
        total: 0,
        page: 1,
        pageSize: 50,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Initial room'), findsNothing);
    expect(
      tester.widget<AppPaginationBar>(find.byType(AppPaginationBar)).label,
      contains('0 total'),
    );
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('disposition on the last page refetches the remaining page', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    gateway.onList = (query) async => AdminContentReportsPage(
      reports: gateway.updates == 0 || query.page == 1
          ? [_report(query.page == 1 ? 'First room' : 'Last room')]
          : [],
      total: gateway.updates == 0 ? 51 : 50,
      page: query.page,
      pageSize: query.pageSize,
    );
    await _pumpReports(tester, gateway);
    tester.widget<AppPaginationBar>(find.byType(AppPaginationBar)).onNext!();
    await tester.pumpAndSettle();
    expect(find.textContaining('Last room'), findsOneWidget);
    await tester.tap(byAppTooltip('Resolve'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    gateway.update.complete(_report('Last room'));
    await tester.pumpAndSettle();
    expect(gateway.queries.map((query) => query.page), [1, 2, 2, 1]);
    expect(find.textContaining('First room'), findsOneWidget);
    final pager = tester.widget<AppPaginationBar>(
      find.byType(AppPaginationBar),
    );
    expect(pager.onPrevious, isNull);
    expect(pager.onNext, isNull);
    expect(pager.label, contains('50 total'));
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('new search supersedes pending disposition refresh', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    final refreshed = Completer<AdminContentReportsPage>();
    gateway.onList = (query) => query.search == 'new'
        ? Future.value(_page('New room'))
        : gateway.queries.length == 1
        ? Future.value(_page('Initial room'))
        : refreshed.future;
    await _pumpReports(tester, gateway);
    await tester.tap(byAppTooltip('Resolve'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    gateway.update.complete(_report('Initial room'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(gateway.queries, hasLength(2));
    await tester.enterText(find.byType(TextField), 'new');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    refreshed.complete(_page('Stale room'));
    await tester.pumpAndSettle();
    expect(find.textContaining('New room'), findsOneWidget);
    expect(find.textContaining('Stale room'), findsNothing);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('report detail flow shares one lock with disposition', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    await _pumpReports(tester, gateway);
    final detail = tester.widget<AppTile>(find.byType(AppTile).last).onPressed!;
    final resolve = tester
        .widgetList<AppIconButton>(find.byType(AppIconButton))
        .singleWhere((button) => button.tooltip == 'Resolve')
        .onPressed!;
    detail();
    detail();
    detail();
    resolve();
    await tester.pump();
    expect(gateway.detailRequests, 1);
    expect(find.byType(ReportDispositionDialog), findsNothing);
    gateway.detail.complete(_report('Initial room'));
    await tester.pumpAndSettle();
    expect(find.byType(AppDialogFrame, skipOffstage: false), findsOneWidget);
    detail();
    resolve();
    await tester.pumpAndSettle();
    expect(gateway.detailRequests, 1);
    expect(find.byType(ReportDispositionDialog), findsNothing);
    await tester.tap(find.text('Resolve'));
    await tester.pumpAndSettle();
    expect(
      find.byType(ReportDispositionDialog, skipOffstage: false),
      findsOneWidget,
    );
    expect(find.byType(AppDialogFrame, skipOffstage: false), findsNothing);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    resolve();
    await tester.pumpAndSettle();
    expect(
      find.byType(ReportDispositionDialog, skipOffstage: false),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('direct disposition blocks repeated and detail entry', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    await _pumpReports(tester, gateway);
    final detail = tester.widget<AppTile>(find.byType(AppTile).last).onPressed!;
    final resolve = tester
        .widgetList<AppIconButton>(find.byType(AppIconButton))
        .singleWhere((button) => button.tooltip == 'Resolve')
        .onPressed!;
    resolve();
    resolve();
    resolve();
    detail();
    await tester.pumpAndSettle();
    expect(gateway.detailRequests, 0);
    expect(
      find.byType(ReportDispositionDialog, skipOffstage: false),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    detail();
    await tester.pump();
    expect(gateway.detailRequests, 1);
    gateway.detail.completeError(StateError('detail unavailable'));
    await tester.pumpAndSettle();
    expect(find.text('Report details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final failure in [false, true]) {
    testWidgets('covered page ignores late report details failure=$failure', (
      tester,
    ) async {
      final gateway = _ControlledContentReportsGateway();
      final navigator = GlobalKey<NavigatorState>();
      await _pumpReports(tester, gateway, navigator: navigator);
      final detail = tester
          .widget<AppTile>(find.byType(AppTile).last)
          .onPressed!;
      detail();
      await tester.pump();
      unawaited(
        navigator.currentState!.push<void>(
          MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Replacement page')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (failure) {
        gateway.detail.completeError(StateError('late details'));
      } else {
        gateway.detail.complete(_report('Initial room'));
      }
      await tester.pumpAndSettle();
      expect(find.text('Replacement page'), findsOneWidget);
      expect(find.byType(AppDialogFrame), findsNothing);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      detail();
      await tester.pumpAndSettle();
      expect(gateway.detailRequests, 2);
      expect(find.byType(AppDialogFrame), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('disposed report entry callbacks do not start work', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    await _pumpReports(tester, gateway);
    final detail = tester.widget<AppTile>(find.byType(AppTile).last).onPressed!;
    final resolve = tester
        .widgetList<AppIconButton>(find.byType(AppIconButton))
        .singleWhere((button) => button.tooltip == 'Resolve')
        .onPressed!;
    await tester.pumpWidget(const SizedBox.shrink());
    detail();
    resolve();
    await tester.pump();
    expect(gateway.detailRequests, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail resolve uses dialog navigator in nested navigation', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    gateway.detail.complete(_report('Initial room'));
    await _pumpReports(tester, gateway, nested: true);
    await tester.tap(find.textContaining('Initial room').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Resolve'));
    await tester.pumpAndSettle();
    expect(
      find.byType(ContentReportsView, skipOffstage: false),
      findsOneWidget,
    );
    expect(find.byType(AppDialogFrame, skipOffstage: false), findsNothing);
    expect(find.byType(ReportDispositionDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disposition locks fields and submits once', (tester) async {
    final gateway = _ControlledContentReportsGateway();
    await _pumpReports(tester, gateway);
    await tester.tap(byAppTooltip('Resolve'));
    await tester.pumpAndSettle();
    final save = tester
        .widgetList<AppActionButton>(find.byType(AppActionButton))
        .singleWhere((button) => button.label == 'Save')
        .onPressed!;
    save();
    save();
    await tester.pump();
    expect(gateway.updates, 1);
    final note = tester
        .widgetList<TextField>(find.byType(TextField))
        .singleWhere((field) => field.maxLines == 4);
    expect(note.enabled, isFalse);
    final status = tester.widget<AppSelect<admin_enum.ContentReportStatus>>(
      find.byType(AppSelect<admin_enum.ContentReportStatus>).last,
    );
    expect(status.onChanged, isNull);
    gateway.update.complete(_report('Initial room'));
    await tester.pumpAndSettle();
    expect(find.text('Resolve report'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('disposition error unlocks fields for retry', (tester) async {
    final gateway = _ControlledContentReportsGateway();
    await _pumpReports(tester, gateway);
    await tester.tap(byAppTooltip('Resolve'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pump();
    gateway.update.completeError(StateError('try again'));
    await tester.pumpAndSettle();
    expect(find.byType(ReportDispositionDialog), findsOneWidget);
    final note = tester
        .widgetList<TextField>(find.byType(TextField))
        .singleWhere((field) => field.maxLines == 4);
    expect(note.enabled, isTrue);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    gateway.update = Completer<AdminContentReport>();
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(gateway.updates, 2);
    gateway.update.complete(_report('Initial room'));
    await tester.pumpAndSettle();
    expect(find.byType(ReportDispositionDialog), findsNothing);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'zh']) {
    for (final width in [320.0, 1200.0]) {
      testWidgets('disposition 3x layout $locale at $width', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 700);
        addTearDown(tester.view.reset);
        final gateway = _ControlledContentReportsGateway();
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(3)),
              child: buildThemedTestApp(context, child),
            ),
            home: Builder(
              builder: (context) => Scaffold(
                body: AppActionButton(
                  label: 'Open',
                  onPressed: () => showAppDialog<AdminContentReport>(
                    context: context,
                    builder: (_) => ReportDispositionDialog(
                      gateway: gateway,
                      report: _report('Initial room'),
                      targetText: 'Initial room',
                      roomScopeId: 'room-scope',
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final l10n = AppLocalizations.of(
          tester.element(find.byType(ReportDispositionDialog)),
        );
        final select = find.byType(AppSelect<admin_enum.ContentReportStatus>);
        await tester.ensureVisible(select);
        await tester.tap(select);
        await tester.pumpAndSettle();
        final resolved = find.text(l10n.resolved).last;
        await tester.ensureVisible(resolved);
        await tester.tap(resolved);
        await tester.pumpAndSettle();
        final note = find.byType(TextField);
        await tester.ensureVisible(note);
        await tester.enterText(note, 'Reviewed note');
        final save = find.text(l10n.save);
        await tester.ensureVisible(save);
        await tester.tap(save);
        await tester.pump();
        expect(
          gateway.parameters?[#status],
          admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_RESOLVED,
        );
        expect(gateway.parameters?[#resolutionNote], 'Reviewed note');
        expect(gateway.parameters?[#roomScopeId], 'room-scope');
        gateway.update.complete(_report('Initial room'));
        await tester.pumpAndSettle();
        expect(find.byType(ReportDispositionDialog), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('disposition owns controller until closing transition ends', (
    tester,
  ) async {
    await _pumpReports(tester, _ControlledContentReportsGateway());
    await tester.tap(byAppTooltip('Resolve'));
    await tester.pumpAndSettle();
    final field = tester
        .widgetList<TextField>(find.byType(TextField))
        .singleWhere((field) => field.maxLines == 4);
    final controller = field.controller!;
    void listener() {}
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(() => controller.addListener(listener), returnsNormally);
    controller.removeListener(listener);
    await tester.pumpAndSettle();
    expect(() => controller.addListener(listener), throwsFlutterError);
    expect(tester.takeException(), isNull);
  });

  for (final failure in [false, true]) {
    testWidgets(
      'covered disposition does not affect current route failure=$failure',
      (tester) async {
        final gateway = _ControlledContentReportsGateway();
        final navigator = GlobalKey<NavigatorState>();
        await _pumpReports(tester, gateway, navigator: navigator);
        await tester.tap(byAppTooltip('Resolve'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Save'));
        await tester.pump();
        unawaited(
          navigator.currentState!.push<void>(
            MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Replacement page')),
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (failure) {
          gateway.update.completeError(StateError('covered request failed'));
        } else {
          gateway.update.complete(_report('Initial room'));
        }
        await tester.pumpAndSettle();
        expect(find.text('Replacement page'), findsOneWidget);
        expect(find.textContaining('covered request failed'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final failure in [false, true]) {
    testWidgets('cancelled disposition ignores late result, failure=$failure', (
      tester,
    ) async {
      final gateway = _ControlledContentReportsGateway();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: buildThemedTestApp,
          home: Scaffold(
            body: ContentReportsView(
              gateway: gateway,
              showTargetTypeTabs: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Resolve'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(gateway.updates, 1);
      final save = tester
          .widgetList<AppActionButton>(find.byType(AppActionButton))
          .singleWhere((item) => item.label == 'Save');
      expect(save.onPressed, isNull);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      if (failure) {
        gateway.update.completeError(StateError('late disposition failure'));
      } else {
        gateway.update.complete(_report('Updated room'));
      }
      await tester.pumpAndSettle();
      expect(find.byType(ContentReportsView), findsOneWidget);
      expect(find.textContaining('Initial room'), findsOneWidget);
      expect(find.textContaining('late disposition failure'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('latest report filter wins while existing results stay visible', (
    tester,
  ) async {
    final gateway = _ControlledContentReportsGateway();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: Scaffold(
          body: ContentReportsView(
            gateway: gateway,
            showTargetTypeTabs: false,
            initialTargetType: admin_enum
                .ContentReportTargetType
                .CONTENT_REPORT_TARGET_TYPE_ROOM,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Initial room'), findsOneWidget);

    final search = find.byType(TextField);
    await tester.enterText(search, 'old');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.textContaining('Initial room'), findsOneWidget);
    expect(find.byType(AppLinearProgress), findsOneWidget);

    await tester.enterText(search, 'new');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    gateway.newRequest.complete(_page('New room'));
    await tester.pump();
    expect(find.textContaining('New room'), findsOneWidget);

    gateway.oldRequest.complete(_page('Old room'));
    await tester.pump();
    expect(find.textContaining('New room'), findsOneWidget);
    expect(find.textContaining('Old room'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpReportSource(
  WidgetTester tester,
  ValueNotifier<({ContentReportsGateway gateway, String room})> source, {
  String injection = 'direct',
  bool tabs = false,
  GlobalKey<NavigatorState>? navigator,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: navigator,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: buildThemedTestApp,
      home: ValueListenableBuilder(
        valueListenable: source,
        builder: (_, value, _) {
          final page = Scaffold(
            body: ContentReportsView(
              gateway: injection == 'direct' ? value.gateway : null,
              roomScopedRoomId: value.room,
              showTargetTypeTabs: tabs,
            ),
          );
          return switch (injection) {
            'scope' => DependencyScope<ContentReportsGateway>(
              value: value.gateway,
              child: page,
            ),
            'registry' => DependencyRegistryScope(
              values: {ContentReportsGateway: value.gateway},
              child: page,
            ),
            _ => page,
          };
        },
      ),
    ),
  );
  await tester.pump();
}

Future<void> _pumpReports(
  WidgetTester tester,
  ContentReportsGateway gateway, {
  GlobalKey<NavigatorState>? navigator,
  bool nested = false,
  Locale locale = const Locale('en'),
  double textScale = 1,
  ContentReportsView? reportsView,
}) async {
  final page = Scaffold(
    body:
        reportsView ??
        ContentReportsView(gateway: gateway, showTargetTypeTabs: false),
  );
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: navigator,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => buildThemedTestApp(
        context,
        MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
      home: nested
          ? Navigator(
              onGenerateRoute: (_) =>
                  MaterialPageRoute<void>(builder: (_) => page),
            )
          : page,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpTabbedReports(
  WidgetTester tester,
  ContentReportsGateway gateway,
  TabController inner,
  TabController parent,
) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: buildThemedTestApp,
      home: Scaffold(
        body: AppTabBarView(
          controller: parent,
          children: [
            _KeepReportTab(
              child: AppTabBarView(
                controller: inner,
                children: [
                  _KeepReportTab(
                    child: ContentReportsView(
                      gateway: gateway,
                      showTargetTypeTabs: false,
                    ),
                  ),
                  const Center(child: Text('Other inner tab')),
                ],
              ),
            ),
            if (parent.length == 3) const Center(child: Text('Middle tab')),
            const Center(child: Text('Other outer tab')),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _KeepReportTab extends StatefulWidget {
  const _KeepReportTab({required this.child});
  final Widget child;
  @override
  State<_KeepReportTab> createState() => _KeepReportTabState();
}

class _KeepReportTabState extends State<_KeepReportTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

AdminContentReportsPage _page(String roomName) => AdminContentReportsPage(
  reports: [_report(roomName)],
  total: 1,
  page: 1,
  pageSize: 50,
);

AdminContentReport _report(
  String roomName, {
  String reason = 'Test report',
  Map<String, dynamic> metadata = const {},
}) => AdminContentReport(
  id: roomName,
  reporterUserId: 'reporter',
  reporterUsername: 'Reporter',
  roomId: '',
  roomName: '',
  targetType:
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_ROOM,
  targetRoomId: roomName,
  targetRoomName: roomName,
  targetUserId: '',
  targetUsername: '',
  targetMemberRoomId: '',
  targetMemberRoomName: '',
  targetMemberUserId: '',
  targetMemberUsername: '',
  targetChatMessageId: '0',
  targetChatMessageCreatedAt: 0,
  targetChatMessagePreview: '',
  reasonCode: 'test',
  reason: reason,
  metadata: metadata,
  status: admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN,
  reviewedBy: '',
  reviewedByUsername: '',
  reviewedAt: 0,
  resolutionNote: '',
  createdAt: 0,
  updatedAt: 0,
);

final class _ControlledContentReportsGateway implements ContentReportsGateway {
  var detail = Completer<AdminContentReport>();
  int detailRequests = 0;

  @override
  Future<AdminContentReport> get({
    required String reportId,
    String roomScopeId = '',
  }) {
    detailRequests++;
    return detail.future;
  }

  var update = Completer<AdminContentReport>();
  Map<Symbol, dynamic>? parameters;
  int updates = 0;
  final oldRequest = Completer<AdminContentReportsPage>();
  final newRequest = Completer<AdminContentReportsPage>();
  final queries = <ContentReportsQuery>[];
  Future<AdminContentReportsPage> Function(ContentReportsQuery)? onList;

  @override
  Future<AdminContentReportsPage> list(ContentReportsQuery query) {
    queries.add(query);
    if (onList != null) return onList!(query);
    return switch (query.search) {
      'old' => oldRequest.future,
      'new' => newRequest.future,
      _ => Future.value(_page('Initial room')),
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #updateStatus) {
      updates++;
      parameters = invocation.namedArguments;
      return update.future;
    }
    throw UnimplementedError('${invocation.memberName}');
  }
}
