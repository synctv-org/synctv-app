import 'package:synctv_app/models/watch_together_models.dart';

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

class AdminSystemStats {
  final int totalUsers;
  final int activeUsers;
  final int bannedUsers;
  final int totalRooms;
  final int activeRooms;
  final int bannedRooms;
  final int totalMedia;
  final int providerInstances;
  final Map<String, dynamic> additionalStats;

  const AdminSystemStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.bannedUsers,
    required this.totalRooms,
    required this.activeRooms,
    required this.bannedRooms,
    required this.totalMedia,
    required this.providerInstances,
    required this.additionalStats,
  });
}

class AdminSettingsGroup {
  final String name;
  final Map<String, dynamic> settings;

  const AdminSettingsGroup({
    required this.name,
    required this.settings,
  });
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

  const AdminActiveStreamsPage({
    required this.streams,
    required this.total,
  });
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
  final List<WUser> users;
  final int total;

  const AdminUsersPage({
    required this.users,
    required this.total,
  });
}

class AdminRoomsPage {
  final List<WRoom> rooms;
  final int total;

  const AdminRoomsPage({
    required this.rooms,
    required this.total,
  });
}

class AdminsPage {
  final List<WUser> admins;
  final int total;

  const AdminsPage({
    required this.admins,
    required this.total,
  });
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
  final bool oauth2EmailVerified;
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
    this.oauth2EmailVerified = false,
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
