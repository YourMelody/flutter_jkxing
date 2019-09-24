import 'package:json_annotation/json_annotation.dart';

part "MineDetailModel.g.dart";

@JsonSerializable()

class MineDetailModel {
	
	MineDetailModel(this.agentName, this.regionName, this.teamName, this.teamCode, this.crossMonth, this.grossProfitMargin, this.teamSaleMoney, this.bonusMoney, this.saleMoney, this.targetMoney, this.floatMoney);
	String agentName;           // 代表姓名
	String regionName;          // 地区
	String teamName;            // 团队名称
	String teamCode;            // 团队编码
	bool crossMonth;            // 是否跨月
	String grossProfitMargin;   // 净毛利率
	int teamSaleMoney;          // 团队业绩
	int bonusMoney;             // 个人提成
	int saleMoney;              // 销售业绩
	int targetMoney;            // 销售指标
	int floatMoney;             // 距离销售指标
	
	factory MineDetailModel.fromJson(Map<String, dynamic> json) => _$MineDetailModelFromJson(json);
	Map<String, dynamic> toJson() => _$MineDetailModelToJson(this);
}