// 管理登陆状态的state
class ZFLoginState {
	bool isLogin;
	ZFLoginState({this.isLogin:false});
}

//
class ZFAlertViewState {
	bool showShare;
	ZFAlertViewState({this.showShare:false});
}

// 所有state的集合
class ZFAppState {
	final ZFLoginState loginState;
	final ZFAlertViewState shareState;
	ZFAppState({
		this.loginState,
		this.shareState
	});
}