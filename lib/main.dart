import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Login/LoginPage.dart';
import 'package:flutter_jkxing/ZFBaseTabBar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_jkxing/Redux/ZFMainReducer.dart';
//import 'package:flutter_jkxing/Common/PPSession.dart';

void main() {
//	PPSession session = PPSession.getInstance();
//	session.isLogin().then((value) {
//		print('isLogin = $value');
//		ZFLoginState loginState = ZFLoginState(isLogin: value == true);
//		Store<ZFAppState> store = Store<ZFAppState>(mainReducer, initialState: ZFAppState(
//			loginState: loginState
//		));
//		return runApp(MyApp(store));
//	});
	
	
	Store<ZFAppState> store = Store<ZFAppState>(mainReducer, initialState: ZFAppState(loginState: ZFLoginState()));
	runApp(MyApp(store));
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
							return ZFBaseTabBar();
						} else {
							return LoginPageWidget();
						}
					}
				),
				debugShowCheckedModeBanner: false
			)
		);
	}
}


