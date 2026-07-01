part of 'synctv_api_client.dart';

class SyncTvAuthApi {
  SyncTvAuthApi._(this._api);

  final SyncTvApiClient _api;

  Future<client.RegisterResponse> registerWithDirectPassword(
    client.RegisterWithDirectPasswordRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/direct-password/register',
      client.RegisterResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.LoginResponse> loginWithDirectPassword(
    client.LoginWithDirectPasswordRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/direct-password/login',
      client.LoginResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.RequestEmailRegistrationResponse> requestEmailRegistration(
    client.RequestEmailRegistrationRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/email/registration/request',
      client.RequestEmailRegistrationResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.RegisterResponse> confirmEmailRegistration(
    client.ConfirmEmailRegistrationRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/email/registration/confirm',
      client.RegisterResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.LoginResponse> confirmEmailLogin(
    client.ConfirmEmailLoginRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/email/confirm',
      client.LoginResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.CreateGuestTokenResponse> createGuestToken(
    client.CreateGuestTokenRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/guest-token',
      client.CreateGuestTokenResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.StartOpaqueRegistrationResponse> startOpaqueRegistration(
    client.StartOpaqueRegistrationRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/opaque/registration/start',
      client.StartOpaqueRegistrationResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.RegisterResponse> finishOpaqueRegistration(
    client.FinishOpaqueRegistrationRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/opaque/registration/finish',
      client.RegisterResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.StartOpaqueLoginResponse> startOpaqueLogin(
    client.StartOpaqueLoginRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/opaque/login/start',
      client.StartOpaqueLoginResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.LoginResponse> finishOpaqueLogin(
    client.FinishOpaqueLoginRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/opaque/login/finish',
      client.LoginResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.StartPasskeyRegistrationResponse> startPasskeyRegistration(
    client.StartPasskeyRegistrationRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/passkeys/registration/start',
      client.StartPasskeyRegistrationResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.RegisterResponse> finishPasskeyRegistration(
    client.FinishPasskeyRegistrationRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/passkeys/registration/finish',
      client.RegisterResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.StartPasskeyLoginResponse> startPasskeyLogin(
    client.StartPasskeyLoginRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/passkeys/login/start',
      client.StartPasskeyLoginResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.LoginResponse> finishPasskeyLogin(
    client.FinishPasskeyLoginRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/passkeys/login/finish',
      client.LoginResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.RequestEmailLoginResponse> requestEmailLogin(
    client.RequestEmailLoginRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/email/request',
      client.RequestEmailLoginResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.RequestMfaEmailCodeResponse> requestMfaEmailCode(
    client.RequestMfaEmailCodeRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/mfa/email/request',
      client.RequestMfaEmailCodeResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.LoginResponse> verifyMfaEmailCode(
    client.VerifyMfaEmailCodeRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/mfa/email/verify',
      client.LoginResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.StartMfaPasskeyResponse> startMfaPasskey(
    client.StartMfaPasskeyRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/auth/mfa/passkeys/start',
      client.StartMfaPasskeyResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.LoginResponse> finishMfaPasskey(
    client.FinishMfaPasskeyRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/auth/mfa/passkeys/finish',
      client.LoginResponse.create,
      auth: false,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<client.RefreshTokenResponse> refreshToken(
    client.RefreshTokenRequest request,
  ) async {
    final response = await _api._sendWithoutRefresh(
      'POST',
      '/api/auth/refresh',
      client.RefreshTokenResponse.create,
      auth: false,
      body: request,
    );
    _api.session.accessToken = response.accessToken;
    _api.session.refreshToken = response.refreshToken;
    return response;
  }
}

class SyncTvUserApi {
  SyncTvUserApi._(this._api);

  final SyncTvApiClient _api;

  Future<client.LogoutResponse> logout(client.LogoutRequest request) async {
    var response = client.LogoutResponse();
    if (_api.session.hasAccessToken && !_api.session.isGuest) {
      try {
        response = await _api._send(
          'POST',
          '/api/user/logout',
          client.LogoutResponse.create,
          body: request,
        );
      } catch (e) {
        debugPrint('Logout request failed before local session clear: $e');
      }
    }
    _api.session.accessToken = null;
    _api.session.refreshToken = null;
    _api.session.isGuest = false;
    return response;
  }

  Future<client.GetProfileResponse> getProfile(
    client.GetProfileRequest request,
  ) {
    return _api._send('GET', '/api/user', client.GetProfileResponse.create);
  }

  Future<client.CreateUserAvatarUploadSessionResponse>
  createUserAvatarUploadSession(
    client.CreateUserAvatarUploadSessionRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/avatar/upload-session',
      client.CreateUserAvatarUploadSessionResponse.create,
      body: request,
    );
  }

  Future<client.UploadUserAvatarObjectResponse> uploadUserAvatarObject(
    client.UploadUserAvatarObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._uploadFileObject(
      '/api/user/avatar-objects/$key',
      token: request.token,
      data: request.data,
      contentType: request.contentType,
      contentRange: request.hasContentRange() ? request.contentRange : null,
    );
    return client.UploadUserAvatarObjectResponse(
      complete: result.complete,
      uploadedSizeBytes: result.uploadedSizeBytes,
      uploadedParts: result.uploadedParts,
    );
  }

  Future<client.CompleteUserAvatarUploadSessionResponse>
  completeUserAvatarUploadSession(
    client.CompleteUserAvatarUploadSessionRequest request,
  ) {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    return _api._send(
      'POST',
      '/api/user/avatar-objects/$key/complete',
      client.CompleteUserAvatarUploadSessionResponse.create,
      body: request,
      auth: false,
    );
  }

  Future<client.UserAvatarObjectResponse> getUserAvatarObject(
    client.GetUserAvatarObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._downloadFileObject(
      '/api/user/avatar-objects/$key',
      token: request.token,
      range: request.hasRange() ? request.range : null,
    );
    return client.UserAvatarObjectResponse(
      mimeType: result.mimeType,
      contentManifestSha256: result.contentManifestSha256,
      data: result.data,
      contentRange: result.contentRange,
      totalSizeBytes: result.totalSizeBytes,
    );
  }

  Future<client.GetProfileResponse> updateUserAvatar(
    client.UpdateUserAvatarRequest request,
  ) {
    return _api._send(
      'PUT',
      '/api/user/avatar',
      client.GetProfileResponse.create,
      body: request,
    );
  }

  Future<client.GetProfileResponse> clearUserAvatar(
    client.ClearUserAvatarRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/user/avatar',
      client.GetProfileResponse.create,
    );
  }

  Future<client.SetUsernameResponse> setUsername(
    client.SetUsernameRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/user',
      client.SetUsernameResponse.create,
      body: request,
    );
  }

  Future<client.StartEmailBindResponse> startEmailBind(
    client.StartEmailBindRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/email/bind/start',
      client.StartEmailBindResponse.create,
      body: request,
    );
  }

  Future<client.ConfirmEmailBindResponse> confirmEmailBind(
    client.ConfirmEmailBindRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/email/bind/confirm',
      client.ConfirmEmailBindResponse.create,
      body: request,
    );
  }

  Future<client.UnbindEmailResponse> unbindEmail(
    client.UnbindEmailRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/email/unbind',
      client.UnbindEmailResponse.create,
      body: request,
    );
  }

  Future<client.StartOpaquePasswordUpdateResponse> startOpaquePasswordUpdate(
    client.StartOpaquePasswordUpdateRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/opaque-password/update/start',
      client.StartOpaquePasswordUpdateResponse.create,
      body: request,
    );
  }

  Future<client.FinishOpaquePasswordUpdateResponse> finishOpaquePasswordUpdate(
    client.FinishOpaquePasswordUpdateRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/opaque-password/update/finish',
      client.FinishOpaquePasswordUpdateResponse.create,
      body: request,
    );
  }

  Future<client.StartSensitiveOperationVerificationResponse>
  startSensitiveOperationVerification(
    client.StartSensitiveOperationVerificationRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/sensitive-verification/start',
      client.StartSensitiveOperationVerificationResponse.create,
      body: request,
    );
  }

  Future<client.StartSensitiveOperationPasskeyResponse>
  startSensitiveOperationPasskey(
    client.StartSensitiveOperationPasskeyRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/sensitive-verification/passkey/start',
      client.StartSensitiveOperationPasskeyResponse.create,
      body: request,
    );
  }

  Future<client.RequestSensitiveOperationEmailCodeResponse>
  requestSensitiveOperationEmailCode(
    client.RequestSensitiveOperationEmailCodeRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/sensitive-verification/email/request',
      client.RequestSensitiveOperationEmailCodeResponse.create,
      body: request,
    );
  }

  Future<client.FinishSensitiveOperationVerificationResponse>
  finishSensitiveOperationVerification(
    client.FinishSensitiveOperationVerificationRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/sensitive-verification/finish',
      client.FinishSensitiveOperationVerificationResponse.create,
      body: request,
    );
  }

  Future<client.StartPasskeyBindResponse> startPasskeyBind(
    client.StartPasskeyBindRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/passkeys/bind/start',
      client.StartPasskeyBindResponse.create,
      body: request,
    );
  }

  Future<client.PasskeyCredentialResponse> finishPasskeyBind(
    client.FinishPasskeyBindRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/user/passkeys/bind/finish',
      client.PasskeyCredentialResponse.create,
      body: request,
    );
  }

  Future<client.ListPasskeysResponse> listPasskeys(
    client.ListPasskeysRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/user/passkeys',
      client.ListPasskeysResponse.create,
    );
  }

  Future<client.DeletePasskeyResponse> deletePasskey(
    client.DeletePasskeyRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/user/passkeys/${request.credentialId}',
      client.DeletePasskeyResponse.create,
    );
  }

  Future<client.GetUserPreferencesResponse> getUserPreferences(
    client.GetUserPreferencesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/user/preferences',
      client.GetUserPreferencesResponse.create,
    );
  }

  Future<client.UpdateUserPreferencesResponse> updateUserPreferences(
    client.UpdateUserPreferencesRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/user/preferences',
      client.UpdateUserPreferencesResponse.create,
      body: request,
    );
  }

  Future<client.CloseAccountResponse> closeAccount(
    client.CloseAccountRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/user/account-closure',
      client.CloseAccountResponse.create,
      body: request,
    );
    _api.session.accessToken = null;
    _api.session.refreshToken = null;
    _api.session.isGuest = false;
    return response;
  }

