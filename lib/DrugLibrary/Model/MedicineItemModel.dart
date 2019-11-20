import 'package:json_annotation/json_annotation.dart';

part "MedicineItemModel.g.dart";

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
		this.productStatusType,     // 2有货  4缺货（药品列表要显示缺货标志）
		this.purchasePrice,
		this.marketPrice,
		this.ourPrice,
		this.prescriptionType,      // 处方类型：0:空 1:其他 2:红OTC 3:绿OTC 4:处方药 5:管制处方药 9:非药品（4或5时展示RX标签）
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