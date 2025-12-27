import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialStorage {
  static const _storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  static const _emailKey = 'user_email';
  static const _passwordKey = 'user_password';

  static Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  static Future<Map<String, String>?> getCredentials() async {
    final email = await _storage.read(key: _emailKey);
    final password = await _storage.read(key: _passwordKey);
    if (email == null || password == null) return null;
    return {'email': email, 'password': password};
  }

  static Future<void> clearCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }

  static Future<bool> hasCredentials() async {
    final email = await _storage.read(key: _emailKey);
    return email != null;
  }
}