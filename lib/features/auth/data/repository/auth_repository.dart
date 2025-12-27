import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> register({
    required String email,
    required String password,
    String? username,
    String? phoneNumber,
  });
  Future<UserModel> login({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();

  Future<bool> isBiometricAvailable();
  Future<bool> authenticateWithBiometric(String reason);
  Future<void> saveBiometricPreference(String userId, bool enabled);
  Future<bool> getBiometricPreference(String userId);
  Future<bool> canUseBiometricLogin(String userId);
}

