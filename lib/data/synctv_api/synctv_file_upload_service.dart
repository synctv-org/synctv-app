import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;

import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class SyncTvFileUploadException implements Exception {
  final String message;

  const SyncTvFileUploadException(this.message);

  @override
  String toString() => message;
}

client.FileMetadata _imageMetadata(LocalImageUpload upload) {
  return client.FileMetadata(
    width: upload.width == 0 ? null : upload.width,
    height: upload.height == 0 ? null : upload.height,
  );
}

class _OwnershipProofRange {
  const _OwnershipProofRange({required this.offset, required this.length});

  final int offset;
  final int length;
}

class _UploadSessionResult<TSession> {
  const _UploadSessionResult({
    required this.plan,
    required this.session,
    required this.manifestParts,
    required this.contentManifestSha256,
  });

  final client.FileUploadPlan plan;
  final TSession session;
  final List<client.FileUploadManifestPart> manifestParts;
  final String contentManifestSha256;
}

class _UploadedPart {
  const _UploadedPart({
    required this.part,
    required this.checksumSha256,
    required this.etag,
  });

  final client.FileUploadManifestPart part;
  final String checksumSha256;
  final String etag;
}

class SyncTvFileUploadDomainService {
  SyncTvFileUploadDomainService(this._api);

  final SyncTvApiClient _api;

