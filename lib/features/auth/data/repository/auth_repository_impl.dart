import 'package:crypto_tracker/core/utils/gravatar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final FirebaseAuth _firebaseAuth;
  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? username,
    String? phoneNumber,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
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

      return UserModel(
        id: user.uid,
        email: user.email!,
        username: username,
        phoneNumber: phoneNumber,
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
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return null;
      }

      // Reload user to get fresh data
      await user.reload();
      final refreshedUser = _firebaseAuth.currentUser;

      if (refreshedUser == null) {
        return null;
      }

      return UserModel(
        id: refreshedUser.uid,
        username: refreshedUser.displayName ?? '',
        email: refreshedUser.email!,
        phoneNumber: refreshedUser.phoneNumber,
        photoUrl: refreshedUser.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromFirebaseException(code: e.code);
    } catch (e) {
      throw GeneralFailure.fromException(e as Exception);
    }
  }

}