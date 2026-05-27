import 'package:shared_preferences/shared_preferences.dart';

import 'package:synctv_app/services/synctv_api_client.dart';

class SyncTvSessionStore {
  SyncTvSessionStore(this.session);

  static const String tokenKey = 'synctv_token';
  static const String refreshTokenKey = 'synctv_refresh_token';
  static const String guestTokenKey = 'synctv_guest_token';
  static const String guestRoomKey = 'synctv_guest_room_id';
  static const String guestDisplayNameKey = 'synctv_guest_display_name';
  static const String baseUrlKey = 'synctv_base_url';
  static const String defaultBaseUrl = 'http://127.0.0.1:8080';

  final SyncTvSession session;

  String baseUrl = defaultBaseUrl;
  String? guestRoomId;
  String? guestDisplayName;

  bool get isGuestSession => session.isGuest;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString(baseUrlKey) ?? defaultBaseUrl;
    final guestToken = prefs.getString(guestTokenKey);
    if (guestToken != null && guestToken.isNotEmpty) {
      session.accessToken = guestToken;
      session.refreshToken = null;
      session.isGuest = true;
      guestRoomId = prefs.getString(guestRoomKey);
      guestDisplayName = prefs.getString(guestDisplayNameKey);
      return;
    }

    session.accessToken = prefs.getString(tokenKey);
    session.refreshToken = prefs.getString(refreshTokenKey);
    session.isGuest = false;
    guestRoomId = null;
    guestDisplayName = null;
  }

  Future<void> setBaseUrl(String normalizedBaseUrl) async {
    baseUrl = normalizedBaseUrl;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(baseUrlKey, baseUrl);
  }

  Future<void> persistTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = session.accessToken;
    final refreshToken = session.refreshToken;
    if (session.isGuest) {
      await prefs.remove(tokenKey);
      await prefs.remove(refreshTokenKey);
      if (accessToken == null || accessToken.isEmpty) {
        await prefs.remove(guestTokenKey);
        await prefs.remove(guestRoomKey);
        await prefs.remove(guestDisplayNameKey);
      } else {
        await prefs.setString(guestTokenKey, accessToken);
        final roomId = guestRoomId;
        final displayName = guestDisplayName;
        if (roomId != null) {
          await prefs.setString(guestRoomKey, roomId);
        }
        if (displayName != null) {
          await prefs.setString(guestDisplayNameKey, displayName);
        }
      }
      return;
    }

    await prefs.remove(guestTokenKey);
    await prefs.remove(guestRoomKey);
    await prefs.remove(guestDisplayNameKey);
    if (accessToken == null || accessToken.isEmpty) {
      await prefs.remove(tokenKey);
    } else {
      await prefs.setString(tokenKey, accessToken);
    }
    if (refreshToken == null || refreshToken.isEmpty) {
      await prefs.remove(refreshTokenKey);
    } else {
      await prefs.setString(refreshTokenKey, refreshToken);
    }
  }

  Future<void> clearGuestContextAndPersist() async {
    guestRoomId = null;
    guestDisplayName = null;
    await persistTokens();
  }

  Future<void> activateGuest({
    required String accessToken,
    required String roomId,
    required String displayName,
  }) async {
    session.accessToken = accessToken;
    session.refreshToken = null;
    session.isGuest = true;
    guestRoomId = roomId;
    guestDisplayName = displayName;
    await persistTokens();
  }
}
