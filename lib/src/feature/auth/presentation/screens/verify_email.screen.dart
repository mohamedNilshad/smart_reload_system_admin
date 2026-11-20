
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/body_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.event.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool loadingBtn = false;
  bool enableBtn = false;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  bool showText = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = HelperFunctions.screenWidth(context);
    screenHeight = HelperFunctions.screenHeight(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
            onPressed: () {
              context.read<AuthBloc>().add(AuthReset());
              Navigator.of(context).pop();
            },
          ),
          title: const Text("Verify Email", style: TextStyle(color: AppColors.white)),
      ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            setState(() => loadingBtn = state is AuthLoading);
            if (state is AuthFailureState) {
              AppSnackbar.showError(context, state.message);
            } else if (state is AuthVerifyEmailSuccess) {
              setState(() {
                showText = true;
                enableBtn = false;
              });
              AppSnackbar.showSuccess(context, "Reset email sent successfully");
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                CCard(
                  margin: EdgeInsets.fromLTRB(Sizes.sm, screenHeight/3.5, Sizes.sm, Sizes.sm),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: Sizes.spaceBtwInputField,
                      children: [
                        CTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline_rounded,
                          onChanged: (v){
                            setState(() => enableBtn = (v != null) && (v.isNotEmpty));
                            return;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter email address';
                            return null;
                          },
                        ),

                        CElevatedButton(
                          onPressed: !enableBtn || loadingBtn ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() => showText = false);
                              context.read<AuthBloc>().add(VerifyEmailRequested(email: _emailController.text.trim()));
                            }
                          },
                          isLoading: loadingBtn,
                          label: "Get Code",
                        ),
                      ],
                    ),
                  ),
                ),

                if(showText)...{
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BodyText(
                      text: "We have sent an reset email to your email, please check",
                      textAlign: TextAlign.center,
                      color: AppColors.red,
                    ),
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
