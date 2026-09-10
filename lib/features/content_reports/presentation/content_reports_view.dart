import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_tab_activity.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/content_reports/application/content_reports_gateway.dart';
import 'package:synctv_app/features/content_reports/presentation/report_disposition_dialog.dart';
import 'package:synctv_app/features/content_reports/presentation/report_filters_dialog.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';

class ContentReportsView extends StatefulWidget {
  final ContentReportsGateway? gateway;
  final String? title;
  final admin_enum.ContentReportTargetType initialTargetType;
  final String initialReporterUserId;
  final String initialRoomId;
  final String initialTargetRoomId;
  final String initialTargetUserId;
  final String initialTargetMemberRoomId;
  final String initialTargetMemberUserId;
  final String initialTargetChatMessageId;
  final admin_enum.ContentReportScope initialScope;
  final String initialSearch;
  final bool showTargetTypeTabs;
  final String roomScopedRoomId;

  const ContentReportsView({
    super.key,
    this.gateway,
    this.title,
    this.initialTargetType = admin_enum
        .ContentReportTargetType
        .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    this.initialReporterUserId = '',
    this.initialRoomId = '',
    this.initialTargetRoomId = '',
    this.initialTargetUserId = '',
    this.initialTargetMemberRoomId = '',
    this.initialTargetMemberUserId = '',
    this.initialTargetChatMessageId = '0',
    this.initialScope =
        admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_UNSPECIFIED,
    this.initialSearch = '',
    this.showTargetTypeTabs = true,
    this.roomScopedRoomId = '',
  });

  Object get _queryConfiguration => (
    initialTargetType,
    initialReporterUserId,
    initialRoomId,
    initialTargetRoomId,
    initialTargetUserId,
    initialTargetMemberRoomId,
    initialTargetMemberUserId,
    initialTargetChatMessageId,
    initialScope,
    initialSearch,
    showTargetTypeTabs,
    roomScopedRoomId,
  );

  @override
  State<ContentReportsView> createState() => _ContentReportsViewState();
}

