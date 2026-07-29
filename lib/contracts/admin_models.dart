import 'package:synctv_app/contracts/synctv_models.dart';

class AdminProviderInstance {
  final String name;
  final String endpoint;
  final String comment;
  final int timeoutSeconds;
  final bool tls;
  final bool insecureTls;
  final List<String> providers;
  final bool enabled;
  final int status;
  final int createdAt;
  final int updatedAt;

  const AdminProviderInstance({
    required this.name,
    required this.endpoint,
    required this.comment,
    required this.timeoutSeconds,
    required this.tls,
    required this.insecureTls,
    required this.providers,
    required this.enabled,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

class AdminServiceState {
  final int totalUsers;
  final int activeUsers;
  final int bannedUsers;
  final int totalRooms;
  final int activeRooms;
  final int bannedRooms;
  final int totalMedia;
  final int providerInstances;
  final int onlineUsers;
  final int onlineConnections;
  final int activePresenceRooms;
  final int activeStreams;
  final int openReports;

  const AdminServiceState({
    required this.totalUsers,
    required this.activeUsers,
    required this.bannedUsers,
    required this.totalRooms,
    required this.activeRooms,
    required this.bannedRooms,
    required this.totalMedia,
    required this.providerInstances,
    this.onlineUsers = 0,
    this.onlineConnections = 0,
    this.activePresenceRooms = 0,
    required this.activeStreams,
    required this.openReports,
  });
}

class RuntimeSettingsSection {
  final String name;
  final Map<String, dynamic> settings;

  const RuntimeSettingsSection({required this.name, required this.settings});

  RuntimeSettingsSection copyWith({Map<String, dynamic>? settings}) {
    return RuntimeSettingsSection(
      name: name,
      settings: settings ?? this.settings,
    );
  }
}

class RuntimeSettingsModel {
  final List<RuntimeSettingsSection> sections;

  const RuntimeSettingsModel({required this.sections});

  RuntimeSettingsSection? section(String name) {
    for (final section in sections) {
      if (section.name == name) return section;
    }
    return null;
  }

  RuntimeSettingsModel replaceSection(RuntimeSettingsSection next) {
    return RuntimeSettingsModel(
      sections: [
        for (final section in sections)
          section.name == next.name ? next : section,
      ],
    );
  }
}

class AdminActiveStream {
  final String roomId;
  final String mediaId;
  final String userId;
  final String nodeId;
  final int startedAt;

  const AdminActiveStream({
    required this.roomId,
    required this.mediaId,
    required this.userId,
    required this.nodeId,
    required this.startedAt,
  });
}

class AdminActiveStreamsPage {
  final List<AdminActiveStream> streams;
  final int total;

  const AdminActiveStreamsPage({required this.streams, required this.total});
}

class AdminProviderInstancesPage {
  final List<AdminProviderInstance> instances;
  final int total;

  const AdminProviderInstancesPage({
    required this.instances,
    required this.total,
  });
}

class AdminBanRecord {
  final String id;
  final int targetType;
  final String userId;
  final String username;
  final String roomId;
  final String roomName;
  final String bannedBy;
  final String bannedByUsername;
  final String reason;
  final int startsAt;
  final int endsAt;
  final int revokedAt;
  final String revokedBy;
  final bool isActive;

  const AdminBanRecord({
    required this.id,
    required this.targetType,
    required this.userId,
    required this.username,
    required this.roomId,
    required this.roomName,
    required this.bannedBy,
    required this.bannedByUsername,
    required this.reason,
    required this.startsAt,
    required this.endsAt,
    required this.revokedAt,
    required this.revokedBy,
    required this.isActive,
  });
}

class AdminUsersPage {
  final List<SyncTvUser> users;
  final int total;

  const AdminUsersPage({required this.users, required this.total});
}

class AdminRoomsPage {
  final List<SyncTvRoom> rooms;
  final int total;

  const AdminRoomsPage({required this.rooms, required this.total});
}

class AdminsPage {
  final List<SyncTvUser> admins;
  final int total;

  const AdminsPage({required this.admins, required this.total});
}

class AdminBanRecordsPage {
  final List<AdminBanRecord> records;
  final int total;
  final int page;
  final int pageSize;

  const AdminBanRecordsPage({
    required this.records,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class AdminContentReport {
  final String id;
  final String reporterUserId;
  final String reporterUsername;
  final String roomId;
  final String roomName;
  final int targetType;
  final String targetRoomId;
  final String targetRoomName;
  final String targetUserId;
  final String targetUsername;
  final String targetMemberRoomId;
  final String targetMemberRoomName;
  final String targetMemberUserId;
  final String targetMemberUsername;
  final int targetChatMessageId;
  final int targetChatMessageCreatedAt;
  final String targetChatMessagePreview;
  final String reasonCode;
  final String reason;
  final Map<String, dynamic> metadata;
  final int status;
  final String reviewedBy;
  final String reviewedByUsername;
  final int reviewedAt;
  final String resolutionNote;
  final int createdAt;
  final int updatedAt;

  const AdminContentReport({
    required this.id,
    required this.reporterUserId,
    required this.reporterUsername,
    required this.roomId,
    required this.roomName,
    required this.targetType,
    required this.targetRoomId,
    required this.targetRoomName,
    required this.targetUserId,
    required this.targetUsername,
    required this.targetMemberRoomId,
    required this.targetMemberRoomName,
    required this.targetMemberUserId,
    required this.targetMemberUsername,
    required this.targetChatMessageId,
    required this.targetChatMessageCreatedAt,
    required this.targetChatMessagePreview,
    required this.reasonCode,
    required this.reason,
    required this.metadata,
    required this.status,
    required this.reviewedBy,
    required this.reviewedByUsername,
    required this.reviewedAt,
    required this.resolutionNote,
    required this.createdAt,
    required this.updatedAt,
  });
}

class AdminContentReportsPage {
  final List<AdminContentReport> reports;
  final int total;
  final int page;
  final int pageSize;

  const AdminContentReportsPage({
    required this.reports,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class AdminReviewItem {
  final String kind;
  final String id;
  final String title;
  final String subtitle;
  final String detail;
  final List<String> details;
  final int status;
  final int requestedAt;
  final int reviewedAt;
  final String reviewedBy;
  final String rejectionReason;
  final int signupMethod;
  final String oauth2Provider;
  final String oauth2ProviderInstanceName;
  final String oauth2ProviderIssuer;
  final String oauth2ProviderUserId;
  final String oauth2ProviderUsername;
  final String oauth2AvatarUrl;
  final String webauthnCredentialId;
  final String webauthnCredentialName;

  const AdminReviewItem({
    required this.kind,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.detail,
    this.details = const [],
    required this.status,
    required this.requestedAt,
    required this.reviewedAt,
    required this.reviewedBy,
    required this.rejectionReason,
    this.signupMethod = 0,
    this.oauth2Provider = '',
    this.oauth2ProviderInstanceName = '',
    this.oauth2ProviderIssuer = '',
    this.oauth2ProviderUserId = '',
    this.oauth2ProviderUsername = '',
    this.oauth2AvatarUrl = '',
    this.webauthnCredentialId = '',
    this.webauthnCredentialName = '',
  });
}

class AdminReviewsPage {
  final List<AdminReviewItem> reviews;
  final int total;
  final int page;
  final int pageSize;

  const AdminReviewsPage({
    required this.reviews,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class AdminBatchResult {
  final String id;
  final bool success;
  final String error;

  const AdminBatchResult({
    required this.id,
    required this.success,
    required this.error,
  });
}

class AdminBatchOperationResult {
  final List<AdminBatchResult> results;
  final int succeeded;
  final int failed;

  const AdminBatchOperationResult({
    required this.results,
    required this.succeeded,
    required this.failed,
  });
}
