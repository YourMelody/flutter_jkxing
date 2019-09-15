enum AppActions {
	LoginSuccess,       // 登陆
	LogoutSuccess,      // 退出登陆
	ShowShareView,      // 展示分享弹框
	DismissShareView,   // 收起分享弹框
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

class ZFShowShareAction extends ZFAction {
	ZFShowShareAction() : super(type: AppActions.ShowShareView);
}

class ZFDismissShareAction extends ZFAction {
	ZFDismissShareAction() : super(type: AppActions.DismissShareView);
}