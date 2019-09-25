import 'ZFAuthState.dart';
import 'ZFAction.dart';

ZFAppState mainReducer(ZFAppState state, dynamic action) {
	if (action == AppActions.LoginSuccess) {
		// 登陆
		state.loginState.isLogin = true;
	} else if (action == AppActions.LogoutSuccess) {
		// 退出登陆
		state.loginState.isLogin = false;
	} else if (action == AppActions.ShowShareView) {
		// 分享
		state.shareState.showShare = true;
	} else if (action == AppActions.DismissShareView) {
		// 收起分享
		state.shareState.showShare = false;
	} else if (action == AppActions.ZFProgressHUDDismiss) {
		// ProgressHUD消失
		state.progressState.progressHUDType = ProgressHUDType.ProgressHUDType_Dismiss;
		state.progressState.titleStr = '';
	} else if (action == AppActions.ZFProgressHUDLoading) {
		// 加载loading
		state.progressState.progressHUDType = ProgressHUDType.ProgressHUDType_Loading;
		state.progressState.titleStr = '';
	} else if (action == AppActions.ZFProgressHUDSuccess) {
		// ProgressHUD成功提示
		state.progressState.progressHUDType = ProgressHUDType.ProgressHUDType_Success;
	} else if (action == AppActions.ZFProgressHUDError) {
		// ProgressHUD错误提示
		state.progressState.progressHUDType = ProgressHUDType.ProgressHUDType_Error;
	} else if (action == HttpAlertType.HttpAlertType_None) {
		// 请求无提示
		state.httpActionState.httpAlertType = HttpAlertType.HttpAlertType_None;
	} else if (action == HttpAlertType.HttpAlertType_ProgressHUD) {
		// 请求ProgressHUD提示
		state.httpActionState.httpAlertType = HttpAlertType.HttpAlertType_ProgressHUD;
	} else if (action == HttpAlertType.HttpAlertType_Customer) {
		// 请求自定义加载视图
		state.httpActionState.httpAlertType = HttpAlertType.HttpAlertType_Customer;
	}
	
	return state;
}