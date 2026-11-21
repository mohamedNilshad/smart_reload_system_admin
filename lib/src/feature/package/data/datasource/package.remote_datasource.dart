import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/entity/package.entity.dart';

abstract class PackageRemoteDataSource {
  Future<List<PackageEntity>> getPackages();
  Future<bool> addPackage(PackageEntity package);
  Future<bool> updatePackage(PackageEntity package);
  Future<bool> deletePackage(String packageId);
}

class PackageRemoteDataSourceImpl implements PackageRemoteDataSource {
  final FirebaseFirestore firestore;
  PackageRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _collection => firestore.collection('package_details');

  @override
  Future<List<PackageEntity>> getPackages() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs.map(PackageEntity.fromFirestore).toList();
    } catch (e, st) {
      errorLog(e, location: 'PackageRemoteDataSourceImpl.getPackages', stackTrace: st);
      throw ServerException('Failed to load packages.');
    }
  }

  @override
  Future<bool> addPackage(PackageEntity package) async {
    try {
      await _collection.add(package.toFirestore());
      return true;
    } catch (e, st) {
      errorLog(e, location: 'PackageRemoteDataSourceImpl.addPackage', stackTrace: st);
      throw ServerException('Failed to add package.');
    }
  }

  @override
  Future<bool> updatePackage(PackageEntity package) async {
    try {
      if (package.id == null) throw ArgumentError('Package ID is required');
      await _collection.doc(package.id).update(package.toFirestore());
      return true;
    } catch (e, st) {
      errorLog(e, location: 'PackageRemoteDataSourceImpl.updatePackage', stackTrace: st);
      throw ServerException('Failed to update package.');
    }
  }

  @override
  Future<bool> deletePackage(String packageId) async {
    try {
      await _collection.doc(packageId).delete();
      return true;
    } catch (e, st) {
      errorLog(e, location: 'PackageRemoteDataSourceImpl.deletePackage', stackTrace: st);
      throw ServerException('Failed to delete package.');
    }
  }
}
