import 'package:synctv_app/contracts/admin_models.dart';

final class ContentReportsQuery {
  const ContentReportsQuery({
    this.roomScopeId = '',
    this.page = 1,
    this.pageSize = 50,
    this.status = 0,
    this.targetType = 0,
    this.reporterUserId = '',
    this.roomId = '',
    this.targetRoomId = '',
    this.targetUserId = '',
    this.targetMemberRoomId = '',
    this.targetMemberUserId = '',
    this.targetChatMessageId = 0,
    this.scope = 0,
    this.search = '',
  });

  final String roomScopeId;
  final int page;
  final int pageSize;
  final int status;
  final int targetType;
  final String reporterUserId;
  final String roomId;
  final String targetRoomId;
  final String targetUserId;
  final String targetMemberRoomId;
  final String targetMemberUserId;
  final int targetChatMessageId;
  final int scope;
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
    required int status,
    required String resolutionNote,
    String roomScopeId = '',
  });
}
