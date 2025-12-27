sealed class BiometricState {}

class BiometricInitial extends BiometricState {}

class BiometricCheckingAvailability extends BiometricState {}

class BiometricAvailable extends BiometricState {
  final bool isAvailable;

  BiometricAvailable({required this.isAvailable});
}

class BiometricScanning extends BiometricState {}

class BiometricSuccess extends BiometricState {}

class BiometricFailed extends BiometricState {
  final String? message;

  BiometricFailed({this.message});
}

class BiometricSkipped extends BiometricState {}

class BiometricError extends BiometricState {
  final String message;

  BiometricError(this.message);
}