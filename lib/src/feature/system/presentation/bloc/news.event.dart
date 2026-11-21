import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class NewsUpdateRequested extends NewsEvent {
  final BannerNewsModel bannerNewsModel;
  final String? publishedId;

  const NewsUpdateRequested({required this.bannerNewsModel, this.publishedId});

  @override
  List<Object?> get props => [bannerNewsModel, publishedId];
}

class AddNewsRequested extends NewsEvent {
  final BannerNewsModel bannerNewsModel;
  final String? publishedId;

  const AddNewsRequested({required this.bannerNewsModel, this.publishedId});

  @override
  List<Object?> get props => [bannerNewsModel, publishedId];
}

class NewsReset extends NewsEvent {
  const NewsReset();
}

class GetNewsListRequested extends NewsEvent {
  const GetNewsListRequested();
}

class DeleteNewsRequested extends NewsEvent {
  final String newsId;
  const DeleteNewsRequested({required this.newsId});
}
