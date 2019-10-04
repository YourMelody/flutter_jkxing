import 'OrderDrugModel.dart';
import 'package:json_annotation/json_annotation.dart';

// DrugClassModel.g.dart文件将在执行生成命令后自动产生
part "OrderModel.g.dart";

// 这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()

class OrderModel {
	
	OrderModel(
		this.id, this.prescriptionCode, this.prescriptionType, this.applicationCode,
		this.doctorId, this.customerId, this.doctorName, this.agentId, this.agentName,
		this.sendTime, this.payTime, this.signTime, this.refundTime, this.prescriptionStatus,
		this.prescriptionStatusShow, this.orderCode, this.price, this.totalCostPrice,
		this.totalRealCost, this.totalRebatePrice, this.doctorCommission, this.agentCommission,
		this.commissionType, this.couponMoney, this.createTime, this.updateTime, this.isDel,
		this.orderStatus, this.drugList, this.someTime, this.diagnosis, this.hospitalName,
		this.departmentName, this.titleName);
	
	int id;
	String prescriptionCode;
	int prescriptionType;
	String applicationCode;
	String doctorId;
	String customerId;
	String doctorName;
	String agentId;
	String agentName;
	int sendTime;
	int payTime;
	int signTime;
	int refundTime;
	int prescriptionStatus;
	String prescriptionStatusShow;
	String orderCode;
	int price;
	int totalCostPrice;
	int totalRealCost;
	int totalRebatePrice;
	int doctorCommission;
	int agentCommission;
	int commissionType;
	int couponMoney;
	int createTime;
	int updateTime;
	int isDel;
	int orderStatus;
	List <OrderDrugModel> drugList;
	int someTime;
	String diagnosis;
	String hospitalName;
	String departmentName;
	String titleName;
	
	factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
	Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}