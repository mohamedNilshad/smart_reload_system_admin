import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_popup_dialog.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/app_snackbar.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom.circular_progress_indicator.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_app_bars/custom_app_bar_2.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/custom_elevated_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_buttons/toggle_button.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_chip.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text_field.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/news.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/news.event.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/news.state.dart';

class NewsBannerScreen extends StatefulWidget {
  const NewsBannerScreen({super.key});

  @override
  State<NewsBannerScreen> createState() => _NewsBannerScreenState();
}

class _NewsBannerScreenState extends State<NewsBannerScreen> {
  final _formKey = GlobalKey<FormState>();

  final loadingBtn = ValueNotifier<bool>(false);
  final _publishNow = ValueNotifier<bool>(false);
  final _isNew = ValueNotifier<bool>(false);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  List<BannerNewsModel> newsList = [];
  bool isFetching = false;
  String deletedId = "";
  BannerNewsModel? publishedNews;

  @override
  void initState() {
    context.read<NewsBloc>().add(GetNewsListRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = HelperFunctions.screenWidth(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldVendor,
      appBar: customAppBar(
        title: "News Banner",
        isDark: true,
        onPressed: Navigator.of(context).pop,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.ssm),
        child: BlocListener<NewsBloc, NewsState>(
          listener: (context, state) {
            if (state is NewsLoading) {
              loadingBtn.value = state.isAdding;
              setState(() => isFetching = state.isFetching);
            }

            if (state is NewsFailure) {
              AppSnackbar.showError(context, state.message);
              loadingBtn.value = false;
            }

            if (state is NewsSuccess) {
              AppSnackbar.showSuccess(context, "New Banner added successfully");
              loadingBtn.value = false;
              _titleController.clear();
              _bodyController.clear();
              _publishNow.value = false;
              _isNew.value = false;
              Navigator.of(context).pop();
              context.read<NewsBloc>().add(GetNewsListRequested());
            }

            if (state is NewsLoaded) {
              setState(() {
                newsList = state.newsList;
                publishedNews = newsList.firstWhere(
                  (news) => news.status == true,
                  orElse: () => BannerNewsModel(
                    title: '',
                    body: '',
                    isNew: false,
                    status: false,
                  ),
                );
                isFetching = false;
              });
            }

            if (state is NewsDeleteSuccess) {
              setState(() {
                newsList.removeWhere((news) => news.id == deletedId);
                deletedId = "";
              });

              AppSnackbar.showSuccess(context, "News deleted successfully");
            }
          },
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CElevatedButton(
                  onPressed: () {
                    _titleController.clear();
                    _bodyController.clear();
                    _isNew.value = false;
                    _publishNow.value = false;

                    _showForm(
                      onSubmit: () {
                        if (_formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final BannerNewsModel bannerNewsModel =
                              BannerNewsModel(
                                title: _titleController.text.trim(),
                                body: _bodyController.text.trim(),
                                isNew: _isNew.value,
                                status: _publishNow.value,
                              );
                          context.read<NewsBloc>().add(
                            AddNewsRequested(
                              bannerNewsModel: bannerNewsModel,
                              publishedId: publishedNews?.id,
                            ),
                          );
                        }
                      },
                    );
                  },
                  label: "Add News",
                  width: 200,
                ),
              ),
              SizedBox(height: Sizes.lg),
              Expanded(
              child: DataTable2(
                  scrollController: _scrollController,
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: screenWidth - screenWidth / 8,
                  headingTextStyle: Theme.of(context).textTheme.titleLarge,
                  headingRowColor: WidgetStatePropertyAll(AppColors.darkerGrey),
                  columns: [
                    DataColumn2(label: Text('Title'), fixedWidth: 250),
                    DataColumn2(label: Text('Body')),
                    DataColumn2(label: Text('Is New'), fixedWidth: 100),
                    DataColumn2(label: Text('Status'), fixedWidth: 100),
                    DataColumn2(label: Text('Action'), fixedWidth: 100),
                  ],
                  rows: isFetching ? ([_buildMergeTableRow(isLoading: true)]) : newsList.isEmpty ?
                  ([_buildMergeTableRow(text: "Empty")]) : newsList.map((news) {
                    return DataRow(
                      cells: [
                        DataCell(Text(news.title)),
                        DataCell(Text(news.body)),
                        DataCell(
                          CChip(
                            label: news.isNew ? 'YES' : 'NO',
                            fontColor: AppColors.white,
                            bgColor: news.isNew
                                ? AppColors.primary
                                : AppColors.grey,
                          ),
                        ),
                        DataCell(
                          CChip(
                            label: news.status ? 'PUBLISHED' : 'DRAFT',
                            bgColor: news.status
                                ? AppColors.green
                                : AppColors.grey,
                            fontColor: AppColors.white,
                          ),
                        ),
                        DataCell(
                            Row(
                              spacing: Sizes.sm,
                              children: [
                                IconButton(
                                  onPressed: deletedId.isNotEmpty ? null : (){
                                    _titleController.text = news.title;
                                    _bodyController.text = news.body;
                                    _isNew.value = news.isNew;
                                    _publishNow.value = news.status;

                                    _showForm(
                                        isEdit: true,
                                        onSubmit: () {
                                          if (_formKey.currentState!.validate()) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            final BannerNewsModel bannerNewsModel = BannerNewsModel(
                                              id: news.id,
                                              title: _titleController.text.trim(),
                                              body: _bodyController.text.trim(),
                                              isNew: _isNew.value,
                                              status: _publishNow.value,
                                            );
                                            context.read<NewsBloc>().add(
                                              NewsUpdateRequested(bannerNewsModel: bannerNewsModel, publishedId: publishedNews?.id),
                                            );
                                          }
                                        }
                                    );
                                  },
                                  color: AppColors.buttonPrimary,
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: deletedId.isNotEmpty ? null : () async {

                                    final confirmed = await AppDialog.showConfirm(
                                      context,
                                      isDark: true,
                                      isDestructive: true,
                                      icon: Icons.delete_outline_rounded,
                                      title: 'Confirm Delete ?',
                                      subtitle: 'Are you sure you want to delete this news banner? This action cannot be undone.',
                                      cancelText: 'Cancel',
                                      confirmText: 'Delete',
                                    );

                                    if (context.mounted && confirmed == true) {
                                      setState(() => deletedId = news.id!);
                                      context.read<NewsBloc>().add(DeleteNewsRequested(newsId: deletedId));
                                    }

                                  },
                                  color: AppColors.red,
                                  icon: deletedId == news.id ? CCircularProgressIndicator(radius: 15, color: AppColors.error): Icon(Icons.delete),
                                ),
                              ],
                            )
                        ),
                      ],
                    );
                  }).toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildMergeTableRow({bool isLoading = false, String text = ""}) {
    Widget widget = Text(text);

    widget = isLoading
        ? CCircularProgressIndicator()
        : Align(alignment: Alignment.centerLeft, child: widget);

    return DataRow(
      cells: [
        DataCell(SizedBox()),
        DataCell(widget),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
        DataCell(SizedBox()),
      ],
    );
  }

  void _showForm({bool isEdit = false, void Function()? onSubmit}) {
    AppDialog.showForm(
      context,
      title: "Add News",
      form: Form(
        key: _formKey,
        child: Column(
          spacing: Sizes.spaceBtwInputField,
          children: [
            CTextField(
              isDark: true,
              controller: _titleController,
              label: 'Title',
              hint: 'Enter Banner Title',
              keyboardType: TextInputType.text,
              prefixIcon: Icons.edit,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            CTextField(
              isDark: true,
              controller: _bodyController,
              label: 'Body',
              hint: 'Enter Banner Body',
              maxLines: 4,
              keyboardType: TextInputType.text,
              prefixIcon: Icons.description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a body';
                }
                return null;
              },
            ),
            Row(
              spacing: Sizes.lg,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _isNew,
                  builder: (context, isNew, _) => AppSwitchTile(
                    compact: true,
                    isDark: true,
                    value: isNew,
                    label: 'Is New',
                    onChanged: (val) => _isNew.value = val,
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _publishNow,
                  builder: (context, publishNow, _) => AppSwitchTile(
                    compact: true,
                    isDark: true,
                    value: publishNow,
                    label: 'Publish now ?',
                    onChanged: (val) => _publishNow.value = val,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      buttonText: isEdit ? "Update" : "Save",
      isDark: true,
      isLoading: loadingBtn,
      onSubmit: onSubmit,
    );
  }
}
