import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_cubit.dart';
import 'biometric_state.dart';

class BiometricCubit extends Cubit<BiometricState> {
  final AuthRepository _repository;
  final AuthCubit _authCubit;

  BiometricCubit(this._repository, this._authCubit) : super(BiometricInitial());

  Future<void> checkAvailability() async {
    emit(BiometricCheckingAvailability());

    try {
      final isAvailable = await _repository.isBiometricAvailable();
      emit(BiometricAvailable(isAvailable: isAvailable));
    } catch (e) {
      emit(BiometricAvailable(isAvailable: false));
    }
  }

  Future<void> authenticate({
    required String userId,
    required String reason,
    bool savePreference = false,
  }) async {
    emit(BiometricScanning());

    try {
      final authenticated = await _repository.authenticateWithBiometric(reason);

      if (authenticated) {
        if (savePreference) {
          await _repository.saveBiometricPreference(userId, true);
        }
        emit(BiometricSuccess());
      } else {
        emit(BiometricFailed(message: 'Authentication failed'));
      }
    } catch (e) {
      emit(BiometricFailed(message: e.toString()));
    }
  }

  Future<void> completeLogin() async {
    try {
      await _authCubit.loginWithBiometric();
    } catch (e) {
      emit(BiometricError(e.toString()));
    }
  }

  Future<void> skip(String userId) async {
    try {
      await _repository.saveBiometricPreference(userId, false);
      emit(BiometricSkipped());
    } catch (e) {
      emit(BiometricError(e.toString()));
    }
  }

  void reset() {
    emit(BiometricInitial());
  }
}
