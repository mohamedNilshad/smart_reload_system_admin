import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_bottom_sheet.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/label_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/title_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/svg_builder.widget.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.event.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.cubit.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.state.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.event.dart';
import 'package:smart_reload_system_admin/src/feature/profile/presentation/bloc/profile.state.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();


  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();

  late UserEntity user;
  bool enableBtn = false;
  bool loadingBtn = false;
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  String btnText = "Update";

  @override
  void initState() {
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.ssm),
          child: Center(
            child: Column(
              children: [
                HeadlineText(text: "Update your profile", color: AppColors.white),
                SizedBox(height: Sizes.lg),
                CCard(
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
                            isDark: true,
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
                            isDark: true,
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
                            isDark: true,
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
                            isDark: true,
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
                
                                  await AppDialog.showForm(
                                    context,
                                    isDark: true,
                                    title: 'Enter Password',
                                    form: Form(
                                      key: _passwordFormKey,
                                      child: CTextField(
                                        isDark: true,
                                        controller: _passwordController,
                                        label: 'Password',
                                        hint: '•••••••••',
                                        isPassword: true,
                                        keyboardType: TextInputType.visiblePassword,
                                        prefixIcon: Icons.lock_outline,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return 'Please enter password';
                                          return null;
                                        },
                                      ),
                                    ),
                                    buttonText: 'Continue',
                                    isLoading: _isLoadingNotifier,
                                    onSubmit: () {
                                      if(_passwordFormKey.currentState!.validate()){
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        context.read<AuthBloc>().add(ReauthenticateRequested(password: _passwordController.text));
                                      }
                                    },
                                  );
                
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOption(BuildContext context, {required String icon, required Color leadColor, required String title, required String subtitle, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        spacing: 10.0,
        children: [
          Container(
            padding: EdgeInsets.all(Sizes.md),
            decoration: BoxDecoration(
              color: leadColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
            ),
            child: CSvgBuilder(
              path: icon,
              width: 20,
              colorFilter: ColorFilter.mode(leadColor, BlendMode.srcIn),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5.0,
            children: [
              TitleText(text: title, color: AppColors.white),
              LabelText(text: subtitle, color: AppColors.grey),
            ],
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18, color: AppColors.grey,
          ),
        ],
      ),
    );
  }
}
