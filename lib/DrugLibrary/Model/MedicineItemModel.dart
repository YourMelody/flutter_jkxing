import 'package:json_annotation/json_annotation.dart';

part "MedicineItemModel.g.dart";

@JsonSerializable()

class MedicineItemModel {

	MedicineItemModel(
		this.productCode,           // 药品编号
		this.mainProductCode,       // 主产品编号（暂时没用到）
		this.productName,           // 产品名称
		this.classCode,             // 产品分类编号
		this.commonTitle,           // 通用名（暂时没用到）
		this.unit,                  // 单位（盒、瓶）
		this.manufacturer,          // 制造商
		this.packing,               // 产品规格
		this.productStatusType,     // 2有货  4缺货（药品列表要显示缺货标志）
		this.purchasePrice,         // 采购价（单位：分）
		this.marketPrice,           // 市场价（单位：分）
		this.ourPrice,              // 健客价（单位：分）
		this.prescriptionType,      // 处方类型：0:空 1:其他 2:红OTC 3:绿OTC 4:处方药 5:管制处方药 9:非药品（4或5时展示RX标签）
		this.dosage,                // 常规用法（'口服等等'）
		this.priceCommission,       // 健康指数
		this.productImageUrl,       // 药品图片
		this.salesVolume,			// 销售数量
		this.grossProfitMarginFlag
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
	int priceCommission;
	String productImageUrl;
	int salesVolume;
	int grossProfitMarginFlag;

	factory MedicineItemModel.fromJson(Map<String, dynamic> json) => _$MedicineItemModelFromJson(json);
	Map<String, dynamic> toJson() => _$MedicineItemModelToJson(this);
}