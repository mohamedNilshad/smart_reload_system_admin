// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserEntity _$AdminUserEntityFromJson(Map<String, dynamic> json) =>
    AdminUserEntity(
      id: json['id'] as String?,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      nic: json['nic'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$AdminUserEntityToJson(AdminUserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'nic': instance.nic,
      'role': instance.role,
      'isActive': instance.isActive,
    };