class _ContentReportsViewState extends State<ContentReportsView>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  admin_enum.ContentReportStatus _status =
      admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN;
  admin_enum.ContentReportTargetType _targetType =
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED;
  String _search = '';
  String _reporterUserId = '';
  String _roomId = '';
  String _targetRoomId = '';
  String _targetUserId = '';
  String _targetMemberRoomId = '';
  String _targetMemberUserId = '';
  String _targetChatMessageId = '0';
  admin_enum.ContentReportScope _scope =
      admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_UNSPECIFIED;
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  List<AdminContentReport> _reports = const [];
  final _searchController = TextEditingController();
  TabController? _targetTypeTabController;
  int _loadRevision = 0;
  String? _activeReportId;
  bool _loadingDetail = false;
  bool _filtersOpen = false;
  bool _tabActive = true;
  ContentReportsGateway? _sourceGateway;
  int _sourceRevision = 0;
  int _actionRevision = 0;
  ModalRoute<dynamic>? _reportDialog;

  static const _targetTypeTabs = <_ReportTargetTypeTab>[
    _ReportTargetTypeTab(
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    ),
    _ReportTargetTypeTab(
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_ROOM,
    ),
    _ReportTargetTypeTab(
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_USER,
    ),
    _ReportTargetTypeTab(
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER,
    ),
    _ReportTargetTypeTab(
      admin_enum
          .ContentReportTargetType
          .CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE,
    ),
  ];

  bool get _isRoomScoped => widget.roomScopedRoomId.isNotEmpty;

  ContentReportsGateway get _gateway => _sourceGateway!;

  @override
  void initState() {
    super.initState();
    _resetQuery();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final active = AppTabActivity.of(context);
    if (_tabActive && !active) {
      // Leaving any enclosing tab expires its pending actions and dialog drafts.
      _sourceRevision++;
      _actionRevision++;
      _dismissReportDialog();
      _activeReportId = null;
      _loadingDetail = false;
      _filtersOpen = false;
    }
    _tabActive = active;
    _syncSource();
  }

  @override
  void didUpdateWidget(ContentReportsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSource(
      reset: oldWidget._queryConfiguration != widget._queryConfiguration,
    );
  }

  void _syncSource({bool reset = false}) {
    final gateway =
        widget.gateway ?? DependencyScope.of<ContentReportsGateway>(context);
    if (!reset && identical(gateway, _sourceGateway)) return;
    if (_sourceGateway != null) _resetQuery();
    _sourceGateway = gateway;
    _sourceRevision++;
    _dismissReportDialog();
    _reports = const [];
    _total = 0;
    _activeReportId = null;
    _loadingDetail = false;
    _filtersOpen = false;
    _loadReports();
  }

  void _resetQuery() {
    _targetTypeTabController?.removeListener(_handleTargetTypeTabChanged);
    _targetTypeTabController?.dispose();
    _targetTypeTabController = null;
    _page = 1;
    _pageSize = 50;
    _status = admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN;
    _targetType = widget.initialTargetType;
    _reporterUserId = widget.initialReporterUserId;
    _roomId = _isRoomScoped ? widget.roomScopedRoomId : widget.initialRoomId;
    _targetRoomId = widget.initialTargetRoomId;
    _targetUserId = widget.initialTargetUserId;
    _targetMemberRoomId = widget.initialTargetMemberRoomId;
    _targetMemberUserId = widget.initialTargetMemberUserId;
    _targetChatMessageId = widget.initialTargetChatMessageId;
    _scope = widget.initialScope;
    _search = widget.initialSearch;
    _searchController.text = _search;
    if (widget.showTargetTypeTabs) {
      final visibleTabs = _visibleTargetTypeTabs;
      if (_targetType ==
          admin_enum
              .ContentReportTargetType
              .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED) {
        _targetType = visibleTabs.first.targetType;
      }
      final initialIndex = visibleTabs.indexWhere(
        (tab) => tab.targetType == _targetType,
      );
      if (initialIndex < 0) {
        _targetType = visibleTabs.first.targetType;
      }
      _targetTypeTabController = TabController(
        length: visibleTabs.length,
        initialIndex: initialIndex < 0 ? 0 : initialIndex,
        vsync: this,
      )..addListener(_handleTargetTypeTabChanged);
    }
  }

  @override
  void dispose() {
    _loadRevision++;
    _sourceRevision++;
    _dismissReportDialog();
    _targetTypeTabController?.removeListener(_handleTargetTypeTabChanged);
    _targetTypeTabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _sourceCurrent(int revision) =>
      mounted && _tabActive && revision == _sourceRevision;

  void _trackReportDialog(BuildContext dialogContext, int revision) {
    final route = ModalRoute.of(dialogContext);
    if (_sourceCurrent(revision)) {
      _reportDialog = route;
    } else {
      _removeReportDialog(route);
    }
  }

  void _dismissReportDialog() {
    final route = _reportDialog;
    _reportDialog = null;
    _removeReportDialog(route);
  }

  void _removeReportDialog(ModalRoute<dynamic>? route) {
    if (route == null) return;
    // Source changes can happen while Navigator is building or transitioning.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = route.navigator;
      if (navigator != null && navigator.mounted && route.isActive) {
        navigator.removeRoute(route);
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _handleTargetTypeTabChanged() {
    final controller = _targetTypeTabController;
    if (controller == null || controller.indexIsChanging) return;
    final next = _visibleTargetTypeTabs[controller.index].targetType;
    if (_targetType == next) return;
    setState(() {
      _targetType = next;
      _page = 1;
    });
    _loadReports();
  }

  Future<void> _loadReports() async {
    final revision = ++_loadRevision;
    setState(() => _isLoading = true);
    try {
      final data = await _gateway.list(
        ContentReportsQuery(
          roomScopeId: widget.roomScopedRoomId,
          page: _page,
          pageSize: _pageSize,
          status: _status,
          targetType: _targetType,
          reporterUserId: _reporterUserId,
          roomId: _roomId,
          targetRoomId: _targetRoomId,
          targetUserId: _targetUserId,
          targetMemberRoomId: _targetMemberRoomId,
          targetMemberUserId: _targetMemberUserId,
          targetChatMessageId: _targetChatMessageId,
          scope: _scope,
          search: _search,
        ),
      );
      if (!mounted || revision != _loadRevision) return;
      final lastPage = ((data.total + _pageSize - 1) ~/ _pageSize).clamp(
        1,
        1 << 31,
      );
      if (_page > lastPage) {
        setState(() {
          _page = lastPage;
          _total = data.total;
        });
        await _loadReports();
        return;
      }
      setState(() {
        _reports = data.reports;
        _total = data.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || revision != _loadRevision) return;
      setState(() => _isLoading = false);
      if (_reportPageCurrent) {
        AppNotifications.showError(
          context,
          context.l10n.loadReportsFailed('$e'),
        );
      }
    }
  }

  void _applySearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _page = 1;
    });
    _loadReports();
  }

  bool get _reportPageCurrent =>
      mounted && _tabActive && ModalRoute.of(context)?.isCurrent == true;

  Future<void> _runReportAction(
    String reportId,
    Future<void> Function() action,
  ) async {
    if (!_reportPageCurrent || _activeReportId != null || _filtersOpen) return;
    final revision = _sourceRevision;
    final actionRevision = ++_actionRevision;
    setState(() => _activeReportId = reportId);
    try {
      await action();
    } finally {
      if (_sourceCurrent(revision) && actionRevision == _actionRevision) {
        setState(() {
          _activeReportId = null;
          _loadingDetail = false;
        });
      }
    }
  }

  Future<void> _openReport(AdminContentReport report, int revision) async {
    if (!_sourceCurrent(revision)) return;
    await _runReportAction(report.id, () => _showReport(report));
  }

  Future<void> _showReport(AdminContentReport report) async {
    final revision = _sourceRevision;
    final actionRevision = _actionRevision;
    setState(() => _loadingDetail = true);
    AdminContentReport detail = report;
    try {
      detail = await _gateway.get(
        reportId: report.id,
        roomScopeId: widget.roomScopedRoomId,
      );
    } catch (_) {
      detail = report;
    }
    if (!mounted ||
        !_sourceCurrent(revision) ||
        actionRevision != _actionRevision ||
        !_reportPageCurrent) {
      return;
    }
    setState(() => _loadingDetail = false);
    final resolve = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.reportDetails,
      icon: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.red),
      content: Builder(
        builder: (dialogContext) {
          _trackReportDialog(dialogContext, revision);
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReportDetailRow(
                    label: dialogContext.l10n.status,
                    value: _reportStatusText(dialogContext, detail.status),
                  ),
                  _ReportDetailRow(
                    label: dialogContext.l10n.target,
                    value: _reportTargetText(dialogContext, detail),
                  ),
                  _ReportDetailRow(
                    label: dialogContext.l10n.reporter,
                    value: _reporterText(detail),
                  ),
                  _ReportDetailRow(
                    label: dialogContext.l10n.reason,
                    value: _reportReasonText(detail),
                  ),
                  if (detail.targetChatMessagePreview.isNotEmpty)
                    _ReportDetailRow(
                      label: dialogContext.l10n.messageContent,
                      value: detail.targetChatMessagePreview,
                    ),
                  _ReportDetailRow(
                    label: dialogContext.l10n.createdAt,
                    value: _formatTimestamp(detail.createdAt),
                  ),
                  if (detail.reviewedByUsername.isNotEmpty ||
                      detail.reviewedBy.isNotEmpty)
                    _ReportDetailRow(
                      label: dialogContext.l10n.reviewedByLabel,
                      value: detail.reviewedByUsername.isEmpty
                          ? detail.reviewedBy
                          : detail.reviewedByUsername,
                    ),
                  if (detail.reviewedAt > 0)
                    _ReportDetailRow(
                      label: dialogContext.l10n.reviewedAtLabel,
                      value: _formatTimestamp(detail.reviewedAt),
                    ),
                  if (detail.resolutionNote.isNotEmpty)
                    _ReportDetailRow(
                      label: dialogContext.l10n.resolutionNote,
                      value: detail.resolutionNote,
                    ),
                  if (detail.metadata.isNotEmpty)
                    _ReportDetailRow(
                      label: dialogContext.l10n.metadata,
                      value: const JsonEncoder.withIndent('  ')
                          .convert(detail.metadata),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        Builder(
          builder: (dialogContext) =>
              AppDialogs.createConfirmButton(dialogContext, () {
                if (_sourceCurrent(revision) &&
                    ModalRoute.of(dialogContext)?.isCurrent == true) {
                  Navigator.of(dialogContext).pop(true);
                }
              }, text: dialogContext.l10n.resolve),
        ),
      ],
    );
    if (!_sourceCurrent(revision)) return;
    _reportDialog = null;
    if (resolve == true && _reportPageCurrent) {
      await _showDisposition(detail);
    }
  }

  Future<void> _openDisposition(AdminContentReport report, int revision) async {
    if (!_sourceCurrent(revision)) return;
    await _runReportAction(report.id, () => _showDisposition(report));
  }

  void _cancelDetail(int revision, int actionRevision) {
    if (!_sourceCurrent(revision) ||
        !_reportPageCurrent ||
        !_loadingDetail ||
        actionRevision != _actionRevision) {
      return;
    }
    setState(() {
      _actionRevision++;
      _loadingDetail = false;
      _activeReportId = null;
    });
  }

  Future<void> _openFilters(int revision) async {
    if (!_sourceCurrent(revision) ||
        !_reportPageCurrent ||
        _activeReportId != null ||
        _filtersOpen) {
      return;
    }
    setState(() => _filtersOpen = true);
    ContentReportFilters? filters;
    try {
      filters = await showAppDialog<ContentReportFilters>(
        context: context,
        builder: (dialogContext) {
          _trackReportDialog(dialogContext, revision);
          return ReportFiltersDialog(
            initialFilters: ContentReportFilters(
              reporterUserId: _reporterUserId,
              roomId: _roomId,
              targetRoomId: _targetRoomId,
              targetUserId: _targetUserId,
              targetMemberRoomId: _targetMemberRoomId,
              targetMemberUserId: _targetMemberUserId,
              targetChatMessageId: _targetChatMessageId,
            ),
            roomScoped: _isRoomScoped,
            isSourceCurrent: () => _sourceCurrent(revision),
          );
        },
      );
    } finally {
      if (_sourceCurrent(revision)) {
        _reportDialog = null;
        setState(() => _filtersOpen = false);
      }
    }
    if (filters == null || !_sourceCurrent(revision) || !_reportPageCurrent) {
      return;
    }
    final selected = filters;
    setState(() {
      _reporterUserId = selected.reporterUserId;
      _roomId = selected.roomId;
      _targetRoomId = selected.targetRoomId;
      _targetUserId = selected.targetUserId;
      _targetMemberRoomId = selected.targetMemberRoomId;
      _targetMemberUserId = selected.targetMemberUserId;
      _targetChatMessageId = selected.targetChatMessageId;
      _page = 1;
    });
    await _loadReports();
  }

  Future<void> _showDisposition(AdminContentReport report) async {
    if (!mounted || !_reportPageCurrent) return;
    final revision = _sourceRevision;
    final gateway = _gateway;
    final targetText = _reportTargetText(context, report);
    final roomScopeId = widget.roomScopedRoomId;
    final updated = await showAppDialog<AdminContentReport>(
      context: context,
      builder: (dialogContext) {
        _trackReportDialog(dialogContext, revision);
        return ReportDispositionDialog(
          gateway: gateway,
          report: report,
          targetText: targetText,
          roomScopeId: roomScopeId,
          isSourceCurrent: () => _sourceCurrent(revision),
        );
      },
    );
    if (!_sourceCurrent(revision)) return;
    _reportDialog = null;
    if (updated == null || !mounted || !_reportPageCurrent) return;
    setState(() {
      _reports = [
        for (final item in _reports) item.id == updated.id ? updated : item,
      ];
    });
    AppNotifications.showSuccess(context, context.l10n.reportStatusUpdated);
    await _loadReports();
  }

  int get _pageCount {
    if (_total <= 0) return 1;
    return ((_total + _pageSize - 1) ~/ _pageSize).clamp(1, 1 << 31);
  }

  @override
  Widget build(BuildContext context) {
    final revision = _sourceRevision;
    final actionRevision = _actionRevision;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final title = widget.title ?? context.l10n.reports;
    final header = <Widget>[
      if (title.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(
            children: [
              Icon(
                Icons.report_gmailerrorred_rounded,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      if (widget.showTargetTypeTabs && _targetTypeTabController != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AppPanelSurface(
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.all(3),
              child: AppTabBar(
                controller: _targetTypeTabController!,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                tabs: [
                  for (final tab in _visibleTargetTypeTabs)
                    Tab(text: _reportTargetTypeLabel(context, tab.targetType)),
                ],
              ),
            ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppSelect<admin_enum.ContentReportStatus>(
              value: _status,
              options: {
                context.l10n.allStatuses: admin_enum
                    .ContentReportStatus
                    .CONTENT_REPORT_STATUS_UNSPECIFIED,
                context.l10n.reportOpenStatus:
                    admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN,
                context.l10n.reviewing: admin_enum
                    .ContentReportStatus
                    .CONTENT_REPORT_STATUS_REVIEWING,
                context.l10n.resolved: admin_enum
                    .ContentReportStatus
                    .CONTENT_REPORT_STATUS_RESOLVED,
                context.l10n.dismissed: admin_enum
                    .ContentReportStatus
                    .CONTENT_REPORT_STATUS_DISMISSED,
              },
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _status = value;
                  _page = 1;
                });
                _loadReports();
              },
            ),
            if (!widget.showTargetTypeTabs)
              AppSelect<admin_enum.ContentReportTargetType>(
                value: _targetType,
                options: _isRoomScoped
                    ? {
                        context.l10n.allTargets: admin_enum
                            .ContentReportTargetType
                            .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
                        context.l10n.members: admin_enum
                            .ContentReportTargetType
                            .CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER,
                        context.l10n.messages: admin_enum
                            .ContentReportTargetType
                            .CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE,
                      }
                    : {
                        context.l10n.allTargets: admin_enum
                            .ContentReportTargetType
                            .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
                        context.l10n.rooms: admin_enum
                            .ContentReportTargetType
                            .CONTENT_REPORT_TARGET_TYPE_ROOM,
                        context.l10n.users: admin_enum
                            .ContentReportTargetType
                            .CONTENT_REPORT_TARGET_TYPE_USER,
                        context.l10n.members: admin_enum
                            .ContentReportTargetType
                            .CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER,
                        context.l10n.messages: admin_enum
                            .ContentReportTargetType
                            .CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE,
                      },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _targetType = value;
                    _page = 1;
                  });
                  _loadReports();
                },
              ),
            AppSelect<int>(
              value: _pageSize,
              options: {
                context.l10n.itemsPerPage(20): 20,
                context.l10n.itemsPerPage(50): 50,
                context.l10n.itemsPerPage(100): 100,
              },
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _pageSize = value;
                  _page = 1;
                });
                _loadReports();
              },
            ),
            SizedBox(
              width: 300,
              child: AppSearchField(
                controller: _searchController,
                hintText: context.l10n.searchReportsHint,
                onChanged: (value) {
                  if (value.isEmpty && _search.isNotEmpty) {
                    _applySearch('');
                  }
                },
                onSubmitted: _applySearch,
              ),
            ),
            if (_search.isNotEmpty)
              AppChip(
                label: Text(_search),
                avatar: const Icon(Icons.close_rounded, size: 16),
                onPressed: () {
                  _searchController.clear();
                  _applySearch('');
                },
              ),
            ..._activeFilterChips(),
            AppIconButton(
              tooltip: context.l10n.reportFilters,
              icon: Icons.filter_list_rounded,
              onPressed: _activeReportId == null && !_filtersOpen
                  ? () => _openFilters(revision)
                  : null,
            ),
            AppIconButton(
              tooltip: context.l10n.refresh,
              icon: Icons.refresh_rounded,
              onPressed: _loadReports,
            ),
          ],
        ),
      ),
      _ContentReportPager(
        page: _page,
        pageSize: _pageSize,
        total: _total,
        onPrevious: _page <= 1
            ? null
            : () {
                setState(() => _page -= 1);
                _loadReports();
              },
        onNext: _page >= _pageCount
            ? null
            : () {
                setState(() => _page += 1);
                _loadReports();
              },
      ),
      SizedBox(
        height: 2,
        child: _isLoading && _reports.isNotEmpty
            ? const AppLinearProgress(minHeight: 2)
            : null,
      ),
    ];
    return CustomScrollView(
      slivers: [
        for (final child in header) SliverToBoxAdapter(child: child),
        if (_reports.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _isLoading
                ? const AppLoadingIndicator()
                : Center(
                    child: Text(
                      context.l10n.noReportRecords,
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                final loadingDetail =
                    _activeReportId == report.id && _loadingDetail;
                return _ContentReportCard(
                  isDark: isDark,
                  child: AppTile(
                    enabled: _activeReportId == null || loadingDetail,
                    onPressed: _activeReportId == null
                        ? () => _openReport(report, revision)
                        : null,
                    prefix: SizedBox.square(
                      dimension: 24,
                      child: loadingDetail
                          ? const AppLoadingIndicator(size: AppLoadingSize.sm)
                          : Icon(
                              _reportStatusIcon(report.status),
                              color: _reportStatusColor(report.status),
                            ),
                    ),
                    title: Text(
                      _reportTargetText(context, report),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      context.l10n.reportListSummary(
                        _reportReasonText(report),
                        _reporterText(report),
                        _formatTimestamp(report.createdAt),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    suffix: AppIconButton(
                      style: loadingDetail
                          ? AppIconButtonStyle.tonal
                          : AppIconButtonStyle.ghost,
                      tooltip: loadingDetail
                          ? context.l10n.cancel
                          : context.l10n.resolve,
                      icon: loadingDetail
                          ? Icons.close_rounded
                          : Icons.rule_rounded,
                      onPressed: loadingDetail
                          ? () => _cancelDetail(revision, actionRevision)
                          : _activeReportId == null
                          ? () => _openDisposition(report, revision)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  List<Widget> _activeFilterChips() {
    final chips = <Widget>[];
    void addChip(String label, VoidCallback onClear) {
      chips.add(
        AppChip(
          label: Text(label),
          avatar: const Icon(Icons.close_rounded, size: 16),
          onPressed: () {
            setState(() {
              onClear();
              _page = 1;
            });
            _loadReports();
          },
        ),
      );
    }

    if (_reporterUserId.isNotEmpty) {
      addChip(
        context.l10n.reporterFilter(_reporterUserId),
        () => _reporterUserId = '',
      );
    }
    if (!_isRoomScoped && _roomId.isNotEmpty) {
      addChip(context.l10n.contextRoomFilter(_roomId), () => _roomId = '');
    }
    if (_targetRoomId.isNotEmpty) {
      addChip(
        context.l10n.reportedRoomFilter(_targetRoomId),
        () => _targetRoomId = '',
      );
    }
    if (_targetUserId.isNotEmpty) {
      addChip(
        context.l10n.reportedUserFilter(_targetUserId),
        () => _targetUserId = '',
      );
    }
    if (_targetMemberRoomId.isNotEmpty) {
      addChip(
        context.l10n.memberRoomFilter(_targetMemberRoomId),
        () => _targetMemberRoomId = '',
      );
    }
    if (_targetMemberUserId.isNotEmpty) {
      addChip(
        context.l10n.reportedMemberFilter(_targetMemberUserId),
        () => _targetMemberUserId = '',
      );
    }
    if (_targetChatMessageId != '0') {
      addChip(
        context.l10n.messageFilter(_targetChatMessageId),
        () => _targetChatMessageId = '0',
      );
    }
    return chips;
  }

  List<_ReportTargetTypeTab> get _visibleTargetTypeTabs {
    if (_isRoomScoped) {
      return _targetTypeTabs
          .where(
            (tab) =>
                tab.targetType ==
                    admin_enum
                        .ContentReportTargetType
                        .CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER ||
                tab.targetType ==
                    admin_enum
                        .ContentReportTargetType
                        .CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE,
          )
          .toList(growable: false);
    }
    if (widget.initialTargetType ==
            admin_enum
                .ContentReportTargetType
                .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED &&
        widget.initialReporterUserId.isEmpty &&
        widget.initialRoomId.isEmpty &&
        widget.initialTargetRoomId.isEmpty &&
        widget.initialTargetUserId.isEmpty &&
        widget.initialTargetMemberRoomId.isEmpty &&
        widget.initialTargetMemberUserId.isEmpty &&
        widget.initialTargetChatMessageId == '0' &&
        widget.initialScope ==
            admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_UNSPECIFIED &&
        widget.initialSearch.isEmpty) {
      return _targetTypeTabs.skip(1).toList(growable: false);
    }
    if (widget.initialScope ==
        admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_ROOM_CONTEXT) {
      return _targetTypeTabs
          .where(
            (tab) =>
                tab.targetType ==
                    admin_enum
                        .ContentReportTargetType
                        .CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER ||
                tab.targetType ==
                    admin_enum
                        .ContentReportTargetType
                        .CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE,
          )
          .toList(growable: false);
    }
    return _targetTypeTabs;
  }
}

class _ReportTargetTypeTab {
  final admin_enum.ContentReportTargetType targetType;

  const _ReportTargetTypeTab(this.targetType);
}

class _ReportDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReportDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          AppSelectableText(value.isEmpty ? '-' : value),
        ],
      ),
    );
  }
}

String _reportTargetTypeLabel(
  BuildContext context,
  admin_enum.ContentReportTargetType targetType,
) {
  return switch (targetType) {
    admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED =>
      context.l10n.allTargets,
    admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_ROOM =>
      context.l10n.rooms,
    admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_USER =>
      context.l10n.users,
    admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER =>
      context.l10n.members,
    admin_enum
        .ContentReportTargetType
        .CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE =>
      context.l10n.messages,
    _ => context.l10n.unknown,
  };
}

String _reportTargetText(BuildContext context, AdminContentReport report) {
  switch (report.targetType) {
    case admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_ROOM:
      return context.l10n.roomTarget(
        _nameOrId(report.targetRoomName, report.targetRoomId),
      );
    case admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_USER:
      return context.l10n.userTarget(
        _nameOrId(report.targetUsername, report.targetUserId),
      );
    case admin_enum
        .ContentReportTargetType
        .CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER:
      final room = _nameOrId(
        report.targetMemberRoomName,
        report.targetMemberRoomId,
      );
      final user = _nameOrId(
        report.targetMemberUsername,
        report.targetMemberUserId,
      );
      return context.l10n.memberTarget(user, room);
    case admin_enum
        .ContentReportTargetType
        .CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE:
      final room = _nameOrId(report.roomName, report.roomId);
      return context.l10n.chatMessageTarget(report.targetChatMessageId, room);
    default:
      return context.l10n.unknownTarget(report.id);
  }
}

String _reporterText(AdminContentReport report) {
  return _nameOrId(report.reporterUsername, report.reporterUserId);
}

String _reportReasonText(AdminContentReport report) {
  if (report.reason.isEmpty) return report.reasonCode;
  if (report.reasonCode.isEmpty) return report.reason;
  return '${report.reasonCode}: ${report.reason}';
}

String _nameOrId(String name, String id) {
  if (name.isEmpty) return id;
  if (id.isEmpty) return name;
  return '$name ($id)';
}

String _reportStatusText(
  BuildContext context,
  admin_enum.ContentReportStatus status,
) {
  switch (status) {
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN:
      return context.l10n.reportOpenStatus;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_REVIEWING:
      return context.l10n.reviewing;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_RESOLVED:
      return context.l10n.resolved;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_DISMISSED:
      return context.l10n.dismissed;
    default:
      return context.l10n.unknown;
  }
}

IconData _reportStatusIcon(admin_enum.ContentReportStatus status) {
  switch (status) {
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN:
      return Icons.error_outline_rounded;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_REVIEWING:
      return Icons.pending_actions_rounded;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_RESOLVED:
      return Icons.check_circle_outline_rounded;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_DISMISSED:
      return Icons.cancel_outlined;
    default:
      return Icons.help_outline_rounded;
  }
}

Color _reportStatusColor(admin_enum.ContentReportStatus status) {
  switch (status) {
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN:
      return Colors.red;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_REVIEWING:
      return Colors.orange;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_RESOLVED:
      return Colors.green;
    case admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_DISMISSED:
      return Colors.grey;
    default:
      return Colors.blueGrey;
  }
}

class _ContentReportCard extends StatelessWidget {
  const _ContentReportCard({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }
}

class _ContentReportPager extends StatelessWidget {
  const _ContentReportPager({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  final int page;
  final int pageSize;
  final int total;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return AppPaginationBar(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      label: context.l10n.pageSizeTotalSummary(page, pageSize, total),
      onPrevious: onPrevious,
      onNext: onNext,
    );
  }
}

String _formatTimestamp(int timestamp) {
  if (timestamp <= 0) return "-";
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return "${date.year.toString().padLeft(4, "0")}-"
      "${date.month.toString().padLeft(2, "0")}-"
      "${date.day.toString().padLeft(2, "0")} "
      "${date.hour.toString().padLeft(2, "0")}:"
      "${date.minute.toString().padLeft(2, "0")}";
}
