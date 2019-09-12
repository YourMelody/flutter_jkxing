import 'package:json_annotation/json_annotation.dart';

// DrugClassModel.g.dart文件将在执行生成命令后自动产生
part "MedicineItemModel.g.dart";

// 这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()

class MedicineItemModel {

	MedicineItemModel(
		this.productCode,           // 药品编号
		this.mainProductCode,       //
		this.productName,           // 产品名称
		this.classCode,             //
		this.commonTitle,           // 俗称
		this.unit,                  // 单位（盒、瓶）
		this.manufacturer,          // 药品公司
		this.packing,               // 含量
		this.productStatusType,     //
		this.purchasePrice,
		this.marketPrice,
		this.ourPrice,
		this.prescriptionType,
		this.dosage,
		this.merchantManageCode,
		this.priceCommission,
		this.productImageUrl
		);

	int productCode;
	int mainProductCode;
	String productName;
	String classCode;
	String commonTitle;
	String unit;
	String manufacturer;
	String packing;
	int productStatusType;
	int purchasePrice;
	int marketPrice;
	int ourPrice;
	int prescriptionType;
	String dosage;
	String merchantManageCode;
	int priceCommission;
	String productImageUrl;

	factory MedicineItemModel.fromJson(Map<String, dynamic> json) => _$MedicineItemModelFromJson(json);
	Map<String, dynamic> toJson() => _$MedicineItemModelToJson(this);
}