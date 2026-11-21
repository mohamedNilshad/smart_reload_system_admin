import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/firebase_exceptions.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';

abstract class SystemRemoteDataSource {
  Future<bool> addNewNews(BannerNewsModel bannerNewsModel);
  Future<List<BannerNewsModel>> getNewsList();
}

class SystemRemoteDataSourceImpl implements SystemRemoteDataSource {
  final FirebaseFirestore firestore;

  SystemRemoteDataSourceImpl(this.firestore);

  @override
  Future<bool> addNewNews(BannerNewsModel bannerNewsModel) async {
    try {
      await firestore.collection('banner_news').add(bannerNewsModel.toJson());
      return true;
    } on FirebaseAuthException catch (e, st) {
      errorLog(
        e,
        location: 'SystemRemoteDataSourceImpl.addNewNews',
        stackTrace: st,
      );
      throw ServerException(mapFirebaseError(e)); // 'wrong-password' already mapped

    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'SystemRemoteDataSourceImpl.addNewNews',
        stackTrace: st,
      );
      throw ServerException(mapFirestoreError(e));
    } catch (e, st) {
      errorLog(
        e,
        location: 'SystemRemoteDataSourceImpl.addNewNews',
        stackTrace: st,
      );
      throw Exception('Failed to add new news: $e');
    }
  }

  @override
  Future<List<BannerNewsModel>> getNewsList() async {
    try {
      final snapshot = await firestore.collection('banner_news').get();
      return snapshot.docs.map((doc) => BannerNewsModel.fromJson(doc.data(), id: doc.id)).toList();
    } catch (e, st) {
      errorLog(
        e,
        location: 'SystemRemoteDataSourceImpl.getNewsList',
        stackTrace: st,
      );
      throw ServerException('Failed to load news list.');
    }
  }

}
