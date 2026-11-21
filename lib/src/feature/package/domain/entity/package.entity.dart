import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package.entity.g.dart';

@JsonSerializable()
class PackageEntity extends Equatable {
  final String? id;
  final String packageDescription;
  final String packageName;
  final double packagePrice;
  final String packageType;
  final double packageValidity;
  final String serviceProvider;
  final String telecomType;
  final String validityPeriod;

  const PackageEntity({
    this.id,
    required this.packageDescription,
    required this.packageName,
    required this.packagePrice,
    required this.packageType,
    required this.packageValidity,
    required this.serviceProvider,
    required this.telecomType,
    required this.validityPeriod,
  });

  factory PackageEntity.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return PackageEntity(
      id: doc.id,
      packageDescription: data['packageDescription'] as String? ?? '',
      packageName: data['packageName'] as String? ?? '',
      packagePrice: (data['packagePrice'] as num?)?.toDouble() ?? 0,
      packageType: data['packageType'] as String? ?? '',
      packageValidity: (data['packageValidity'] as num?)?.toDouble() ?? 0,
      serviceProvider: data['serviceProvider'] as String? ?? '',
      telecomType: data['telecomType'] as String? ?? '',
      validityPeriod: data['validityPeriod'] as String? ?? '',
    );
  }

  factory PackageEntity.fromJson(Map<String, dynamic> json) => _$PackageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$PackageEntityToJson(this);

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'packageDescription': packageDescription,
        'packageName': packageName,
        'packagePrice': packagePrice,
        'packageType': packageType,
        'packageValidity': packageValidity,
        'serviceProvider': serviceProvider,
        'telecomType': telecomType,
        'validityPeriod': validityPeriod,
        'modifiedAt': FieldValue.serverTimestamp(),
      };

  @override
  List<Object?> get props => [id, packageDescription, packageName, packagePrice, packageType, packageValidity, serviceProvider, telecomType, validityPeriod];
}