  Future<client.CreateRoomResponse> createRoom(
    client.CreateRoomRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms',
      client.CreateRoomResponse.create,
      body: request,
    );
  }

  Future<client.GetRoomResponse> getRoom(client.GetRoomRequest request) {
    return _api._send(
      'GET',
      '/api/rooms/${request.roomId}',
      client.GetRoomResponse.create,
      auth: _api.session.hasAccessToken,
    );
  }

  Future<client.JoinRoomResponse> joinRoom(client.JoinRoomRequest request) {
    return _api._send(
      'PUT',
      '/api/rooms/${request.roomId}/members/@me',
      client.JoinRoomResponse.create,
      body: request,
    );
  }

  Future<client.StartRoomPasswordLoginResponse> startRoomPasswordLogin(
    String roomId,
    client.StartRoomPasswordLoginRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/password/opaque/login/start',
      client.StartRoomPasswordLoginResponse.create,
      body: request,
    );
  }

  Future<client.JoinRoomResponse> finishRoomPasswordLogin(
    String roomId,
    client.FinishRoomPasswordLoginRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/password/opaque/login/finish',
      client.JoinRoomResponse.create,
      body: request,
    );
  }

  Future<client.ListMyRoomsResponse> listMyRooms(
    client.ListMyRoomsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/user/rooms',
      client.ListMyRoomsResponse.create,
      query: _api._messageQuery(request),
    );
  }
}

class SyncTvRoomApi {
  SyncTvRoomApi._(this._api);

  final SyncTvApiClient _api;

