// 管理登陆状态的state
class ZFLoginState {
	bool isLogin;
	ZFLoginState({this.isLogin:false});
}



// 分享弹框的state
class ZFAlertViewState {
	bool showShare;
	ZFAlertViewState({this.showShare:false});
}



// 提示框的状态
enum ProgressHUDType {
	ProgressHUDType_Dismiss,
	ProgressHUDType_Loading,
	ProgressHUDType_Success,
	ProgressHUDType_Error
}

class ZFProgressHUDState {
	ProgressHUDType progressHUDType;
	String titleStr;
	ZFProgressHUDState({this.progressHUDType: ProgressHUDType.ProgressHUDType_Dismiss, this.titleStr: ''});
}



// 网络请求的状态
enum HttpAlertType {
	HttpAlertType_None,
	HttpAlertType_ProgressHUD,
	HttpAlertType_Customer
}

class ZFHttpActionState {
	HttpAlertType httpAlertType;
	ZFHttpActionState({this.httpAlertType: HttpAlertType.HttpAlertType_None});
}

// 所有state的集合
class ZFAppState {
	final ZFLoginState loginState;
	final ZFAlertViewState shareState;
	final ZFProgressHUDState progressState;
	final ZFHttpActionState httpActionState;
	ZFAppState({
		this.loginState,
		this.shareState,
		this.progressState,
		this.httpActionState
	});
}