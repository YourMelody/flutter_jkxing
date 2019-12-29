import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Mine/Model/TeamSalesDetailModel.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'package:flutter_jkxing/Mine/Model/MineDetailModel.dart';
import 'package:flutter_jkxing/Mine/Model/DoctorReportDataModel.dart';
import 'package:flutter_jkxing/Mine/Model/ActivePerModel.dart';

class MineRequest {
	// 获取销售业绩、指标、提成等
	static Future<dynamic> getAgentSalesDetail(int startTime, int endTime, BuildContext context, {ToastType showToast}) {
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
	static Future<dynamic> getDoctorNumber(int startTime, int endTime,{String agentId, BuildContext context, ToastType showToast}) {
		return HttpUtil.getInstance().get(
			'/crm/api/agentMine/getDoctorNum',
			data: {'startTime': startTime, 'endTime': endTime, 'agentId': agentId == null? '' : agentId},
			showToast: showToast,
			context: context
		).then((data) {
			return data;
		});
	}
	
	// 获取医生活跃度
	static Future<dynamic> getDoctorActiveRequest(int periodFlag) {
		return HttpUtil.getInstance().get(
			'/crm/api/agent/doctorActivePer',
			data: {'agentId': PPSession.getInstance()?.userId ?? '', 'monthTime': DateTime.now().millisecondsSinceEpoch, 'periodFlag': periodFlag},
			showToast: ToastType.ToastTypeNone
		).then((data) {
			try {
				return ActivePerModel.fromJson(data);
			} catch (e) {
				return null;
			}
		});
	}
	
	// 获取医生报表详情
	static Future<dynamic> getDoctorReportDetailData(int startTime, int endTime, BuildContext context) {
		return HttpUtil.getInstance().post(
			'crm/api/doctorDetail/allData',
			data: {'endTime': endTime, 'startTime': startTime},
			context: context
		).then((data) {
			try {
				if (data != null && data['list'] != null) {
					return (data['list'] as List)?.map((e) {
						return e == null ? null : DoctorReportDataModel.fromJson(e);
					})?.toList();
				} else {
					return null;
				}
			} catch(e) {
				return null;
			}
		});
	}
	
	// 获取团队业绩
	static Future<dynamic> getTeamSalesDetail(int startTime, int endTime, String teamCode, BuildContext context) {
		return HttpUtil.getInstance().get(
			'crm/api/agentTeam/teamSalesPerformanceDetail',
			data: {'startTime': startTime, 'endTime': endTime, 'teamCode': teamCode},
			context: context
		).then((data) {
			try {
				if (data != null) {
					return TeamSalesDetailModel.fromJson(data);
				} else {
					return null;
				}
			} catch(e) {
				return null;
			}
		});
	}
	
	// 获取未活跃医生列表
	static Future<dynamic> getNonActiveDoctorList(int periodFlag, int page, BuildContext context) {
		return HttpUtil.getInstance().get(
			'crm/api/agent/doctorNonActiveInfo',
			data: {'agentId': PPSession.getInstance()?.userId ?? '', 'monthTime': DateTime.now().millisecondsSinceEpoch, 'periodFlag': periodFlag, 'page': page, 'limit': 20},
			showToast: ToastType.ToastTypeNone
		).then((data) {
			return data;
		});
	}
	
	// 退出登陆
	static Future<dynamic> logoutRequest(String userId, String deviceId,BuildContext context) {
		return HttpUtil.getInstance().post(
			'/user/api/user/logout',
			data: {'userId': userId, 'deviceUuid': deviceId},
			context: context
		).then((data) {
			return data;
		});
	}
}