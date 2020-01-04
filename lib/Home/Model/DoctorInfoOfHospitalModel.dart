import 'package:json_annotation/json_annotation.dart';

part "DoctorInfoOfHospitalModel.g.dart";

@JsonSerializable()


class DoctorInfoOfHospitalModel {
	
	DoctorInfoOfHospitalModel(this.userId, this.realName, this.hospitalId, this.hospitalName, this.parentDepartmentId,
		this.parentDepartmentName, this.departmentId, this.departmentName, this.title, this.doctorTitle,
		this.userStatus, this.headImgShowPath, this.license, this.workPermit, this.imageOriginal, this.dataAudit,
		this.titleMatch, this.addNew, this.dataAuditStatus, this.userPhone, this.statu, this.salesVolume);
	
	int userId;                         // 医生id
	String realName;                    // 医生姓名
	int hospitalId;                     // 医院id
	String hospitalName;                // 医院名称
	int parentDepartmentId;             // 父科室id
	String parentDepartmentName;        // 父科室名称
	int departmentId;                   // 部门id
	String departmentName;              // 部门名称
	String title;                       //
	String doctorTitle;                 // 医生职称
	int userStatus;
	String headImgShowPath;             // 医生头像
	bool license;
	bool workPermit;
	bool imageOriginal;
	bool dataAudit;
	bool titleMatch;
	bool addNew;
	int dataAuditStatus;
	String userPhone;
	int statu;
	int salesVolume;                    // 药品数量
	
	factory DoctorInfoOfHospitalModel.fromJson(Map<String, dynamic> json) => _$DoctorInfoOfHospitalModelFromJson(json);
	Map<String, dynamic> toJson() => _$DoctorInfoOfHospitalModelToJson(this);
}