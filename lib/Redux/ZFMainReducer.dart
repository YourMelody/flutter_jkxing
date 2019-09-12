import 'ZFAuthState.dart';
import 'ZFAction.dart';

ZFAppState mainReducer(ZFAppState state, dynamic action) {
	if (action == AppActions.LoginSuccess) {
		state.loginState.isLogin = true;
	}
	
	if (action == AppActions.LogoutSuccess) {
		state.loginState.isLogin = false;
	}
	
	return state;
}