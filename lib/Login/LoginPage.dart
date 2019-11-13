import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/Common/UserModel.dart';
import 'package:flutter_jkxing/Common/ZFBaseUrl.dart';
import 'package:flutter_jkxing/Common/ZFProgressHUDView.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_jkxing/Utils/ProgressUtil.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'LoginRequest.dart';
import 'package:flutter_jkxing/Redux/ZFAction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';

// 登陆页
class LoginPageWidget extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _LoginPageState();
	}
}

class _LoginPageState extends State<LoginPageWidget> {
	String accountStr = ''; // 输入的账号
	String pwdStr = '';     // 输入的密码
	String verifyStr = '';  // 输入的验证码
	String tokenStr = '';   // 图形验证码token
	TextEditingController accountCon = TextEditingController(text: '');
	TextEditingController pwdCon = TextEditingController(text: '');
	@override
	void initState() {
		super.initState();
		_getPhoneNum();
	}
	
	_getPhoneNum() async {
		SharedPreferences pref = await SharedPreferences.getInstance();
		// 保存账号信息
		String numStr = pref.getString('loginPhoneNum');
		print('numStr = $numStr');
		if (numStr != null && numStr.length > 0) {
			setState(() {
				this.accountStr = numStr;
				accountCon = TextEditingController(text: this.accountStr);
			});
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return Container(
			color: Colors.white,
			child: SafeArea(child: Column(
				children: <Widget>[
					Padding(padding: EdgeInsets.only(top: 67)),
					// 大白logo
					Image.asset('lib/Images/login_icon_logo.png', width: 96),
					Padding(padding: EdgeInsets.only(top: 10)),
					// 健客行logo
					Image.asset('lib/Images/login_icon_jkx.png', width: 103, height: 29),
					Padding(padding: EdgeInsets.only(top: 11)),
					// 欢迎使用
					Text(
						'欢迎使用',
						style: TextStyle(
							color: Color(0xff6bcbd6),
							fontSize: 16,
							letterSpacing: 3,
							fontWeight: FontWeight.w400,
							decoration: TextDecoration.none,
							height: 0.8
						),
						textAlign: TextAlign.center
					),
					// 账号
					_getMyTF('请输入用户名', false, 'lib/Images/login_icon_account.png'),
					// 密码
					_getMyTF('请输入密码', true, 'lib/Images/login_icon_password.png'),
					// 验证码
					Offstage(
						offstage: this.tokenStr == null || this.tokenStr.length == 0,
						child: _getVerifyTF()
					),
					Padding(padding: EdgeInsets.only(top: 44)),
					// 登陆按钮
					_getLoginBtn()
				]
			))
		);
	}
	
	// 账号/密码输入框
	Widget _getMyTF(String placeholder, bool isPassword, String imgStr) {
		return Container(
			margin: EdgeInsets.only(left: 30, right: 30, top: isPassword ? 14 : 20),
			decoration: BoxDecoration(
				border: Border(
					bottom: BorderSide(
						color: Color.fromRGBO(0, 0, 0, 0.2),
						width: 0.5
					)
				)
			),
			child: CupertinoTextField(
				controller: isPassword ? pwdCon : accountCon,
				decoration: BoxDecoration(
					border: Border.all(width: 0, color: Colors.white)
				),
				padding: EdgeInsets.only(left: 10),
				maxLength: isPassword ? 30 : 11,
				style: TextStyle(
					fontSize: 14,
					color: Color(0xff4d4d4d),
					fontWeight: FontWeight.normal
				),
				placeholder: placeholder,
				placeholderStyle: TextStyle(
					fontSize: 14,
					color: Color(0xffcccccc),
					fontWeight: FontWeight.normal
				),
				clearButtonMode: OverlayVisibilityMode.editing,
				cursorColor: Color(0xff6bcbd6),
				cursorRadius: Radius.circular(1),
				obscureText: isPassword,
				prefix: Image.asset(imgStr, width: 20),
				onChanged: (text) {
					if (isPassword) {
						setState(() {
							this.pwdStr = text;
						});
					} else {
						setState(() {
							this.accountStr = text;
						});
					}
				}
			),
			height: 40
		);
	}
	
	// 验证码输入框
	Widget _getVerifyTF() {
		return Container(
			height: 40,
			margin: EdgeInsets.only(left: 30, right: 30, top: 14),
			child: Row(
				children: <Widget>[
					Expanded(child: Container(
						margin: EdgeInsets.only(right: 10),
						decoration: BoxDecoration(
							border: Border(
								bottom: BorderSide(
									color: Color.fromRGBO(0, 0, 0, 0.2),
									width: 0.5
								)
							)
						),
						child: Row(
							children: <Widget>[
								Image.asset('lib/Images/login_icon_safe.png', width: 20),
								Expanded(child: CupertinoTextField(
									decoration: BoxDecoration(
										border: Border.all(width: 0, color: Colors.white)
									),
									padding: EdgeInsets.only(left: 10),
									style: TextStyle(
										fontSize: 14,
										color: Color(0xff4d4d4d),
										fontWeight: FontWeight.normal
									),
									placeholder: '请输入图形验证码',
									placeholderStyle: TextStyle(
										fontSize: 14,
										color: Color(0xffcccccc),
										fontWeight: FontWeight.normal
									),
									clearButtonMode: OverlayVisibilityMode.editing,
									cursorColor: Color(0xff6bcbd6),
									cursorRadius: Radius.circular(1),
									onChanged: (text) {
										setState(() {
											this.verifyStr = text;
										});
									}
								))
							]
						),
						height: 40
					)),
					GestureDetector(
						onTap: () => _getImgToken(),
						child: FadeInImage.assetNetwork(
							placeholder: this.tokenStr == 'failed' ? 'lib/Images/login_token_failed.png' : 'lib/Images/login_token_loading.png',
							image: '${ZFBaseUrl().BjUrl()}/user/api/sms/authCode?token=' + this.tokenStr,
							width: 105,
							height: 40,
							fit: BoxFit.cover
						)
					)
				]
			)
		);
	}
	
	// 登陆按钮
	Widget _getLoginBtn() {
		return StoreConnector<ZFAppState, VoidCallback> (
			// converter的返回值将做为builder的callback参数
			converter: (Store<ZFAppState> store) {
				return () => store.dispatch(AppActions.LoginSuccess);
			},
			builder: (BuildContext context, VoidCallback callback) {
				return Container(
					margin: EdgeInsets.symmetric(horizontal: 15),
					height: 40,
					width: double.infinity,
					child: FlatButton(
						onPressed: ((this.tokenStr == null || this.tokenStr.length == 0) &&
							this.accountStr.length > 0 && this.pwdStr.length > 0) ||
							(this.accountStr.length > 0 && this.pwdStr.length > 0 && this.verifyStr.length > 0) ?
						() => _loginBtnAction(callback) : null,
						child: Text('登陆', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
						textColor: Colors.white,
						color: Color(0xff6bcbd6),
						disabledColor: Color(0xffe5e5e5),
						disabledTextColor: Colors.white,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(20)
						)
					)
				);
			}
		);
	}
	
	// 点击登陆
	_loginBtnAction(VoidCallback callback) {
		ProgressUtil().showWithType(context, ProgressType.ProgressType_Loading, autoDismiss: false);
		LoginRequest.loginReq(this.accountStr, this.pwdStr, this.verifyStr, this.tokenStr).then((response) {
			ProgressUtil().dismiss(context);
			int respCode = response['msg']['code'];
			String infoStr = response['msg']['info'];
			print('$respCode-----$infoStr');
			if (respCode == 20002) {
				// 展示图形验证码
				if (this.tokenStr == null || this.tokenStr.length == 0) {
					_getImgToken();
				} else {
					setState(() {});
				}
			} else if (respCode == 10012) {
				// 输入验证码有误，刷新图形验证码
				_getImgToken();
			} else if (respCode == 10002 || respCode == 10001) {
				ProgressUtil().showWithType(context, ProgressType.ProgressType_Error, title: infoStr);
				return;
			} else if (respCode == 0) {
				// 登陆成功
				_saveUserData(response['data'], callback);
			} else {
				ProgressUtil().showWithType(context, ProgressType.ProgressType_Error, title: infoStr);
			}
		}).catchError((error) {
			ProgressUtil().showWithType(context, ProgressType.ProgressType_Error, title: '网络连接异常，请检查您的网络设置');
		});
	}
	
	// 获取图形验证码的token
	_getImgToken() {
		LoginRequest.getImgToken(context).then((tokenResp) {
			if (tokenResp != null) {
				// 获取token成功
				String respToken = tokenResp['token'];
				setState(() {
					this.tokenStr = respToken;
				});
			} else {
				setState(() {
					this.tokenStr = 'failed';
				});
			}
		}).catchError((error) {
			setState(() {
				this.tokenStr = 'failed';
			});
		});
	}
	
	// 登陆成功
	_saveUserData(Map respData, VoidCallback callback) async {
		SharedPreferences pref = await SharedPreferences.getInstance();
		// 保存账号信息
		pref.setString('loginPhoneNum', this.accountStr);
		String userId = respData['userId'].toString();
		String userToken = respData['userToken'];
		// 保存userId/userToken
		pref.setString('kSessionAccess_userId', userId).then((value) {
			pref.setString('kSessionAccess_userToken', userToken).then((tokenValue) {
				PPSession session = PPSession.getInstance();
				session.userId = userId;
				session.userToken = userToken;
				// 请求获取用户信息
				LoginRequest.getUserInfoReq(context: context).then((data) {
					if (data != null) {
						PPSession.getInstance().userModel = UserModel.fromJson(data);
						callback();
					}
				});
			});
		});
	}
}