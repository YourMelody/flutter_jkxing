part of 'DrugConfigModel.dart';

HotSpecialModel _$HotSpecialModelFromJson(Map<String, dynamic> json) {
	return HotSpecialModel(
		json['limitRate'] as int,
		json['detailsPicUrl'] as String,
		json['rateIconUrl'] as String
	);
}

Map<String, dynamic> _$HotSpecialModelToJson(HotSpecialModel instance) => <String, dynamic>{
	'limitRate': instance.limitRate,
	'detailsPicUrl': instance.detailsPicUrl,
	'rateIconUrl': instance.rateIconUrl
};

DrugConfigModel _$DrugConfigModelFromJson(Map<String, dynamic> json) {
	return DrugConfigModel(
		json['configCode'] as String,
		(json['hotSpecialItems'] as List)?.map((item) => item == null ? null : HotSpecialModel.fromJson(item as Map<String, dynamic>))?.toList(),
		(json['configCode'] as String)?.length == 3 ? (json['configCode'] as String).substring(0, 1) : '0',
		(json['configCode'] as String)?.length == 3 ? (json['configCode'] as String).substring(1, 1) : '0',
		(json['configCode'] as String)?.length == 3 ? (json['configCode'] as String).substring(2, 1) : '0',
		(json['hotSpecialItems'] as List)?.map((item) => item == null ? null : item['limitRate'])?.toList()
	);
}

Map<String, dynamic> _$DrugConfigModelToJson(DrugConfigModel instance) => <String, dynamic>{
	'configCode': instance.configCode,
	'hotSpecialItems': instance.hotSpecialItems,
	'firstBit': instance.firstBit,
	'secondBit': instance.secondBit,
	'thirdBit': instance.thirdBit,
	'rateArr': instance.rateArr
};
