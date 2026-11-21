import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_popup_dialog.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom.circular_progress_indicator.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_app_bars/custom_app_bar_2.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_invoice_card.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/body_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/sub_headline_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/sub_title_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/title_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/empty_screen.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/fallback.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/shimmer_loading.widget.dart';
import 'package:smart_reload_system_admin/src/core/router/route.constants.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/entity/commission_withdrew_history.entity.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.event.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.state.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/com_history/com_history.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/com_history/com_history.event.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/com_history/com_history.state.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/wallet/wallet.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/wallet/wallet.event.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/wallet/wallet.state.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isTotalLoading = false;
  bool isHistoryLoading = false;
  bool isError = false;
  double totalBalance = 0.0;
  List<ComWithdrawHistoryEntity> historyList = const [];
  bool withdrewLoading = false;
  List<BankDetailsModel> bankInfoList = [];

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(const WalletReset());
    context.read<WalletBloc>().add(const WalletRequested());
    context.read<ComHistoryBloc>().add(const ComWithdrawHistoryRequested());
  }

  Future<void> _showWithdrawSheet(double availableBalance, List<BankDetailsModel> items) async {

    BankDetailsModel item = items.first;
    final navigator = Navigator.of(context);

    final confirmed = await AppDialog.showForm(
      context,
      isDark: true,
      title: 'Withdraw commission',
      form: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isEmpty) ...{
            Container(
              padding: const EdgeInsets.all(Sizes.sm),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.red, width: 1.5),
              ),
              child: Row(
                spacing: 15,
                children: [
                  Icon(Icons.error, color: AppColors.red),
                  Expanded(
                    child: const BodyText(
                      text:
                      'No bank account found. Please add a bank account to withdraw your commission.',
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          } else ...[
            Stack(
              children: [
                CCard(
                  isDark: true,
                  bgColor: AppColors.info,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_balance_outlined,
                            size: 22,
                            color: AppColors.white,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TitleText(
                              text: item.bankName,
                              color: AppColors.white,
                            ),
                          ),
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
                          SubHeadlineText(
                            text: HelperFunctions.maskedNumber(
                              item.accountNumber,
                              showFullNumber: false,
                            ),
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 20,
                  child: Icon(Icons.check_circle, color: AppColors.green),
                )
              ],
            ),
          ],

          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: HeadlineText(
              text: HelperFunctions.formatCurrency(availableBalance),
              color: AppColors.white,
            ),
          ),
        ],
      ),
      buttonText: 'Confirm withdraw',
      onSubmit: items.isEmpty ? null : () => navigator.pop(true),
    );

    if (confirmed == true) {
      if (!mounted) return;
      context.read<WalletBloc>().add(
        ComWithdrawalSubmitted(
          withdrewAmount: availableBalance,
          totalAmount: availableBalance,
          bankId: item.id!,
        ),
      );
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      appBar: customAppBar(isDark: true, title: 'Wallet'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.ssm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Header_showWithdrawSheet(totalBalance)
            MultiBlocListener(
              listeners: [
                BlocListener<WalletBloc, WalletState>(
                  listener: (context, state) {
                    if (state is WalletLoading) {
                      setState(() {
                        isError = false;
                        isTotalLoading = state.isWalletLoading;
                        withdrewLoading = state.isWithdrawalLoading;
                      });
                    }
                    if (state is WalletFailure) {
                      AppSnackbar.showError(context, state.message);
                      setState(() => isError = true);
                    }
                    if (state is WalletSuccess) {
                      setState(() {
                        totalBalance = state.totalBalance;
                        isTotalLoading = false;
                        isError = false;
                      });
                    }
                    if (state is WithdrawSubmitted) {
                      setState(() {
                        withdrewLoading = false;
                        isError = false;
                      });

                      AppSnackbar.showSuccess(context, "Amount withdrawal successfully.");
                    }
                  },
                ),

                BlocListener<BankBloc, BankState>(
                  listener: (context, state) {
                    if (state is BankLoading) {
                      setState(() => withdrewLoading = true);
                    }
                    if (state is BankFailure) {
                      setState(() => withdrewLoading = false);
                      AppSnackbar.showError(context, state.message);
                    }

                    if (state is BankSuccess) {
                      setState(() => withdrewLoading = false);
                      bankInfoList = state.items;

                      _showWithdrawSheet(totalBalance, state.items);
                    }
                  },
                ),
              ],
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Sizes.lg),
                decoration: BoxDecoration(
                  gradient: AppColors.linerGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubTitleText(
                          text: 'AVAILABLE BALANCE',
                          color: AppColors.white,
                        ),
                        Visibility(
                          visible: !isError,
                          replacement: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.14),
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.read<WalletBloc>().add(
                                  const WalletRequested(),
                                );
                              },
                              icon: Icon(Icons.refresh),
                            ),
                          ),
                          child: Row(
                            spacing: 10,
                            children: [
                              TextButton(
                                onPressed: (totalBalance == 0.0 || withdrewLoading || bankInfoList.isEmpty)
                                    ? null
                                    : () => context.read<BankBloc>().add(
                                        const BankInfoRequested(),
                                      ),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.white,
                                  backgroundColor: AppColors.white.withValues(
                                    alpha: 0.14,
                                  ),
                                ),
                                child: withdrewLoading
                                    ? CCircularProgressIndicator(
                                        color: AppColors.white,
                                        radius: 10,
                                      )
                                    : const Text('Withdraw'),
                              ),
                              if(bankInfoList.isEmpty)...{
                                InkWell(
                                  onTap: (){
                                    Navigator.pushNamed(context, RouteConstants.bankInfoScreen);
                                  },

                                  child: CircleAvatar(
                                    backgroundColor: AppColors.error.withValues(alpha: 0.3),
                                    child: Icon(Icons.question_mark_rounded, color: AppColors.white,),
                                  ),
                                )
                              },
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.xs),
                    HeadlineText(
                      text: HelperFunctions.formatCurrency(totalBalance),
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: Sizes.md),
            TitleText(text: 'Withdrawal history', color: AppColors.white),
            const SizedBox(height: Sizes.md),

            ///History
            BlocBuilder<ComHistoryBloc, ComHistoryState>(
              builder: (context, state) {
                if (state is ComHistoryLoading) {
                  return Column(
                    spacing: 10,
                    children: [
                      ShimmerLoading(
                        height: 90,
                        width: double.infinity,
                        isDark: true,
                      ),
                      ShimmerLoading(
                        height: 90,
                        width: double.infinity,
                        isDark: true,
                      ),
                      ShimmerLoading(
                        height: 90,
                        width: double.infinity,
                        isDark: true,
                      ),
                    ],
                  );
                }
                if (state is ComHistoryFailure) {
                  return FallbackWidget(
                    isDark: true,
                    onPressed: () {
                      context.read<ComHistoryBloc>().add(
                        const ComWithdrawHistoryRequested(),
                      );
                    },
                  );
                }
                if (state is WithdrawHistorySuccess) {
                  historyList = state.history;

                  if (historyList.isEmpty) {
                    return EmptyScreenWidget(
                      isDark: true,
                      message: 'No withdrawal history yet.',
                    );
                  } else {
                    return ListView.separated(
                      itemCount: historyList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = historyList[index];
                        return CustomInvoiceCard(
                          title: HelperFunctions.invoiceNumber(
                            (historyList.length - index),
                          ),
                          icon: Icons.monetization_on_outlined,
                          subtitle: 'Withdrawn',
                          amount: item.withdrewAmount,
                          date: item.date,
                          isDark: true,
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
    );
  }
}
