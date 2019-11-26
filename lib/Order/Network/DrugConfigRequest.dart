import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';


class DrugConfigRequest {
	static Future<dynamic> drugConfigReq() {
		return HttpUtil.getInstance().get(
			'/prescription/api/prescription/config/rateInfo',
			showToast: ToastType.ToastTypeNone
		).then((data) {
			try {
				if (data == null) {
					return null;
				} else {
					return DrugConfigModel.fromJson(data);
				}
			} catch(e) {
				return null;
			}
		});
	}
}