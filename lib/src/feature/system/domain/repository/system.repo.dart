import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';

abstract class SystemRepo {
  Future<Either<Failure, bool>> addNewNews(BannerNewsModel bannerNewsModel);
  Future<Either<Failure, List<BannerNewsModel>>> getNewsList();
}
