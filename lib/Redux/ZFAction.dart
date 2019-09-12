enum AppActions {
	LoginSuccess,       // 登陆
	LogoutSuccess       // 退出登陆
}

class ZFAction {
	final AppActions type;
	ZFAction({this.type});
}

class ZFLoginAction extends ZFAction {
	ZFLoginAction() : super(type: AppActions.LoginSuccess);
}

class ZFLogoutAction extends ZFAction {
	ZFLogoutAction() : super(type: AppActions.LogoutSuccess);
}