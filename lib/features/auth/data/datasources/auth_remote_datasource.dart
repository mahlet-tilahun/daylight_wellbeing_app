// All Firebase Auth and Firestore calls live here.
// This is the ONLY place we talk to Firebase for auth.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithGoogle();
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Fetch user data from Firestore
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .get();
      return UserModel.fromMap(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      // Save user to Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toMap());
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null)
        throw const AuthException('Google sign-in cancelled');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user!;

      // Check if user already exists in Firestore
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }

      // New user — save to Firestore
      final user = UserModel(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'User',
        email: firebaseUser.email ?? '',
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toMap());
      return user;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(firebaseUser.uid)
          .get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Maps Firebase error codes to friendly messages
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
