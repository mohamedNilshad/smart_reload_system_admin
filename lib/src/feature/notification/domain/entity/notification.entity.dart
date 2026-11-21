import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.entity.g.dart';

@JsonSerializable()
class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? route;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.route,
  });

  /// Firestore's Timestamp type isn't plain JSON, so map it manually here
  /// rather than through the generated fromJson (which is kept for any
  /// future local-cache use, same pattern as UserEntity).
  factory NotificationEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationEntity(
      id: doc.id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      isRead: data['isRead'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      route: data['route'] as String?,
    );
  }

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$NotificationEntityFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationEntityToJson(this);

  @override
  List<Object?> get props => [id, title, body, isRead, createdAt, route];
}