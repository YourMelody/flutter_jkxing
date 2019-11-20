import 'package:json_annotation/json_annotation.dart';

part "DrugClassModel.g.dart";

@JsonSerializable()

class DrugClassModel {

	DrugClassModel(this.categoryCode, this.hasNode, this.categories, this.categoryName);

	String categoryCode;
	bool hasNode;
	List <DrugClassModel> categories;
	String categoryName;

	factory DrugClassModel.fromJson(Map<String, dynamic> json) => _$DrugClassModelFromJson(json);
	Map<String, dynamic> toJson() => _$DrugClassModelToJson(this);
}