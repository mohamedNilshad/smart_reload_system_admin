import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/system/data/model/banner_news.model.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class NewsUpdateRequested extends NewsEvent {
  final BannerNewsModel bannerNewsModel;

  const NewsUpdateRequested({required this.bannerNewsModel});

  @override
  List<Object?> get props => [bannerNewsModel];
}

class AddNewsRequested extends NewsEvent {
  final BannerNewsModel bannerNewsModel;

  const AddNewsRequested({required this.bannerNewsModel});

  @override
  List<Object?> get props => [bannerNewsModel];
}

class NewsReset extends NewsEvent {
  const NewsReset();
}

class GetNewsListRequested extends NewsEvent {
  const GetNewsListRequested();
}
