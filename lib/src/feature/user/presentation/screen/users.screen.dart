import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_popup_dialog.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_dropdown.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/feature/user/domain/entity/admin_user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/user/presentation/bloc/user.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/user/presentation/bloc/user.event.dart';
import 'package:smart_reload_system_admin/src/feature/user/presentation/bloc/user.state.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loading = ValueNotifier<bool>(false);
  final _fullName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _email = TextEditingController();
  final _nic = TextEditingController();
  String _role = 'client';
  bool _isActive = true;
  List<AdminUserEntity> _users = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const GetUsersRequested());
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phoneNumber.dispose();
    _email.dispose();
    _nic.dispose();
    _loading.dispose();
    super.dispose();
  }

  void _resetForm() {
    _fullName.clear();
    _phoneNumber.clear();
    _email.clear();
    _nic.clear();
    _role = 'client';
    _isActive = true;
  }

  AdminUserEntity _buildEntity({String? id}) => AdminUserEntity(
    id: id,
    fullName: _fullName.text.trim(),
    phoneNumber: _phoneNumber.text.trim(),
    email: _email.text.trim(),
    nic: _nic.text.trim(),
    role: _role,
    isActive: _isActive,
  );

  void _showUserForm({AdminUserEntity? user}) {
    if (user != null) {
      _fullName.text = user.fullName;
      _phoneNumber.text = user.phoneNumber;
      _email.text = user.email;
      _nic.text = user.nic;
      _role = user.role;
      _isActive = user.isActive;
    } else {
      _resetForm();
    }

    AppDialog.showForm(
      context,
      title: user == null ? 'Add User' : 'Update User',
      isDark: true,
      isLoading: _loading,
      buttonText: user == null ? 'Save' : 'Update',
      form: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return Form(
            key: _formKey,
            child: Column(
              spacing: Sizes.spaceBtwInputField,
              children: [
                CTextField(
                  isDark: true,
                  controller: _fullName,
                  label: 'Full Name',
                  hint: 'Enter full name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter full name'
                      : null,
                ),
                CTextField(
                  isDark: true,
                  controller: _phoneNumber,
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter phone number'
                      : null,
                ),
                CTextField(
                  isDark: true,
                  controller: _email,
                  label: 'Email',
                  hint: 'Enter email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter email'
                      : null,
                ),
                CTextField(
                  isDark: true,
                  controller: _nic,
                  label: 'NIC',
                  hint: 'Enter NIC',
                  prefixIcon: Icons.badge_outlined,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter NIC'
                      : null,
                ),
                CDropDown(
                  isDark: true,
                  label: 'Role',
                  selectedType: _role,
                  items: const ['client', 'vendor'],
                  onChanged: (value) =>
                      setDialogState(() => _role = value ?? 'client'),
                ),
                CDropDown(
                  isDark: true,
                  label: 'Status',
                  selectedType: _isActive ? 'Active' : 'Inactive',
                  items: const ['Active', 'Inactive'],
                  onChanged: (value) =>
                      setDialogState(() => _isActive = value == 'Active'),
                ),
              ],
            ),
          );
        },
      ),
      onSubmit: () {
        if (!(_formKey.currentState?.validate() ?? false)) return;
        _loading.value = true;
        if (user == null) {
          context.read<UserBloc>().add(AddUserRequested(_buildEntity()));
        } else {
          context.read<UserBloc>().add(
            UpdateUserRequested(_buildEntity(id: user.id)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: AppColors.scaffoldVendor,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoading) {
            setState(() => _isFetching = state.isFetching);
          }
          if (state is UserLoaded) {
            setState(() {
              _users = state.users;
              _isFetching = false;
            });
          }
          if (state is UserFailure) {
            _loading.value = false;
            AppSnackbar.showError(context, state.message);
          }
          if (state is UserSuccess) {
            _loading.value = false;
            Navigator.of(context).pop();
            AppSnackbar.showSuccess(context, 'User saved successfully');
            context.read<UserBloc>().add(const GetUsersRequested());
          }
          if (state is UserDeleteSuccess) {
            AppSnackbar.showSuccess(context, 'User deleted successfully');
            context.read<UserBloc>().add(const GetUsersRequested());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(Sizes.ssm),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CElevatedButton(
                  onPressed: () => _showUserForm(),
                  label: 'Add User',
                  width: 200,
                ),
              ),
              const SizedBox(height: Sizes.lg),
              Expanded(
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 1100,
                  headingRowColor: const WidgetStatePropertyAll(
                    AppColors.darkerGrey,
                  ),
                  columns: const [
                    DataColumn2(label: Text('Full Name'), fixedWidth: 180),
                    DataColumn2(label: Text('Phone'), fixedWidth: 140),
                    DataColumn2(label: Text('Email')),
                    DataColumn2(label: Text('NIC'), fixedWidth: 140),
                    DataColumn2(label: Text('Role'), fixedWidth: 100),
                    DataColumn2(label: Text('Status'), fixedWidth: 90),
                    DataColumn2(label: Text('Actions'), fixedWidth: 110),
                  ],
                  rows: _isFetching
                      ? [_buildInfoRow(const Text('Loading...'))]
                      : _users.isEmpty
                      ? [_buildInfoRow(const Text('No users'))]
                      : _users
                            .map(
                              (user) => DataRow(
                                cells: [
                                  DataCell(Text(user.fullName)),
                                  DataCell(Text(user.phoneNumber)),
                                  DataCell(Text(user.email)),
                                  DataCell(Text(user.nic)),
                                  DataCell(Text(user.role)),
                                  DataCell(
                                    Text(user.isActive ? 'Active' : 'Inactive'),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              _showUserForm(user: user),
                                          color: AppColors.buttonPrimary,
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final confirmed =
                                                await AppDialog.showConfirm(
                                                  context,
                                                  isDark: true,
                                                  isDestructive: true,
                                                  icon: Icons
                                                      .delete_outline_rounded,
                                                  title: 'Confirm Delete ?',
                                                  subtitle:
                                                      'Are you sure you want to delete this user?',
                                                  confirmText: 'Delete',
                                                  cancelText: 'Cancel',
                                                );
                                            if (confirmed == true &&
                                                user.id != null &&
                                                context.mounted) {
                                              context.read<UserBloc>().add(
                                                DeleteUserRequested(user.id!),
                                              );
                                            }
                                          },
                                          color: AppColors.red,
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildInfoRow(Widget text) {
    return DataRow(
      cells: [
        DataCell(text),
        for (var i = 0; i < 6; i++) const DataCell(SizedBox()),
      ],
    );
  }
}
