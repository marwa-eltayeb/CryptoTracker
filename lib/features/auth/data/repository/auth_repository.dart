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
}