  Future<client.GetRoomSettingsResponse> getRoomSettings(
    String roomId,
    client.GetRoomSettingsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/settings',
      client.GetRoomSettingsResponse.create,
    );
  }

  Future<client.Room> updateRoomSettings(
    String roomId,
    client.UpdateRoomSettingsRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/rooms/$roomId/settings',
      client.Room.create,
      body: request,
    );
  }

  Future<client.ResetRoomSettingsResponse> resetRoomSettings(
    String roomId,
    client.ResetRoomSettingsRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/settings/reset',
      client.ResetRoomSettingsResponse.create,
      body: request,
    );
  }

  Future<client.TransferRoomOwnershipResponse> transferRoomOwnership(
    String roomId,
    client.TransferRoomOwnershipRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/owner',
      client.TransferRoomOwnershipResponse.create,
      body: request,
    );
  }

  Future<client.LeaveRoomResponse> leaveRoom(
    String roomId,
    client.LeaveRoomRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/members/@me',
      client.LeaveRoomResponse.create,
    );
  }

  Future<client.DeleteRoomResponse> deleteRoom(
    String roomId,
    client.DeleteRoomRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId',
      client.DeleteRoomResponse.create,
    );
  }

  Future<client.SetRoomPasswordResponse> setRoomPassword(
    String roomId,
    client.ClearRoomPasswordRequest request,
  ) {
    return clearRoomPassword(roomId, request);
  }

  Future<client.SetRoomPasswordResponse> clearRoomPassword(
    String roomId,
    client.ClearRoomPasswordRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/password',
      client.SetRoomPasswordResponse.create,
      body: request,
    );
  }

  Future<client.StartRoomPasswordRegistrationResponse>
  startRoomPasswordRegistration(
    String roomId,
    client.StartRoomPasswordRegistrationRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/rooms/$roomId/password/opaque/registration/start',
      client.StartRoomPasswordRegistrationResponse.create,
      body: request,
    );
  }

  Future<client.SetRoomPasswordResponse> finishRoomPasswordRegistration(
    String roomId,
    client.FinishRoomPasswordRegistrationRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/rooms/$roomId/password/opaque/registration/finish',
      client.SetRoomPasswordResponse.create,
      body: request,
    );
  }

  Future<client.GetRoomMembersResponse> getRoomMembers(
    String roomId,
    client.GetRoomMembersRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/members',
      client.GetRoomMembersResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.ListRoomStreamsResponse> listRoomStreams(
    String roomId,
    client.ListRoomStreamsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/streams',
      client.ListRoomStreamsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.GetRoomStreamInfoResponse> getRoomStreamInfo(
    String roomId,
    client.GetRoomStreamInfoRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/streams/${request.mediaId}',
      client.GetRoomStreamInfoResponse.create,
    );
  }

  Future<client.KickRoomStreamResponse> kickRoomStream(
    String roomId,
    client.KickRoomStreamRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/streams/${request.mediaId}/kick',
      client.KickRoomStreamResponse.create,
      body: request,
    );
  }

  Future<client.AddMemberResponse> addMember(
    String roomId,
    client.AddMemberRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/members',
      client.AddMemberResponse.create,
      body: request,
    );
  }

  Future<client.ListRoomJoinReviewsResponse> listRoomJoinReviews(
    String roomId,
    client.ListRoomJoinReviewsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/reviews/joins',
      client.ListRoomJoinReviewsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.ApproveRoomJoinReviewResponse> approveRoomJoinReview(
    String roomId,
    client.ApproveRoomJoinReviewRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/reviews/joins/${request.requestId}/approve',
      client.ApproveRoomJoinReviewResponse.create,
      body: request,
    );
  }

  Future<client.RejectRoomJoinReviewResponse> rejectRoomJoinReview(
    String roomId,
    client.RejectRoomJoinReviewRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/reviews/joins/${request.requestId}/reject',
      client.RejectRoomJoinReviewResponse.create,
      body: request,
    );
  }

  Future<client.UpdateMemberPermissionsResponse> updateMemberPermissions(
    String roomId,
    client.UpdateMemberPermissionsRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/rooms/$roomId/members/${request.userId}',
      client.UpdateMemberPermissionsResponse.create,
      body: request,
    );
  }

  Future<client.KickMemberResponse> kickMember(
    String roomId,
    client.KickMemberRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/members/${request.userId}',
      client.KickMemberResponse.create,
      body: request,
    );
  }

  Future<client.CreateWebSocketTicketResponse> createWebSocketTicket(
    client.CreateWebSocketTicketRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/tickets',
      client.CreateWebSocketTicketResponse.create,
      body: request,
    );
  }

  Stream<client.WatchPlaybackStateEvent> watchPlaybackState(
    String roomId,
    client.WatchPlaybackStateRequest request,
  ) {
    return _api._watchSse(
      '/api/rooms/$roomId/watch/playback-state',
      client.WatchPlaybackStateEvent.create,
      query: {
        ..._api._watchQuery(deliveryMode: request.deliveryMode),
        if (request.playbackState.hasEventSequence())
          'eventSequence': request.playbackState.eventSequence.toString(),
      },
    );
  }

  Stream<client.WatchPlaybackEvent> watchPlayback(
    String roomId,
    client.WatchPlaybackRequest request,
  ) {
    final profile = request.playback.hasPlaybackClientProfile()
        ? request.playback.playbackClientProfile
        : defaultPlaybackClientProfile();
    return _api._watchSse(
      '/api/rooms/$roomId/watch/playback',
      client.WatchPlaybackEvent.create,
      query: {
        ..._api._watchQuery(deliveryMode: request.deliveryMode),
        ..._api._playbackClientProfileQuery(profile),
      },
    );
  }

  Stream<client.WatchRoomSettingsEvent> watchRoomSettings(
    String roomId,
    client.WatchRoomSettingsRequest request,
  ) {
    return _api._watchSse(
      '/api/rooms/$roomId/watch/room-settings',
      client.WatchRoomSettingsEvent.create,
      query: _api._watchQuery(
        deliveryMode: request.deliveryMode,
        afterEventSequence: request.roomSettings.hasAfterEventSequence()
            ? request.roomSettings.afterEventSequence
            : null,
      ),
    );
  }

  Stream<client.WatchPlaylistItemsEvent> watchPlaylistItems(
    String roomId,
    client.WatchPlaylistItemsRequest request,
  ) {
    return _api._watchSse(
      '/api/rooms/$roomId/watch/playlist-items',
      client.WatchPlaylistItemsEvent.create,
      query: {
        ..._api._watchQuery(
          deliveryMode: request.deliveryMode,
          afterEventSequence: request.playlistItems.hasAfterEventSequence()
              ? request.playlistItems.afterEventSequence
              : null,
        ),
        ..._api._messageQuery(request.playlistItems.request),
      },
    );
  }

  Stream<client.WatchRoomMemberEventsEvent> watchRoomMemberEvents(
    String roomId,
    client.WatchRoomMemberEventsRequest request,
  ) {
    return _api._watchSse(
      '/api/rooms/$roomId/watch/room-members',
      client.WatchRoomMemberEventsEvent.create,
      query: {
        ..._api._watchQuery(
          deliveryMode: request.deliveryMode,
          afterEventSequence: request.roomMemberEvents.hasAfterEventSequence()
              ? request.roomMemberEvents.afterEventSequence
              : null,
        ),
      },
    );
  }

  Stream<client.WatchChatEventsEvent> watchChatEvents(
    String roomId,
    client.WatchChatEventsRequest request,
  ) {
    return _api._watchSse(
      '/api/rooms/$roomId/watch/chat-events',
      client.WatchChatEventsEvent.create,
      query: {
        ..._api._watchQuery(
          deliveryMode: request.deliveryMode,
          afterEventSequence: request.chatEvents.hasAfterEventSequence()
              ? request.chatEvents.afterEventSequence
              : null,
        ),
        ..._api._messageQuery(request.chatEvents),
      },
    );
  }

  Stream<client.WatchChatPinEventsEvent> watchChatPinEvents(
    String roomId,
    client.WatchChatPinEventsRequest request,
  ) {
    return _api._watchSse(
      '/api/rooms/$roomId/watch/chat-pin-events',
      client.WatchChatPinEventsEvent.create,
      query: {
        ..._api._watchQuery(
          deliveryMode: request.deliveryMode,
          afterEventSequence: request.chatPinEvents.hasAfterEventSequence()
              ? request.chatPinEvents.afterEventSequence
              : null,
        ),
      },
    );
  }

  Future<client.GetChatHistoryResponse> getChatHistory(
    String roomId,
    client.GetChatHistoryRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/history',
      client.GetChatHistoryResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.SearchChatMessagesResponse> searchChatMessages(
    String roomId,
    client.SearchChatMessagesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/search',
      client.SearchChatMessagesResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.ChatMessageEventResponse> sendChatMessage(
    String roomId,
    client.SendChatMessageRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/chat/messages',
      client.ChatMessageEventResponse.create,
      body: request,
    );
  }

  Future<client.GetChatMessageResponse> getChatMessage(
    String roomId,
    client.GetChatMessageRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/messages/${request.messageId}',
      client.GetChatMessageResponse.create,
      query: _api._messageQuery(request)..remove('messageId'),
    );
  }

  Future<client.GetChatMessageContextResponse> getChatMessageContext(
    String roomId,
    client.GetChatMessageContextRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/messages/${request.messageId}/context',
      client.GetChatMessageContextResponse.create,
      query: _api._messageQuery(request)..remove('messageId'),
    );
  }

  Future<client.GetChatPlaybackMessagesResponse> getChatPlaybackMessages(
    String roomId,
    client.GetChatPlaybackMessagesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/playback-messages',
      client.GetChatPlaybackMessagesResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.ChatMessageEventResponse> editChatMessage(
    String roomId,
    client.EditChatMessageRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/rooms/$roomId/chat/messages/${request.messageId}',
      client.ChatMessageEventResponse.create,
      body: request,
    );
  }

  Future<client.ChatMessageEventResponse> deleteChatMessage(
    String roomId,
    client.DeleteChatMessageRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/chat/messages/${request.messageId}',
      client.ChatMessageEventResponse.create,
      body: request,
    );
  }

  Future<client.ListPinnedChatMessagesResponse> listPinnedChatMessages(
    String roomId,
    client.ListPinnedChatMessagesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/pinned-messages',
      client.ListPinnedChatMessagesResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.ChatPinEventResponse> pinChatMessage(
    String roomId,
    client.PinChatMessageRequest request,
  ) {
    final messageId = Uri.encodeComponent(request.messageId);
    return _api._send(
      'PUT',
      '/api/rooms/$roomId/chat/messages/$messageId/pin',
      client.ChatPinEventResponse.create,
      body: request,
    );
  }

  Future<client.ChatPinEventResponse> unpinChatMessage(
    String roomId,
    client.UnpinChatMessageRequest request,
  ) {
    final messageId = Uri.encodeComponent(request.messageId);
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/chat/messages/$messageId/pin',
      client.ChatPinEventResponse.create,
      body: request,
    );
  }

  Future<client.SetChatReactionResponse> setChatReaction(
    String roomId,
    client.SetChatReactionRequest request,
  ) {
    final messageId = Uri.encodeComponent(request.messageId);
    final reactionKey = Uri.encodeComponent(request.reactionKey);
    return _api._send(
      request.enabled ? 'PUT' : 'DELETE',
      '/api/rooms/$roomId/chat/messages/$messageId/reactions/$reactionKey',
      client.SetChatReactionResponse.create,
    );
  }

  Future<client.ReportContentResponse> reportContent(
    String roomId,
    client.ReportContentRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/reports',
      client.ReportContentResponse.create,
      body: request,
    );
  }

  Future<client.ListRoomContentReportsResponse> listRoomContentReports(
    String roomId,
    client.ListRoomContentReportsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/reports',
      client.ListRoomContentReportsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.GetRoomContentReportResponse> getRoomContentReport(
    String roomId,
    client.GetRoomContentReportRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/reports/${request.reportId}',
      client.GetRoomContentReportResponse.create,
    );
  }

  Future<client.UpdateRoomContentReportStatusResponse>
  updateRoomContentReportStatus(
    String roomId,
    client.UpdateRoomContentReportStatusRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/reports/${request.reportId}/status',
      client.UpdateRoomContentReportStatusResponse.create,
      body: request,
    );
  }

  Future<client.ListChatReactionUsersResponse> listChatReactionUsers(
    String roomId,
    client.ListChatReactionUsersRequest request,
  ) {
    final messageId = Uri.encodeComponent(request.messageId);
    final reactionKey = Uri.encodeComponent(request.reactionKey);
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/messages/$messageId/reactions/$reactionKey/users',
      client.ListChatReactionUsersResponse.create,
      query: _api._messageQuery(request)
        ..remove('messageId')
        ..remove('reactionKey'),
    );
  }

  Future<client.ChatReadStateResponse> markChatRead(
    String roomId,
    client.MarkChatReadRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/chat/read-state',
      client.ChatReadStateResponse.create,
      body: request,
    );
  }

  Future<client.ChatReadStateResponse> getChatReadState(
    String roomId,
    client.GetChatReadStateRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/read-state',
      client.ChatReadStateResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.GetChatMessageReadReceiptsResponse> getChatMessageReadReceipts(
    String roomId,
    client.GetChatMessageReadReceiptsRequest request,
  ) {
    final messageId = Uri.encodeComponent(request.messageId);
    return _api._send(
      'GET',
      '/api/rooms/$roomId/chat/messages/$messageId/read-receipts',
      client.GetChatMessageReadReceiptsResponse.create,
      query: _api._messageQuery(request)..remove('messageId'),
    );
  }

  Future<client.CreateChatAttachmentUploadSessionResponse>
  createChatAttachmentUploadSession(
    String roomId,
    client.CreateChatAttachmentUploadSessionRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/chat/attachments/upload-session',
      client.CreateChatAttachmentUploadSessionResponse.create,
      body: request,
    );
  }

  Future<client.UploadChatAttachmentObjectResponse> uploadChatAttachmentObject(
    client.UploadChatAttachmentObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._uploadFileObject(
      '/api/chat/attachment-objects/$key',
      token: request.token,
      data: request.data,
      contentType: request.contentType,
      contentRange: request.hasContentRange() ? request.contentRange : null,
    );
    return client.UploadChatAttachmentObjectResponse(
      complete: result.complete,
      uploadedSizeBytes: result.uploadedSizeBytes,
      uploadedParts: result.uploadedParts,
    );
  }

  Future<client.ChatAttachmentObjectResponse> getChatAttachmentObject(
    client.GetChatAttachmentObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._downloadFileObject(
      '/api/chat/attachment-objects/$key',
      token: request.token,
      range: request.hasRange() ? request.range : null,
    );
    return client.ChatAttachmentObjectResponse(
      roomId: request.roomId,
      mimeType: result.mimeType,
      contentManifestSha256: result.contentManifestSha256,
      data: result.data,
      contentRange: result.contentRange,
      totalSizeBytes: result.totalSizeBytes,
    );
  }

  Future<client.CompleteChatAttachmentUploadSessionResponse>
  completeChatAttachmentUploadSession(
    client.CompleteChatAttachmentUploadSessionRequest request,
  ) {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    return _api._send(
      'POST',
      '/api/chat/attachment-objects/$key/complete',
      client.CompleteChatAttachmentUploadSessionResponse.create,
      body: request,
      auth: false,
    );
  }

  Future<client.GetIceServersResponse> getIceServers(
    String roomId,
    client.GetIceServersRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/webrtc/ice-servers',
      client.GetIceServersResponse.create,
    );
  }

  Future<client.CreatePlaylistResponse> createPlaylist(
    String roomId,
    client.CreatePlaylistRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/playlists',
      client.CreatePlaylistResponse.create,
      body: request,
    );
  }

  Future<client.CreateRoomCoverUploadSessionResponse>
  createRoomCoverUploadSession(
    String roomId,
    client.CreateRoomCoverUploadSessionRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/cover/upload-session',
      client.CreateRoomCoverUploadSessionResponse.create,
      body: request,
    );
  }

  Future<client.UploadRoomCoverObjectResponse> uploadRoomCoverObject(
    client.UploadRoomCoverObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._uploadFileObject(
      '/api/room/cover-objects/$key',
      token: request.token,
      data: request.data,
      contentType: request.contentType,
      contentRange: request.hasContentRange() ? request.contentRange : null,
    );
    return client.UploadRoomCoverObjectResponse(
      complete: result.complete,
      uploadedSizeBytes: result.uploadedSizeBytes,
      uploadedParts: result.uploadedParts,
    );
  }

  Future<client.RoomCoverObjectResponse> getRoomCoverObject(
    client.GetRoomCoverObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._downloadFileObject(
      '/api/room/cover-objects/$key',
      token: request.token,
      range: request.hasRange() ? request.range : null,
    );
    return client.RoomCoverObjectResponse(
      mimeType: result.mimeType,
      contentManifestSha256: result.contentManifestSha256,
      data: result.data,
      contentRange: result.contentRange,
      totalSizeBytes: result.totalSizeBytes,
    );
  }

  Future<client.CompleteRoomCoverUploadSessionResponse>
  completeRoomCoverUploadSession(
    client.CompleteRoomCoverUploadSessionRequest request,
  ) {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    return _api._send(
      'POST',
      '/api/room/cover-objects/$key/complete',
      client.CompleteRoomCoverUploadSessionResponse.create,
      body: request,
      auth: false,
    );
  }

  Future<client.GetRoomResponse> updateRoomCover(
    String roomId,
    client.UpdateRoomCoverRequest request,
  ) {
    return _api._send(
      'PUT',
      '/api/rooms/$roomId/cover',
      client.GetRoomResponse.create,
      body: request,
    );
  }

  Future<client.GetRoomResponse> clearRoomCover(
    String roomId,
    client.ClearRoomCoverRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/cover',
      client.GetRoomResponse.create,
    );
  }

  Future<client.GetPlaylistResponse> getPlaylist(
    String roomId,
    client.GetPlaylistRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/playlists/${request.playlistId}',
      client.GetPlaylistResponse.create,
    );
  }

  Future<client.UpdatePlaylistResponse> updatePlaylist(
    String roomId,
    client.UpdatePlaylistRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/rooms/$roomId/playlists/${request.playlistId}',
      client.UpdatePlaylistResponse.create,
      body: request,
    );
  }

  Future<client.CreatePlaylistCoverUploadSessionResponse>
  createPlaylistCoverUploadSession(
    String roomId,
    client.CreatePlaylistCoverUploadSessionRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/playlists/${request.playlistId}/cover/upload-session',
      client.CreatePlaylistCoverUploadSessionResponse.create,
      body: request,
    );
  }

  Future<client.UploadPlaylistCoverObjectResponse> uploadPlaylistCoverObject(
    client.UploadPlaylistCoverObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._uploadFileObject(
      '/api/playlist/cover-objects/$key',
      token: request.token,
      data: request.data,
      contentType: request.contentType,
      contentRange: request.hasContentRange() ? request.contentRange : null,
    );
    return client.UploadPlaylistCoverObjectResponse(
      complete: result.complete,
      uploadedSizeBytes: result.uploadedSizeBytes,
      uploadedParts: result.uploadedParts,
    );
  }

  Future<client.PlaylistCoverObjectResponse> getPlaylistCoverObject(
    client.GetPlaylistCoverObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._downloadFileObject(
      '/api/playlist/cover-objects/$key',
      token: request.token,
      range: request.hasRange() ? request.range : null,
    );
    return client.PlaylistCoverObjectResponse(
      mimeType: result.mimeType,
      contentManifestSha256: result.contentManifestSha256,
      data: result.data,
      contentRange: result.contentRange,
      totalSizeBytes: result.totalSizeBytes,
    );
  }

  Future<client.CompletePlaylistCoverUploadSessionResponse>
  completePlaylistCoverUploadSession(
    client.CompletePlaylistCoverUploadSessionRequest request,
  ) {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    return _api._send(
      'POST',
      '/api/playlist/cover-objects/$key/complete',
      client.CompletePlaylistCoverUploadSessionResponse.create,
      body: request,
      auth: false,
    );
  }

  Future<client.UpdatePlaylistResponse> updatePlaylistCover(
    String roomId,
    client.UpdatePlaylistCoverRequest request,
  ) {
    return _api._send(
      'PUT',
      '/api/rooms/$roomId/playlists/${request.playlistId}/cover',
      client.UpdatePlaylistResponse.create,
      body: request,
    );
  }

  Future<client.UpdatePlaylistResponse> clearPlaylistCover(
    String roomId,
    client.ClearPlaylistCoverRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/playlists/${request.playlistId}/cover',
      client.UpdatePlaylistResponse.create,
    );
  }

  Future<client.MovePlaylistResponse> movePlaylist(
    String roomId,
    client.MovePlaylistRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/playlists/${request.playlistId}/move',
      client.MovePlaylistResponse.create,
      body: request,
    );
  }

  Future<client.DeletePlaylistResponse> deletePlaylist(
    String roomId,
    client.DeletePlaylistRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/playlists/${request.playlistId}',
      client.DeletePlaylistResponse.create,
      query: _api._messageQuery(
        client.DeletePlaylistQuery(force: request.force),
      ),
    );
  }

  Future<client.ListPlaylistsResponse> listPlaylists(
    String roomId,
    client.ListPlaylistsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/playlists',
      client.ListPlaylistsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.AddMediaResponse> addMedia(
    String roomId,
    client.AddMediaRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/media',
      client.AddMediaResponse.create,
      body: request,
    );
  }

  Future<client.Media> getMedia(String roomId, client.GetMediaRequest request) {
    return _api._send(
      'GET',
      '/api/rooms/$roomId/media/${request.mediaId}',
      client.Media.create,
    );
  }

  Future<client.DeleteMediaResponse> deleteMedia(
    String roomId,
    client.DeleteMediaRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/media/${request.mediaId}',
      client.DeleteMediaResponse.create,
      query: _api._messageQuery(client.DeleteMediaQuery(force: request.force)),
    );
  }

  Future<client.DeleteEntriesResponse> deleteEntries(
    String roomId,
    client.DeleteEntriesRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/entries',
      client.DeleteEntriesResponse.create,
      body: request,
    );
  }

  Future<client.EditMediaResponse> editMedia(
    String roomId,
    client.EditMediaRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/rooms/$roomId/media/${request.mediaId}',
      client.EditMediaResponse.create,
      body: request,
    );
  }

  Future<client.CreateMediaCoverUploadSessionResponse>
  createMediaCoverUploadSession(
    String roomId,
    client.CreateMediaCoverUploadSessionRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/media/${request.mediaId}/cover/upload-session',
      client.CreateMediaCoverUploadSessionResponse.create,
      body: request,
    );
  }

  Future<client.UploadMediaCoverObjectResponse> uploadMediaCoverObject(
    client.UploadMediaCoverObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._uploadFileObject(
      '/api/media/cover-objects/$key',
      token: request.token,
      data: request.data,
      contentType: request.contentType,
      contentRange: request.hasContentRange() ? request.contentRange : null,
    );
    return client.UploadMediaCoverObjectResponse(
      complete: result.complete,
      uploadedSizeBytes: result.uploadedSizeBytes,
      uploadedParts: result.uploadedParts,
    );
  }

  Future<client.MediaCoverObjectResponse> getMediaCoverObject(
    client.GetMediaCoverObjectRequest request,
  ) async {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    final result = await _api._downloadFileObject(
      '/api/media/cover-objects/$key',
      token: request.token,
      range: request.hasRange() ? request.range : null,
    );
    return client.MediaCoverObjectResponse(
      mimeType: result.mimeType,
      contentManifestSha256: result.contentManifestSha256,
      data: result.data,
      contentRange: result.contentRange,
      totalSizeBytes: result.totalSizeBytes,
    );
  }

  Future<client.CompleteMediaCoverUploadSessionResponse>
  completeMediaCoverUploadSession(
    client.CompleteMediaCoverUploadSessionRequest request,
  ) {
    final key = Uri.encodeComponent(request.encodedObjectKey);
    return _api._send(
      'POST',
      '/api/media/cover-objects/$key/complete',
      client.CompleteMediaCoverUploadSessionResponse.create,
      body: request,
      auth: false,
    );
  }

  Future<client.EditMediaResponse> updateMediaCover(
    String roomId,
    client.UpdateMediaCoverRequest request,
  ) {
    return _api._send(
      'PUT',
      '/api/rooms/$roomId/media/${request.mediaId}/cover',
      client.EditMediaResponse.create,
      body: request,
    );
  }

  Future<client.EditMediaResponse> clearMediaCover(
    String roomId,
    client.ClearMediaCoverRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/media/${request.mediaId}/cover',
      client.EditMediaResponse.create,
    );
  }

  Future<client.ListPlaylistItemsResponse> listPlaylistItems(
    String roomId,
    client.ListPlaylistItemsRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/media/list',
      client.ListPlaylistItemsResponse.create,
      body: request,
    );
  }

  Future<client.MoveMediaResponse> moveMedia(
    String roomId,
    client.MoveMediaRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/media/move',
      client.MoveMediaResponse.create,
      body: request,
    );
  }

  Future<client.ClearPlaylistResponse> clearPlaylist(
    String roomId,
    client.ClearPlaylistRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/rooms/$roomId/media',
      client.ClearPlaylistResponse.create,
      body: request,
    );
  }

  Future<client.AddMediaBatchResponse> addMediaBatch(
    String roomId,
    client.AddMediaBatchRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/media/batch',
      client.AddMediaBatchResponse.create,
      body: request,
    );
  }

  Future<client.StartPlaybackResponse> startPlayback(
    String roomId,
    client.StartPlaybackRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/playback/start',
      client.StartPlaybackResponse.create,
      body: request,
    );
  }

  Future<client.StopPlaybackResponse> stopPlayback(
    String roomId,
    client.StopPlaybackRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/rooms/$roomId/playback/stop',
      client.StopPlaybackResponse.create,
      body: request,
    );
  }

  Future<client.GetPlaybackResponse> getPlayback(
    String roomId,
    client.GetPlaybackRequest request,
  ) {
    final profile = request.hasPlaybackClientProfile()
        ? request.playbackClientProfile
        : defaultPlaybackClientProfile();
    return _api._send(
      'GET',
      '/api/rooms/$roomId/playback',
      client.GetPlaybackResponse.create,
      query: _api._playbackClientProfileQuery(profile),
    );
  }

  Future<client.UpdatePlaybackStateResponse> updatePlaybackState(
    String roomId,
    client.UpdatePlaybackStateRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/rooms/$roomId/playback',
      client.UpdatePlaybackStateResponse.create,
      body: request,
    );
  }
}

