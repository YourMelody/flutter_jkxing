// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TeamSalesDetailModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamAgentInfoModel _$TeamAgentInfoModelFromJson(Map<String, dynamic> json) {
	return TeamAgentInfoModel(
		json['agentName'] as String,
		json['agentUserId'] as String,
		json['agentBonusMoney'] as int,
		json['agentSaleMoney'] as int,
		json['agentTargetMoney'] as int,
		json['doctorNum'] as int
	);
}

Map<String, dynamic> _$TeamAgentInfoModelToJson(TeamAgentInfoModel instance) =>
	<String, dynamic>{
		'agentName': instance.agentName,
		'agentUserId': instance.agentUserId,
		'agentBonusMoney': instance.agentBonusMoney,
		'agentSaleMoney': instance.agentSaleMoney,
		'agentTargetMoney': instance.agentTargetMoney,
		'doctorNum': instance.doctorNum
	};


TeamSalesDetailModel _$TeamSalesDetailModelFromJson(Map<String, dynamic> json) {
	return TeamSalesDetailModel(
		json['teamName'] as String,
		json['completeRate'] as String,
		json['teamNum'] as int,
		json['teamSaleMoney'] as int,
		json['teamTargetMoney'] as int,
		json['crossMonth'] as bool,
		(json['agentList'] as List)
			?.map((e) => e == null
			? null
			: TeamAgentInfoModel.fromJson(e as Map<String, dynamic>))
			?.toList()
	);
}

Map<String, dynamic> _$TeamSalesDetailModelToJson(TeamSalesDetailModel instance) =>
	<String, dynamic>{
		'teamName': instance.teamName,
		'completeRate': instance.completeRate,
		'teamNum': instance.teamNum,
		'teamSaleMoney': instance.teamSaleMoney,
		'teamTargetMoney': instance.teamTargetMoney,
		'crossMonth': instance.crossMonth,
		'agentList': instance.agentList
	};
