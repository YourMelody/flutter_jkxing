import 'package:json_annotation/json_annotation.dart';

part "OrderDrugModel.g.dart";

@JsonSerializable()

// 订单中药品model
class OrderDrugModel {
	
	OrderDrugModel(this.id, this.prescriptionCode, this.productId, this.productName, this.amount, this.packing, this.salePrice, this.costPrice, this.doctorPriceCommission, this.agentPriceCommission, this.createTime, this.updateTime, this.rebatePrice);
	
	int id;
	String prescriptionCode;
	int productId;
	String productName;
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