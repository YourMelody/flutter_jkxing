enum AppActions {
	LoginSuccess,       // 登陆
	LogoutSuccess,      // 退出登陆
	
	ZFEmptyDataAction,		// 空数据
	ZFErrorDataAction,		// 请求出错
	ZFRequestDataAction,	// 正在请求数据
}

class ZFAction {
	final AppActions type;
	ZFAction({this.type});
}