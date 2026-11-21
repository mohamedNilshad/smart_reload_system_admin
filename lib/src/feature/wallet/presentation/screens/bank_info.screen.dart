import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_popup_dialog.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom.circular_progress_indicator.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.event.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/auth.state.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_app_bars/custom_app_bar_2.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/sub_headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/sub_title_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/title_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/empty_screen.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/fallback.widget.dart';
import 'package:smart_reload_system_admin/src/core/router/route.constants.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.event.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.state.dart';

class BankInfoScreen extends StatefulWidget {
  const BankInfoScreen({super.key});

  @override
  State<BankInfoScreen> createState() => _BankInfoScreenState();
}

class _BankInfoScreenState extends State<BankInfoScreen> {
  bool _showFullNumber = false;
  final _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final _isLoadingNotifier = ValueNotifier<bool>(false);


  List<BankDetailsModel> bankInfoList = [];

  @override
  void initState() {
    context.read<BankBloc>().add(const BankReset());
    context.read<BankBloc>().add(const BankInfoRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      appBar: customAppBar(
        isDark: true,
        onPressed: () => Navigator.of(context).pop(),
        icon: Icons.arrow_back_ios_new_rounded,
        title: "Bank info",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.sm),
          child: Column(
            spacing: 10,
            children: [
              BlocBuilder<BankBloc, BankState>(
                builder: (context, state) {

                  if(state is BankLoading) {
                    return Padding(
                      padding: EdgeInsetsGeometry.only(top: HelperFunctions.screenHeight(context)/2.5),
                      child: CCircularProgressIndicator(color: AppColors.white),
                    );
                  }
                  if (state is BankFailure) {
                    return Padding(
                      padding: EdgeInsetsGeometry.only(top: HelperFunctions.screenHeight(context)/3.5),
                      child: FallbackWidget(
                        isDark: true,
                        onPressed: () {
                          context.read<BankBloc>().add(const BankInfoRequested());
                        },
                      ),
                    );
                  }
                  if(state is BankInfoRemoveSuccess){
                    if(state.success){
                      AppSnackbar.showSuccess(context, "Bank info removed successfully");
                    }else{
                      AppSnackbar.showError(context, "Failed to remove bank info");
                    }
                  }
                  if(state is BankSuccess) {
                    bankInfoList = state.items;

                    if(bankInfoList.isEmpty) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(top: HelperFunctions.screenHeight(context)/3),
                            child: Column(
                              children: [
                                EmptyScreenWidget(isDark: true, message: 'No Bank info yet.'),
                                SizedBox(height: Sizes.sm),
                                BlocListener<AuthBloc, AuthState>(
                                  listener: (context, state) {
                                    _isLoadingNotifier.value = state is AuthLoading;

                                    if (state is AuthFailureState) {
                                      AppSnackbar.showError(context, state.message, showUp: true); // wrong password, etc.
                                    } else if (state is ReauthenticationSuccess) {
                                      Navigator.of(context).pop();
                                      Navigator.pushNamed(context, RouteConstants.newBankInfoScreen);
                                    }
                                  },
                                  child: CElevatedButton(
                                    onPressed: () async{
                                      await AppDialog.showForm(
                                        context,
                                        isDark: true,
                                        title: 'Enter Password',
                                        form: Form(
                                          key: _passwordFormKey,
                                          child: CTextField(
                                            isDark: true,
                                            maxLines: 1,
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
                                        onSubmit: () {
                                          if(_passwordFormKey.currentState!.validate()){
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            context.read<AuthBloc>().add(ReauthenticateRequested(password: _passwordController.text));
                                          }
                                        },
                                      );
                                    },
                                    bgColor: AppColors.primary.withValues(alpha: 0.4),
                                    width: HelperFunctions.screenWidth(context)/2,
                                    label: "Add New",
                                  ),
                                ),
                              ],
                            ),
                        ),
                      );
                    }else{
                      return ListView.separated(
                        itemCount: bankInfoList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, _) =>
                        const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = bankInfoList[index];
                          return CCard(
                            isDark: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.account_balance_outlined, size: 22, color: AppColors.white),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TitleText(text: item.bankName, color: AppColors.white),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SubTitleText(
                                  text: '${item.accountHolderName} • ${item.branchName}',
                                  color: AppColors.grey,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SubHeadlineText(
                                          text: HelperFunctions.maskedNumber(item.accountNumber, showFullNumber: _showFullNumber),
                                          color: AppColors.white,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            _showFullNumber ? Icons.visibility_off : Icons.visibility,
                                            color: AppColors.darkGrey,
                                            size: 18,
                                          ),
                                          onPressed: () => setState(() => _showFullNumber = !_showFullNumber),
                                        ),
                                      ],
                                    ),
                                    BlocListener<AuthBloc, AuthState>(
                                      listener: (context, state) {
                                        _isLoadingNotifier.value = state is AuthLoading;

                                        if (state is AuthFailureState) {
                                          AppSnackbar.showError(context, state.message, showUp: true); // wrong password, etc.
                                        } else if (state is ReauthenticationSuccess) {
                                          context.read<BankBloc>().add(RemoveBankInfoRequested(bankDetailsId: item.id!));
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: TextButton.icon(
                                        onPressed: () async{
                                          await AppDialog.showForm(
                                            context,
                                            isDark: true,
                                            title: 'Enter Password',
                                            form: Form(
                                              key: _passwordFormKey,
                                              child: CTextField(
                                                isDark: true,
                                                maxLines: 1,
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

                                        },
                                        style: Theme.of(context).textButtonTheme.style?.copyWith(
                                            foregroundColor: WidgetStatePropertyAll(AppColors.red)
                                        ),
                                        icon: const Icon(Icons.clear, size: 16),
                                        label: const Text('Remove'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );

                        },
                      );
                    }
                  }

                  return const SizedBox();
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}