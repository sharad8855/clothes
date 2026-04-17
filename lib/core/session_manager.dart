import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Persists and retrieves auth tokens + user data between app sessions.
class SessionManager {
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUser = 'user_json';
  static const _keySelectedBusinessId = 'selected_business_id';

  // ─── Singleton ─────────────────────────────────────────────────────────────
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  SharedPreferences? _prefs;

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ─── Save session ──────────────────────────────────────────────────────────
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
  }) async {
    await _init();
    await _prefs!.setString(_keyAccessToken, accessToken);
    await _prefs!.setString(_keyRefreshToken, refreshToken);
    await _prefs!.setString(_keyUser, jsonEncode(user.toJson()));
  }

  // ─── Read session ──────────────────────────────────────────────────────────
  Future<String?> getAccessToken() async {
    await _init();
    return _prefs!.getString(_keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    await _init();
    return _prefs!.getString(_keyRefreshToken);
  }

  Future<UserModel?> getUser() async {
    await _init();
    final raw = _prefs!.getString(_keyUser);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ─── Selected Business ───────────────────────────────────────────────────
  Future<void> saveSelectedBusinessId(String businessId) async {
    await _init();
    await _prefs!.setString(_keySelectedBusinessId, businessId);
  }

  Future<String?> getSelectedBusinessId() async {
    await _init();
    return _prefs!.getString(_keySelectedBusinessId);
  }

  // ─── Clear session (logout) ────────────────────────────────────────────────
  Future<void> clearSession() async {
    await _init();
    await _prefs!.remove(_keyAccessToken);
    await _prefs!.remove(_keyRefreshToken);
    await _prefs!.remove(_keyUser);
    await _prefs!.remove(_keySelectedBusinessId);
  }
}
