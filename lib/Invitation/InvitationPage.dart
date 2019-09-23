import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Redux/ZFAction.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class InvitationPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _InvitationPageState();
	}
}

class _InvitationPageState extends State<InvitationPage> {
	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				// 设置渐变色
				gradient: LinearGradient(
					begin: Alignment.topCenter,
					end: Alignment.bottomCenter,
					colors: [Color(0xff33beff), Color(0x1133beff)],
					stops: [0.6, 1.0]
				)
			),
			child: Stack(
				alignment: Alignment.center,
				children: <Widget>[
					_getMainContainer(),
					_getShareBtn()
				],
			),
		);
	}
	
	Widget _getMainContainer() {
		return Positioned(
			top: 15,
			left: 20,
			right: 20,
			bottom: 28,
			child: Container(
				decoration: BoxDecoration(
					color: Colors.white,
					borderRadius: BorderRadius.circular(10)
				),
				child: Column(children: <Widget>[
					// 顶部刘海图片
					Image.asset('lib/Images/img_invite_volet.png', width: 126, height: 24),
					Padding(padding: EdgeInsets.only(bottom: 10)),
					Text('健客互联网医院', style: TextStyle(
						fontSize: 20,
						fontWeight: FontWeight.w500,
						color: Color(0xff444444)
					)),
					
					Padding(padding: EdgeInsets.only(bottom: 8)),
					Text('医疗经纪人', style: TextStyle(
						fontSize: 14,
						fontWeight: FontWeight.w500,
						color: Color(0xff666666)
					)),
					
					Padding(padding: EdgeInsets.only(top: 15)),
					Image.asset('lib/Images/img_invite_n0_network.png', width: 180, height: 180, fit: BoxFit.contain),
					
					Padding(padding: EdgeInsets.only(top: 10)),
					Text('微信扫一扫', style: TextStyle(
						fontSize: 14,
						fontWeight: FontWeight.w500,
						color: Color(0xff999999)
					)),
					
					Padding(padding: EdgeInsets.only(top: 30)),
					Container(
						margin: EdgeInsets.only(left: 20),
						alignment: Alignment.topLeft,
						child: Column(
							children: <Widget>[
								Text('1、出示二维码让医生扫描', style: TextStyle(
									fontSize: 13,
									fontWeight: FontWeight.w500,
									color: Color(0xff999999),
									height: 1.3
								)),
								Text('2、扫码后进行医生注册', style: TextStyle(
									fontSize: 13,
									fontWeight: FontWeight.w500,
									color: Color(0xff999999),
									height: 1.3
								)),
								Text('3、下载健客医院APP，登录后即可接诊', style: TextStyle(
									fontSize: 13,
									fontWeight: FontWeight.w500,
									color: Color(0xff999999),
									height: 1.3
								))
							],
							crossAxisAlignment: CrossAxisAlignment.start
						)
					)
				])
			)
		);
	}
	
	// 分享到微信
	Widget _getShareBtn() {
		return Positioned(
			bottom: 11,
			child: StoreConnector<ZFAppState, VoidCallback>(
				converter: (Store<ZFAppState> store) {
					return () => store.dispatch(AppActions.ShowShareView);
				},
				builder: (BuildContext context, VoidCallback callback) {
					return GestureDetector(
						onTap: () {
							callback();
						},
						child: Container(
							width: 210,
							height: 49,
							alignment: Alignment.center,
							decoration: BoxDecoration(
								color: Color(0xff5aa5ff),
								borderRadius: BorderRadius.circular(5)
							),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									Image.asset(
										'lib/Images/icon_invite_wechat.png',
										width: 30,
										height: 24,
									),
									Text(
										'分享到微信',
										style: TextStyle(
											fontSize: 18,
											color: Colors.white
										)
									)
								]
							)
						)
					);
				}
			)
		);
	}
}