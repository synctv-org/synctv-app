import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/content_reports/application/content_reports_gateway.dart';
import 'package:synctv_app/features/content_reports/presentation/content_reports_view.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;

import '../../../test_app.dart';

void main() {
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

AdminContentReportsPage _page(String roomName) => AdminContentReportsPage(
  reports: [_report(roomName)],
  total: 1,
  page: 1,
  pageSize: 50,
);

AdminContentReport _report(String roomName) => AdminContentReport(
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
  targetChatMessageId: 0,
  targetChatMessageCreatedAt: 0,
  targetChatMessagePreview: '',
  reasonCode: 'test',
  reason: 'Test report',
  metadata: const {},
  status: admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN,
  reviewedBy: '',
  reviewedByUsername: '',
  reviewedAt: 0,
  resolutionNote: '',
  createdAt: 0,
  updatedAt: 0,
);

final class _ControlledContentReportsGateway implements ContentReportsGateway {
  final oldRequest = Completer<AdminContentReportsPage>();
  final newRequest = Completer<AdminContentReportsPage>();

  @override
  Future<AdminContentReportsPage> list(ContentReportsQuery query) {
    return switch (query.search) {
      'old' => oldRequest.future,
      'new' => newRequest.future,
      _ => Future.value(_page('Initial room')),
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
