class RoomStreamEntryInfo {
  final String mediaId;
  final bool active;
  final String publisherUserId;
  final int startedAt;

  const RoomStreamEntryInfo({
    required this.mediaId,
    required this.active,
    this.publisherUserId = '',
    this.startedAt = 0,
  });
}

class RoomStreamsPage {
  final List<RoomStreamEntryInfo> streams;
  final int total;
  final int page;
  final int pageSize;

  const RoomStreamsPage({
    required this.streams,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class RoomJoinReviewInfo {
  final String id;
  final String roomId;
  final String userId;
  final String username;
  final int requestedRole;
  final int status;
  final int requestedAt;
  final int reviewedAt;
  final String reviewedBy;
  final String rejectionReason;

  const RoomJoinReviewInfo({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.username,
    required this.requestedRole,
    required this.status,
    required this.requestedAt,
    required this.reviewedAt,
    required this.reviewedBy,
    required this.rejectionReason,
  });
}

class RoomJoinReviewsPage {
  final List<RoomJoinReviewInfo> reviews;
  final int total;
  final int page;
  final int pageSize;

  const RoomJoinReviewsPage({
    required this.reviews,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class RoomMembersPage {
  final List<AdminRoomMember> members;
  final int total;
  final int onlineCount;
  final int connectionCount;
  final int page;
  final int pageSize;
  final String version;

  const RoomMembersPage({
    required this.members,
    required this.total,
    this.onlineCount = 0,
    this.connectionCount = 0,
    required this.page,
    required this.pageSize,
    required this.version,
  });
}

enum RoomResourceWatchKind { observed, changed, error }

class RoomResourceWatchEvent<T> {
  final RoomResourceWatchKind kind;
  final String version;
  final bool changed;
  final T? snapshot;
  final String errorMessage;
  final int errorCode;

  const RoomResourceWatchEvent._({
    required this.kind,
    required this.version,
    required this.changed,
    this.snapshot,
    this.errorMessage = '',
    this.errorCode = 0,
  });

  factory RoomResourceWatchEvent.observed({
    required String version,
    required bool changed,
  }) {
    return RoomResourceWatchEvent._(
      kind: RoomResourceWatchKind.observed,
      version: version,
      changed: changed,
    );
  }

  factory RoomResourceWatchEvent.changed({
    required String version,
    T? snapshot,
  }) {
    return RoomResourceWatchEvent._(
      kind: RoomResourceWatchKind.changed,
      version: version,
      changed: true,
      snapshot: snapshot,
    );
  }

  factory RoomResourceWatchEvent.error({
    required String message,
    required int code,
  }) {
    return RoomResourceWatchEvent._(
      kind: RoomResourceWatchKind.error,
      version: '',
      changed: false,
      errorMessage: message,
      errorCode: code,
    );
  }
}

class IceServerInfo {
  final List<String> urls;
  final String username;
  final String credential;

  const IceServerInfo({
    required this.urls,
    required this.username,
    required this.credential,
  });
}

class AdminRoomMember {
  final String roomId;
  final String userId;
  final String username;
  final String remarkName;
  final String displayTag;
  final int role;
  final int permissions;
  final int addedPermissions;
  final int removedPermissions;
  final int adminAddedPermissions;
  final int adminRemovedPermissions;
  final int joinedAt;
  final bool isOnline;
  final int connectionCount;

  const AdminRoomMember({
    required this.roomId,
    required this.userId,
    required this.username,
    this.remarkName = '',
    this.displayTag = '',
    required this.role,
    required this.permissions,
    required this.addedPermissions,
    required this.removedPermissions,
    required this.adminAddedPermissions,
    required this.adminRemovedPermissions,
    required this.joinedAt,
    required this.isOnline,
    this.connectionCount = 0,
  });

  AdminRoomMember copyWith({
    String? roomId,
    String? userId,
    String? username,
    String? remarkName,
    String? displayTag,
    int? role,
    int? permissions,
    int? addedPermissions,
    int? removedPermissions,
    int? adminAddedPermissions,
    int? adminRemovedPermissions,
    int? joinedAt,
    bool? isOnline,
    int? connectionCount,
  }) {
    return AdminRoomMember(
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      remarkName: remarkName ?? this.remarkName,
      displayTag: displayTag ?? this.displayTag,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      addedPermissions: addedPermissions ?? this.addedPermissions,
      removedPermissions: removedPermissions ?? this.removedPermissions,
      adminAddedPermissions:
          adminAddedPermissions ?? this.adminAddedPermissions,
      adminRemovedPermissions:
          adminRemovedPermissions ?? this.adminRemovedPermissions,
      joinedAt: joinedAt ?? this.joinedAt,
      isOnline: isOnline ?? this.isOnline,
      connectionCount: connectionCount ?? this.connectionCount,
    );
  }
}

class AdminRoomMembersPage {
  final List<AdminRoomMember> members;
  final int total;
  final int onlineCount;
  final int connectionCount;

  const AdminRoomMembersPage({
    required this.members,
    required this.total,
    this.onlineCount = 0,
    this.connectionCount = 0,
  });
}
