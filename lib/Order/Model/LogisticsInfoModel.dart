import 'package:json_annotation/json_annotation.dart';
part 'LogisticsInfoModel.g.dart';

@JsonSerializable()
class LogisticsInfoModel {
  List<LogisticsInfoDesModel> logisticsList;
  String orderCode;
  String shippingNo;
  String companeName;
  LogisticsInfoModel(this.logisticsList,this.orderCode,this.shippingNo,this.companeName);

  factory LogisticsInfoModel.fromJson(Map<String, dynamic> json) => _$LogisticsInfoModelFromJson(json);
}

@JsonSerializable()
class LogisticsInfoDesModel {
	String description;
	int time;
	int orderStatus;

	LogisticsInfoDesModel(this.description, this.time, this.orderStatus);

	factory LogisticsInfoDesModel.fromJson(Map<String, dynamic> json) => _$LogisticsInfoDesModelFromJson(json);
}