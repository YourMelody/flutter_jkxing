import 'package:json_annotation/json_annotation.dart';

part "UserModel.g.dart";

@JsonSerializable()

class UserModel {
	
	UserModel(this.realName, this.userPhone, this.userId, this.medicalCompany, this.regionName, this.investCodeImage, this.agentLevel, this.agentType);
	
	String realName;
	String userPhone;
	String userId;
	String medicalCompany;
	String regionName;
	String investCodeImage;
	int agentType;          // 1全职  2兼职
	int agentLevel;         // 1一级代理  2二级代理
	
	factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
	Map<String, dynamic> toJson() => _$UserModelToJson(this);
}