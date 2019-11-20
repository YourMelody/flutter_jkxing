import 'package:json_annotation/json_annotation.dart';

part "AuthenticationDoctorModel.g.dart";

@JsonSerializable()

class AuthenticationDoctorModel {
	
	AuthenticationDoctorModel(this.hospitalId, this.hospitalName, this.doctorCount);
	
	int hospitalId;         // 医院id
	String hospitalName;    // 医院名称
	int doctorCount;        // 医生数
	
	factory AuthenticationDoctorModel.fromJson(Map<String, dynamic> json) => _$AuthenticationDoctorModelFromJson(json);
	Map<String, dynamic> toJson() => _$AuthenticationDoctorModelToJson(this);
}