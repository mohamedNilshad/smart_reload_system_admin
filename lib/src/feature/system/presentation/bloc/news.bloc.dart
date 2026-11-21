import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/delete_news.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/get_news_list.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/update_news.usecase.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/news.event.dart';
import 'package:smart_reload_system_admin/src/feature/system/presentation/bloc/news.state.dart';
import 'package:smart_reload_system_admin/src/feature/system/domain/usecase/add_new_news.usecase.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final AddNewNewsUseCase addNewNewsUseCase;
  final UpdateNewsUseCase updateNewsUseCase;
  final DeleteNewsUseCase deleteNewsUseCase;
  final GetNewsListUseCase getNewsListUseCase;

  NewsBloc({
    required this.addNewNewsUseCase,
    required this.updateNewsUseCase,
    required this.deleteNewsUseCase,
    required this.getNewsListUseCase,
  }) : super(const NewsInitial()) {
    on<NewsUpdateRequested>(_onUpdateRequested);
    on<GetNewsListRequested>(_onGetNewsListRequested);
    on<AddNewsRequested>(_onAddNewsRequested);
    on<DeleteNewsRequested>(_onDeleteNewsRequested);
    on<NewsReset>(_onReset);
  }

  Future<void> _onUpdateRequested(NewsUpdateRequested event, Emitter<NewsState> emit) async {
    emit(const NewsLoading(isUpdating: true));
    final result = await updateNewsUseCase(event.bannerNewsModel, publishedId: event.publishedId);
    result.fold((failure) => emit(NewsFailure(failure.message)), (_) {
      emit(const NewsSuccess());
    });
  }

  Future<void> _onAddNewsRequested(AddNewsRequested event, Emitter<NewsState> emit) async {
    emit(const NewsLoading(isAdding: true));
    final result = await addNewNewsUseCase(event.bannerNewsModel, publishedId: event.publishedId);
    result.fold((failure) => emit(NewsFailure(failure.message)), (_) {
      emit(const NewsSuccess());
    });
  }

  Future<void> _onReset(NewsReset event, Emitter<NewsState> emit) async {
    emit(const NewsInitial());
  }

  Future<void> _onGetNewsListRequested(GetNewsListRequested event, Emitter<NewsState> emit) async {
    emit(const NewsLoading(isFetching: true));
    final result = await getNewsListUseCase();
    result.fold((failure) => emit(NewsFailure(failure.message)), (newsList) {
      emit(NewsLoaded(newsList: newsList));
    });
  }

  Future<void> _onDeleteNewsRequested(DeleteNewsRequested event, Emitter<NewsState> emit) async {
    emit(const NewsLoading(isDeleting: true));
    final result = await deleteNewsUseCase(event.newsId);
    result.fold((failure) => emit(NewsFailure(failure.message)), (_) {
      emit(const NewsDeleteSuccess());
    });
  }
}
