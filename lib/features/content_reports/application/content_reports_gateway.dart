import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;

final class ContentReportsQuery {
  const ContentReportsQuery({
    this.roomScopeId = '',
    this.page = 1,
    this.pageSize = 50,
    this.status =
        admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_UNSPECIFIED,
    this.targetType = admin_enum
        .ContentReportTargetType
        .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    this.reporterUserId = '',
    this.roomId = '',
    this.targetRoomId = '',
    this.targetUserId = '',
    this.targetMemberRoomId = '',
    this.targetMemberUserId = '',
    this.targetChatMessageId = 0,
    this.scope = admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_UNSPECIFIED,
    this.search = '',
  });

  final String roomScopeId;
  final int page;
  final int pageSize;
  final admin_enum.ContentReportStatus status;
  final admin_enum.ContentReportTargetType targetType;
  final String reporterUserId;
  final String roomId;
  final String targetRoomId;
  final String targetUserId;
  final String targetMemberRoomId;
  final String targetMemberUserId;
  final int targetChatMessageId;
  final admin_enum.ContentReportScope scope;
  final String search;
}

abstract interface class ContentReportsGateway {
  Future<AdminContentReportsPage> list(ContentReportsQuery query);

  Future<AdminContentReport> get({
    required String reportId,
    String roomScopeId = '',
  });

  Future<AdminContentReport> updateStatus({
    required String reportId,
    required admin_enum.ContentReportStatus status,
    required String resolutionNote,
    String roomScopeId = '',
  });
}
