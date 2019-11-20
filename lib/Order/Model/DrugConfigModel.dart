import 'package:json_annotation/json_annotation.dart';

part 'DrugConfigModel.g.dart';

@JsonSerializable()

class HotSpecialModel {
	HotSpecialModel(this.limitRate, this.detailsPicUrl, this.rateIconUrl);
	
	double limitRate;
	String detailsPicUrl;
	String rateIconUrl;
	
	factory HotSpecialModel.fromJson(Map<String, dynamic> json) => _$HotSpecialModelFromJson(json);
	Map<String, dynamic> toJson() => _$HotSpecialModelToJson(this);
}

class DrugConfigModel {
	
	DrugConfigModel(this.configCode, this.hotSpecialItems, this.firstBit, this.secondBit, this.thirdBit, this.rateArr);
	
	String configCode;
	List <HotSpecialModel> hotSpecialItems;
	String firstBit;
	String secondBit;
	String thirdBit;
	List <dynamic> rateArr;
	
	factory DrugConfigModel.fromJson(Map<String, dynamic> json) => _$DrugConfigModelFromJson(json);
	Map<String, dynamic> toJson() => _$DrugConfigModelToJson(this);
}