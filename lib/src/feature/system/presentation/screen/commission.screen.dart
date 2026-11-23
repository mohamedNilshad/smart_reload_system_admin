import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_app_bars/custom_app_bar_2.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/commission/commission.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/commission/commission.event.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/commission/commission.state.dart';

class CommissionScreen extends StatefulWidget {
  const CommissionScreen({super.key});

  @override
  State<CommissionScreen> createState() => _CommissionScreenState();
}

class _CommissionScreenState extends State<CommissionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _adminComController = TextEditingController();
  final TextEditingController _vendorComController = TextEditingController();
  bool loadingBtn = false;
  bool isFetching = false;
  bool enableBtn = false;

  @override
  void initState() {
    context.read<CommissionBloc>().add(GetCommissionRequested());
    super.initState();
  }

  String? _validatePercentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a percentage';
    }

    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed.isNaN || parsed.isInfinite) {
      return 'Enter a valid number (e.g., 12.5)';
    }

    if (parsed < 0 || parsed > 100) {
      return 'Must be between 0 and 100';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      appBar: customAppBar(
        title: "Commissions",
        isDark: true,
        onPressed: Navigator.of(context).pop,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.ssm),
        child: BlocListener<CommissionBloc, CommissionState>(
          listener: (context, state) {
            if (state is CommissionLoading) {
              setState(() {
                isFetching = state.isFetching;
                loadingBtn = state.isUpdating;
              });
            }

            if (state is CommissionFailure) {
              AppSnackbar.showError(context, state.message);
              setState(() {
                isFetching = false;
                loadingBtn = false;
              });
            }

            if (state is CommissionLoaded) {
              setState(() {
                _adminComController.text = state.adminCommission.toString();
                _vendorComController.text = state.vendorCommission.toString();
                isFetching = false;
              });
            }

            if (state is CommissionSuccess) {
              AppSnackbar.showSuccess(context, "Commission updated successfully");
              setState(() => loadingBtn = false);
            }

          },
          child: Padding(
            padding: const EdgeInsets.all(Sizes.ssm),
            child: Center(
              child: Column(
                children: [
                  HeadlineText(text: "Manage commissions", color: AppColors.white),
                  SizedBox(height: Sizes.lg),
                  CCard(
                    isDark: true,
                    width: HelperFunctions.screenWidth(context) / 1.5,
                    child: Form(
                      key: _formKey,
                      child:  Column(
                        spacing: Sizes.spaceBtwInputField,
                        children: [
                          Row(
                            spacing: Sizes.lg,
                            children: [
                              Expanded(
                                child: CTextField(
                                  isDark: true,
                                  controller: _adminComController,
                                  label: 'Admin Commission %',
                                  hint: '50',
                                  prefixIcon: Icons.percent,
                                  inputFormatters: [FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}$'),
                                  )],
                                  validator: _validatePercentage,
                                ),
                              ),
                              Expanded(
                                child: CTextField(
                                  isDark: true,
                                  controller: _vendorComController,
                                  label: 'Vendor Commission %',
                                  hint: '50',
                                  prefixIcon: Icons.percent,
                                  inputFormatters: [FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}$'),
                                  )],
                                  validator: _validatePercentage,
                                ),
                              ),
                            ],
                          ),

                          CElevatedButton(
                            onPressed: enableBtn || loadingBtn ? null : () async {
                              if (_formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                context.read<CommissionBloc>().add(UpdateCommissionRequested(
                                  adminCommission: _adminComController.text,
                                  vendorCommission: _vendorComController.text,
                                ));
                              }
                            },
                            isLoading: loadingBtn,
                            label: "Update",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
