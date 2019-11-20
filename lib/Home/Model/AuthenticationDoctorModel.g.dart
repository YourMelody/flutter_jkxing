// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthenticationDoctorModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationDoctorModel _$AuthenticationDoctorModelFromJson(Map<String, dynamic> json) {
	return AuthenticationDoctorModel(
		json['hospitalId'] as int,
		json['hospitalName'] as String,
		json['doctorCount'] as int,
	);
}

Map<String, dynamic> _$AuthenticationDoctorModelToJson(AuthenticationDoctorModel instance) =>
	<String, dynamic>{
		'hospitalId': instance.hospitalId,
		'hospitalName': instance.hospitalName,
		'doctorCount': instance.doctorCount,
	};
