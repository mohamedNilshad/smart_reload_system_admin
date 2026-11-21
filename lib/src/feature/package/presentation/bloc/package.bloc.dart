import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/usecase/add_package.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/usecase/delete_package.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/usecase/get_packages.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/usecase/update_package.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/package/presentation/bloc/package.event.dart';
import 'package:smart_reload_system_admin/src/feature/package/presentation/bloc/package.state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final GetPackagesUseCase getPackagesUseCase;
  final AddPackageUseCase addPackageUseCase;
  final UpdatePackageUseCase updatePackageUseCase;
  final DeletePackageUseCase deletePackageUseCase;

  PackageBloc({required this.getPackagesUseCase, required this.addPackageUseCase, required this.updatePackageUseCase, required this.deletePackageUseCase}) : super(const PackageInitial()) {
    on<GetPackagesRequested>(_onGet);
    on<AddPackageRequested>(_onAdd);
    on<UpdatePackageRequested>(_onUpdate);
    on<DeletePackageRequested>(_onDelete);
  }

  Future<void> _onGet(GetPackagesRequested event, Emitter<PackageState> emit) async {
    emit(const PackageLoading(isFetching: true));
    final result = await getPackagesUseCase();
    result.fold((failure) => emit(PackageFailure(failure.message)), (packages) => emit(PackageLoaded(packages)));
  }

  Future<void> _onAdd(AddPackageRequested event, Emitter<PackageState> emit) async {
    emit(const PackageLoading());
    final result = await addPackageUseCase(event.package);
    result.fold((failure) => emit(PackageFailure(failure.message)), (_) => emit(const PackageSuccess()));
  }

  Future<void> _onUpdate(UpdatePackageRequested event, Emitter<PackageState> emit) async {
    emit(const PackageLoading());
    final result = await updatePackageUseCase(event.package);
    result.fold((failure) => emit(PackageFailure(failure.message)), (_) => emit(const PackageSuccess()));
  }

  Future<void> _onDelete(DeletePackageRequested event, Emitter<PackageState> emit) async {
    emit(const PackageLoading());
    final result = await deletePackageUseCase(event.packageId);
    result.fold((failure) => emit(PackageFailure(failure.message)), (_) => emit(const PackageDeleteSuccess()));
  }
}
