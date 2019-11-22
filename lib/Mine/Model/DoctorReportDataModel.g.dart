// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DoctorReportDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorReportDataModel _$DoctorReportDataModelFromJson(Map<String, dynamic> json) {
	return DoctorReportDataModel(
		json['num'] as String,
		json['name'] as String,
		json['type'] as String,
		json['order'] as String
	);
}

Map<String, dynamic> _$DoctorReportDataModelToJson(DoctorReportDataModel instance) =>
	<String, dynamic>{
		'num': instance.num,
		'name': instance.name,
		'type': instance.type,
		'order': instance.order
	};
