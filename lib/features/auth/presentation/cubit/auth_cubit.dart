import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/security/credential_storage.dart';
import '../../../../core/security/session_manager.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';
import 'dart:async';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  Timer? _sessionTimer;
  AuthState? previousState;

  AuthCubit(this._repository) : super(AuthInitial());

  @override
  void emit(AuthState state) {
    previousState = this.state;
    super.emit(state);
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(
        email: email,
        password: password,
      );

      await CredentialStorage.saveCredentials(email, password);
      await SessionManager.updateActivity();
      emit(AuthAuthenticated(user));
      _startSessionMonitoring();
    } on Failures catch (failure) {
      emit(AuthError(failure.errMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }


  Future<void> register({required String email, required String password, String? username, String? phoneNumber,}) async {
    emit(AuthLoading());
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        username: username,
        phoneNumber: phoneNumber,
      );

      await CredentialStorage.saveCredentials(email, password);
      await SessionManager.updateActivity();
      emit(AuthAuthenticated(user));
      _startSessionMonitoring();
    } on Failures catch (failure) {
      emit(AuthError(failure.errMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }


  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _repository.logout();
      await FirebaseAuth.instance.signOut();
      await SessionManager.clearActivity();
      _sessionTimer?.cancel();

      emit(AuthUnauthenticated());
    } on Failures catch (failure) {
      emit(AuthError(failure.errMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> loginWithBiometric() async {
    emit(AuthLoading());
    try {
      final credentials = await CredentialStorage.getCredentials();

      if (credentials == null) {
        emit(AuthError('No stored credentials found for biometric login'));
        return;
      }

      final user = await _repository.login(
        email: credentials['email']!,
        password: credentials['password']!,
      );
      await SessionManager.updateActivity();
      emit(AuthAuthenticated(user));
      _startSessionMonitoring();

    } on Failures catch (failure) {
      emit(AuthError(failure.errMessage));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: $e'));
    }
  }

  void _startSessionMonitoring() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (state is AuthAuthenticated) {
        final timedOut = await SessionManager.isInactivityTimeout();
        if (timedOut) {
          await SessionManager.clearActivity();
          await FirebaseAuth.instance.signOut();
          _sessionTimer?.cancel();
          emit(AuthUnauthenticated());
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