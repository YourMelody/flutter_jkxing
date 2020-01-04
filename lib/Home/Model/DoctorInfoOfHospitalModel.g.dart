// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DoctorInfoOfHospitalModel.dart';


DoctorInfoOfHospitalModel _$DoctorInfoOfHospitalModelFromJson(Map<String, dynamic> json) {
	return DoctorInfoOfHospitalModel(
		json['userId'] as int,
		json['realName'] as String,
		json['hospitalId'] as int,
		json['hospitalName'] as String,
		json['parentDepartmentId'] as int,
		json['parentDepartmentName'] as String,
		json['departmentId'] as int,
		json['departmentName'] as String,
		json['title'] as String,
		json['doctorTitle'] as String,
		json['userStatus'] as int,
		json['headImgShowPath'] as String,
		json['license'] as bool,
		json['workPermit'] as bool,
		json['imageOriginal'] as bool,
		json['dataAudit'] as bool,
		json['titleMatch'] as bool,
		json['addNew'] as bool,
		json['dataAuditStatus'] as int,
		json['userPhone'] as String,
		json['statu'] as int,
		json['salesVolume'] as int
	);
}

Map<String, dynamic> _$DoctorInfoOfHospitalModelToJson(DoctorInfoOfHospitalModel instance) =>
	<String, dynamic>{
		'userId': instance.userId,
		'realName': instance.realName,
		'hospitalId': instance.hospitalId,
		'hospitalName': instance.hospitalName,
		'parentDepartmentId': instance.parentDepartmentId,
		'parentDepartmentName': instance.parentDepartmentName,
		'departmentId': instance.departmentId,
		'departmentName': instance.departmentName,
		'title': instance.title,
		'doctorTitle': instance.doctorTitle,
		'userStatus': instance.userStatus,
		'headImgShowPath': instance.headImgShowPath,
		'license': instance.license,
		'workPermit': instance.workPermit,
		'imageOriginal': instance.imageOriginal,
		'dataAudit': instance.dataAudit,
		'titleMatch': instance.titleMatch,
		'addNew': instance.addNew,
		'dataAuditStatus': instance.dataAuditStatus,
		'userPhone': instance.userPhone,
		'statu': instance.statu,
		'salesVolume': instance.salesVolume
	};
