import 'package:json_annotation/json_annotation.dart';

// DrugClassModel.g.dart文件将在执行生成命令后自动产生
part "OrderDrugModel.g.dart";

// 这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()

class OrderDrugModel {
	
	OrderDrugModel(this.id, this.prescriptionCode, this.productId, this.productName, this.amount, this.packing, this.salePrice, this.costPrice, this.doctorPriceCommission, this.agentPriceCommission, this.createTime, this.updateTime, this.rebatePrice);
	
	int id;
	String prescriptionCode;
	int productId;
	String  productName;
	int amount;
	String packing;
	int salePrice;
	int costPrice;
	int doctorPriceCommission;
	int agentPriceCommission;
	int createTime;
	int updateTime;
	int rebatePrice;
	
	
	factory OrderDrugModel.fromJson(Map<String, dynamic> json) => _$OrderDrugModelFromJson(json);
	Map<String, dynamic> toJson() => _$OrderDrugModelToJson(this);
}