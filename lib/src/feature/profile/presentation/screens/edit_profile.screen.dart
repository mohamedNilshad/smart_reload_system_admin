
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_app_bars/custom_app_bar_2.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.cubit.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.state.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.event.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.state.dart';

class EditProfileScreen extends StatefulWidget {
  final bool isDark;
  const EditProfileScreen({super.key, this.isDark = false});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  late UserEntity user;

  bool isDark = false;
  bool enableBtn = false;
  bool loadingBtn = false;
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  double screenWidth = 0.0;
  String btnText = "Update";

  @override
  void initState() {
    isDark = widget.isDark;
    final sessionState = context.read<SessionCubit>().state;
    if (sessionState is SessionAuthenticated) {
      user = sessionState.user;
      _initValues();
    }

    super.initState();
  }

  void _initValues(){
    _nameController.text = user.fullName;
    _phoneController.text = user.phoneNumber;
    _emailController.text = user.email;
    _nicController.text = user.nic;
  }

  void _setNewValues(){
    setState(() {
      user = user.copyWith(
        newFullName : _nameController.text,
        newPhoneNumber : _phoneController.text,
        newEmail : _emailController.text,
        newNic : _nicController.text,
      );
    });

    // context.read<ProfileBloc>().add(
    //   ProfileUpdateRequested(
    //     userId: user.uid,
    //     isEmailChanged: user.email != _emailController.text.trim(),
    //     fullName: _nameController.text.trim(),
    //     phoneNumber: _phoneController.text.trim(),
    //     email: _emailController.text.trim(),
    //     nic: _nicController.text.trim(),
    //   ),
    // );
  }

  void _validateNewValues(){
    setState(() {
      if((_nameController.text != user.fullName) && (_nameController.text.isNotEmpty)){
        enableBtn = true;
      }else if((_phoneController.text != user.phoneNumber) && (_phoneController.text.isNotEmpty)){
        enableBtn = true;
      }else if((_emailController.text != user.email) && (_emailController.text.isNotEmpty)){
        enableBtn = true;
      }else if((_nicController.text != user.nic) && (_nicController.text.isNotEmpty)){
        enableBtn = true;
      }else{
        enableBtn = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = HelperFunctions.screenWidth(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      appBar: customAppBar(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icons.arrow_back_ios_new_rounded,
        title: "Edit Profile",
        isDark: isDark,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Sizes.sm, Sizes.lg, Sizes.sm, Sizes.sm),
          child: CCard(
            isDark: true,
            child: Form(
              key: _formKey,
              child:  BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  loadingBtn = state is ProfileLoading;

                  if (state is ProfileFailure) {
                    AppSnackbar.showError(context, state.message);

                  } else if (state is ProfileUpdateSuccess) {
                    _setNewValues();
                    AppSnackbar.showSuccess(context, "Successfully updated!");
                  }
                },
                child: Column(
                  spacing: Sizes.spaceBtwInputField,
                  children: [
                    CTextField(
                      isDark: isDark,
                      controller: _nameController,
                      label: 'Name',
                      hint: 'John Doe',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.person_outline_rounded,
                      onChanged: (v) {
                        _validateNewValues();
                        return;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your name';
                        return null;
                      },
                    ),
                    CTextField(
                      isDark: isDark,
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: '7xxxxxxxxxx',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.phone_android,
                      readOnly: true,
                      onChanged: (v) {
                        _validateNewValues();
                        return;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter mobile number';
                        return null;
                      },
                    ),
                    CTextField(
                      isDark: isDark,
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline_rounded,
                      readOnly: true,
                      onChanged: (v) {
                        _validateNewValues();
                        return;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter email address';
                        return null;
                      },
                    ),
                    CTextField(
                      isDark: isDark,
                      controller: _nicController,
                      label: 'NIC / ID Number',
                      hint: '123456789V',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.credit_card,
                      onChanged: (v) {
                        _validateNewValues();
                        return;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your NIC / ID card';
                        return null;
                      },
                    ),

                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        _isLoadingNotifier.value = state is AuthLoading;

                        if (state is AuthFailureState) {
                          AppSnackbar.showError(context, state.message, showUp: true); // wrong password, etc.
                        } else if (state is ReauthenticationSuccess) {

                          context.read<ProfileBloc>().add(
                            ProfileUpdateRequested(
                              userId: user.uid,
                              isEmailChanged: user.email != _emailController.text.trim(),
                              fullName: _nameController.text.trim(),
                              phoneNumber: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                              nic: _nicController.text.trim(),
                            ),
                          );
                          setState(() {
                            enableBtn = true;
                            btnText = "Update";
                          });

                          Navigator.of(context).pop();
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
                            //   context,
                            //   isDark: isDark,
                            //   title: 'Enter Password',
                            //   form: Form(
                            //     key: _passwordFormKey,
                            //     child: CTextField(
                            //       isDark: isDark,
                            //       controller: _passwordController,
                            //       label: 'Password',
                            //       hint: '•••••••••',
                            //       isPassword: true,
                            //       keyboardType: TextInputType.visiblePassword,
                            //       prefixIcon: Icons.lock_outline,
                            //       validator: (value) {
                            //         if (value == null || value.isEmpty) return 'Please enter password';
                            //         return null;
                            //       },
                            //     ),
                            //   ),
                            //   buttonText: 'Continue',
                            //   isLoading: _isLoadingNotifier,
                            //   onSubmit: () {
                            //     if(_passwordFormKey.currentState!.validate()){
                            //       FocusManager.instance.primaryFocus?.unfocus();
                            //       context.read<AuthBloc>().add(ReauthenticateRequested(password: _passwordController.text));
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
