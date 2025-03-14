import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';

// 我的-->设置-->重设密码
class ResetPwdPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _ResetPwdState();
	}
}

class _ResetPwdState extends State<ResetPwdPage> {
	String verifyStr = '';
	
	@override
	void initState() {
		super.initState();
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar('重设密码', context: context),
			body: Container(
				padding: EdgeInsets.fromLTRB(50, 40, 50, 0),
				child: Column(
					children: <Widget>[
						Image.asset('lib/Images/login_icon_logo.png', width: 88, height: 88),
						Padding(padding: EdgeInsets.only(top: 15)),
						Text(
							'健客行',
							style: TextStyle(
								fontWeight: FontWeight.w500,
								fontSize: 19,
								color: Color(0xff000000),
								letterSpacing: 3
							),
						),
						Padding(padding: EdgeInsets.only(top: 15)),
						Text(
							'验证码已发送到绑定手机号\n${_securityNumText()}',
							style: TextStyle(
								fontSize: 14,
								color: Color(0xff999999),
								height: 1.1
							),
							textAlign: TextAlign.center
						),
						
						Padding(padding: EdgeInsets.only(top: 30)),
						
						// 验证码
						_createVerifyTf(),
						
						// 分割线
						Container(
							margin: EdgeInsets.only(top: 7, bottom: 40),
							height: 0.5,
							color: Color(0xff999999),
						),
						
						// 下一步btn
						Container(
							child: CupertinoButton(
								child: Text(
									'下一步',
									style: TextStyle(fontSize: 18, color: Colors.white),
								),
								color: Color(0xff6bcbd7),
								minSize: 48,
								borderRadius: BorderRadius.circular(24),
								pressedOpacity: 0.8,
								onPressed: () {
								
								}
							),
							width: double.maxFinite,
						)
					],
				),
				width: double.maxFinite,
			),
			backgroundColor: Colors.white
		);
	}
	
	// 验证码输入框
	Widget _createVerifyTf() {
		return Row(
			children: <Widget>[
				Expanded(child: Container(
					height: 26,
					child: CupertinoTextField(
						decoration: BoxDecoration(
							border: Border.all(width: 0, color: Colors.white)
						),
						padding: EdgeInsets.only(right: 10),
						style: TextStyle(
							fontSize: 14,
							color: Color(0xff1a1a1a),
						),
						placeholder: '请输入验证码',
						placeholderStyle: TextStyle(
							fontSize: 14,
							color: Color(0xffcccccc),
						),
						clearButtonMode: OverlayVisibilityMode.editing,
						cursorColor: Color(0xff6bcbd6),
						cursorRadius: Radius.circular(1),
						onChanged: (text) {
							setState(() {
								this.verifyStr = text;
							});
						}
					),
				)),
				Padding(padding: EdgeInsets.only(right: 10)),
				GestureDetector(
					onTap: () {
					
					},
					child: Container(
						width: 108,
						height: 26,
						decoration: BoxDecoration(
							color: Color(0xffe5e5e5),
							borderRadius: BorderRadius.circular(13)
						),
						child: Center(
							child: Text(
								'发送验证码',
								style: TextStyle(
									fontSize: 12,
									color: Color(0xff4d4d4d)
								),
							),
						),
					)
				)
			],
		);
	}
	
	// 手机号处理
	String _securityNumText() {
		String phoneStr = PPSession.getInstance().userModel.userPhone;
		if (phoneStr.length >= 11) {
			return phoneStr.replaceRange(3, 7, '****');
		} else {
			return '';
		}
	}
}