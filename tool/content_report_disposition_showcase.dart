import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/content_reports/application/content_reports_gateway.dart';
import 'package:synctv_app/features/content_reports/presentation/content_reports_view.dart';
import 'package:synctv_app/features/content_reports/presentation/report_disposition_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          Uri.base.queryParameters.containsKey('long')
              ? 3
              : Uri.base.queryParameters.containsKey('list') ||
                    Uri.base.queryParameters.containsKey('source')
              ? 1
              : 3,
        ),
      ),
      child: child!,
    ),
    home: Uri.base.queryParameters.containsKey('source')
        ? const _SourceShowcase()
        : Uri.base.queryParameters.containsKey('list')
        ? const _ListShowcase()
        : const _Showcase(),
  ),
);

class _SourceShowcase extends StatefulWidget {
  const _SourceShowcase();

  @override
  State<_SourceShowcase> createState() => _SourceShowcaseState();
}

class _SourceShowcaseState extends State<_SourceShowcase> {
  final _original = _Gateway(roomName: 'Original room');
  final _replacement = _Gateway(roomName: 'Replacement room');
  bool _replaced = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _original.onDetail = () {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 500), _replace);
    };
  }

  void _replace() {
    if (mounted) setState(() => _replaced = true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _original.onDetail = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DependencyScope<ContentReportsGateway>(
    value: _replaced ? _replacement : _original,
    child: Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ContentReportsView(
              showTargetTypeTabs: false,
              roomScopedRoomId: _replaced
                  ? 'replacement-room'
                  : 'original-room',
            ),
          ),
          Text(_replaced ? 'Replacement source' : 'Original source'),
          AppActionButton(
            icon: Icons.timer_outlined,
            label: 'Switch source in 10 seconds',
            wrapLabel: true,
            onPressed: _replaced
                ? null
                : () {
                    _timer?.cancel();
                    _timer = Timer(const Duration(seconds: 10), _replace);
                  },
          ),
        ],
      ),
    ),
  );
}

class _ListShowcase extends StatefulWidget {
  const _ListShowcase();

  @override
  State<_ListShowcase> createState() => _ListShowcaseState();
}

class _ListShowcaseState extends State<_ListShowcase>
    with SingleTickerProviderStateMixin {
  final _gateway = _Gateway();
  late final TabController _tabs;
  Timer? _switchTimer;
  final _tabMode = Uri.base.queryParameters.containsKey('tabs');

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _gateway.onDetail = () {
      setState(() {});
      if (_tabMode) {
        _switchTimer?.cancel();
        _switchTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            _tabs.animateTo(2, duration: const Duration(seconds: 5));
          }
        });
      }
    };
  }

  @override
  void dispose() {
    _switchTimer?.cancel();
    _tabs.dispose();
    _gateway.onDetail = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        if (_tabMode)
          AppTabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: 'Reports'),
              Tab(text: 'Activity'),
              Tab(text: 'Other tab'),
            ],
          ),
        Expanded(
          child: _tabMode
              ? AppTabBarView(
                  controller: _tabs,
                  children: [
                    ContentReportsView(
                      gateway: _gateway,
                      showTargetTypeTabs: false,
                    ),
                    const Center(child: Text('Activity content')),
                    const Center(child: Text('Other tab content')),
                  ],
                )
              : ContentReportsView(
                  gateway: _gateway,
                  showTargetTypeTabs: false,
                ),
        ),
        Text('Detail requests: ${_gateway.detailRequests}'),
      ],
    ),
  );
}

class _Showcase extends StatefulWidget {
  const _Showcase();

  @override
  State<_Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<_Showcase> {
  final _gateway = _Gateway();
  int _saved = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppActionButton(
              label: 'Resolve report',
              wrapLabel: true,
              icon: Icons.rule_rounded,
              onPressed: () async {
                final result = await showAppDialog<AdminContentReport>(
                  context: context,
                  builder: (_) => ReportDispositionDialog(
                    gateway: _gateway,
                    report: _report,
                    targetText: 'Evening screening room',
                    roomScopeId: 'room-scope',
                  ),
                );
                if (mounted && result != null) setState(() => _saved++);
              },
            ),
            const SizedBox(height: 16),
            Text('Saved reports: $_saved'),
          ],
        ),
      ),
    ),
  );
}

