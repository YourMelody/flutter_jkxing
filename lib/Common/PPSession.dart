import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PPSession {
	static PPSession instance;
	UserModel userModel;
	DrugConfigModel configModel;
	String userId;
	String userToken;
	int logOutType;     // 1用户在其它设备登陆  2用户被禁用
	double paddingBottom;
	
	static PPSession getInstance() {
		if(instance == null){
			instance = PPSession();
		}
		return instance;
	}
	
	// 清除用户信息
	Future removeUserInfo() async {
		this.userId = null;
		this.userToken = null;
		this.userModel = null;
		this.configModel = null;
		instance = null;
		HttpUtil().removeInfo();
		SharedPreferences pref = await SharedPreferences.getInstance();
		pref.remove('kSessionAccess_userId');
		pref.remove('kSessionAccess_userToken');
	}
	
	// 判断用户是否登陆---刚启动App用该方法（此时PPSession为null），其它情况可直接根据PPSession来判断
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
	
	// 获取药品热度标签
	String getHotImgStr(int ourPrice, int priceCommission) {
		String hotImgStr = '';
		if (this.configModel != null && this.configModel?.firstBit == '1' && this.configModel?.thirdBit == '1') {
			if (this.configModel?.rateArr?.length != null && this.configModel.rateArr.length > 0) {
				double ratio = 0.0;
				if (ourPrice != null && ourPrice > 0 && priceCommission != null) {
					ratio = (priceCommission / ourPrice) * 100.0;
				}
				if (this.configModel.rateArr.last <= ratio) {
					for(int i = 0; i < this.configModel.rateArr.length; i++) {
						double tmpRate = this.configModel.rateArr[i];
						if (tmpRate <= ratio) {
							hotImgStr = this.configModel?.hotSpecialItems[i]?.rateIconUrl ?? '';
							break;
						}
					}
				}
			}
		}
		return hotImgStr;
	}
}