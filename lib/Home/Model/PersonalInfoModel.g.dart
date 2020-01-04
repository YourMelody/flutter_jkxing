// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PersonalInfoModel.dart';

PersonalInfoModel _$PersonalInfoModelFromJson(Map<String, dynamic> json) {
	return PersonalInfoModel(
		json['titleMatch'] as bool,
		json['titleType'] as int,
		(json['list'] as List)?.map((e) => e == null ? null
			: PersonInfoListItemModel.fromJson(e as Map<String, dynamic>))?.toList()
	);
}

Map<String, dynamic> _$PersonalInfoModelToJson(PersonalInfoModel instance) =>
	<String, dynamic>{
		'titleMatch': instance.titleMatch,
		'titleType': instance.titleType,
		'list': instance.list
	};

PersonInfoListItemModel _$PersonInfoListItemModelFromJson(Map<String, dynamic> json) {
	return PersonInfoListItemModel(
		json['auditType'] as int,
		json['auditShowStatus'] as int,
		json['rejectReason'] as String,
		json['auth'] as bool
	);
}

Map<String, dynamic> _$PersonInfoListItemModelToJson(PersonInfoListItemModel instance) =>
	<String, dynamic>{
		'auditType': instance.auditType,
		'rejectReason': instance.rejectReason,
		'auditShowStatus': instance.auditShowStatus,
		'auth': instance.auth
	};
