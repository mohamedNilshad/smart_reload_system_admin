
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/primary_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/label_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/router/route.constants.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.event.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => loading = true);
          }
          if (state is AuthFailureState) {
            AppSnackbar.showError(context, state.message);
          }
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, RouteConstants.mainScreen, (r) => false);
          }
        },
        child: Center(
          child: CCard(
            isDark: true,
            child: Form(
              key: _formKey,
              child: Column(
                spacing: Sizes.spaceBtwInputField,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeadlineText(text: "Admin Login", color: AppColors.white),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  CTextField(
                    isDark: true,
                    controller: _emailController,
                    label: 'Email',
                    hint: 'example@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CTextField(
                        isDark: true,
                        controller: _passwordController,
                        label: 'Password',
                        hint: '•••••••••',
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),

                      Align(
                        alignment: AlignmentGeometry.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, RouteConstants.forgotPasswordScreen);
                            },
                            child: LabelText(text: "Forgot Password?", color: AppColors.info, isBold: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) return const CircularProgressIndicator();

                        return PrimaryButton(
                          onPressed: (){
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(LoginRequested(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ));
                            }
                          },
                          title: "Login",
                        );
                      }
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
