import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/firebase_exceptions.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile({required String userId, required bool isEmailChanged, required String fullName, required String phoneNumber, required String email, required String nic});
  Future<void> updatePassword({required String password});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ProfileRemoteDataSourceImpl({required this.firestore, required this.firebaseAuth});

  @override
  Future<void> updateProfile({required String userId, required bool isEmailChanged, required String fullName, required String phoneNumber, required String email, required String nic}) async {
    try {

      await firestore.collection('users').doc(userId).update({
        'fullName': fullName,
        // 'phoneNumber': phoneNumber,
        // 'email': email,
        'nic': nic,
      });

    } on FirebaseAuthException catch (e, st) {
      errorLog(
        e,
        location: 'AuthRemoteDataSourceImpl.logout',
        stackTrace: st,
      );
      throw ServerException(mapFirebaseError(e)); // 'wrong-password' already mapped

    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'ProfileRemoteDataSourceImpl.updateProfile',
        stackTrace: st,
      );
      throw ServerException(mapFirestoreError(e));
    } catch (e, st) {
      errorLog(
        e,
        location: 'ProfileRemoteDataSourceImpl.updateProfile',
        stackTrace: st,
      );
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    try {

      final user = firebaseAuth.currentUser;
      final userId = user?.uid;
      if (userId == null) throw ServerException('User not authenticated');
      await user?.updatePassword(password);
    } on FirebaseAuthException catch (e, st) {
      errorLog(
        e,
        location: 'AuthRemoteDataSourceImpl.logout',
        stackTrace: st,
      );
      throw ServerException(mapFirebaseError(e)); // 'wrong-password' already mapped

    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'ProfileRemoteDataSourceImpl.updatePassword',
        stackTrace: st,
      );
      throw ServerException(mapFirestoreError(e));
    } catch (e, st) {
      errorLog(
        e,
        location: 'ProfileRemoteDataSourceImpl.updatePassword',
        stackTrace: st,
      );
      throw Exception('Failed to update password: $e');
    }
  }
}
