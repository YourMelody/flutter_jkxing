import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Order/Model/LogisticsInfoModel.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'package:flutter_jkxing/Order/Model/OrderModel.dart';

class OrderRequest {
	// 获取订单列表
	static Future<dynamic> getOrderList(int page, BuildContext context, {int status, bool showToast: true}) {
		var param;
		if (status == null) {
			param = {'limit': 20, 'page': page};
		} else {
			param = {'status': status, 'limit': 20, 'page': page};
		}
		return HttpUtil.getInstance().get(
			'/crm/api/prescription/list',
			data: param,
			showToast: showToast,
			context: context
		).then((data) {
			try {
				return (data['list'] as List)?.map((e) {
					return e == null ? null : OrderModel.fromJson(e);
				})?.toList();
			} catch(e) {
				return null;
			}
		});
	}
	
	static Future<dynamic> getLogisticsInfo(String orderCode, BuildContext context) {
		return HttpUtil.getInstance().post(
			'/crm/api/logistics/orderInfoNew',
			data: {'orderCode': orderCode, 'secondAgentId': PPSession.getInstance().userModel.userId},
			showToast: false,
			context: context
		).then((response) {
			if (response != null) {
				return LogisticsInfoModel.fromJson(response);
			} else {
				return null;
			}
		});
	}
}