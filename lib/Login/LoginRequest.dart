import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/UserModel.dart';
import 'package:flutter_jkxing/Redux/ZFAction.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../Utils/HttpUtil.dart';
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
	static Future<dynamic> loginReq(String account, String password, String inputCode, String token, BuildContext context) {
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
			disposeData: false,
			showToast: true,
			context: context
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
			showToast: true,
			context: context
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
			showToast: false
		).then((data) {
			if (data != null) {
				PPSession.getInstance().userModel = UserModel.fromJson(data);
			}
		});
	}
}