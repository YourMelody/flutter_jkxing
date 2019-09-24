// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MineDetailModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MineDetailModel _$MineDetailModelFromJson(Map<String, dynamic> json) {
	return MineDetailModel(
		json['agentName'] as String,
		json['regionName'] as String,
		json['teamName'] as String,
		json['teamCode'] as String,
		json['crossMonth'] as bool,
		json['grossProfitMargin'] as String,
		json['teamSaleMoney'] as int,
		json['bonusMoney'] as int,
		json['saleMoney'] as int,
		json['targetMoney'] as int,
		json['floatMoney'] as int
	);
}

Map<String, dynamic> _$MineDetailModelToJson(MineDetailModel instance) =>
	<String, dynamic>{
		'agentName': instance.agentName,
		'regionName': instance.regionName,
		'teamName': instance.teamName,
		'teamCode': instance.teamCode,
		'crossMonth': instance.crossMonth,
		'grossProfitMargin': instance.grossProfitMargin,
		'teamSaleMoney': instance.teamSaleMoney,
		'bonusMoney': instance.bonusMoney,
		'saleMoney': instance.saleMoney,
		'targetMoney': instance.targetMoney,
		'floatMoney': instance.floatMoney
	};
