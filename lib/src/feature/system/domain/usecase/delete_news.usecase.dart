import 'package:dartz/dartz.dart';
import 'package:smart_reload_system_admin/src/core/error/failures.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/repository/system.repo.dart';

class DeleteNewsUseCase {
  final SystemRepo repo;
  DeleteNewsUseCase(this.repo);

  Future<Either<Failure, bool>> call(String newsId){
    return repo.deleteNews(newsId);
  }
}

