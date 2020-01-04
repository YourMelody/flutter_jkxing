import 'package:json_annotation/json_annotation.dart';

part "PersonalInfoModel.g.dart";

@JsonSerializable()

class PersonalInfoModel {
	
	PersonalInfoModel(this.titleMatch, this.titleType, this.list);
	
	bool titleMatch;
	int titleType;
	List <PersonInfoListItemModel> list;
	
	factory PersonalInfoModel.fromJson(Map<String, dynamic> json) => _$PersonalInfoModelFromJson(json);
	Map<String, dynamic> toJson() => _$PersonalInfoModelToJson(this);
}

class PersonInfoListItemModel {
	PersonInfoListItemModel(this.auditType, this.auditShowStatus, this.rejectReason, this.auth);
	
	int auditType;
	int auditShowStatus;
	String rejectReason;
	bool auth;
	
	factory PersonInfoListItemModel.fromJson(Map<String, dynamic> json) => _$PersonInfoListItemModelFromJson(json);
	Map<String, dynamic> toJson() => _$PersonInfoListItemModelToJson(this);
}