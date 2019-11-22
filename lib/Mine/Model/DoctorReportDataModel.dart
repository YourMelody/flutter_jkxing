import 'package:json_annotation/json_annotation.dart';

part "DoctorReportDataModel.g.dart";

@JsonSerializable()

class DoctorReportDataModel {
	
	DoctorReportDataModel(this.num, this.name, this.type, this.order);
	String num;           // 代表姓名
	String name;          // 地区
	String type;          // 团队名称
	String order;         // 团队编码
	
	factory DoctorReportDataModel.fromJson(Map<String, dynamic> json) => _$DoctorReportDataModelFromJson(json);
	Map<String, dynamic> toJson() => _$DoctorReportDataModelToJson(this);
}