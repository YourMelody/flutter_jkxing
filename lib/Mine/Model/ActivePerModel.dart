import 'package:json_annotation/json_annotation.dart';

part "ActivePerModel.g.dart";

@JsonSerializable()

class ActivePerModel {
	
	ActivePerModel(this.activeBase, this.activePer);
	double activeBase;  // 活跃百分比及格线
	double activePer;   // 当前活跃百分比
	
	factory ActivePerModel.fromJson(Map<String, dynamic> json) => _$ActivePerModelFromJson(json);
	Map<String, dynamic> toJson() => _$ActivePerModelToJson(this);
}