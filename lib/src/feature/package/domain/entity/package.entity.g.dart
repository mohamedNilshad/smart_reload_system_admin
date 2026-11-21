// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageEntity _$PackageEntityFromJson(Map<String, dynamic> json) =>
    PackageEntity(
      id: json['id'] as String?,
      packageDescription: json['packageDescription'] as String,
      packageName: json['packageName'] as String,
      packagePrice: (json['packagePrice'] as num).toDouble(),
      packageType: json['packageType'] as String,
      packageValidity: (json['packageValidity'] as num).toDouble(),
      serviceProvider: json['serviceProvider'] as String,
      telecomType: json['telecomType'] as String,
      validityPeriod: json['validityPeriod'] as String,
    );

Map<String, dynamic> _$PackageEntityToJson(PackageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packageDescription': instance.packageDescription,
      'packageName': instance.packageName,
      'packagePrice': instance.packagePrice,
      'packageType': instance.packageType,
      'packageValidity': instance.packageValidity,
      'serviceProvider': instance.serviceProvider,
      'telecomType': instance.telecomType,
      'validityPeriod': instance.validityPeriod,
    };
