import 'package:synctv_app/features/content_reports/application/content_reports_gateway.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';

final class SyncTvContentReportsGateway implements ContentReportsGateway {
  const SyncTvContentReportsGateway();

  @override
  Future<AdminContentReportsPage> list(ContentReportsQuery query) {
    if (query.roomScopeId.isNotEmpty) {
      return SyncTvService.listRoomContentReportsPage(
        query.roomScopeId,
        page: query.page,
        pageSize: query.pageSize,
        status: query.status,
        targetType: query.targetType,
        targetMemberUserId: query.targetMemberUserId,
        targetChatMessageId: query.targetChatMessageId,
        search: query.search,
      );
    }
    return SyncTvService.adminListContentReportsPage(
      page: query.page,
      pageSize: query.pageSize,
      status: query.status,
      targetType: query.targetType,
      reporterUserId: query.reporterUserId,
      roomId: query.roomId,
      targetRoomId: query.targetRoomId,
      targetUserId: query.targetUserId,
      targetMemberRoomId: query.targetMemberRoomId,
      targetMemberUserId: query.targetMemberUserId,
      targetChatMessageId: query.targetChatMessageId,
      scope: query.scope,
      search: query.search,
    );
  }

  @override
  Future<AdminContentReport> get({
    required String reportId,
    String roomScopeId = '',
  }) {
    if (roomScopeId.isNotEmpty) {
      return SyncTvService.getRoomContentReport(roomScopeId, reportId);
    }
    return SyncTvService.adminGetContentReport(reportId);
  }

  @override
  Future<AdminContentReport> updateStatus({
    required String reportId,
    required int status,
    required String resolutionNote,
    String roomScopeId = '',
  }) {
    if (roomScopeId.isNotEmpty) {
      return SyncTvService.updateRoomContentReportStatus(
        roomScopeId,
        reportId,
        status,
        resolutionNote: resolutionNote,
      );
    }
    return SyncTvService.adminUpdateContentReportStatus(
      reportId,
      status,
      resolutionNote: resolutionNote,
    );
  }
}
