import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BannerNewsModel extends Equatable {
  final String? id;
  final String title;
  final String body;
  final bool isNew;
  final bool status;

  const BannerNewsModel({
    this.id,
    required this.title,
    required this.body,
    required this.isNew,
    required this.status,
  });

  factory BannerNewsModel.fromJson(Map<String, dynamic> json, {required String id}) {
    return BannerNewsModel(
      id: id,
      title: json['title'] as String,
      body: json['body'] as String,
      isNew: json['isNew'] as bool,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'isNew': isNew,
      'status': status,
      'modifiedAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [id, title, body, isNew, status];
}
