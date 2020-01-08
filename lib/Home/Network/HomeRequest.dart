import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Home/Model/DoctorStatisticModel.dart';
import 'package:flutter_jkxing/Home/Model/PersonalInfoModel.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'package:flutter_jkxing/Home/Model/AuthenticationDoctorModel.dart';
import 'package:flutter_jkxing/Home/Model/DoctorInfoOfHospitalModel.dart';
import 'package:flutter_jkxing/Home/Model/InviteShareModel.dart';

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
					return e == null ? null : DoctorInfoOfHospitalModel.fromJson(e);
				})?.toList();
			} catch(e) {
				return null;
			}
		});
	}
	
	// 获取某个医院的医生列表
	static Future<dynamic> getDoctorListOfHospital(BuildContext context, int hospitalId, String agentId, int page) {
		return HttpUtil().get(
			'crm/api/agentInvitation/v2/getHospitalDoctorsInfo',
			context: context,
			showToast: ToastType.ToastTypeNone,
			data: {'hospitalId': hospitalId, 'agentId': agentId, 'page': page, 'limit': 20}
		).then((data) {
			try {
				return (data as List)?.map((e) {
					return e == null ? null : DoctorInfoOfHospitalModel.fromJson(e);
				})?.toList();
			} catch(e) {
				return null;
			}
		});
	}
	
	// 获取医生统计详情
	static Future<dynamic> getDoctorStatisticRequest(BuildContext context, int startTime, int endTime, String doctorId) {
		return HttpUtil().post(
			'crm/api/doctorDetail/statisData',
			context: context,
			data: {'startTime': startTime, 'endTime': endTime, 'doctorId': doctorId}
		).then((data) {
			try {
				if (data != null) {
					return DoctorStatisticModel.fromJson(data);
				}
				return null;
			} catch(e) {
				return null;
			}
		});
	}
	
	// 邀请患者二维码
	static Future<dynamic> getInvitationQRCodeReq(BuildContext context, int userId) {
		return HttpUtil().get(
			'user/api/hospitalUser/jkWalkUserInfo',
			data: {'userId': userId},
			context: context
		).then((data) {
			return data;
		});
	}
	
	// 分享信息
	static Future<dynamic> getShareInfoReq(BuildContext context, int userId) {
		return HttpUtil().post(
			'core/api/doctor/inviteDoctorShare',
			data: {'doctorId': userId.toString(), 'type': '2'},
			context: context
		).then((data) {
			try {
				if (data != null) {
					return InviteShareModel.fromJson(data);
				}
				return null;
			} catch(e) {
				return null;
			}
		});
	}
	
	// 个人信息
	static Future<dynamic> getPersonDataStatusInfo(int doctorId, BuildContext context) {
		return HttpUtil.getInstance().get(
			'user/api/hospitalUser/v2/agentGetDoctorAuditDataStatus',
			data: {'doctorId': doctorId},
			context: context
		).then((data) {
			try {
				if (data != null) {
					return PersonalInfoModel.fromJson(data);
				} else {
					return null;
				}
			} catch (e) {
				return null;
			}
		});
	}
	
	// 获取个人信息的认证照片
	static Future<dynamic> getDocAvatarReq(int doctorId, int auditType, BuildContext context) {
		return HttpUtil.getInstance().get(
			'user/api/hospitalUser/agentGetDoctorCertificateDetail',
			data: {'doctorId': doctorId, 'auditType': auditType},
			context: context
		).then((data) {
			try {
				if (data != null && (data as List).length > 0) {
					 return (data as List)[0];
				} else {
					return null;
				}
			} catch (e) {
				return null;
			}
		});
	}
}