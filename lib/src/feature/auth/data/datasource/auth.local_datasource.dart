import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserEntity user);
  Future<UserEntity?> getCachedUser();
  Future<void> clearCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const _key = 'cached_user';

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> cacheUser(UserEntity user) async {
    try{
      await secureStorage.write(key: _key, value: jsonEncode(user.toJson()));
    } catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthLocalDataSourceImpl.cacheUser',
        stackTrace: st,
      );
      throw Exception('Failed to cache user: $e');
    }
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final jsonStr = await secureStorage.read(key: _key);
    if (jsonStr == null) return null;
    try {
      return UserEntity.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthLocalDataSourceImpl.getCachedUser',
        stackTrace: st,
      );
      throw Exception('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try{
      await secureStorage.delete(key: _key);
    }catch(e, st) {
      ErrorLogger.log(
        e,
        location: 'AuthLocalDataSourceImpl.clearCachedUser',
        stackTrace: st,
      );
      throw Exception('Failed to clear cached user: $e');
    }

  }
}