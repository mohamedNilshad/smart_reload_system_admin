
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
// import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_bottom_sheet.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_app_bars/custom_app_bar_2.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.event.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final bool isDark;
  const ResetPasswordScreen({super.key, this.isDark = false});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isDark = false;
  bool enableBtn = false;
  bool loadingBtn = false;
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  double screenWidth = 0.0;
  String btnText = "Update";
  String errorMsg = "";
  @override
  void initState() {
    isDark = widget.isDark;
    super.initState();
  }

  void _validateField(){
    setState(() {
      String pass = _passwordController.text.trim();
      String conPass = _confirmPassController.text.trim();
      errorMsg = "";
      enableBtn = false;
      if(pass.isNotEmpty && conPass.isNotEmpty){
        if(pass.length >= 8 && conPass.length >= 8){
          if(pass == conPass){
            enableBtn = true;
          }else{
            errorMsg = "* Incorrect Confirm password";
          }
        }else{
          errorMsg = "* Password should be at least 8 characters";
        }

      }else{
        errorMsg = "* Password shouldn't leave empty";
      }

      //enableBtn = (_passwordController.text.trim().isNotEmpty || _confirmPassController.text.trim().isNotEmpty) && (_passwordController.text.trim() == _confirmPassController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = HelperFunctions.screenWidth(context);
    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldVendor : null,
      appBar: customAppBar(
        isDark: isDark,
        onPressed: () => Navigator.of(context).pop(),
        icon: Icons.arrow_back_ios_new_rounded,
        title: "Reset Password",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Sizes.sm, Sizes.lg, Sizes.sm, Sizes.sm),
          child: CCard(
            isDark: isDark,
            child: Form(
              key: _formKey,
              child:  BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  loadingBtn = state is PasswordLoading;

                  if (state is PasswordFailure) {
                    AppSnackbar.showError(context, state.message);

                  } else if (state is PasswordUpdateSuccess) {
                    loadingBtn = false;
                    _passwordController.clear();
                    _confirmPassController.clear();
                    AppSnackbar.showSuccess(context, "Password successfully updated!");
                  }
                },
                child: Column(
                  spacing: Sizes.spaceBtwInputField,
                  children: [
                    CTextField(
                      isDark: isDark,
                      controller: _passwordController,
                      errorMessage: errorMsg,
                      label: 'New Password',
                      hint: '•••••••••',
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outline,
                      onChanged: (v){
                        _validateField();
                        return;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter password';
                        return null;
                      },
                    ),
                    CTextField(
                      isDark: isDark,
                      controller: _confirmPassController,
                      errorMessage: errorMsg,
                      label: 'Confirm New Password',
                      hint: '•••••••••',
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outline,
                      onChanged: (v){
                        _validateField();
                        return;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter confirm password';
                        return null;
                      },
                    ),

                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        _isLoadingNotifier.value = state is AuthLoading;

                        if (state is AuthFailureState) {
                          AppSnackbar.showError(context, state.message, showUp: true); // wrong password, etc.
                        } else if (state is ReauthenticationSuccess) {

                          if(_passwordController.text.trim() == _oldPassController.text.trim()){
                            _isLoadingNotifier.value = false;
                            AppSnackbar.showError(context, "New password can't be current password!", showUp: true);
                          }else{
                            context.read<ProfileBloc>().add(
                              PasswordUpdateRequested(password: _passwordController.text.trim()),
                            );
                            setState(() {
                              enableBtn = true;
                              btnText = "Update";
                            });
                            Navigator.of(context).pop();

                          }
                        }
                      },
                      child: CElevatedButton(
                        onPressed: !enableBtn || loadingBtn ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              enableBtn = false;
                              btnText = "Waiting for confirm";
                            });

                            // await AppBottomSheet.showForm(
                            //   isDark: isDark,
                            //   context,
                            //   title: 'Enter Password',
                            //   form: Form(
                            //     key: _passwordFormKey,
                            //     child: CTextField(
                            //       isDark: isDark,
                            //       controller: _oldPassController,
                            //       label: 'Password',
                            //       hint: '•••••••••',
                            //       isPassword: true,
                            //       keyboardType: TextInputType.visiblePassword,
                            //       prefixIcon: Icons.lock_outline,
                            //       validator: (value) {
                            //         if (value == null || value.isEmpty) return 'Please enter current password';
                            //         return null;
                            //       },
                            //     ),
                            //   ),
                            //   buttonText: 'Continue',
                            //   isLoading: _isLoadingNotifier,
                            //   onSubmit: () {
                            //     if(_passwordFormKey.currentState!.validate()){
                            //       FocusManager.instance.primaryFocus?.unfocus();
                            //       context.read<AuthBloc>().add(ReauthenticateRequested(password: _oldPassController.text));
                            //     }
                            //   },
                            // );

                            setState(() {
                              enableBtn = true;
                              btnText = "Update";
                            });
                          }
                        },
                        isLoading: loadingBtn,
                        label: btnText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
