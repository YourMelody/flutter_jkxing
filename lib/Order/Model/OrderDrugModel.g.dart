// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderDrugModel.dart';

OrderDrugModel _$OrderDrugModelFromJson(Map<String, dynamic> json) {
	return OrderDrugModel(
		json['id'] as int,
		json['prescriptionCode'] as String,
		json['productId'] as int,
		json['productName'] as String,
		json['amount'] as int,
		json['packing'] as String,
		json['salePrice'] as int,
		json['costPrice'] as int,
		json['doctorPriceCommission'] as int,
		json['agentPriceCommission'] as int,
		json['createTime'] as int,
		json['updateTime'] as int,
		json['rebatePrice'] as int
	);
}

Map<String, dynamic> _$OrderDrugModelToJson(OrderDrugModel instance) =>
	<String, dynamic>{
		'id': instance.id,
		'prescriptionCode': instance.prescriptionCode,
		'productId': instance.productId,
		'productName': instance.productName,
		'amount': instance.amount,
		'packing': instance.packing,
		'salePrice': instance.salePrice,
		'costPrice': instance.costPrice,
		'doctorPriceCommission': instance.doctorPriceCommission,
		'agentPriceCommission': instance.agentPriceCommission,
		'createTime': instance.createTime,
		'updateTime': instance.updateTime,
		'rebatePrice': instance.rebatePrice
	};
