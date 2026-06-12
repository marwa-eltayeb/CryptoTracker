import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  static const _storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true),);
  static const _lastActiveKey = 'last_active_time';
  static const _timeoutMinutes = 3;

  static Future<void> updateActivity() async {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    await _storage.write(key: _lastActiveKey, value: now);
  }

  static Future<bool> isInactivityTimeout() async {
    final lastActiveStr = await _storage.read(key: _lastActiveKey);
    if (lastActiveStr == null) return false;

    final lastActive = DateTime.fromMillisecondsSinceEpoch(int.parse(lastActiveStr));
    final diff = DateTime.now().difference(lastActive);
    return diff.inMinutes >= _timeoutMinutes;
  }

  static Future<void> clearActivity() async {
    await _storage.delete(key: _lastActiveKey);
  }
}