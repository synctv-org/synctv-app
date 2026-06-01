import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';

import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class SyncTvFileUploadException implements Exception {
  final String message;

  const SyncTvFileUploadException(this.message);

  @override
  String toString() => message;
}

class LocalImageUpload {
  const LocalImageUpload({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    this.width = 0,
    this.height = 0,
  });

  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final int width;
  final int height;

  int get sizeBytes => bytes.length;
  String get checksumSha256 => sha256.convert(bytes).toString();
  List<int> get metadata => utf8.encode(jsonEncode({
        'file_name': fileName,
      }));
}

class _OwnershipProofRange {
  const _OwnershipProofRange({
    required this.offset,
    required this.length,
  });

  final int offset;
  final int length;
}

class SyncTvFileUploadDomainService {
  SyncTvFileUploadDomainService(this._api);

  final SyncTvApiClient _api;

  Future<client.ChatImage> uploadChatImage(
    String roomId,
    LocalImageUpload upload,
  ) async {
    _validateImageUpload(
      upload,
      maxSizeBytes: 20 * 1024 * 1024,
      allowAnyImageMime: true,
    );
    final response = await _createUploadSession(
      () => _api.room.createChatImageUploadSession(
        roomId,
        client.CreateChatImageUploadSessionRequest(
          clientImageId: _clientObjectId(upload),
          mimeType: upload.mimeType,
          sizeBytes: Int64(upload.sizeBytes),
          width: upload.width,
          height: upload.height,
          checksumSha256: upload.checksumSha256,
          metadata: upload.metadata,
        ),
      ),
    );
    final session = response.session;
    if (session.uploadRequired) {
      await _uploadSessionObject(
        uploadUrl: session.uploadUrl,
        headers: session.uploadHeaders,
        upload: upload,
      );
    }
    _attachOwnershipProofToChatImage(
      upload: upload,
      session: session,
      image: session.image,
    );
    return session.image;
  }

  Future<client.User> updateUserAvatar(LocalImageUpload upload) async {
    _validateImageUpload(upload, maxSizeBytes: 5 * 1024 * 1024);
    final response = await _createUploadSession(
      () => _api.user.createUserAvatarUploadSession(
        client.CreateUserAvatarUploadSessionRequest(
          clientAvatarId: _clientObjectId(upload),
          mimeType: upload.mimeType,
          sizeBytes: Int64(upload.sizeBytes),
          width: upload.width,
          height: upload.height,
          checksumSha256: upload.checksumSha256,
          metadata: upload.metadata,
        ),
      ),
    );
    final session = response.session;
    if (session.uploadRequired) {
      await _uploadSessionObject(
        uploadUrl: session.uploadUrl,
        headers: session.uploadHeaders,
        upload: upload,
      );
    }
    _attachOwnershipProofToUserAvatar(
      upload: upload,
      session: session,
      avatar: session.avatar,
    );
    final updated = await _api.user.updateUserAvatar(
      client.UpdateUserAvatarRequest(avatar: session.avatar),
    );
    return updated.user;
  }

  Future<client.User> clearUserAvatar() async {
    final response =
        await _api.user.clearUserAvatar(client.ClearUserAvatarRequest());
    return response.user;
  }

  Future<client.Room> updateRoomCover(
    String roomId,
    LocalImageUpload upload,
  ) async {
    _validateImageUpload(upload, maxSizeBytes: 10 * 1024 * 1024);
    final response = await _createUploadSession(
      () => _api.room.createRoomCoverUploadSession(
        roomId,
        client.CreateRoomCoverUploadSessionRequest(
          roomId: roomId,
          clientCoverId: _clientObjectId(upload),
          mimeType: upload.mimeType,
          sizeBytes: Int64(upload.sizeBytes),
          width: upload.width,
          height: upload.height,
          checksumSha256: upload.checksumSha256,
          metadata: upload.metadata,
        ),
      ),
    );
    final session = response.session;
    if (session.uploadRequired) {
      await _uploadSessionObject(
        uploadUrl: session.uploadUrl,
        headers: session.uploadHeaders,
        upload: upload,
      );
    }
    _attachOwnershipProofToRoomCover(
      upload: upload,
      session: session,
      cover: session.cover,
    );
    final updated = await _api.room.updateRoomCover(
      roomId,
      client.UpdateRoomCoverRequest(roomId: roomId, cover: session.cover),
    );
    return updated.room;
  }

