import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> login({required String email, required String password});
  Future<void> reauthenticate(String password);
  Future<void> forgotPassword(String email);
  Future<void> logout();
  Stream<UserEntity?> watchUser(String uid);
  Future<void> updateUser(String uid, Map<String, dynamic> data);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  static const _collection = 'users';
  final FirebaseDatabase database;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.database,
  });

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    try {
      final lookup = await firestore.collection('phone_lookup')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (lookup.docs.isEmpty || lookup.docs.first.data()['role'] != 'Admin') {
        ErrorLogger.log(
          'Invalid Credentials',
          location: 'AuthRemoteDataSourceImpl.login',
        );
        throw ServerException('Account not found');
      }

      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw ServerException('Authentication failed: missing user ID');
      }

      final doc = await firestore.collection(_collection).doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        await firebaseAuth.signOut();
        ErrorLogger.log(
          'Admin profile document missing for uid: $uid',
          location: 'AuthRemoteDataSourceImpl.login',
        );
        throw ServerException('Admin profile not found');
      }

      return UserEntity.fromJson(doc.data()!);
    } on ServerException {
      rethrow;
    } on fb.FirebaseAuthException catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.login',
        stackTrace: st,
      );
      throw ServerException(_mapFirebaseError(e));
    } on FirebaseException catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.login',
        stackTrace: st,
      );
      throw ServerException(_mapFirestoreError(e));
    } catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.login',
        stackTrace: st,
      );
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final existing = await firestore.collection('phone_lookup').where('email', isEqualTo: email).get();

      if (existing.docs.isEmpty) {
        throw ServerException('Email not found');
      }
      await firebaseAuth.sendPasswordResetEmail(email: email);

    } on fb.FirebaseAuthException catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.forgotPassword',
        stackTrace: st,
      );
      throw ServerException(_mapFirebaseError(e));
    } catch(e, st){
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.forgotPassword',
        stackTrace: st,
      );
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> reauthenticate(String password) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw ServerException('No authenticated user found.');
      }
      final credential = fb.EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);

    } on fb.FirebaseAuthException catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.reauthenticate',
        stackTrace: st,
      );
      throw ServerException(_mapFirebaseError(e)); // 'wrong-password' already mapped
    }catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.reauthenticate',
        stackTrace: st,
      );
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> logout() async {
    try{
      firebaseAuth.signOut();
    }on fb.FirebaseAuthException catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.logout',
        stackTrace: st,
      );
      throw ServerException(_mapFirebaseError(e)); // 'wrong-password' already mapped
    }catch(e, st){
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.logout',
        stackTrace: st,
      );
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Stream<UserEntity?> watchUser(String uid) {
    try{
      return database.ref('user_update/$uid').onValue.asyncMap((event) async {
        debugPrint("User Data Changed: ${event.snapshot.value}");
        final value = event.snapshot.value;

        bool isActive = true;
        DateTime updatedOn = DateTime.now();
        if (value == null) {
          await updateUser(uid, {
            'isActive': isActive,
            'updatedOn': updatedOn.toIso8601String(),
            'updateType': -1,///-1-null, 0-disable, 1-profile
          });
        }else{
          isActive = (value as Map?)?['isActive'] ?? true;
          updatedOn = (value as Map?)?['updatedOn'] != null ? DateTime.parse((value as Map)['updatedOn']) : DateTime.now();
        }

        final doc = await firestore.collection(_collection).doc(uid).get();

        if (!doc.exists || doc.data() == null) return null;

        UserEntity user = UserEntity.fromJson(doc.data()!);
        user = user.copyWith(newIsActive: isActive, newUpdatedOn: updatedOn);
        return user;
      });

    }catch(e, st){
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.watchUser',
        stackTrace: st,
      );
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try{
      await database.ref('user_update/$uid').update(data);
    }catch(e, st){
      ErrorLogger.log(
        e,
        location: 'AuthRemoteDataSourceImpl.updateUser',
        stackTrace: st,
      );
      throw Exception('An unexpected error occurred: $e');
    }
  }


  String _mapFirebaseError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
        return 'Incorrect email or password.';
      case 'user-not-found':
        return 'No account found.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }

  String _mapFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'Service is temporarily unavailable. Check your internet connection.';
      case 'not-found':
        return 'The requested record could not be found.';
      case 'already-exists':
        return 'This record already exists.';
      case 'unauthenticated':
        return 'Session expired. Please log in again.';
      case 'deadline-exceeded':
        return 'The request timed out. Please try again.';
      case 'cancelled':
        return 'The operation was cancelled.';
      case 'resource-exhausted':
        return 'Database quota exceeded. Please try again later.';
      case 'failed-precondition':
        return 'Operation failed due to a missing index or invalid state.';
      case 'aborted':
        return 'The operation was aborted due to a conflict. Please try again.';
      case 'invalid-argument':
        return 'Invalid data was submitted.';
      default:
        return e.message ?? 'A database error occurred.';
    }
  }
}