class SyncTvPublicApi {
  SyncTvPublicApi._(this._api);

  final SyncTvApiClient _api;

  Future<client.CheckRoomResponse> checkRoom(client.CheckRoomRequest request) {
    return _api._send(
      'GET',
      '/api/rooms/${request.roomId}/check',
      client.CheckRoomResponse.create,
      auth: false,
    );
  }

  Future<client.ListRoomsResponse> listRooms(client.ListRoomsRequest request) {
    return _api._send(
      'GET',
      '/api/rooms',
      client.ListRoomsResponse.create,
      auth: false,
      query: _api._messageQuery(request),
    );
  }

  Future<client.GetHotRoomsResponse> getHotRooms(
    client.GetHotRoomsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/hot',
      client.GetHotRoomsResponse.create,
      auth: false,
      query: _api._messageQuery(request),
    );
  }

  Future<client.GetPublicSettingsResponse> getPublicSettings(
    client.GetPublicSettingsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/public/settings',
      client.GetPublicSettingsResponse.create,
      auth: false,
    );
  }

  Future<client.GetServerInfoResponse> getServerInfo(
    client.GetServerInfoRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/public/server-info',
      client.GetServerInfoResponse.create,
      auth: false,
    );
  }

  Future<client.ListRoomCategoriesResponse> listRoomCategories(
    client.ListRoomCategoriesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/categories',
      client.ListRoomCategoriesResponse.create,
      auth: false,
      query: _api._messageQuery(request),
    );
  }

  Future<client.ListRoomLabelsResponse> listRoomLabels(
    client.ListRoomLabelsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/rooms/labels',
      client.ListRoomLabelsResponse.create,
      auth: false,
      query: _api._messageQuery(request),
    );
  }
}

