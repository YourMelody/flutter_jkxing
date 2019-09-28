import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Mine/Network/MineRequest.dart';
import 'package:flutter_jkxing/Redux/ZFAction.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar('设置', context: context),
			body: Container(
				margin: EdgeInsets.only(top: 10),
				child: SafeArea(child: Column(children: <Widget>[
					// 列表
					Expanded(child: ListView.separated(
						itemBuilder: (context, index) => _getSettingItem(index, context),
						separatorBuilder: (BuildContext context, int index) {
							return Container(
								height: 10,
								color: Color(0xfff4f6f9)
							);
						},
						itemCount: 3
					)),
					
					StoreConnector<ZFAppState, VoidCallback> (
						converter: (Store<ZFAppState> store) {
							return () => store.dispatch(AppActions.LogoutSuccess);
						},
						builder: (BuildContext context, VoidCallback callback) {
							// 退出登录按钮
							return GestureDetector(
								onTap: () => _logoutAction(callback, context),
								child: Container(
									height: 44,
									alignment: Alignment.center,
									color: Colors.white,
									child: Text('退出登录',
										style: TextStyle(
											fontSize: 17,
											color: Color(0xff999999)
										)
									)
								)
							);
						},
					)
				]))
			),
			backgroundColor: Color(0xfff4f6f9)
		);
	}
	
	// 退出登陆
	_logoutAction(VoidCallback callback, BuildContext context) {
		// 弹框提示
		showDialog(
			context: context,
			builder: (value) {
				return CupertinoAlertDialog(
					title: Text('确定退出登陆？'),
					actions: <Widget>[
						CupertinoButton(
							onPressed: () {
								Navigator.pop(value);
							},
							child: Text('取消'),
							pressedOpacity: 0.8
						),
						CupertinoButton(
							onPressed: () async {
								Navigator.pop(value);
								String deviceId;
								DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
								if (Platform.isAndroid) {
									AndroidDeviceInfo devInfo = await deviceInfo.androidInfo;
									deviceId = devInfo.androidId;
								} else {
									//
									IosDeviceInfo devInfo = await deviceInfo.iosInfo;
									deviceId = devInfo.identifierForVendor;
								}
								MineRequest.logoutRequest(PPSession.getInstance().userId, deviceId, context).then((response) {
									if (response != null) {
										Navigator.pop(context);
										PPSession.getInstance().removeUserInfo().then((_) {
											callback();
										});
									}
								});
							},
							child: Text('确定'),
							pressedOpacity: 0.8
						)
					]
				);
			}
		);
	}
	
	_getSettingItem(index, context) {
		if (index == 0) {
			return GestureDetector(
				onTap: () {
					Navigator.pushNamed(context, 'reset_password_page');
				},
				child:  _getItemContainer('重设密码', index)
			);
		} else if (index == 1) {
			return _getItemContainer('版本号', index);
		} else {
			return _getItemContainer('联系我们', index);
		}
	}
	
	_getItemContainer(String titleStr, int index) {
		return Container(
			alignment: Alignment.center,
			height: 44,
			color: Colors.white,
			padding: EdgeInsets.symmetric(horizontal: 15),
			child: Row(
				children: <Widget>[
					Expanded(child: Text(titleStr,
						style: TextStyle(
							fontSize: 16,
							color: Color(0xff4d4d4d)
						)
					)),
					_getItemRight(index)
				],
			),
		);
	}
	
	_getItemRight(int index) {
		if (index == 0) {
			return Image.asset('lib/Images/btn_arrow.png', width: 18, height: 18);
		} else if (index == 1) {
			return Text('v2.6.4',
				style: TextStyle(
					fontSize: 16,
					color: Color(0xff4d4d4d)
				)
			);
		} else {
			return GestureDetector(
				onTap: () {
					const String telNum = 'tel:020-80736878';
					canLaunch(telNum).then((value) {
						if (value) {
							launch(telNum);
						}
					});
				},
				child: Text('020-80736878',
					style: TextStyle(
						fontSize: 16,
						color: Color(0xff6bcbd6)
					)
				),
			);
		}
	}
}