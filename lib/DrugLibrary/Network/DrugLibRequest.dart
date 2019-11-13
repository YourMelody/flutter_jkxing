import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import '../Model/DrugClassModel.dart';
import '../Model/MedicineItemModel.dart';
import 'package:flutter_jkxing/Common/ZFBaseUrl.dart';

class DrugLibRequest {
	// 获取药品库
	static Future<dynamic> getDrugClassList(String useSource) {
		return HttpUtil.getInstance().get(
			'product/listCategory',
			showToast: ToastType.ToastTypeNone,
			data: {'useSource': useSource}).then((data) {
				try {
					List tempData = data;
					tempData.insert(0, {
						'hasNode': false,
						'categoryName': '名医推荐',
						'categories': [],
						'categoryCode': ''
					});
					return tempData?.map((e) {
						return e == null ? null : DrugClassModel.fromJson(e);
					})?.toList();
				} catch(e) {
					return null;
				}
			}
		);
	}
	
	// 名医推荐药品列表（不分页）
	static Future<dynamic> getRecommendMedicineList() {
		return HttpUtil.getInstance().get(
			'product/recommend/productList',
			showToast: ToastType.ToastTypeNone
		).then((data) {
				try {
					return (data as List)?.map((e) {
						return e == null ? null : MedicineItemModel.fromJson(e);
					})?.toList();
				} catch(e) {
					return null;
				}
			}
		);
	}
	
	// 分类药品列表（分页）
	static Future<dynamic> getMedicineList(String categoryCode, bool hasNode, int page, BuildContext context, ToastType showToast) {
		return HttpUtil().get(
			'product/category/productList',
			context: context,
			showToast: showToast,
			data: {'categoryCode': categoryCode, 'limit': 10, 'hasNode': hasNode, 'page': page}).then((data) {
				try {
					return (data['list'] as List)?.map((e) {
						return e == null ? null : MedicineItemModel.fromJson(e);
					})?.toList();
				} catch(e) {
					return null;
				}
			}
		);
	}
	
	// 药品详情
	static Future<dynamic> getMedicineDetail(int drugCode) {
		return HttpUtil().get(
			'details/api/app/mainData/$drugCode',
			showToast: ToastType.ToastTypeNone,
			disposeData: false,
			baseUrl: ZFBaseUrl().GDUrl()).then((data) {
				return data;
			}
		);
	}
	
	// 药品库存
	static Future<dynamic> getMedicineLastCount(int drugCode, BuildContext context, ToastType showToast) {
		return HttpUtil().post(
			'product/stock/getLast',
			context: context,
			showToast: showToast,
			data: {'productCodeList': [drugCode.toString()], 'hospital': 'true'}).then((data) {
				return data;
			}
		);
	}
}