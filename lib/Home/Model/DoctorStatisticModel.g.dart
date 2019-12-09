// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DoctorStatisticModel.dart';

DoctorStatisticModel _$DoctorStatisticModelFromJson(Map<String, dynamic> json) {
	return DoctorStatisticModel(
		json['askNum'] as int,
		json['visitNum'] as int,
		json['returnNum'] as int,
		json['sendNum'] as int,
		json['payNum'] as int,
		json['payMoney'] as int,
		json['patientNum'] as int,
		json['doctorName'] as String,
		json['hospitalName'] as String,
		json['enterDays'] as int,
		json['doctorNum'] as int,
		json['headImgShowPath'] as String,
		json['titleName'] as String,
		json['departmentName'] as String
	);
}

Map<String, dynamic> _$DoctorStatisticModelToJson(DoctorStatisticModel instance) =>
	<String, dynamic>{
		'askNum': instance.askNum,
		'visitNum': instance.visitNum,
		'returnNum': instance.returnNum,
		'sendNum': instance.sendNum,
		'payNum': instance.payNum,
		'payMoney': instance.payMoney,
		'patientNum': instance.patientNum,
		'doctorName': instance.doctorName,
		'hospitalName': instance.hospitalName,
		'enterDays': instance.enterDays,
		'doctorNum': instance.doctorNum,
		'headImgShowPath': instance.headImgShowPath,
		'titleName': instance.titleName,
		'departmentName': instance.departmentName
	};