  Future<client.ChatAttachmentReference> uploadChatImage(
    String roomId,
    LocalImageUpload upload,
  ) async {
    _validateImageUpload(
      upload,
      maxSizeBytes: 20 * 1024 * 1024,
      allowAnyImageMime: true,
    );
    final result =
        await _createUploadSession<
          client.ChatAttachmentUploadSession,
          client.CreateChatAttachmentUploadSessionResponse
        >(
          upload: upload,
          createRequest: (parts) => _api.room.createChatAttachmentUploadSession(
            roomId,
            client.CreateChatAttachmentUploadSessionRequest(
              clientAttachmentId: _clientObjectId(upload),
              mimeType: upload.mimeType,
              sizeBytes: Int64(upload.sizeBytes),
              width: upload.width,
              height: upload.height,
              parts: parts,
              metadata: _imageMetadata(upload),
              filename: upload.fileName,
            ),
          ),
          planOf: (response) => response.plan,
          sessionOf: (response) => response.session,
          hasPlan: (response) => response.hasPlan(),
          hasSession: (response) => response.hasSession(),
        );
    final session = result.session;
    final uploadedParts = await _uploadSessionParts(
      upload: upload,
      sessionUploadRequired: session.uploadRequired,
      uploadUrl: session.uploadUrl,
      uploadHeaders: session.uploadHeaders,
      partUrls: session.partUrls,
      manifestParts: result.manifestParts,
    );
    final complete = await _api.room.completeChatAttachmentUploadSession(
      client.CompleteChatAttachmentUploadSessionRequest(
        roomId: roomId,
        encodedObjectKey: session.encodedObjectKey,
        token: session.uploadToken,
        uploadId: session.uploadId,
        parts: uploadedParts.map(_completePart),
        fileId: session.attachmentReference.id,
        ownershipProof: _ownershipProof(
          upload: upload,
          required: session.ownershipProofRequired,
          nonce: session.ownershipProofNonce,
          contentManifestSha256: result.contentManifestSha256,
          ranges: session.ownershipProofRanges
              .map(
                (range) => _OwnershipProofRange(
                  offset: range.offset.toInt(),
                  length: range.length,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
    if (!complete.complete) {
      throw const SyncTvFileUploadException('图片上传尚未完成，请稍后重试。');
    }
    return session.attachmentReference;
  }

  Future<client.User> updateUserAvatar(LocalImageUpload upload) async {
    _validateImageUpload(upload, maxSizeBytes: 5 * 1024 * 1024);
    final result =
        await _createUploadSession<
          client.UserAvatarUploadSession,
          client.CreateUserAvatarUploadSessionResponse
        >(
          upload: upload,
          createRequest: (parts) => _api.user.createUserAvatarUploadSession(
            client.CreateUserAvatarUploadSessionRequest(
              clientAvatarId: _clientObjectId(upload),
              mimeType: upload.mimeType,
              sizeBytes: Int64(upload.sizeBytes),
              width: upload.width,
              height: upload.height,
              parts: parts,
              metadata: _imageMetadata(upload),
            ),
          ),
          planOf: (response) => response.plan,
          sessionOf: (response) => response.session,
          hasPlan: (response) => response.hasPlan(),
          hasSession: (response) => response.hasSession(),
        );
    final session = result.session;
    final uploadedParts = await _uploadSessionParts(
      upload: upload,
      sessionUploadRequired: session.uploadRequired,
      uploadUrl: session.uploadUrl,
      uploadHeaders: session.uploadHeaders,
      partUrls: session.partUrls,
      manifestParts: result.manifestParts,
    );
    final complete = await _api.user.completeUserAvatarUploadSession(
      client.CompleteUserAvatarUploadSessionRequest(
        encodedObjectKey: session.encodedObjectKey,
        token: session.uploadToken,
        uploadId: session.uploadId,
        parts: uploadedParts.map(_completePart),
        fileId: session.avatarReference.id,
        ownershipProof: _ownershipProof(
          upload: upload,
          required: session.ownershipProofRequired,
          nonce: session.ownershipProofNonce,
          contentManifestSha256: result.contentManifestSha256,
          ranges: session.ownershipProofRanges
              .map(
                (range) => _OwnershipProofRange(
                  offset: range.offset.toInt(),
                  length: range.length,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
    if (!complete.complete) {
      throw const SyncTvFileUploadException('头像上传尚未完成，请稍后重试。');
    }
    final updated = await _api.user.updateUserAvatar(
      client.UpdateUserAvatarRequest(avatarReference: session.avatarReference),
    );
    return updated;
  }

  Future<client.User> clearUserAvatar() async {
    final response = await _api.user.clearUserAvatar(
      client.ClearUserAvatarRequest(),
    );
    return response;
  }

  Future<client.Room> updateRoomCover(
    String roomId,
    LocalImageUpload upload,
  ) async {
    _validateImageUpload(upload, maxSizeBytes: 10 * 1024 * 1024);
    final result =
        await _createUploadSession<
          client.RoomCoverUploadSession,
          client.CreateRoomCoverUploadSessionResponse
        >(
          upload: upload,
          createRequest: (parts) => _api.room.createRoomCoverUploadSession(
            roomId,
            client.CreateRoomCoverUploadSessionRequest(
              roomId: roomId,
              clientCoverId: _clientObjectId(upload),
              mimeType: upload.mimeType,
              sizeBytes: Int64(upload.sizeBytes),
              width: upload.width,
              height: upload.height,
              parts: parts,
              metadata: _imageMetadata(upload),
            ),
          ),
          planOf: (response) => response.plan,
          sessionOf: (response) => response.session,
          hasPlan: (response) => response.hasPlan(),
          hasSession: (response) => response.hasSession(),
        );
    final session = result.session;
    final uploadedParts = await _uploadSessionParts(
      upload: upload,
      sessionUploadRequired: session.uploadRequired,
      uploadUrl: session.uploadUrl,
      uploadHeaders: session.uploadHeaders,
      partUrls: session.partUrls,
      manifestParts: result.manifestParts,
    );
    final complete = await _api.room.completeRoomCoverUploadSession(
      client.CompleteRoomCoverUploadSessionRequest(
        encodedObjectKey: session.encodedObjectKey,
        token: session.uploadToken,
        uploadId: session.uploadId,
        parts: uploadedParts.map(_completePart),
        fileId: session.coverReference.id,
        ownershipProof: _ownershipProof(
          upload: upload,
          required: session.ownershipProofRequired,
          nonce: session.ownershipProofNonce,
          contentManifestSha256: result.contentManifestSha256,
          ranges: session.ownershipProofRanges
              .map(
                (range) => _OwnershipProofRange(
                  offset: range.offset.toInt(),
                  length: range.length,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
    if (!complete.complete) {
      throw const SyncTvFileUploadException('封面上传尚未完成，请稍后重试。');
    }
    final updated = await _api.room.updateRoomCover(
      roomId,
      client.UpdateRoomCoverRequest(
        roomId: roomId,
        coverReference: session.coverReference,
      ),
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
    final result =
        await _createUploadSession<
          client.PlaylistCoverUploadSession,
          client.CreatePlaylistCoverUploadSessionResponse
        >(
          upload: upload,
          createRequest: (parts) => _api.room.createPlaylistCoverUploadSession(
            roomId,
            client.CreatePlaylistCoverUploadSessionRequest(
              roomId: roomId,
              playlistId: playlistId,
              clientCoverId: _clientObjectId(upload),
              mimeType: upload.mimeType,
              sizeBytes: Int64(upload.sizeBytes),
              width: upload.width,
              height: upload.height,
              parts: parts,
              metadata: _imageMetadata(upload),
            ),
          ),
          planOf: (response) => response.plan,
          sessionOf: (response) => response.session,
          hasPlan: (response) => response.hasPlan(),
          hasSession: (response) => response.hasSession(),
        );
    final session = result.session;
    final uploadedParts = await _uploadSessionParts(
      upload: upload,
      sessionUploadRequired: session.uploadRequired,
      uploadUrl: session.uploadUrl,
      uploadHeaders: session.uploadHeaders,
      partUrls: session.partUrls,
      manifestParts: result.manifestParts,
    );
    final complete = await _api.room.completePlaylistCoverUploadSession(
      client.CompletePlaylistCoverUploadSessionRequest(
        encodedObjectKey: session.encodedObjectKey,
        token: session.uploadToken,
        uploadId: session.uploadId,
        parts: uploadedParts.map(_completePart),
        fileId: session.coverReference.id,
        ownershipProof: _ownershipProof(
          upload: upload,
          required: session.ownershipProofRequired,
          nonce: session.ownershipProofNonce,
          contentManifestSha256: result.contentManifestSha256,
          ranges: session.ownershipProofRanges
              .map(
                (range) => _OwnershipProofRange(
                  offset: range.offset.toInt(),
                  length: range.length,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
    if (!complete.complete) {
      throw const SyncTvFileUploadException('封面上传尚未完成，请稍后重试。');
    }
    final updated = await _api.room.updatePlaylistCover(
      roomId,
      client.UpdatePlaylistCoverRequest(
        roomId: roomId,
        playlistId: playlistId,
        coverReference: session.coverReference,
      ),
    );
    return updated;
  }

  Future<client.Playlist> clearPlaylistCover(
    String roomId,
    String playlistId,
  ) async {
    final response = await _api.room.clearPlaylistCover(
      roomId,
      client.ClearPlaylistCoverRequest(roomId: roomId, playlistId: playlistId),
    );
    return response;
  }

  Future<client.Media> updateVideoCover(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  ) async {
    _validateImageUpload(upload, maxSizeBytes: 10 * 1024 * 1024);
    final result =
        await _createUploadSession<
          client.MediaCoverUploadSession,
          client.CreateMediaCoverUploadSessionResponse
        >(
          upload: upload,
          createRequest: (parts) => _api.room.createMediaCoverUploadSession(
            roomId,
            client.CreateMediaCoverUploadSessionRequest(
              roomId: roomId,
              mediaId: mediaId,
              clientCoverId: _clientObjectId(upload),
              mimeType: upload.mimeType,
              sizeBytes: Int64(upload.sizeBytes),
              width: upload.width,
              height: upload.height,
              parts: parts,
              metadata: _imageMetadata(upload),
            ),
          ),
          planOf: (response) => response.plan,
          sessionOf: (response) => response.session,
          hasPlan: (response) => response.hasPlan(),
          hasSession: (response) => response.hasSession(),
        );
    final session = result.session;
    final uploadedParts = await _uploadSessionParts(
      upload: upload,
      sessionUploadRequired: session.uploadRequired,
      uploadUrl: session.uploadUrl,
      uploadHeaders: session.uploadHeaders,
      partUrls: session.partUrls,
      manifestParts: result.manifestParts,
    );
    final complete = await _api.room.completeMediaCoverUploadSession(
      client.CompleteMediaCoverUploadSessionRequest(
        encodedObjectKey: session.encodedObjectKey,
        token: session.uploadToken,
        uploadId: session.uploadId,
        parts: uploadedParts.map(_completePart),
        fileId: session.coverReference.id,
        ownershipProof: _ownershipProof(
          upload: upload,
          required: session.ownershipProofRequired,
          nonce: session.ownershipProofNonce,
          contentManifestSha256: result.contentManifestSha256,
          ranges: session.ownershipProofRanges
              .map(
                (range) => _OwnershipProofRange(
                  offset: range.offset.toInt(),
                  length: range.length,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
    if (!complete.complete) {
      throw const SyncTvFileUploadException('封面上传尚未完成，请稍后重试。');
    }
    final updated = await _api.room.updateMediaCover(
      roomId,
      client.UpdateMediaCoverRequest(
        roomId: roomId,
        mediaId: mediaId,
        coverReference: session.coverReference,
      ),
    );
    return updated;
  }

  Future<client.Media> clearVideoCover(String roomId, String mediaId) async {
    final response = await _api.room.clearMediaCover(
      roomId,
      client.ClearMediaCoverRequest(roomId: roomId, mediaId: mediaId),
    );
    return response;
  }

  Future<client.Media> updateVideoThumbnail(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  ) async {
    _validateImageUpload(upload, maxSizeBytes: 10 * 1024 * 1024);
    final result =
        await _createUploadSession<
          client.MediaThumbnailUploadSession,
          client.CreateMediaThumbnailUploadSessionResponse
        >(
          upload: upload,
          createRequest: (parts) => _api.room.createMediaThumbnailUploadSession(
            roomId,
            client.CreateMediaThumbnailUploadSessionRequest(
              roomId: roomId,
              mediaId: mediaId,
              clientThumbnailId: _clientObjectId(upload),
              mimeType: upload.mimeType,
              sizeBytes: Int64(upload.sizeBytes),
              width: upload.width,
              height: upload.height,
              parts: parts,
              metadata: _imageMetadata(upload),
            ),
          ),
          planOf: (response) => response.plan,
          sessionOf: (response) => response.session,
          hasPlan: (response) => response.hasPlan(),
          hasSession: (response) => response.hasSession(),
        );
    final session = result.session;
    final uploadedParts = await _uploadSessionParts(
      upload: upload,
      sessionUploadRequired: session.uploadRequired,
      uploadUrl: session.uploadUrl,
      uploadHeaders: session.uploadHeaders,
      partUrls: session.partUrls,
      manifestParts: result.manifestParts,
    );
    final complete = await _api.room.completeMediaThumbnailUploadSession(
      client.CompleteMediaThumbnailUploadSessionRequest(
        encodedObjectKey: session.encodedObjectKey,
        token: session.uploadToken,
        uploadId: session.uploadId,
        parts: uploadedParts.map(_completePart),
        fileId: session.thumbnailReference.id,
        ownershipProof: _ownershipProof(
          upload: upload,
          required: session.ownershipProofRequired,
          nonce: session.ownershipProofNonce,
          contentManifestSha256: result.contentManifestSha256,
          ranges: session.ownershipProofRanges
              .map(
                (range) => _OwnershipProofRange(
                  offset: range.offset.toInt(),
                  length: range.length,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
    if (!complete.complete) {
      throw const SyncTvFileUploadException('缩略图上传尚未完成，请稍后重试。');
    }
    final updated = await _api.room.updateMediaThumbnail(
      roomId,
      client.UpdateMediaThumbnailRequest(
        roomId: roomId,
        mediaId: mediaId,
        thumbnailReference: session.thumbnailReference,
      ),
    );
    return updated;
  }

  Future<client.Media> clearVideoThumbnail(
    String roomId,
    String mediaId,
  ) async {
    final response = await _api.room.clearMediaThumbnail(
      roomId,
      client.ClearMediaThumbnailRequest(roomId: roomId, mediaId: mediaId),
    );
    return response;
  }

  Future<_UploadSessionResult<TSession>>
  _createUploadSession<TSession, TResponse>({
    required LocalImageUpload upload,
    required Future<TResponse> Function(
      Iterable<client.FileUploadManifestPart> parts,
    )
    createRequest,
    required client.FileUploadPlan Function(TResponse response) planOf,
    required TSession Function(TResponse response) sessionOf,
    required bool Function(TResponse response) hasPlan,
    required bool Function(TResponse response) hasSession,
  }) async {
    try {
      final planResponse = await createRequest(const []);
      if (!hasPlan(planResponse)) {
        throw const SyncTvFileUploadException('图片上传会话缺少分片计划，请重新选择图片。');
      }
      final plan = planOf(planResponse);
      final manifestParts = _manifestPartsForPlan(upload, plan);
      final sessionResponse = await createRequest(manifestParts);
      if (!hasSession(sessionResponse)) {
        throw const SyncTvFileUploadException('图片上传会话创建失败，请重新选择图片。');
      }
      return _UploadSessionResult<TSession>(
        plan: plan,
        session: sessionOf(sessionResponse),
        manifestParts: manifestParts,
        contentManifestSha256: _contentManifestSha256(
          upload.sizeBytes,
          plan.partSizeBytes.toInt(),
          manifestParts,
        ),
      );
    } on SyncTvApiException catch (error) {
      throw SyncTvFileUploadException(_uploadSessionErrorMessage(error));
    }
  }

  List<client.FileUploadManifestPart> _manifestPartsForPlan(
    LocalImageUpload upload,
    client.FileUploadPlan plan,
  ) {
    if (plan.parts.isEmpty) {
      throw const SyncTvFileUploadException('图片上传会话缺少分片计划，请重新选择图片。');
    }
    return plan.parts
        .map((part) {
          final offset = part.offsetBytes.toInt();
          final size = part.sizeBytes.toInt();
          final end = offset + size;
          if (offset < 0 || size <= 0 || end > upload.bytes.length) {
            throw const SyncTvFileUploadException('图片上传会话分片范围无效，请重新选择图片。');
          }
          return client.FileUploadManifestPart(
            partNumber: part.partNumber,
            offsetBytes: part.offsetBytes,
            sizeBytes: part.sizeBytes,
            checksumSha256: sha256
                .convert(Uint8List.sublistView(upload.bytes, offset, end))
                .toString(),
          );
        })
        .toList(growable: false);
  }

  Future<List<_UploadedPart>> _uploadSessionParts({
    required LocalImageUpload upload,
    required bool sessionUploadRequired,
    required String uploadUrl,
    required Map<String, String> uploadHeaders,
    required Iterable<client.FileUploadPartUrl> partUrls,
    required List<client.FileUploadManifestPart> manifestParts,
  }) async {
    final uploaded = <_UploadedPart>[];
    final partUrlByNumber = {
      for (final partUrl in partUrls) partUrl.partNumber: partUrl,
    };

    for (final part in manifestParts) {
      final checksum = part.checksumSha256;
      if (!sessionUploadRequired) {
        uploaded.add(
          _UploadedPart(part: part, checksumSha256: checksum, etag: ''),
        );
        continue;
      }
      final offset = part.offsetBytes.toInt();
      final size = part.sizeBytes.toInt();
      final bytes = Uint8List.sublistView(upload.bytes, offset, offset + size);
      final wholeObjectUpload =
          manifestParts.length == 1 && offset == 0 && size == upload.sizeBytes;
      final specificPartUrl = partUrlByNumber[part.partNumber];
      final headers = <String, String>{
        ...uploadHeaders,
        if (specificPartUrl != null) ...specificPartUrl.uploadHeaders,
      };
      final url = specificPartUrl?.uploadUrl.isNotEmpty == true
          ? specificPartUrl!.uploadUrl
          : uploadUrl;
      if (url.trim().isEmpty) {
        throw const SyncTvFileUploadException('图片上传会话缺少上传地址，请重新选择图片。');
      }
      if (partUrls.isEmpty && !wholeObjectUpload) {
        final endInclusive = offset + size - 1;
        headers['content-range'] =
            'bytes $offset-$endInclusive/${upload.sizeBytes}';
      }
      final response = await _uploadSessionPart(
        uploadUrl: url,
        headers: headers,
        bytes: bytes,
        contentType: upload.mimeType,
      );
      uploaded.add(
        _UploadedPart(
          part: part,
          checksumSha256: checksum,
          etag: _responseHeader(response, 'etag'),
        ),
      );
    }
    return uploaded;
  }

  Future<http.Response> _uploadSessionPart({
    required String uploadUrl,
    required Map<String, String> headers,
    required Uint8List bytes,
    required String contentType,
  }) {
    return _api.uploadRawBytes(
      uploadUrl,
      bytes,
      contentType: contentType,
      headers: headers,
    );
  }

  client.CompleteFileUploadPart _completePart(_UploadedPart uploaded) {
    return client.CompleteFileUploadPart(
      partNumber: uploaded.part.partNumber,
      etag: uploaded.etag,
      sizeBytes: uploaded.part.sizeBytes,
      checksumSha256: uploaded.checksumSha256,
    );
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

  String _ownershipProof({
    required LocalImageUpload upload,
    required bool required,
    required String nonce,
    required String contentManifestSha256,
    required List<_OwnershipProofRange> ranges,
  }) {
    if (!required) return '';
    if (nonce.trim().isEmpty || contentManifestSha256.trim().isEmpty) {
      throw const SyncTvFileUploadException('图片上传会话缺少所有权验证信息，请重新选择图片。');
    }
    final proofBytes = BytesBuilder();
    proofBytes.add(utf8.encode('synctv-file-ownership-proof-v1'));
    proofBytes.add([0]);
    proofBytes.add(utf8.encode(nonce));
    proofBytes.add([0]);
    proofBytes.add(utf8.encode(contentManifestSha256.trim().toLowerCase()));
    proofBytes.add(_int64ToBigEndian(upload.sizeBytes));
    proofBytes.add(_uint64ToBigEndian(ranges.length));
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

    return sha256.convert(proofBytes.toBytes()).toString();
  }

  String _contentManifestSha256(
    int sizeBytes,
    int partSizeBytes,
    List<client.FileUploadManifestPart> parts,
  ) {
    final sorted = [...parts]
      ..sort((a, b) => a.partNumber.compareTo(b.partNumber));
    final bytes = BytesBuilder();
    bytes.add(utf8.encode('synctv-file-part-manifest-sha256-v1'));
    bytes.add([0]);
    bytes.add(_int64ToBigEndian(sizeBytes));
    bytes.add(_int64ToBigEndian(partSizeBytes));
    bytes.add(_uint64ToBigEndian(sorted.length));
    for (final part in sorted) {
      bytes.add(_int32ToBigEndian(part.partNumber));
      bytes.add(_int64ToBigEndian(part.sizeBytes.toInt()));
      bytes.add(utf8.encode(part.checksumSha256.trim().toLowerCase()));
    }
    return sha256.convert(bytes.toBytes()).toString();
  }

  String _responseHeader(http.Response response, String name) {
    final lowerName = name.toLowerCase();
    for (final entry in response.headers.entries) {
      if (entry.key.toLowerCase() == lowerName) return entry.value;
    }
    return '';
  }

  List<int> _int64ToBigEndian(int value) {
    final data = ByteData(8)..setInt64(0, value, Endian.big);
    return data.buffer.asUint8List();
  }

  List<int> _uint64ToBigEndian(int value) {
    final data = ByteData(8)..setUint64(0, value, Endian.big);
    return data.buffer.asUint8List();
  }

  List<int> _int32ToBigEndian(int value) {
    final data = ByteData(4)..setInt32(0, value, Endian.big);
    return data.buffer.asUint8List();
  }
}
