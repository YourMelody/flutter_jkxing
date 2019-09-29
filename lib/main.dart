import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Login/LoginPage.dart';
import 'package:flutter_jkxing/ZFBaseTabBar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_jkxing/Redux/ZFMainReducer.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Mine/Pages/SettingPage.dart';
import 'package:flutter_jkxing/Common/ZFProgressHUDView.dart';
import 'Common/UserModel.dart';
import 'Common/ZFShareAlertView.dart';
import 'Login/LoginRequest.dart';
import 'Mine/Pages/ResetPwdPage.dart';

void main() {
	PPSession session = PPSession.getInstance();
	session.isLogin().then((value) async {
		if (value == true && PPSession.getInstance().userModel == null) {
			var respData = await LoginRequest.getUserInfoReq();
			if (respData != null) {
				PPSession.getInstance().userModel = UserModel.fromJson(respData);
			}
		}
		ZFLoginState loginState = ZFLoginState(isLogin: value == true);
		Store<ZFAppState> store = Store<ZFAppState>(
			mainReducer,
			initialState: ZFAppState.getInstance(value)
		);
		return runApp(MyApp(store));
	});
}

class MyApp extends StatelessWidget {
	final Store<ZFAppState> store;
	MyApp(this.store);
	
	@override
	Widget build(BuildContext context) {
		return StoreProvider<ZFAppState> (
			store: this.store, 
			child: MaterialApp(
				theme: ThemeData(
					primarySwatch: Colors.blue,
				),
				home: StoreConnector<ZFAppState, ZFAppState>(
					converter: (Store<ZFAppState> store) {
						return store.state;
					},
					builder: (BuildContext context, ZFAppState appState) {
						if (appState.loginState.isLogin) {
							return Stack(
								children: <Widget>[
									ZFBaseTabBar(),
									
									// 分享弹框
									Positioned(
										top: 0,
										right: 0,
										bottom: 0,
										left: 0,
										child: Offstage(
											offstage: appState.shareState.showShare != true,
											child: ZFShareAlertView()
										)
									),
									
									// 提示弹框
									Positioned(
										top: 0,
										right: 0,
										bottom: 0,
										left: 0,
										child: Offstage(
											offstage: appState.progressState.progressHUDType == ProgressHUDType.ProgressHUDType_Dismiss,
											child: ZFProgressHUDView(appState.progressState.progressHUDType, appState.progressState.titleStr),
										)
									)
								]
							);
						} else {
							return Stack(
								children: <Widget>[
									LoginPageWidget(),
									
									// 提示弹框
									Positioned(
										top: 0,
										right: 0,
										bottom: 0,
										left: 0,
										child: Offstage(
											offstage: appState.progressState.progressHUDType == ProgressHUDType.ProgressHUDType_Dismiss,
											child: ZFProgressHUDView(appState.progressState.progressHUDType, appState.progressState.titleStr),
										)
									)
								]
							);
						}
					}
				),
				routes: {
					'my_setting_page': (_) => SettingPage(),
					'reset_password_page': (_) => ResetPwdPage()
				},
				debugShowCheckedModeBanner: false
			)
		);
	}
}


