import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/enums/connection_data.enum.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_popup_dialog.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_dropdown.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/feature/package/domain/entity/package.entity.dart';
import 'package:smart_reload_system_admin/src/feature/package/presentation/bloc/package.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/package/presentation/bloc/package.event.dart';
import 'package:smart_reload_system_admin/src/feature/package/presentation/bloc/package.state.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loading = ValueNotifier<bool>(false);
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _validity = TextEditingController();
  String _packageType = PackageType.Data.name;
  String _telecomType = TelecomType.Mobile.name;
  String _serviceProvider = ServiceProviderMobile.Dialog_Axiata.name;
  String _validityPeriod = 'Day';
  List<PackageEntity> _packages = [];
  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    context.read<PackageBloc>().add(const GetPackagesRequested());
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _validity.dispose();
    _loading.dispose();
    super.dispose();
  }

  PackageEntity _entity({String? id}) => PackageEntity(
        id: id,
        packageDescription: _description.text.trim(),
        packageName: _name.text.trim(),
        packagePrice: double.parse(_price.text.trim()),
        packageType: _packageType,
        packageValidity: double.parse(_validity.text.trim()),
        serviceProvider: _serviceProvider,
        telecomType: _telecomType,
        validityPeriod: _validityPeriod,
      );

  List<String> get _packageTypes => PackageType.values.map((e) => e.name).toList();

  List<String> get _telecomTypes => TelecomType.values.map((e) => e.name).toList();

  List<String> get _serviceProviders {
    if (_telecomType == TelecomType.HBB.name) {
      return ServiceProviderHBB.values.map((e) => e.name).toList();
    }
    if (_telecomType == TelecomType.TV.name) {
      return ServiceProviderTv.values.map((e) => e.name).toList();
    }
    return ServiceProviderMobile.values.map((e) => e.name).toList();
  }

  String _sanitizeSelection(String value, List<String> values) {
    return values.contains(value) ? value : values.first;
  }

  void _clearForm() {
    _name.clear();
    _description.clear();
    _price.clear();
    _validity.clear();
    _packageType = _packageTypes.first;
    _telecomType = _telecomTypes.first;
    _serviceProvider = _serviceProviders.first;
    _validityPeriod = 'Day';
  }

  void _showForm({PackageEntity? package}) {
    if (package != null) {
      _name.text = package.packageName;
      _description.text = package.packageDescription;
      _price.text = package.packagePrice.toString();
      _validity.text = package.packageValidity.toString();
      _packageType = _sanitizeSelection(package.packageType, _packageTypes);
      _telecomType = _sanitizeSelection(package.telecomType, _telecomTypes);
      _serviceProvider = _sanitizeSelection(package.serviceProvider, _serviceProviders);
      _validityPeriod = package.validityPeriod;
    } else {
      _clearForm();
    }

    AppDialog.showForm(
      context,
      title: package == null ? 'Add Package' : 'Update Package',
      isDark: true,
      isLoading: _loading,
      buttonText: package == null ? 'Save' : 'Update',
      form: StatefulBuilder(builder: (dialogContext, setDialogState) {
        return Form(
          key: _formKey,
          child: Column(
            spacing: Sizes.spaceBtwInputField,
            children: [
              CTextField(isDark: true, controller: _name, label: 'Package Name', hint: 'Enter package name', prefixIcon: Icons.inventory_2_outlined, validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a package name' : null),
              CTextField(isDark: true, controller: _description, label: 'Description', hint: 'Enter package description', prefixIcon: Icons.description_outlined, maxLines: 3, validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a description' : null),
              CTextField(isDark: true, controller: _price, label: 'Price', hint: 'Enter package price', prefixIcon: Icons.attach_money, keyboardType: const TextInputType.numberWithOptions(decimal: true), validator: (value) => double.tryParse(value ?? '') == null ? 'Enter a valid price' : null),
              CTextField(isDark: true, controller: _validity, label: 'Validity', hint: 'Enter validity', prefixIcon: Icons.schedule, keyboardType: const TextInputType.numberWithOptions(decimal: true), validator: (value) => double.tryParse(value ?? '') == null ? 'Enter valid validity' : null),
              CDropDown(
                isDark: true,
                label: 'Package Type',
                selectedType: _packageType,
                items: _packageTypes,
                onChanged: (value) => setDialogState(
                  () => _packageType = value ?? _packageTypes.first,
                ),
              ),
              CDropDown(
                isDark: true,
                label: 'Telecom Type',
                selectedType: _telecomType,
                items: _telecomTypes,
                onChanged: (value) => setDialogState(() {
                  _telecomType = value ?? _telecomTypes.first;
                  _serviceProvider = _serviceProviders.first;
                }),
              ),
              CDropDown(
                isDark: true,
                label: 'Service Provider',
                selectedType: _serviceProvider,
                items: _serviceProviders,
                onChanged: (value) => setDialogState(
                  () => _serviceProvider = value ?? _serviceProviders.first,
                ),
              ),
              CDropDown(isDark: true, label: 'Validity Period', selectedType: _validityPeriod, items: const ['Hour', 'Day', 'Month'], onChanged: (value) => setDialogState(() => _validityPeriod = value ?? 'Day')),
            ],
          ),
        );
      }),
      onSubmit: () {
        if (!(_formKey.currentState?.validate() ?? false)) return;
        _loading.value = true;
        if (package == null) {
          context.read<PackageBloc>().add(AddPackageRequested(_entity()));
        } else {
          context.read<PackageBloc>().add(UpdatePackageRequested(_entity(id: package.id)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      appBar: AppBar(title: const Text('Packages'), backgroundColor: AppColors.scaffoldVendor),
      body: BlocListener<PackageBloc, PackageState>(
        listener: (context, state) {
          if (state is PackageLoading) setState(() => _fetching = state.isFetching);
          if (state is PackageLoaded) setState(() { _packages = state.packages; _fetching = false; });
          if (state is PackageFailure) { _loading.value = false; AppSnackbar.showError(context, state.message); }
          if (state is PackageSuccess) {
            _loading.value = false;
            Navigator.of(context).pop();
            AppSnackbar.showSuccess(context, 'Package saved successfully');
            context.read<PackageBloc>().add(const GetPackagesRequested());
          }
          if (state is PackageDeleteSuccess) {
            AppSnackbar.showSuccess(context, 'Package deleted successfully');
            context.read<PackageBloc>().add(const GetPackagesRequested());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(Sizes.ssm),
          child: Column(children: [
            Align(alignment: Alignment.topLeft, child: CElevatedButton(onPressed: () => _showForm(), label: 'Add Package', width: 200)),
            SizedBox(height: Sizes.lg),
            Expanded(child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 1050,
              headingRowColor: WidgetStatePropertyAll(AppColors.darkerGrey),
              columns: const [
                DataColumn2(label: Text('Name'), fixedWidth: 180),
                DataColumn2(label: Text('Description')),
                DataColumn2(label: Text('Price'), fixedWidth: 100),
                DataColumn2(label: Text('Type'), fixedWidth: 100),
                DataColumn2(label: Text('Validity'), fixedWidth: 120),
                DataColumn2(label: Text('Provider'), fixedWidth: 140),
                DataColumn2(label: Text('Actions'), fixedWidth: 110),
              ],
              rows: _fetching
                  ? [_buildRow(Text('Loading...'))]
                  : _packages.isEmpty
                      ? [_buildRow(const Text('No packages'))]
                      : _packages.map((package) => DataRow(cells: [
                          DataCell(Text(package.packageName)),
                          DataCell(Text(package.packageDescription)),
                          DataCell(Text(package.packagePrice.toStringAsFixed(2))),
                          DataCell(Text(package.packageType)),
                          DataCell(Text('${package.packageValidity.toStringAsFixed(0)} ${package.validityPeriod}')),
                          DataCell(Text(package.serviceProvider)),
                          DataCell(Row(children: [
                            IconButton(onPressed: () => _showForm(package: package), icon: const Icon(Icons.edit), color: AppColors.buttonPrimary),
                            IconButton(onPressed: () async {
                              final confirmed = await AppDialog.showConfirm(context, isDark: true, isDestructive: true, icon: Icons.delete_outline, title: 'Confirm Delete?', subtitle: 'Delete this package permanently?', confirmText: 'Delete');
                              if (confirmed == true && package.id != null && context.mounted) context.read<PackageBloc>().add(DeletePackageRequested(package.id!));
                            }, icon: const Icon(Icons.delete), color: AppColors.red),
                          ])),
                        ])).toList(),
            )),
          ]),
        ),
      ),
    );
  }

  DataRow _buildRow(Widget widget) => DataRow(cells: [DataCell(widget), for (var i = 0; i < 6; i++) const DataCell(SizedBox())]);
}
