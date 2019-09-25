import 'dart:async';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'package:flutter_jkxing/Mine/Model/MineDetailModel.dart';

class MineRequest {
	// 获取销售业绩、指标、提成等
	static Future<dynamic> getAgentSalesDetail(int startTime, int endTime) {
		return HttpUtil.getInstance().get(
			'/crm/api/agentMine/agentSalesPerformanceDetail',
			data: {'startTime': startTime, 'endTime': endTime},
			showToast: false
		).then((data) {
			try {
				return MineDetailModel.fromJson(data);
			} catch(e) {
				return null;
			}
		});
	}
	
	// 获取医生数、已通过数、待认证数
	static Future<dynamic> getDoctorNumber(int startTime, int endTime, {String agentId}) {
		return HttpUtil.getInstance().get(
			'/crm/api/agentMine/getDoctorNum',
			data: {'startTime': startTime, 'endTime': endTime, 'agentId': agentId == null? '' : agentId},
			showToast: false
		).then((data) {
			return data;
		});
	}
}