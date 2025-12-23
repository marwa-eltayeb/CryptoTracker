import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _expiryKey = 'auth_token_expiry';

  static Future<void> saveSession(String userId) async {
    final expireAt = DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch.toString();
    await _storage.write(key: _tokenKey, value: userId);
    await _storage.write(key: _expiryKey, value: expireAt);
  }

  static Future<String?> getSession() async {
    final userId = await _storage.read(key: _tokenKey);
    final expireAtStr = await _storage.read(key: _expiryKey);

    if (userId == null || expireAtStr == null) return null;

    final expireAt = DateTime.fromMillisecondsSinceEpoch(int.parse(expireAtStr));
    if (DateTime.now().isAfter(expireAt)) {
      await clearSession();
      return null;
    }
    return userId;
  }

  static Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _expiryKey);
  }

  static Future<bool> hasSession() async {
    return (await getSession()) != null;
  }
}