// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MedicineItemModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineItemModel _$MedicineItemModelFromJson(Map<String, dynamic> json) {
  return MedicineItemModel(
    json['productCode'] as int,
    json['mainProductCode'] as int,
    json['productName'] as String,
    json['classCode'] as String,
    json['commonTitle'] as String,
    json['unit'] as String,
    json['manufacturer'] as String,
    json['packing'] as String,
    json['productStatusType'] as int,
    json['purchasePrice'] as int,
    json['marketPrice'] as int,
    json['ourPrice'] as int,
    json['prescriptionType'] as int,
    json['dosage'] as String,
    json['merchantManageCode'] as String,
    json['priceCommission'] as int,
    json['productImageUrl'] as String,
  );
}

Map<String, dynamic> _$MedicineItemModelToJson(MedicineItemModel instance) =>
    <String, dynamic>{
      'productCode': instance.productCode,
      'mainProductCode': instance.mainProductCode,
      'productName': instance.productName,
      'classCode': instance.classCode,
      'commonTitle': instance.commonTitle,
      'unit': instance.unit,
      'manufacturer': instance.manufacturer,
      'packing': instance.packing,
      'productStatusType': instance.productStatusType,
      'purchasePrice': instance.purchasePrice,
      'marketPrice': instance.marketPrice,
      'ourPrice': instance.ourPrice,
      'prescriptionType': instance.prescriptionType,
      'dosage': instance.dosage,
      'merchantManageCode': instance.merchantManageCode,
      'priceCommission': instance.priceCommission,
      'productImageUrl': instance.productImageUrl,
    };
