import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/entity/package.entity.dart';

abstract class PackageEvent extends Equatable {
  const PackageEvent();
  @override
  List<Object?> get props => [];
}

class GetPackagesRequested extends PackageEvent { const GetPackagesRequested(); }

class AddPackageRequested extends PackageEvent {
  final PackageEntity package;
  const AddPackageRequested(this.package);
  @override
  List<Object?> get props => [package];
}

class UpdatePackageRequested extends PackageEvent {
  final PackageEntity package;
  const UpdatePackageRequested(this.package);
  @override
  List<Object?> get props => [package];
}

class DeletePackageRequested extends PackageEvent {
  final String packageId;
  const DeletePackageRequested(this.packageId);
  @override
  List<Object?> get props => [packageId];
}
