import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/datasource/system.remote_datasource.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/repository/system.repo.dart';
class SystemRepoImpl implements SystemRepo {
  final SystemRemoteDataSource remoteDataSource;

  SystemRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> addNewNews(BannerNewsModel bannerNewsModel, {String? publishedId}) async {
    try {
      final result = await remoteDataSource.addNewNews(bannerNewsModel, publishedId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNews(BannerNewsModel bannerNewsModel, {String? publishedId}) async {
    try {
      final result = await remoteDataSource.updateNews(bannerNewsModel, publishedId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BannerNewsModel>>> getNewsList() async {
    try {
      final result = await remoteDataSource.getNewsList();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNews(String newsId) async {
    try {
      final result = await remoteDataSource.deleteNews(newsId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCommission() async {
    try {
      final result = await remoteDataSource.getCommission();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateCommission(String adminCommission, String vendorCommission) async {
    try {
      final result = await remoteDataSource.updateCommission(adminCommission, vendorCommission);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
