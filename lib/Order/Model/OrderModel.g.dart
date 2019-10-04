// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
	return OrderModel(
		json['id'] as int,
		json['prescriptionCode'] as String,
		json['prescriptionType'] as int,
		json['applicationCode'] as String,
		json['doctorId'] as String,
		json['customerId'] as String,
		json['doctorName'] as String,
		json['agentId'] as String,
		json['agentName'] as String,
		json['sendTime'] as int,
		json['payTime'] as int,
		json['signTime'] as int,
		json['refundTime'] as int,
		json['prescriptionStatus'] as int,
		json['prescriptionStatusShow'] as String,
		json['orderCode'] as String,
		json['price'] as int,
		json['totalCostPrice'] as int,
		json['totalRealCost'] as int,
		json['totalRebatePrice'] as int,
		json['doctorCommission'] as int,
		json['agentCommission'] as int,
		json['commissionType'] as int,
		json['couponMoney'] as int,
		json['createTime'] as int,
		json['updateTime'] as int,
		json['isDel'] as int,
		json['orderStatus'] as int,
		(json['drugList'] as List)?.map((item) => item == null ? null : OrderDrugModel.fromJson(item as Map<String, dynamic>))?.toList(),
		json['someTime'] as int,
		json['diagnosis'] as String,
		json['hospitalName'] as String,
		json['departmentName'] as String,
		json['titleName'] as String
	);
}

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
	<String, dynamic>{
		'id': instance.id,
		'prescriptionCode': instance.prescriptionCode,
		'prescriptionType': instance.prescriptionType,
		'applicationCode': instance.applicationCode,
		'doctorId': instance.doctorId,
		'customerId': instance.customerId,
		'doctorName': instance.doctorName,
		'agentId': instance.agentId,
		'agentName': instance.agentName,
		'sendTime': instance.sendTime,
		'payTime': instance.payTime,
		'signTime': instance.signTime,
		'refundTime': instance.refundTime,
		'prescriptionStatus': instance.prescriptionStatus,
		'prescriptionStatusShow': instance.prescriptionStatusShow,
		'orderCode': instance.orderCode,
		'price': instance.price,
		'totalCostPrice': instance.totalCostPrice,
		'totalRealCost': instance.totalRealCost,
		'totalRebatePrice': instance.totalRebatePrice,
		'doctorCommission': instance.doctorCommission,
		'agentCommission': instance.agentCommission,
		'commissionType': instance.commissionType,
		'couponMoney': instance.couponMoney,
		'createTime': instance.createTime,
		'updateTime': instance.updateTime,
		'isDel': instance.isDel,
		'orderStatus': instance.orderStatus,
		'drugList': instance.drugList,
		'someTime': instance.someTime,
		'diagnosis': instance.diagnosis,
		'hospitalName': instance.hospitalName,
		'departmentName': instance.departmentName,
		'titleName': instance.titleName
	};
