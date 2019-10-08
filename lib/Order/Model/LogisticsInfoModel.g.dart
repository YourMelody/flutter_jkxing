part of 'LogisticsInfoModel.dart';

LogisticsInfoModel _$LogisticsInfoModelFromJson(Map<String, dynamic> json) {
  return LogisticsInfoModel(
      (json['logisticsList'] as List)
          ?.map((e) =>
              e == null ? null : LogisticsInfoDesModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['orderCode'] as String,
      json['shippingNo'] as String,
      json['companeName'] as String);
}

Map<String, dynamic> _$LogisticsInfoModelToJson(LogisticsInfoModel instance) =>
    <String, dynamic>{
      'logisticsList': instance.logisticsList,
      'orderCode': instance.orderCode,
      'shippingNo': instance.shippingNo,
      'companeName': instance.companeName
    };


LogisticsInfoDesModel _$LogisticsInfoDesModelFromJson(Map<String, dynamic> json) {
  return LogisticsInfoDesModel(json['description'] as String, json['time'] as int,
      json['orderStatus'] as int);
}

Map<String, dynamic> _$LogisticsInfoDesModelToJson(LogisticsInfoDesModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'time': instance.time,
      'orderStatus': instance.orderStatus
    };
