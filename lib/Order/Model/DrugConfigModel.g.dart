part of 'DrugConfigModel.dart';

HotSpecialModel _$HotSpecialModelFromJson(Map<String, dynamic> json) {
	return HotSpecialModel(
		json['limitRate'] as double,
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
	String configCode = json['configCode'] as String;
	return DrugConfigModel(
		configCode,
		(json['hotSpecialItems'] as List)?.map((item) => item == null ? null : HotSpecialModel.fromJson(item as Map<String, dynamic>))?.toList(),
		configCode?.length == 3 ? configCode.substring(0, 1) : '0',
		configCode?.length == 3 ? configCode.substring(1, 2) : '0',
		configCode?.length == 3 ? configCode.substring(2) : '0',
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