class SyncTvEmailApi {
  SyncTvEmailApi._(this._api);

  final SyncTvApiClient _api;

  Future<client.RequestPasswordResetResponse> requestPasswordReset(
    client.RequestPasswordResetRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/email/password/reset',
      client.RequestPasswordResetResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.StartOpaquePasswordResetResponse> startOpaquePasswordReset(
    client.StartOpaquePasswordResetRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/email/password/opaque/start',
      client.StartOpaquePasswordResetResponse.create,
      auth: false,
      body: request,
    );
  }

  Future<client.ConfirmPasswordResetResponse> finishOpaquePasswordReset(
    client.FinishOpaquePasswordResetRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/email/password/opaque/finish',
      client.ConfirmPasswordResetResponse.create,
      auth: false,
      body: request,
    );
  }
}

class SyncTvNotificationApi {
  SyncTvNotificationApi._(this._api);

  final SyncTvApiClient _api;

  Future<client.ListNotificationsResponse> listNotifications(
    client.ListNotificationsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/notifications',
      client.ListNotificationsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<client.GetNotificationResponse> getNotification(
    client.GetNotificationRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/notifications/${request.notificationId}',
      client.GetNotificationResponse.create,
    );
  }

  Future<client.MarkAsReadResponse> markAsRead(
    client.MarkAsReadRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/notifications/actions/mark-read',
      client.MarkAsReadResponse.create,
      body: request,
    );
  }

  Future<client.MarkAllAsReadResponse> markAllAsRead(
    client.MarkAllAsReadRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/notifications/read-all',
      client.MarkAllAsReadResponse.create,
      body: request,
    );
  }

  Future<client.DeleteNotificationResponse> deleteNotification(
    client.DeleteNotificationRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/notifications/${request.notificationId}',
      client.DeleteNotificationResponse.create,
    );
  }

  Future<client.DeleteAllReadResponse> deleteAllRead(
    client.DeleteAllReadRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/notifications/read',
      client.DeleteAllReadResponse.create,
    );
  }
}

