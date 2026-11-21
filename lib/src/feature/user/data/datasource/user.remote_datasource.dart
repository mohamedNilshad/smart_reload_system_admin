import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/entity/admin_user.entity.dart';

abstract class UserRemoteDataSource {
  Future<List<AdminUserEntity>> getUsers();
  Future<bool> addUser(AdminUserEntity user);
  Future<bool> updateUser(AdminUserEntity user);
  Future<bool> deleteUser(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  UserRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('users');

  @override
  Future<List<AdminUserEntity>> getUsers() async {
    try {
      final snapshot = await _collection.get();
      final users = snapshot.docs.map(AdminUserEntity.fromFirestore).toList();
      users.sort(
        (a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()),
      );
      return users;
    } catch (e, st) {
      errorLog(
        e,
        location: 'UserRemoteDataSourceImpl.getUsers',
        stackTrace: st,
      );
      throw ServerException('Failed to load users.');
    }
  }

  @override
  Future<bool> addUser(AdminUserEntity user) async {
    try {
      final doc = await _collection.add(user.toFirestore());
      await doc.update({'uid': doc.id});
      return true;
    } catch (e, st) {
      errorLog(e, location: 'UserRemoteDataSourceImpl.addUser', stackTrace: st);
      throw ServerException('Failed to add user.');
    }
  }

  @override
  Future<bool> updateUser(AdminUserEntity user) async {
    try {
      if (user.id == null || user.id!.isEmpty) {
        throw ServerException('User id is required.');
      }
      await _collection.doc(user.id).update(user.toFirestore());
      return true;
    } catch (e, st) {
      errorLog(
        e,
        location: 'UserRemoteDataSourceImpl.updateUser',
        stackTrace: st,
      );
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update user.');
    }
  }

  @override
  Future<bool> deleteUser(String userId) async {
    try {
      await _collection.doc(userId).delete();
      return true;
    } catch (e, st) {
      errorLog(
        e,
        location: 'UserRemoteDataSourceImpl.deleteUser',
        stackTrace: st,
      );
      throw ServerException('Failed to delete user.');
    }
  }
}
