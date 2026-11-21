import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';

abstract class SystemRepo {
  Future<Either<Failure, bool>> addNewNews(BannerNewsModel bannerNewsModel, {String? publishedId});
  Future<Either<Failure, bool>> updateNews(BannerNewsModel bannerNewsModel, {String? publishedId});
  Future<Either<Failure, bool>> deleteNews(String newsId);
  Future<Either<Failure, List<BannerNewsModel>>> getNewsList();
}
