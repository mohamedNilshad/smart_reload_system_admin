import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/entity/package.entity.dart';

abstract class PackageState extends Equatable {
  const PackageState();
  @override
  List<Object?> get props => [];
}

class PackageInitial extends PackageState { const PackageInitial(); }
class PackageLoading extends PackageState {
  final bool isFetching;
  const PackageLoading({this.isFetching = false});
  @override
  List<Object?> get props => [isFetching];
}
class PackageLoaded extends PackageState {
  final List<PackageEntity> packages;
  const PackageLoaded(this.packages);
  @override
  List<Object?> get props => [packages];
}
class PackageSuccess extends PackageState { const PackageSuccess(); }
class PackageDeleteSuccess extends PackageState { const PackageDeleteSuccess(); }
class PackageFailure extends PackageState {
  final String message;
  const PackageFailure(this.message);
  @override
  List<Object?> get props => [message];
}