class SyncTvOAuth2Api {
  SyncTvOAuth2Api._(this._api);

  final SyncTvApiClient _api;

  Future<oauth2.GetAuthorizationUrlResponse> getAuthorizationUrl(
    oauth2.GetAuthorizationUrlRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/oauth2/${request.provider}/authorize',
      oauth2.GetAuthorizationUrlResponse.create,
      auth: false,
      query: _api._messageQuery(request)..remove('provider'),
    );
  }

  Future<oauth2.GetAuthorizationUrlForBindResponse> getAuthorizationUrlForBind(
    oauth2.GetAuthorizationUrlForBindRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/oauth2/${request.provider}/bind',
      oauth2.GetAuthorizationUrlForBindResponse.create,
      query: _api._messageQuery(request)..remove('provider'),
    );
  }

  Future<oauth2.ExchangeAuthorizationCodeResponse> exchangeAuthorizationCode(
    oauth2.ExchangeAuthorizationCodeRequest request,
  ) async {
    final response = await _api._send(
      'POST',
      '/api/oauth2/exchange',
      oauth2.ExchangeAuthorizationCodeResponse.create,
      auth: _api.session.hasAccessToken,
      body: request,
    );
    _api._storeLogin(response.accessToken, response.refreshToken);
    return response;
  }

  Future<oauth2.ListAvailableProvidersResponse> listAvailableProviders(
    oauth2.ListAvailableProvidersRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/oauth2/providers',
      oauth2.ListAvailableProvidersResponse.create,
      auth: false,
    );
  }

  Future<oauth2.UnlinkProviderResponse> unlinkProvider(
    oauth2.UnlinkProviderRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/oauth2/type/${oauth2ProviderTypeToString(request.provider)}/unlink',
      oauth2.UnlinkProviderResponse.create,
      query: _api._messageQuery(request)..remove('provider'),
    );
  }

  Future<oauth2.GetLinkedProvidersResponse> getLinkedProviders(
    oauth2.GetLinkedProvidersRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/oauth2/linked',
      oauth2.GetLinkedProvidersResponse.create,
    );
  }
}

class SyncTvAdminApi {
  SyncTvAdminApi._(this._api);

  final SyncTvApiClient _api;

  Future<admin.RuntimeSettings> getSettings(admin.GetSettingsRequest request) {
    return _api._send(
      'GET',
      '/api/admin/settings',
      admin.RuntimeSettings.create,
    );
  }

