import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';


class DrugConfigRequest {
	static Future<dynamic> drugConfigReq() {
		return HttpUtil.getInstance().get(
			'/prescription/api/prescription/config/rateInfo',
			showToast: ToastType.ToastTypeNone
		).then((data) {
			if (data == null) {
				return null;
			}
			return DrugConfigModel.fromJson(data);
		});
	}
}