  Future<client.Room> clearRoomCover(String roomId) async {
    final response = await _api.room.clearRoomCover(
      roomId,
      client.ClearRoomCoverRequest(roomId: roomId),
    );
    return response.room;
  }

  Future<client.Playlist> updatePlaylistCover(
    String roomId,
    String playlistId,
    LocalImageUpload upload,
  ) async {
    _validateImageUpload(upload, maxSizeBytes: 10 * 1024 * 1024);
    final response = await _createUploadSession(
      () => _api.room.createPlaylistCoverUploadSession(
        roomId,
        client.CreatePlaylistCoverUploadSessionRequest(
          roomId: roomId,
          playlistId: playlistId,
          clientCoverId: _clientObjectId(upload),
          mimeType: upload.mimeType,
          sizeBytes: Int64(upload.sizeBytes),
          width: upload.width,
          height: upload.height,
          checksumSha256: upload.checksumSha256,
          metadata: upload.metadata,
        ),
      ),
    );
    final session = response.session;
    if (session.uploadRequired) {
      await _uploadSessionObject(
        uploadUrl: session.uploadUrl,
        headers: session.uploadHeaders,
        upload: upload,
      );
    }
    _attachOwnershipProofToPlaylistCover(
      upload: upload,
      session: session,
      cover: session.cover,
    );
    final updated = await _api.room.updatePlaylistCover(
      roomId,
      client.UpdatePlaylistCoverRequest(
        roomId: roomId,
        playlistId: playlistId,
        cover: session.cover,
      ),
    );
    return updated.playlist;
  }

  Future<client.Playlist> clearPlaylistCover(
    String roomId,
    String playlistId,
  ) async {
    final response = await _api.room.clearPlaylistCover(
      roomId,
      client.ClearPlaylistCoverRequest(roomId: roomId, playlistId: playlistId),
    );
    return response.playlist;
  }

  Future<client.Media> updateVideoCover(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  ) async {
    _validateImageUpload(upload, maxSizeBytes: 10 * 1024 * 1024);
    final response = await _createUploadSession(
      () => _api.room.createVideoCoverUploadSession(
        roomId,
        client.CreateVideoCoverUploadSessionRequest(
          roomId: roomId,
          mediaId: mediaId,
          clientCoverId: _clientObjectId(upload),
          mimeType: upload.mimeType,
          sizeBytes: Int64(upload.sizeBytes),
          width: upload.width,
          height: upload.height,
          checksumSha256: upload.checksumSha256,
          metadata: upload.metadata,
        ),
      ),
    );
    final session = response.session;
    if (session.uploadRequired) {
      await _uploadSessionObject(
        uploadUrl: session.uploadUrl,
        headers: session.uploadHeaders,
        upload: upload,
      );
    }
    _attachOwnershipProofToVideoCover(
      upload: upload,
      session: session,
      cover: session.cover,
    );
    final updated = await _api.room.updateVideoCover(
      roomId,
      client.UpdateVideoCoverRequest(
        roomId: roomId,
        mediaId: mediaId,
        cover: session.cover,
      ),
    );
    return updated.media;
  }

  Future<client.Media> clearVideoCover(String roomId, String mediaId) async {
    final response = await _api.room.clearVideoCover(
      roomId,
      client.ClearVideoCoverRequest(roomId: roomId, mediaId: mediaId),
    );
    return response.media;
  }

  Future<void> _uploadSessionObject({
    required String uploadUrl,
    required Map<String, String> headers,
    required LocalImageUpload upload,
  }) {
    return _api.uploadRawBytes(
      uploadUrl,
      upload.bytes,
      contentType: upload.mimeType,
      headers: headers,
    );
  }