  Future<admin.RuntimeSettings> updateSettings(
    admin.UpdateSettingsRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/settings',
      admin.RuntimeSettings.create,
      body: request,
    );
  }

  Future<admin.SendTestEmailResponse> sendTestEmail(
    admin.SendTestEmailRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/email/test',
      admin.SendTestEmailResponse.create,
      body: request,
    );
  }

  Future<admin.CreateUserResponse> createUser(admin.CreateUserRequest request) {
    return _api._send(
      'POST',
      '/api/admin/users',
      admin.CreateUserResponse.create,
      body: request,
    );
  }

  Future<admin.DeleteUserResponse> deleteUser(admin.DeleteUserRequest request) {
    return _api._send(
      'DELETE',
      '/api/admin/users/${request.userId}',
      admin.DeleteUserResponse.create,
    );
  }

  Future<admin.ListUsersResponse> listUsers(admin.ListUsersRequest request) {
    return _api._send(
      'GET',
      '/api/admin/users',
      admin.ListUsersResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.GetUserResponse> getUser(admin.GetUserRequest request) {
    return _api._send(
      'GET',
      '/api/admin/users/${request.userId}',
      admin.GetUserResponse.create,
    );
  }

  Future<admin.GetUserPreferencesResponse> getUserPreferences(
    admin.GetUserPreferencesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/users/${request.userId}/preferences',
      admin.GetUserPreferencesResponse.create,
    );
  }

  Future<admin.UpdateUserPreferencesResponse> updateUserPreferences(
    admin.UpdateUserPreferencesRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/admin/users/${request.userId}/preferences',
      admin.UpdateUserPreferencesResponse.create,
      body: request,
    );
  }

  Future<admin.SetUserPasswordResponse> setUserPassword(
    admin.SetUserPasswordRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/users/${request.userId}/password',
      admin.SetUserPasswordResponse.create,
      body: request,
    );
  }

  Future<admin.UpdateUserUsernameResponse> updateUserUsername(
    admin.UpdateUserUsernameRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/users/${request.userId}/username',
      admin.UpdateUserUsernameResponse.create,
      body: request,
    );
  }

  Future<admin.UpdateUserRoleResponse> updateUserRole(
    admin.UpdateUserRoleRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/users/${request.userId}/role',
      admin.UpdateUserRoleResponse.create,
      body: request,
    );
  }

  Future<admin.BanUserResponse> banUser(admin.BanUserRequest request) {
    return _api._send(
      'POST',
      '/api/admin/users/${request.userId}/ban',
      admin.BanUserResponse.create,
      body: request,
    );
  }

  Future<admin.UnbanUserResponse> unbanUser(admin.UnbanUserRequest request) {
    return _api._send(
      'POST',
      '/api/admin/users/${request.userId}/unban',
      admin.UnbanUserResponse.create,
    );
  }

  Future<admin.GetUserRoomsResponse> getUserRooms(
    admin.GetUserRoomsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/users/${request.userId}/rooms',
      admin.GetUserRoomsResponse.create,
      query: _api._messageQuery(request)..remove('userId'),
    );
  }

  Future<admin.BatchBanUsersResponse> batchBanUsers(
    admin.BatchBanUsersRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/users/batch/ban',
      admin.BatchBanUsersResponse.create,
      body: request,
    );
  }

  Future<admin.BatchDeleteUsersResponse> batchDeleteUsers(
    admin.BatchDeleteUsersRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/users/batch/delete',
      admin.BatchDeleteUsersResponse.create,
      body: request,
    );
  }

  Future<admin.ListRoomsResponse> listRooms(admin.ListRoomsRequest request) {
    return _api._send(
      'GET',
      '/api/admin/rooms',
      admin.ListRoomsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.DeleteRoomResponse> deleteRoom(admin.DeleteRoomRequest request) {
    return _api._send(
      'DELETE',
      '/api/admin/rooms/${request.roomId}',
      admin.DeleteRoomResponse.create,
    );
  }

  Future<admin.GetRoomResponse> getRoom(admin.GetRoomRequest request) {
    return _api._send(
      'GET',
      '/api/admin/rooms/${request.roomId}',
      admin.GetRoomResponse.create,
    );
  }

  Future<admin.GetRoomSettingsResponse> getRoomSettings(
    admin.GetRoomSettingsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/rooms/${request.roomId}/settings',
      admin.GetRoomSettingsResponse.create,
    );
  }

  Future<admin.Room> updateRoomSettings(
    admin.UpdateRoomSettingsRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/rooms/${request.roomId}/settings',
      admin.Room.create,
      body: request,
    );
  }

  Future<admin.ResetRoomSettingsResponse> resetRoomSettings(
    admin.ResetRoomSettingsRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/rooms/${request.roomId}/settings/reset',
      admin.ResetRoomSettingsResponse.create,
      body: request,
    );
  }

  Future<admin.UpdateRoomPasswordResponse> updateRoomPassword(
    admin.UpdateRoomPasswordRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/rooms/${request.roomId}/password',
      admin.UpdateRoomPasswordResponse.create,
      body: request,
    );
  }

  Future<admin.BanRoomResponse> banRoom(admin.BanRoomRequest request) {
    return _api._send(
      'POST',
      '/api/admin/rooms/${request.roomId}/ban',
      admin.BanRoomResponse.create,
      body: request,
    );
  }

  Future<admin.UnbanRoomResponse> unbanRoom(admin.UnbanRoomRequest request) {
    return _api._send(
      'POST',
      '/api/admin/rooms/${request.roomId}/unban',
      admin.UnbanRoomResponse.create,
    );
  }

  Future<admin.GetRoomMembersResponse> getRoomMembers(
    admin.GetRoomMembersRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/rooms/${request.roomId}/members',
      admin.GetRoomMembersResponse.create,
      query: _api._messageQuery(request)..remove('roomId'),
    );
  }

  Future<admin.AddMemberResponse> addMember(admin.AddMemberRequest request) {
    return _api._send(
      'POST',
      '/api/admin/rooms/${request.roomId}/members',
      admin.AddMemberResponse.create,
      body: request,
    );
  }

  Future<admin.UpdateMemberPermissionsResponse> updateMemberPermissions(
    admin.UpdateMemberPermissionsRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/admin/rooms/${request.roomId}/members/${request.userId}',
      admin.UpdateMemberPermissionsResponse.create,
      body: request,
    );
  }

  Future<admin.KickMemberResponse> kickMember(admin.KickMemberRequest request) {
    return _api._send(
      'DELETE',
      '/api/admin/rooms/${request.roomId}/members/${request.userId}',
      admin.KickMemberResponse.create,
      body: request,
    );
  }

  Future<admin.ListRoomCategoriesResponse> listRoomCategories(
    admin.ListRoomCategoriesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/rooms/categories',
      admin.ListRoomCategoriesResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.UpsertRoomCategoryResponse> upsertRoomCategory(
    admin.UpsertRoomCategoryRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/rooms/categories',
      admin.UpsertRoomCategoryResponse.create,
      body: request,
    );
  }

  Future<admin.DeleteRoomCategoryResponse> deleteRoomCategory(
    admin.DeleteRoomCategoryRequest request,
  ) {
    final categoryId = Uri.encodeComponent(request.categoryId);
    return _api._send(
      'DELETE',
      '/api/admin/rooms/categories/$categoryId',
      admin.DeleteRoomCategoryResponse.create,
    );
  }

  Future<admin.ListRoomLabelsResponse> listRoomLabels(
    admin.ListRoomLabelsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/rooms/labels',
      admin.ListRoomLabelsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.UpsertRoomLabelResponse> upsertRoomLabel(
    admin.UpsertRoomLabelRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/rooms/labels',
      admin.UpsertRoomLabelResponse.create,
      body: request,
    );
  }

  Future<admin.DeleteRoomLabelResponse> deleteRoomLabel(
    admin.DeleteRoomLabelRequest request,
  ) {
    final labelId = Uri.encodeComponent(request.labelId);
    return _api._send(
      'DELETE',
      '/api/admin/rooms/labels/$labelId',
      admin.DeleteRoomLabelResponse.create,
    );
  }

  Future<admin.UpdateRoomTaxonomyResponse> updateRoomTaxonomy(
    admin.UpdateRoomTaxonomyRequest request,
  ) {
    return _api._send(
      'PATCH',
      '/api/admin/rooms/${request.roomId}/taxonomy',
      admin.UpdateRoomTaxonomyResponse.create,
      body: request,
    );
  }

  Future<admin.BatchBanRoomsResponse> batchBanRooms(
    admin.BatchBanRoomsRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/rooms/batch/ban',
      admin.BatchBanRoomsResponse.create,
      body: request,
    );
  }

  Future<admin.BatchDeleteRoomsResponse> batchDeleteRooms(
    admin.BatchDeleteRoomsRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/rooms/batch/delete',
      admin.BatchDeleteRoomsResponse.create,
      body: request,
    );
  }

  Future<admin.AddAdminResponse> addAdmin(admin.AddAdminRequest request) {
    return _api._send(
      'POST',
      '/api/admin/admins/${request.userId}',
      admin.AddAdminResponse.create,
      body: request,
    );
  }

  Future<admin.RemoveAdminResponse> removeAdmin(
    admin.RemoveAdminRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/admin/admins/${request.userId}',
      admin.RemoveAdminResponse.create,
    );
  }

  Future<admin.ListAdminsResponse> listAdmins(admin.ListAdminsRequest request) {
    return _api._send(
      'GET',
      '/api/admin/admins',
      admin.ListAdminsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.GetSystemStatsResponse> getSystemStats(
    admin.GetSystemStatsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/stats',
      admin.GetSystemStatsResponse.create,
    );
  }

  Future<admin.ListActiveStreamsResponse> listActiveStreams(
    admin.ListActiveStreamsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/streams',
      admin.ListActiveStreamsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.KickStreamResponse> kickStream(admin.KickStreamRequest request) {
    return _api._send(
      'POST',
      '/api/admin/streams/kick',
      admin.KickStreamResponse.create,
      body: request,
    );
  }

  Future<admin.ListUserRegistrationReviewsResponse> listUserRegistrationReviews(
    admin.ListUserRegistrationReviewsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/reviews/user-registrations',
      admin.ListUserRegistrationReviewsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.ApproveUserRegistrationReviewResponse>
  approveUserRegistrationReview(
    admin.ApproveUserRegistrationReviewRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/reviews/user-registrations/approve',
      admin.ApproveUserRegistrationReviewResponse.create,
      body: request,
    );
  }

  Future<admin.RejectUserRegistrationReviewResponse>
  rejectUserRegistrationReview(
    admin.RejectUserRegistrationReviewRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/reviews/user-registrations/reject',
      admin.RejectUserRegistrationReviewResponse.create,
      body: request,
    );
  }

  Future<admin.ListRoomCreationReviewsResponse> listRoomCreationReviews(
    admin.ListRoomCreationReviewsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/reviews/room-creations',
      admin.ListRoomCreationReviewsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.ApproveRoomCreationReviewResponse> approveRoomCreationReview(
    admin.ApproveRoomCreationReviewRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/reviews/room-creations/approve',
      admin.ApproveRoomCreationReviewResponse.create,
      body: request,
    );
  }

  Future<admin.RejectRoomCreationReviewResponse> rejectRoomCreationReview(
    admin.RejectRoomCreationReviewRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/reviews/room-creations/reject',
      admin.RejectRoomCreationReviewResponse.create,
      body: request,
    );
  }

  Future<admin.ListRoomJoinReviewsResponse> listRoomJoinReviews(
    admin.ListRoomJoinReviewsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/reviews/room-joins',
      admin.ListRoomJoinReviewsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.ApproveRoomJoinReviewResponse> approveRoomJoinReview(
    admin.ApproveRoomJoinReviewRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/reviews/room-joins/approve',
      admin.ApproveRoomJoinReviewResponse.create,
      body: request,
    );
  }

  Future<admin.RejectRoomJoinReviewResponse> rejectRoomJoinReview(
    admin.RejectRoomJoinReviewRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/reviews/room-joins/reject',
      admin.RejectRoomJoinReviewResponse.create,
      body: request,
    );
  }

  Future<admin.ListBanRecordsResponse> listBanRecords(
    admin.ListBanRecordsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/bans',
      admin.ListBanRecordsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.ListContentReportsResponse> listContentReports(
    admin.ListContentReportsRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/reports',
      admin.ListContentReportsResponse.create,
      query: _api._messageQuery(request),
    );
  }

  Future<admin.GetContentReportResponse> getContentReport(
    admin.GetContentReportRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/admin/reports/${request.reportId}',
      admin.GetContentReportResponse.create,
    );
  }

  Future<admin.UpdateContentReportStatusResponse> updateContentReportStatus(
    admin.UpdateContentReportStatusRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/admin/reports/${request.reportId}/status',
      admin.UpdateContentReportStatusResponse.create,
      body: request,
    );
  }
}

class SyncTvProviderCommonApi {
  SyncTvProviderCommonApi._(this._api);

  final SyncTvApiClient _api;

  Future<provider_common.ProviderBackendsResponse> listProviderBackends(
    provider_common.ListProviderBackendsRequest request,
  ) {
    final provider = SourceConfigCodec.providerToString(request.providerType);
    return _api._send(
      'GET',
      '/api/providers/backends/${Uri.encodeComponent(provider)}',
      provider_common.ProviderBackendsResponse.create,
    );
  }

