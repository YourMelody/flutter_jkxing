import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'package:flutter_jkxing/Home/Model/AuthenticationDoctorModel.dart';
import 'package:flutter_jkxing/Home/Model/PendingAuthenticationModel.dart';

class HomeRequest {
	// 获取新增医生数和总医生数
	static Future<dynamic> getDoctorNum(BuildContext context) {
		return HttpUtil().get(
			'crm/api/agentInvitation/getDoctorNum',
			context: context,
			showToast: ToastType.ToastTypeError,
			data: {'agentId': PPSession.getInstance()?.userId ?? ''}).then((data) {
			return data;
		});
	}
	
	// 获取已通过认证医生列表
	static Future<dynamic> getAuthenDoctorList(BuildContext context) {
		return HttpUtil().get(
			'crm/api/agentInvitation/getAgentCompleteAuthInfo',
			context: context,
			showToast: ToastType.ToastTypeError,
			data: {'agentId': PPSession.getInstance()?.userId ?? ''}
		).then((data) {
			try {
				return (data as List)?.map((e) {
					return e == null ? null : AuthenticationDoctorModel.fromJson(e);
				})?.toList();
			} catch(e) {
				return null;
			}
		});
	}

	// 获取待认证医生列表
	static Future<dynamic> getPendingAuthenDoctorList(BuildContext context, int page) {
		return HttpUtil().get(
			'crm/api/agentInvitation/v2/getAgentWaitAuthInfo',
			context: context,
			showToast: ToastType.ToastTypeError,
			data: {'agentId': PPSession.getInstance()?.userId ?? '', 'limit': 20, 'page': page}
		).then((data) {
			try {
				return (data as List)?.map((e) {
					return e == null ? null : PendingAuthenticationModel.fromJson(e);
				})?.toList();
			} catch(e) {
				return null;
			}
		});
	}
}