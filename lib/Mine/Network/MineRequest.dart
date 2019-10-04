import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'package:flutter_jkxing/Mine/Model/MineDetailModel.dart';

class MineRequest {
	// 获取销售业绩、指标、提成等
	static Future<dynamic> getAgentSalesDetail(int startTime, int endTime, BuildContext context, {bool showToast: true}) {
		print('startTime = $startTime, endTime = $endTime');
		return HttpUtil.getInstance().get(
			'/crm/api/agentMine/agentSalesPerformanceDetail',
			data: {'startTime': startTime, 'endTime': endTime},
			showToast: showToast,
			context: context
		).then((data) {
			try {
				return MineDetailModel.fromJson(data);
			} catch(e) {
				return null;
			}
		});
	}
	
	// 获取医生数、已通过数、待认证数
	static Future<dynamic> getDoctorNumber(int startTime, int endTime,{String agentId, BuildContext context, bool showToast: true}) {
		return HttpUtil.getInstance().get(
			'/crm/api/agentMine/getDoctorNum',
			data: {'startTime': startTime, 'endTime': endTime, 'agentId': agentId == null? '' : agentId},
			showToast: showToast,
			context: context
		).then((data) {
			return data;
		});
	}
	
	// 退出登陆
	static Future<dynamic> logoutRequest(String userId, String deviceId,BuildContext context) {
		return HttpUtil.getInstance().post(
			'/user/api/user/logout',
			data: {'userId': userId, 'deviceUuid': deviceId},
			showToast: true,
			context: context
		).then((data) {
			return data;
		});
	}
}