class _Gateway implements ContentReportsGateway {
  _Gateway({this.roomName = 'Evening screening room'});

  final String roomName;
  int detailRequests = 0;
  VoidCallback? onDetail;
  late final _reports = Uri.base.queryParameters.containsKey('filters')
      ? [
          _makeReport(
            id: 'first',
            roomName: 'Evening screening room',
            roomId: 'room_evening',
            reporterUserId: 'usr_alex',
            reporterUsername: 'Alex',
          ),
          _makeReport(
            id: 'second',
            roomName: 'Weekend screening room',
            roomId: 'room_weekend',
            reporterUserId: 'usr_sam',
            reporterUsername: 'Sam',
          ),
        ]
      : Uri.base.queryParameters.containsKey('pages')
      ? List.generate(
          51,
          (index) => _makeReport(
            id: 'report-$index',
            roomName: 'Screening room ${index + 1}',
          ),
        )
      : [
          _makeReport(
            roomName: roomName,
            reason: Uri.base.queryParameters.containsKey('long')
                ? List.filled(20, 'A detailed report reason.').join(' ')
                : 'Test report',
            metadata: Uri.base.queryParameters.containsKey('long')
                ? {'context': List.filled(80, 'long_metadata_value').join()}
                : const {},
          ),
        ];

  @override
  Future<AdminContentReportsPage> list(ContentReportsQuery query) async {
    final reports = _reports
        .where(
          (report) =>
              (query.status ==
                      admin_enum
                          .ContentReportStatus
                          .CONTENT_REPORT_STATUS_UNSPECIFIED ||
                  report.status == query.status) &&
              (query.reporterUserId.isEmpty ||
                  report.reporterUserId == query.reporterUserId) &&
              report.targetRoomName.toLowerCase().contains(
                query.search.toLowerCase(),
              ),
        )
        .toList();
    return AdminContentReportsPage(
      reports: reports
          .skip((query.page - 1) * query.pageSize)
          .take(query.pageSize)
          .toList(),
      total: reports.length,
      page: query.page,
      pageSize: query.pageSize,
    );
  }

  @override
  Future<AdminContentReport> get({
    required String reportId,
    String roomScopeId = '',
  }) async {
    detailRequests++;
    onDetail?.call();
    if (Uri.base.queryParameters.containsKey('detail-pending')) {
      return Completer<AdminContentReport>().future;
    }
    await Future<void>.delayed(
      Duration(seconds: Uri.base.queryParameters.containsKey('source') ? 4 : 2),
    );
    return _reports.firstWhere((report) => report.id == reportId);
  }

  @override
  Future<AdminContentReport> updateStatus({
    required String reportId,
    required admin_enum.ContentReportStatus status,
    required String resolutionNote,
    String roomScopeId = '',
  }) async {
    if (Uri.base.queryParameters.containsKey('pending')) {
      return Completer<AdminContentReport>().future;
    }
    await Future<void>.delayed(const Duration(seconds: 2));
    final index = _reports.indexWhere((report) => report.id == reportId);
    return _reports[index] = _makeReport(
      id: reportId,
      roomName: _reports[index].targetRoomName,
      roomId: _reports[index].targetRoomId,
      reporterUserId: _reports[index].reporterUserId,
      reporterUsername: _reports[index].reporterUsername,
      reason: _reports[index].reason,
      metadata: _reports[index].metadata,
      status: status,
      resolutionNote: resolutionNote,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

final _report = _makeReport();

AdminContentReport _makeReport({
  String id = 'report',
  String roomName = 'Evening screening room',
  String roomId = 'room',
  String reporterUserId = 'reporter',
  String reporterUsername = 'Reporter',
  admin_enum.ContentReportStatus status =
      admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN,
  String resolutionNote = '',
  String reason = 'Test report',
  Map<String, dynamic> metadata = const {},
}) => AdminContentReport(
  id: id,
  reporterUserId: reporterUserId,
  reporterUsername: reporterUsername,
  roomId: '',
  roomName: '',
  targetType:
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_ROOM,
  targetRoomId: roomId,
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
  status: status,
  reviewedBy: '',
  reviewedByUsername: '',
  reviewedAt: 0,
  resolutionNote: resolutionNote,
  createdAt: 0,
  updatedAt: 0,
);
