import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Login/LoginPage.dart';
import 'package:flutter_jkxing/ZFBaseTabBar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_jkxing/Redux/ZFMainReducer.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Mine/Pages/SettingPage.dart';
import 'Common/ZFShareAlertView.dart';

void main() {
	PPSession session = PPSession.getInstance();
	session.isLogin().then((value) {
		print('isLogin = $value');
		ZFLoginState loginState = ZFLoginState(isLogin: value == true);
		ZFAlertViewState alertState = ZFAlertViewState(showShare: false);
		Store<ZFAppState> store = Store<ZFAppState>(mainReducer, initialState: ZFAppState(
			loginState: loginState,
			shareState: alertState
		));
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
									
									Positioned(
										top: 0,
										right: 0,
										bottom: 0,
										left: 0,
										child: Offstage(
											offstage: appState.shareState.showShare != true,
											child: ZFShareAlertView(),
										)
									)
								],
							);
						} else {
							return LoginPageWidget();
						}
					}
				),
				routes: {
					'my_setting_page': (_) => SettingPage()
				},
				debugShowCheckedModeBanner: false
			)
		);
	}
}