  Future<T> _createUploadSession<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on SyncTvApiException catch (error) {
      throw SyncTvFileUploadException(_uploadSessionErrorMessage(error));
    }
  }

  void _validateImageUpload(
    LocalImageUpload upload, {
    required int maxSizeBytes,
    bool allowAnyImageMime = false,
  }) {
    if (upload.bytes.isEmpty) {
      throw const SyncTvFileUploadException('图片为空，请重新选择。');
    }
    if (upload.sizeBytes > maxSizeBytes) {
      throw SyncTvFileUploadException(
        '图片不能超过 ${_formatBytes(maxSizeBytes)}，请压缩后再上传。',
      );
    }
    if (!_isSupportedImageMimeType(
      upload.mimeType,
      allowAnyImageMime: allowAnyImageMime,
    )) {
      throw const SyncTvFileUploadException(
        '图片格式暂不支持，请选择 JPEG、PNG、WebP 或 AVIF。',
      );
    }
  }

  bool _isSupportedImageMimeType(
    String mimeType, {
    required bool allowAnyImageMime,
  }) {
    if (allowAnyImageMime && mimeType.toLowerCase().startsWith('image/')) {
      return true;
    }
    return switch (mimeType.toLowerCase()) {
      'image/jpeg' || 'image/png' || 'image/webp' || 'image/avif' => true,
      _ => false,
    };
  }

  String _uploadSessionErrorMessage(SyncTvApiException error) {
    final message = error.message.toLowerCase();
    if (error.statusCode == 400 && message.contains('mime_type')) {
      return '图片格式暂不支持，请选择 JPEG、PNG、WebP 或 AVIF。';
    }
    if (error.statusCode == 400 && message.contains('file size')) {
      return '图片大小超过服务器限制，请压缩后再上传。';
    }
    if (error.statusCode == 400 &&
        (message.contains('request data') ||
            message.contains('deserialize') ||
            message.contains('json'))) {
      return '图片上传参数异常，请重新选择图片后再试。';
    }
    if (error.statusCode == 413) {
      return '图片大小超过服务器限制，请压缩后再上传。';
    }
    if (error.statusCode == 401) {
      return '登录状态已失效，请重新登录后再上传。';
    }
    if (error.statusCode == 403) {
      return '当前账号没有上传此图片的权限。';
    }
    return '创建图片上传会话失败：${error.message}';
  }

  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      final value = bytes / (1024 * 1024);
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} MB';
    }
    if (bytes >= 1024) {
      final value = bytes / 1024;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} KB';
    }
    return '$bytes B';
  }

  String _clientObjectId(LocalImageUpload upload) {
    final safeName = upload.fileName
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final name = safeName.isEmpty ? 'image' : safeName;
    return '${upload.checksumSha256}-$name';
  }

  void _attachOwnershipProofToChatImage({
    required LocalImageUpload upload,
    required client.ChatImageUploadSession session,
    required client.ChatImage image,
  }) {
    final proof = _ownershipProof(
      upload: upload,
      required: session.ownershipProofRequired,
      metadataKey: session.ownershipProofMetadataKey,
      nonce: session.ownershipProofNonce,
      ranges: session.ownershipProofRanges
          .map((range) => _OwnershipProofRange(
                offset: range.offset.toInt(),
                length: range.length,
              ))
          .toList(growable: false),
    );
    if (proof == null) return;
    image.metadata = _metadataWithOwnershipProof(image.metadata, proof);
  }

  void _attachOwnershipProofToUserAvatar({
    required LocalImageUpload upload,
    required client.UserAvatarUploadSession session,
    required client.UserAvatar avatar,
  }) {
    final proof = _ownershipProof(
      upload: upload,
      required: session.ownershipProofRequired,
      metadataKey: session.ownershipProofMetadataKey,
      nonce: session.ownershipProofNonce,
      ranges: session.ownershipProofRanges
          .map((range) => _OwnershipProofRange(
                offset: range.offset.toInt(),
                length: range.length,
              ))
          .toList(growable: false),
    );
    if (proof == null) return;
    avatar.metadata = _metadataWithOwnershipProof(avatar.metadata, proof);
  }

  void _attachOwnershipProofToRoomCover({
    required LocalImageUpload upload,
    required client.RoomCoverUploadSession session,
    required client.FileCover cover,
  }) {
    final proof = _ownershipProof(
      upload: upload,
      required: session.ownershipProofRequired,
      metadataKey: session.ownershipProofMetadataKey,
      nonce: session.ownershipProofNonce,
      ranges: session.ownershipProofRanges
          .map((range) => _OwnershipProofRange(
                offset: range.offset.toInt(),
                length: range.length,
              ))
          .toList(growable: false),
    );
    if (proof == null) return;
    cover.metadata = _metadataWithOwnershipProof(cover.metadata, proof);
  }

  void _attachOwnershipProofToPlaylistCover({
    required LocalImageUpload upload,
    required client.PlaylistCoverUploadSession session,
    required client.FileCover cover,
  }) {
    final proof = _ownershipProof(
      upload: upload,
      required: session.ownershipProofRequired,
      metadataKey: session.ownershipProofMetadataKey,
      nonce: session.ownershipProofNonce,
      ranges: session.ownershipProofRanges
          .map((range) => _OwnershipProofRange(
                offset: range.offset.toInt(),
                length: range.length,
              ))
          .toList(growable: false),
    );
    if (proof == null) return;
    cover.metadata = _metadataWithOwnershipProof(cover.metadata, proof);
  }

  void _attachOwnershipProofToVideoCover({
    required LocalImageUpload upload,
    required client.VideoCoverUploadSession session,
    required client.VideoCover cover,
  }) {
    final proof = _ownershipProof(
      upload: upload,
      required: session.ownershipProofRequired,
      metadataKey: session.ownershipProofMetadataKey,
      nonce: session.ownershipProofNonce,
      ranges: session.ownershipProofRanges
          .map((range) => _OwnershipProofRange(
                offset: range.offset.toInt(),
                length: range.length,
              ))
          .toList(growable: false),
    );
    if (proof == null) return;
    cover.metadata = _metadataWithOwnershipProof(cover.metadata, proof);
  }

  MapEntry<String, String>? _ownershipProof({
    required LocalImageUpload upload,
    required bool required,
    required String metadataKey,
    required String nonce,
    required List<_OwnershipProofRange> ranges,
  }) {
    if (!required) return null;
    if (metadataKey.trim().isEmpty || nonce.trim().isEmpty) {
      throw const SyncTvFileUploadException('图片上传会话缺少所有权验证信息，请重新选择图片。');
    }
    final proofBytes = BytesBuilder();
    proofBytes.add(utf8.encode('synctv-file-ownership-proof-v1'));
    proofBytes.add([0]);
    proofBytes.add(utf8.encode(nonce));
    for (final range in ranges) {
      if (range.offset < 0 || range.length <= 0) {
        throw const SyncTvFileUploadException('图片上传会话包含无效验证范围，请重新选择图片。');
      }
      final end = range.offset + range.length;
      if (end > upload.bytes.length) {
        throw const SyncTvFileUploadException('图片上传会话验证范围超出文件大小，请重新选择图片。');
      }
      proofBytes.add(_int64ToBigEndian(range.offset));
      proofBytes.add(_int32ToBigEndian(range.length));
      proofBytes.add(Uint8List.sublistView(upload.bytes, range.offset, end));
    }

    final digest = sha256.convert(proofBytes.toBytes()).toString();
    return MapEntry(metadataKey, digest);
  }

  List<int> _metadataWithOwnershipProof(
    List<int> metadata,
    MapEntry<String, String> proof,
  ) {
    final value = _decodeMetadata(metadata);
    value[proof.key] = proof.value;
    return utf8.encode(jsonEncode(value));
  }

  Map<String, dynamic> _decodeMetadata(List<int> metadata) {
    if (metadata.isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(utf8.decode(metadata));
      if (decoded is Map<String, dynamic>) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      // Fall through and replace malformed optional metadata with proof metadata.
    }
    return <String, dynamic>{};
  }

  List<int> _int64ToBigEndian(int value) {
    final data = ByteData(8)..setInt64(0, value, Endian.big);
    return data.buffer.asUint8List();
  }

  List<int> _int32ToBigEndian(int value) {
    final data = ByteData(4)..setInt32(0, value, Endian.big);
    return data.buffer.asUint8List();
  }
}