  Future<provider_common.ProviderInstancesResponse>
  listAvailableProviderInstances(
    provider_common.ListAvailableProviderInstancesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/providers/instances/available',
      provider_common.ProviderInstancesResponse.create,
      query: {
        'providerType': SourceConfigCodec.providerToString(
          request.providerType,
        ),
      },
    );
  }

  Future<provider_common.ListProviderInstancesResponse> listProviderInstances(
    provider_common.ListProviderInstancesRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/providers/instances',
      provider_common.ListProviderInstancesResponse.create,
      query: {
        'page': request.page.toString(),
        'pageSize': request.pageSize.toString(),
        'providerType': SourceConfigCodec.providerToString(
          request.providerType,
        ),
        'search': request.search,
        if (request.hasEnabled()) 'enabled': request.enabled.toString(),
        if (request.hasTls()) 'tls': request.tls.toString(),
        'sortBy': request.sortBy.value.toString(),
        'sortDirection': request.sortDirection.value.toString(),
      },
    );
  }

  Future<provider_common.AddProviderInstanceResponse> addProviderInstance(
    provider_common.AddProviderInstanceRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/providers/instances',
      provider_common.AddProviderInstanceResponse.create,
      body: request,
    );
  }

  Future<provider_common.UpdateProviderInstanceResponse> updateProviderInstance(
    provider_common.UpdateProviderInstanceRequest request,
  ) {
    return _api._send(
      'PUT',
      '/api/providers/instances/${request.name}',
      provider_common.UpdateProviderInstanceResponse.create,
      body: request,
    );
  }

  Future<provider_common.DeleteProviderInstanceResponse> deleteProviderInstance(
    provider_common.DeleteProviderInstanceRequest request,
  ) {
    return _api._send(
      'DELETE',
      '/api/providers/instances/${request.name}',
      provider_common.DeleteProviderInstanceResponse.create,
    );
  }

  Future<provider_common.ReconnectProviderInstanceResponse>
  reconnectProviderInstance(
    provider_common.ReconnectProviderInstanceRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/providers/instances/${request.name}/reconnect',
      provider_common.ReconnectProviderInstanceResponse.create,
    );
  }

  Future<provider_common.EnableProviderInstanceResponse> enableProviderInstance(
    provider_common.EnableProviderInstanceRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/providers/instances/${request.name}/enable',
      provider_common.EnableProviderInstanceResponse.create,
    );
  }

  Future<provider_common.DisableProviderInstanceResponse>
  disableProviderInstance(
    provider_common.DisableProviderInstanceRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/providers/instances/${request.name}/disable',
      provider_common.DisableProviderInstanceResponse.create,
    );
  }
}

class SyncTvAlistProviderApi {
  SyncTvAlistProviderApi._(this._api);

  final SyncTvApiClient _api;

  Future<alist.LoginResponse> login(alist.LoginRequest request) {
    return _api._send(
      'POST',
      '/api/providers/alist/login',
      alist.LoginResponse.create,
      body: request,
    );
  }

  Future<alist.ListResponse> list(alist.ListRequest request) {
    final body = request.deepCopy()
      ..path = request.path == '/' ? '' : request.path;
    return _api._send(
      'POST',
      '/api/providers/alist/list',
      alist.ListResponse.create,
      body: body,
    );
  }

  Future<alist.SearchResponse> search(alist.SearchRequest request) {
    final body = request.deepCopy()
      ..parent = request.parent == '/' ? '' : request.parent;
    return _api._send(
      'POST',
      '/api/providers/alist/search',
      alist.SearchResponse.create,
      body: body,
    );
  }

  Future<alist.GetMeResponse> getMe(alist.GetMeRequest request) {
    return _api._send(
      'POST',
      '/api/providers/alist/me',
      alist.GetMeResponse.create,
      body: request,
    );
  }

  Future<alist.LogoutResponse> logout(alist.LogoutRequest request) {
    return _api._send(
      'POST',
      '/api/providers/alist/logout',
      alist.LogoutResponse.create,
      body: request,
    );
  }

  Future<alist.GetBindsResponse> getBinds(alist.GetBindsRequest request) {
    return _api._send(
      'GET',
      '/api/providers/alist/binds',
      alist.GetBindsResponse.create,
      query: _api._messageQuery(request),
    );
  }
}

class SyncTvEmbyProviderApi {
  SyncTvEmbyProviderApi._(this._api);

  final SyncTvApiClient _api;

  Future<emby.LoginResponse> login(emby.LoginRequest request) {
    return _api._send(
      'POST',
      '/api/providers/emby/login',
      emby.LoginResponse.create,
      body: request,
    );
  }

  Future<emby.ListResponse> list(emby.ListRequest request) {
    final body = request.deepCopy()
      ..path = request.path == '/' ? '' : request.path;
    return _api._send(
      'POST',
      '/api/providers/emby/list',
      emby.ListResponse.create,
      body: body,
    );
  }

  Future<emby.GetMeResponse> getMe(emby.GetMeRequest request) {
    return _api._send(
      'POST',
      '/api/providers/emby/me',
      emby.GetMeResponse.create,
      body: request,
    );
  }

  Future<emby.LogoutResponse> logout(emby.LogoutRequest request) {
    return _api._send(
      'POST',
      '/api/providers/emby/logout',
      emby.LogoutResponse.create,
      body: request,
    );
  }

  Future<emby.GetBindsResponse> getBinds(emby.GetBindsRequest request) {
    return _api._send(
      'GET',
      '/api/providers/emby/binds',
      emby.GetBindsResponse.create,
      query: _api._messageQuery(request),
    );
  }
}

class SyncTvBilibiliProviderApi {
  SyncTvBilibiliProviderApi._(this._api);

  final SyncTvApiClient _api;

  Future<bilibili.ParseResponse> parse(bilibili.ParseRequest request) {
    return _api._send(
      'POST',
      '/api/providers/bilibili/parse',
      bilibili.ParseResponse.create,
      body: request,
    );
  }

  Future<bilibili.QRCodeResponse> loginQR(bilibili.LoginQRRequest request) {
    return _api._send(
      'POST',
      '/api/providers/bilibili/login/qr/generate',
      bilibili.QRCodeResponse.create,
      body: request,
    );
  }

  Future<bilibili.QRStatusResponse> checkQR(bilibili.CheckQRRequest request) {
    return _api._send(
      'POST',
      '/api/providers/bilibili/login/qr/check',
      bilibili.QRStatusResponse.create,
      body: request,
    );
  }

  Future<bilibili.StartSMSLoginResponse> startSMSLogin(
    bilibili.StartSMSLoginRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/providers/bilibili/login/sms/start',
      bilibili.StartSMSLoginResponse.create,
      body: request,
    );
  }

  Future<bilibili.SendSMSResponse> sendSMS(bilibili.SendSMSRequest request) {
    return _api._send(
      'POST',
      '/api/providers/bilibili/login/sms/send',
      bilibili.SendSMSResponse.create,
      body: request,
    );
  }

  Future<bilibili.LoginSMSResponse> loginSMS(bilibili.LoginSMSRequest request) {
    return _api._send(
      'POST',
      '/api/providers/bilibili/login/sms/login',
      bilibili.LoginSMSResponse.create,
      body: request,
    );
  }

  Future<bilibili.UserInfoResponse> getUserInfo(
    bilibili.UserInfoRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/providers/bilibili/me',
      bilibili.UserInfoResponse.create,
      body: request,
    );
  }

  Future<bilibili.LogoutResponse> logout(bilibili.LogoutRequest request) {
    return _api._send(
      'POST',
      '/api/providers/bilibili/logout',
      bilibili.LogoutResponse.create,
      body: request,
    );
  }

  Future<bilibili.GetBindsResponse> getBinds(bilibili.GetBindsRequest request) {
    return _api._send(
      'GET',
      '/api/providers/bilibili/binds',
      bilibili.GetBindsResponse.create,
      query: _api._messageQuery(request),
    );
  }
}

class SyncTvRtmpProviderApi {
  SyncTvRtmpProviderApi._(this._api);

  final SyncTvApiClient _api;

  Future<rtmp.CreatePublishKeyResponse> createPublishKey(
    rtmp.CreatePublishKeyRequest request,
  ) {
    return _api._send(
      'POST',
      '/api/providers/rtmp/rooms/${request.roomId}/publish-key/${request.mediaId}',
      rtmp.CreatePublishKeyResponse.create,
    );
  }

  Future<rtmp.GetStreamInfoResponse> getStreamInfo(
    rtmp.GetStreamInfoRequest request,
  ) {
    return _api._send(
      'GET',
      '/api/providers/rtmp/rooms/${request.roomId}/info/${request.mediaId}',
      rtmp.GetStreamInfoResponse.create,
    );
  }
}
