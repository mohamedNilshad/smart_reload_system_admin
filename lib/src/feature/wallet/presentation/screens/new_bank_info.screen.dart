import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_data.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_app_bars/custom_app_bar_2.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_dropdown.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/auth/domain/entity/user.entity.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.cubit.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.state.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.event.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/presentation/bloc/bank/bank.state.dart';

class NewBankInfoScreen extends StatefulWidget {
  const NewBankInfoScreen({super.key});

  @override
  State<NewBankInfoScreen> createState() => _NewBankInfoScreenState();
}

class _NewBankInfoScreenState extends State<NewBankInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _holder = TextEditingController();
  late final _otherBankName = TextEditingController();
  late final _bankCode = TextEditingController();
  late final _branchName = TextEditingController();
  late final _branchCode = TextEditingController();
  late final _accountNo = TextEditingController();
  late final _confirmAccountNo = TextEditingController();

  String? _selectedBank;
  String _accountType = AppData.accountTypes.first;
  late UserEntity user;

  bool isLoading = false;

  @override
  void initState() {
    final sessionState = context.read<SessionCubit>().state;
    if (sessionState is SessionAuthenticated) user = sessionState.user;
    super.initState();
  }

  @override
  void dispose() {
    for (final c in [
      _holder,
      _otherBankName,
      _bankCode,
      _branchName,
      _branchCode,
      _accountNo,
      _confirmAccountNo,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _isOther => _selectedBank == AppData.otherBank;

  void _onBankChanged(String? bank) {
    setState(() => _selectedBank = bank);
    if (bank != null && bank != AppData.otherBank) {
      _bankCode.text = AppData.banks[bank]!;
    } else {
      _bankCode.clear();
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final bankDetails = BankDetailsModel(
      accountHolderName: _holder.text.trim().replaceAll(RegExp(r'\s+'), ' '),
      bankName: _isOther ? _otherBankName.text.trim() : _selectedBank!,
      bankCode: _bankCode.text.trim(),
      branchName: _branchName.text.trim(),
      branchCode: _branchCode.text.trim(),
      accountNumber: _accountNo.text.trim(),
      accountType: _accountType,
      isDeleted: false,
      vendorId: user.uid,
      updatedAt: DateTime.now().toUtc(),
    );

    context.read<BankBloc>().add(NewBankInfoRequested(bankDetailsModel: bankDetails));
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label is required' : null;

  String? _digits(String? v, String label, {required int length}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'Digits only';
    if (v.trim().length != length) return '$label must be $length digits';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 14);

    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      appBar: customAppBar(
        isDark: true,
        onPressed: () => Navigator.of(context).pop(),
        icon: Icons.arrow_back_ios_new_rounded,
        title: "New bank info",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: HelperFunctions.screenWidth(context)/3, vertical: 50),
            child: BlocListener<BankBloc, BankState>(
              listener: (context, state) {
                if(state is BankLoading){
                  setState(() => isLoading = true);
                }

                if (state is BankSuccess) {
                  AppSnackbar.showSuccess(context, 'Bank info added successfully!');
                  setState(() => isLoading = false);
                  Navigator.of(context).pop();

                } else if (state is BankFailure) {
                  setState(() => isLoading = false);
                  AppSnackbar.showError(context, state.message);
                }
              },
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CTextField(
                      isDark: true,
                      controller: _holder,
                      label: 'Account holder',
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      hint: 'As shown on your bank book',
                      prefixIcon: Icons.person_outline_rounded,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z .'\-]")),
                      ],
                      validator: (v) {
                        final err = _required(v, 'Name');
                        if (err != null) return err;
                        return v!.trim().length < 3 ? 'Enter the full name' : null;
                      },
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputField),

                    CDropDown(
                      isDark: true,
                      onChanged: _onBankChanged,
                      validator: (v) => v == null ? 'Select a bank' : null,
                      label: "Bank & branch",
                      items: AppData.banks.keys.toList(),
                      selectedType: _selectedBank,
                    ),

                    if (_isOther) ...[
                      gap,
                      CTextField(
                        isDark: true,
                        controller: _otherBankName,
                        label: 'Bank name',
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        hint: 'Enter other bank name',
                        prefixIcon: Icons.edit_outlined,
                        validator: (v) => _required(v, 'Bank name'),
                      ),

                    ],
                    gap,

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: CTextField(
                            isDark: true,
                            controller: _bankCode,
                            keyboardType: TextInputType.number,
                            label: 'Bank code',
                            textInputAction: TextInputAction.next,
                            hint: '4 digits',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (v) => _digits(v, 'Bank code', length: 4),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: CTextField(
                            isDark: true,
                            controller: _branchCode,
                            keyboardType: TextInputType.number,
                            label: 'Branch code',
                            textInputAction: TextInputAction.next,
                            hint: '3 digits',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: (v) => _digits(v, 'Branch code', length: 3),
                          ),
                        ),
                      ],
                    ),
                    gap,

                    CTextField(
                      isDark: true,
                      controller: _branchName,
                      label: 'Branch name',
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      hint: 'e.g. Kandy Main Branch',
                      prefixIcon: Icons.location_on_outlined,
                      validator: (v) => _required(v, 'Branch name'),
                    ),

                    const SizedBox(height: Sizes.spaceBtwInputField),

                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: Sizes.fontSizeSm,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        segments: [
                          for (final t in AppData.accountTypes)
                            ButtonSegment(value: t, label: Text(t)),
                        ],
                        selected: {_accountType},
                        showSelectedIcon: true,
                        onSelectionChanged: (s) => setState(() => _accountType = s.first),
                        style: SegmentedButton.styleFrom(
                          backgroundColor: AppColors.darkGrey,
                          foregroundColor: AppColors.white,
                          selectedBackgroundColor: AppColors.primary,
                          selectedForegroundColor: AppColors.white,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    gap,

                    CTextField(
                      isDark: true,
                      controller: _accountNo,
                      keyboardType: TextInputType.number,
                      label: 'Account number',
                      textInputAction: TextInputAction.next,
                      hint: 'Enter account number',
                      prefixIcon: Icons.numbers_rounded,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(20),
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Account number is required';
                        final len = v.trim().length;
                        return (len < 6 || len > 20) ? 'Enter a valid account number' : null;
                      },
                    ),

                    const SizedBox(height: 28),

                    CElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                      label: 'Save bank details',
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