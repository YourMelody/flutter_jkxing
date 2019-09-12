// 管理登陆状态的state
class ZFLoginState {
	bool isLogin;
	ZFLoginState({this.isLogin:false});
}

// 所有state的集合
class ZFAppState {
	final ZFLoginState loginState;
	ZFAppState({this.loginState});
}