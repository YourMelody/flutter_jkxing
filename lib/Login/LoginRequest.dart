import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'package:crypto/crypto.dart';

class LoginRequest {
	/*
	* 登陆接口
	*
	* account： 账号
	* password： 密码
	* verifyCode： 输入的验证码
	* authCode： 接口返回的验证码
	* */
	static Future<dynamic> loginReq(String account, String password, String inputCode, String token) {
		var content = new Utf8Encoder().convert(password);
		var digest = md5.convert(content);
		Map params = {
			'userPhone': account,
			'userPwd': digest.toString(),
			'loginWay': '1',
			'smsToken': token,
			'authCode': inputCode
		};
		return HttpUtil.getInstance().post(
			'user/api/user/v2/login',
			data: params,
			showToast: ToastType.ToastTypeNone,
			disposeData: false
		).then((data) {
			return data;
		});
	}
	
	/*
	* 获取图形验证码的token
	* */
	static Future<dynamic> getImgToken(BuildContext context) {
		return HttpUtil.getInstance().get(
			'user/api/sms/getToken',
			context: context
		).then((data) {
			return data;
		});
	}
	
	/*
	* 获取用户信息
	* */
	static Future<dynamic> getUserInfoReq({BuildContext context}) {
		return HttpUtil.getInstance().get(
			'user/api/medicalAgentUser/getAgentInfoWithInvestUrl',
			context: context,
			showToast: ToastType.ToastTypeNormal,
			data: {'userId': PPSession.getInstance().userId}
		).then((data) {
			return data;
		});
	}
}