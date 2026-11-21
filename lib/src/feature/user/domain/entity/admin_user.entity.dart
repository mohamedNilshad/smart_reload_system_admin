import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_user.entity.g.dart';

@JsonSerializable()
class AdminUserEntity extends Equatable {
  final String? id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String nic;
  final String role;
  final bool isActive;

  const AdminUserEntity({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.nic,
    required this.role,
    required this.isActive,
  });

  factory AdminUserEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return AdminUserEntity(
      id: doc.id,
      fullName: data['fullName'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      email: data['email'] as String? ?? '',
      nic: data['nic'] as String? ?? '',
      role: data['role'] as String? ?? 'client',
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  factory AdminUserEntity.fromJson(Map<String, dynamic> json) =>
      _$AdminUserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserEntityToJson(this);

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'email': email,
    'nic': nic,
    'role': role,
    'isActive': isActive,
    'updatedOn': FieldValue.serverTimestamp(),
  };

  @override
  List<Object?> get props => [
    id,
    fullName,
    phoneNumber,
    email,
    nic,
    role,
    isActive,
  ];
}
