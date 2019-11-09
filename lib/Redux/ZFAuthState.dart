// 管理登陆状态的state
import 'dart:math';

class ZFLoginState {
	bool isLogin;
	ZFLoginState({this.isLogin:false});
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
	final ZFProgressHUDState progressState;
	final ZFHttpActionState httpActionState;
	ZFAppState({
		this.loginState,
		this.progressState,
		this.httpActionState
	});
	
	static ZFAppState getInstance(bool isLogin) {
		ZFLoginState loginState = ZFLoginState(isLogin: isLogin);
		ZFProgressHUDState progressHUDState = ZFProgressHUDState(progressHUDType: ProgressHUDType.ProgressHUDType_Dismiss);
		ZFHttpActionState httpActionState = ZFHttpActionState();
		return ZFAppState(
			loginState: loginState,
			progressState: progressHUDState,
			httpActionState: httpActionState
		);
	}
}