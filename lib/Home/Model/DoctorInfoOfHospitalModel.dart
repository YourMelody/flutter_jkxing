import 'package:json_annotation/json_annotation.dart';

part "DoctorInfoOfHospitalModel.g.dart";

@JsonSerializable()


class DoctorInfoOfHospitalModel {
	
	DoctorInfoOfHospitalModel(this.userId, this.realName, this.hospitalId, this.hospitalName, this.parentDepartmentId,
		this.parentDepartmentName, this.departmentId, this.departmentName, this.title, this.doctorTitle,
		this.userStatus, this.headImgShowPath, this.license, this.workPermit, this.imageOriginal, this.dataAudit,
		this.titleMatch, this.addNew, this.dataAuditStatus, this.userPhone, this.statu);
	
	int userId;
	String realName;
	int hospitalId;
	String hospitalName;
	int parentDepartmentId;
	String parentDepartmentName;
	int departmentId;
	String departmentName;
	String title;
	String doctorTitle;
	int userStatus;
	String headImgShowPath;
	bool license;
	bool workPermit;
	bool imageOriginal;
	bool dataAudit;
	bool titleMatch;
	bool addNew;
	int dataAuditStatus;
	String userPhone;
	int statu;
	
	factory DoctorInfoOfHospitalModel.fromJson(Map<String, dynamic> json) => _$DoctorInfoOfHospitalModelFromJson(json);
	Map<String, dynamic> toJson() => _$DoctorInfoOfHospitalModelToJson(this);
}