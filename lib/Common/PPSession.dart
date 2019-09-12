import 'UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PPSession {
	static PPSession instance;
	UserModel userModel;
	String userId;
	String userToken;
	int logOutType;     // 1用户在其它设备登陆  2用户被禁用
	
	static PPSession getInstance() {
		if(instance == null){
			instance = PPSession();
		}
		return instance;
	}
	
	// 清除用户信息
	void removeUserInfo() async {
		this.userId = null;
		this.userToken = null;
		this.userModel = null;
		SharedPreferences pref = await SharedPreferences.getInstance();
		pref.remove('kSessionAccess_userId');
		pref.remove('kSessionAccess_userToken');
	}
	
	// 判断用户是否登陆
	Future isLogin() async {
		SharedPreferences pref = await SharedPreferences.getInstance();
		String tempId = pref.getString('kSessionAccess_userId');
		String tempToken = pref.getString('kSessionAccess_userToken');
		PPSession session = PPSession.getInstance();
		session.userId = tempId;
		session.userToken = tempToken;
		if (tempId != null && tempId.length > 0) {
			return true;
		} else {
			return false;
		}
	}
}