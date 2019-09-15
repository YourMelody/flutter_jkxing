import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/UserModel.dart';
import '../Utils/HttpUtil.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_jkxing/Common/ZFBaseUrl.dart';

class LoginRequest {
	/*
	* 登陆接口
	*
	* account： 账号
	* password： 密码
	* verifyCode： 输入的验证码
	* authCode： 接口返回的验证码
	* */
	static Future<dynamic> loginReq(String account, String password, String inputCode, String token, {CancelToken cancelToken}) {
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
			baseUrl: ZFBaseUrl().BjUrl(),
			cancelToken: cancelToken
		).then((data) {
			return data;
		});
	}
	
	/*
	* 获取图形验证码的token
	* */
	static Future<dynamic> getImgToken() {
		return HttpUtil.getInstance().get(
			'user/api/sms/getToken',
			baseUrl: ZFBaseUrl().BjUrl()
		).then((data) {
			return data;
		});
	}
	
	/*
	* 获取用户信息
	* */
	static Future<dynamic> getUserInfoReq() {
		return HttpUtil.getInstance().get(
			'user/api/medicalAgentUser/getAgentInfoWithInvestUrl',
			data: {'userId': PPSession.getInstance().userId},
			baseUrl: ZFBaseUrl().BjUrl()
		).then((data) {
			PPSession.getInstance().userModel = UserModel.fromJson(data['data']);
		});
	}
}