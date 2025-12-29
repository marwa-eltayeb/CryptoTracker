import 'package:crypto_tracker/core/utils/gravatar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final FirebaseAuth _firebaseAuth;
  final LocalAuthentication _localAuth;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._firebaseAuth, this._localAuth, this._prefs);

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? username,
    String? phoneNumber,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseFailure(errMessage: 'Registration failed');
      }

      final gravatarUrl = GravatarUtils.getGravatarUrl(email);

      await user.updateDisplayName(username);
      await user.updatePhotoURL(gravatarUrl);

      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;

      return UserModel(
        id: updatedUser!.uid,
        email: updatedUser.email!,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: gravatarUrl,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromFirebaseException(code: e.code);
    } catch (e) {
      throw GeneralFailure.fromException(e as Exception);
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseFailure(errMessage: 'Login failed');
      }

      return UserModel(
        id: user.uid,
        username: user.displayName ?? '',
        email: user.email!,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromFirebaseException(code: e.code);
    } catch (e) {
      throw GeneralFailure.fromException(e as Exception);
    }
  }


  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromFirebaseException(code: e.code);
    } catch (e) {
      throw GeneralFailure.fromException(e as Exception);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await _firebaseAuth.authStateChanges().first;

      if (user == null) {
        return null;
      }

      return UserModel(
        id: user.uid,
        username: user.displayName ?? '',
        email: user.email!,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromFirebaseException(code: e.code);
    } catch (e) {
      throw GeneralFailure.fromException(e as Exception);
    }
  }

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) return false;

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> isFaceIDAvailable() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) return false;
      final biometrics = await getAvailableBiometrics();
      return biometrics.contains(BiometricType.face) || biometrics.contains(BiometricType.weak);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isFingerprintAvailable() async {
    try {
      final biometrics = await getAvailableBiometrics();
      return biometrics.contains(BiometricType.fingerprint) || biometrics.contains(BiometricType.strong);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometric(String reason, {BiometricType? specificType}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } on Exception catch (e) {
      throw BiometricFailure(errMessage: 'Biometric authentication failed: ${e.toString()}',);
    }
  }

  @override
  Future<void> saveBiometricPreference(String userId, bool enabled) async {
    try {
      await _prefs.setBool('biometric_enabled_$userId', enabled);
    } catch (e) {
      throw GeneralFailure(errMessage: 'Failed to save biometric preference');
    }
  }

  @override
  Future<bool> getBiometricPreference(String userId) async {
    try {
      return _prefs.getBool('biometric_enabled_$userId') ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> canUseBiometricLogin(String userId) async {
    try {
      final isAvailable = await isBiometricAvailable();
      final isEnabled = await getBiometricPreference(userId);
      return isAvailable && isEnabled;
    } catch (e) {
      return false;
    }
  }

}