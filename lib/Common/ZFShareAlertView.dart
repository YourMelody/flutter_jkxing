import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Redux/ZFAction.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ZFShareAlertView extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () {
				if (Navigator.of(context).canPop()) {
					Navigator.of(context).pop();
				}
			},
			child: Container(
				color: Color.fromRGBO(0, 0, 0, 0.4),
				alignment: Alignment.bottomCenter,
				child: SafeArea(child: Container(
					width: double.maxFinite,
					height: 220,
					child: Container(
						decoration: BoxDecoration(
							borderRadius: BorderRadius.only(
								topLeft: Radius.circular(1.14),
								topRight: Radius.circular(1.14)
							),
							color: Color(0xfff5f5f5)
						),
						child: Column(children: <Widget>[
							Padding(padding: EdgeInsets.only(top: 15)),
							Text(
								'分享到',
								style: TextStyle(
									fontSize: 15,
									color: Color(0xff444444),
									fontWeight: FontWeight.normal,
									decoration: TextDecoration.none
								),
							),
							Padding(padding: EdgeInsets.only(top: 20)),
							Row(children: <Widget>[
								Padding(padding: EdgeInsets.only(right: 30)),
								
								// 朋友圈分享
								GestureDetector(
									onTap: () {
										if (Navigator.of(context).canPop()) {
											Navigator.of(context).pop();
										}
									},
									child: Column(children: <Widget>[
										Image.asset('lib/Images/share_btn_moments.png', width: 45, height: 45, fit: BoxFit.contain),
										Padding(padding: EdgeInsets.only(top: 10)),
										Text(
											'朋友圈',
											style: TextStyle(
												fontWeight: FontWeight.normal,
												fontSize: 15,
												color: Color(0xff999999),
												decoration: TextDecoration.none
											)
										)
									])
								),
								
								// 微信好友分享
								Expanded(child: GestureDetector(
									onTap: () {
										if (Navigator.of(context).canPop()) {
											Navigator.of(context).pop();
										}
									},
									child: Column(children: <Widget>[
										Image.asset('lib/Images/share_btn_wechat.png', width: 45, height: 45, fit: BoxFit.contain),
										Padding(padding: EdgeInsets.only(top: 10)),
										Text(
											'微信好友',
											style: TextStyle(
												fontWeight: FontWeight.normal,
												fontSize: 15,
												color: Color(0xff999999),
												decoration: TextDecoration.none
											)
										)
									])
								)),
								Padding(padding: EdgeInsets.only(right: 76))
							]),
							Padding(padding: EdgeInsets.only(top: 40)),
							
							// 取消
							GestureDetector(
								onTap: () {
									if (Navigator.of(context).canPop()) {
										Navigator.of(context).pop();
									}
								},
								child: Container(
									alignment: Alignment.center,
									color: Colors.white,
									child: Text('取消', style: TextStyle(
										fontSize: 15,
										color: Color(0xff999999),
										fontWeight: FontWeight.normal,
										decoration: TextDecoration.none
									)),
									height: 45,
									width: double.maxFinite
								)
							)
						])
					)
				))
			)
		);
	}
}