import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoading extends NewsState {
  final bool isAdding;
  final bool isUpdating;
  final bool isDeleting;
  final bool isFetching;

  const NewsLoading({this.isAdding = false, this.isUpdating = false, this.isDeleting = false, this.isFetching = false});
  @override
  List<Object?> get props => [isAdding, isUpdating, isDeleting, isFetching];
}

class NewsLoaded extends NewsState {
  final List<BannerNewsModel> newsList;
  const NewsLoaded({required this.newsList});

  @override
  List<Object?> get props => [newsList];
}

class NewsFailure extends NewsState {
  final String message;
  const NewsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NewsUpdateSuccess extends NewsState {
  const NewsUpdateSuccess();
}

class NewsAddedSuccess extends NewsState {
  const NewsAddedSuccess();
}
