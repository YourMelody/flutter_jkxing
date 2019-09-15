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
	}
	
	return state;
}