import 'package:json_annotation/json_annotation.dart';

part "TeamSalesDetailModel.g.dart";

@JsonSerializable()

class TeamAgentInfoModel {
	
	TeamAgentInfoModel(this.agentName, this.agentUserId, this.agentBonusMoney, this.agentSaleMoney, this.agentTargetMoney, this.doctorNum);
	
	String agentName;		// 代表姓名
	String agentUserId;		// 代表id
	int agentBonusMoney;	// 提成
	int agentSaleMoney;		// 销售业绩
	int agentTargetMoney;	// 销售指标
	int doctorNum;
	
	factory TeamAgentInfoModel.fromJson(Map<String, dynamic> json) => _$TeamAgentInfoModelFromJson(json);
	Map<String, dynamic> toJson() => _$TeamAgentInfoModelToJson(this);
}

class TeamSalesDetailModel {
	
	TeamSalesDetailModel(this.teamName, this.completeRate, this.teamNum, this.teamSaleMoney, this.teamTargetMoney, this.crossMonth, this.agentList);
	
	String teamName;			// 团队名称
	String completeRate;		// 完成度
	int teamNum;				// 团队成员个数
	int teamSaleMoney;			// 销售业绩（单位分）
	int teamTargetMoney;		// 销售指标（单位分）
	bool crossMonth;			// 是否跨月
	
	List <TeamAgentInfoModel> agentList;	// 团队成员列表
	
	factory TeamSalesDetailModel.fromJson(Map<String, dynamic> json) => _$TeamSalesDetailModelFromJson(json);
	Map<String, dynamic> toJson() => _$TeamSalesDetailModelToJson(this);
}