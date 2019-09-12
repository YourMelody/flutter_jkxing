import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import '../Model/DrugClassModel.dart';
import '../Model/MedicineItemModel.dart';
import 'package:flutter_jkxing/Common/ZFBaseUrl.dart';

class DrugLibRequest {
	// 获取药品库
	static Future<dynamic> getDrugClassList(String useSource, {CancelToken cancelToken}) {
		return HttpUtil.getInstance().get(
			'product/listCategory',
			baseUrl: ZFBaseUrl().BjUrl(),
			data: {'useSource': useSource},
			cancelToken: cancelToken).then((data) {
				List tempData = data['data'];
				tempData.insert(0, {
					'hasNode': false,
					'categoryName': '名医推荐',
					'categories': [],
					'categoryCode': ''
				});
				return tempData?.map((e) {
					return e == null ? null : DrugClassModel.fromJson(e);
				})?.toList();
			}
		);
	}
	
	// 名医推荐
	static Future<dynamic> getRecommendMedicineList({CancelToken cancelToken}) {
		return HttpUtil.getInstance().get(
			'product/getRecommendProduct',
			baseUrl: ZFBaseUrl().BjUrl(),
			cancelToken: cancelToken).then((data) {
				return (data['data'] as List)?.map((e) {
					return e == null ? null : MedicineItemModel.fromJson(e);
				})?.toList();
			}
		);
	}
	
	// 分类药品列表
	static Future<dynamic> getMedicineList(String categoryCode, bool hasNode, int page, {CancelToken cancelToken}) {
		return HttpUtil().get(
			'product/listByCategory',
			baseUrl: ZFBaseUrl().BjUrl(),
			data: {'categoryCode': categoryCode, 'limit': 10, 'hasNode': hasNode, 'page': page},
			cancelToken: cancelToken).then((data) {
				return (data['data']['list'] as List)?.map((e) {
					return e == null ? null : MedicineItemModel.fromJson(e);
				})?.toList();
			}
		);
	}
	
	// 药品详情
	static Future<dynamic> getMedicineDetail(int drugCode, {CancelToken cancelToken}) {
		return HttpUtil().get(
			'details/api/app/mainData/$drugCode',
			baseUrl: ZFBaseUrl().GDUrl(),
			cancelToken: cancelToken).then((data) {
				return data;
			}
		);
	}
	
	// 药品库存
	static Future<dynamic> getMedicineLastCount(int drugCode, {CancelToken cancelToken}) {
		return HttpUtil().post(
			'product/stock/getLast',
			baseUrl: ZFBaseUrl().BjUrl(),
			data: {'productCodeList': [drugCode.toString()], 'hospital': 'true'},
			cancelToken: cancelToken).then((data) {
				return data;
			}
		);
	}
}