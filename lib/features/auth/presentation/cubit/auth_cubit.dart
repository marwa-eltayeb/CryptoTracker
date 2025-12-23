import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/security/session_manager.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';
import 'dart:async';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  Timer? _sessionTimer;

  AuthCubit(this._repository) : super(AuthInitial());

  // Login
  Future<void> login({required String email, required String password,}) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(
        email: email,
        password: password,
      );

      await SessionManager.saveSession(user.id);
      emit(AuthAuthenticated(user));

      _startSessionMonitoring();
    } on Failures catch (failure) {
      emit(AuthError(failure.errMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  // Register
  Future<void> register({required String email, required String password, String? username, String? phoneNumber,}) async {
    emit(AuthLoading());
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        username: username,
        phoneNumber: phoneNumber,
      );

      await SessionManager.saveSession(user.id);
      emit(AuthAuthenticated(user));

      _startSessionMonitoring();
    } on Failures catch (failure) {
      emit(AuthError(failure.errMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  // Logout
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _repository.logout();
      await SessionManager.clearSession();

      _sessionTimer?.cancel();

      emit(AuthUnauthenticated());
    } on Failures catch (failure) {
      emit(AuthError(failure.errMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }


  void _startSessionMonitoring() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 10), (_) async {

      if (state is AuthAuthenticated) {
        final hasValidSession = await SessionManager.hasSession();
        if (!hasValidSession) {
          await SessionManager.clearSession();
          _sessionTimer?.cancel();
          emit(AuthUnauthenticated());
        } else {
          print('Session still valid');
        }
      }
    });
  }

  @override
  Future<void> close() {
    _sessionTimer?.cancel();
    return super.close();
  }
}