import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/repository/system.repo.dart';

class AddNewNewsUseCase {
  final SystemRepo repo;
  AddNewNewsUseCase(this.repo);

  Future<Either<Failure, bool>> call(BannerNewsModel bannerNewsModel, {String? publishedId}){
    return repo.addNewNews(bannerNewsModel, publishedId: publishedId);
  }
}
