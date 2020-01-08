import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFProgressHUDView.dart';
import 'package:flutter_jkxing/Utils/Util.dart';

class ProgressUtil {
	showWithType(BuildContext context, ProgressType type, {String title, bool autoDismiss: true}) {
		Util().showMyGeneralDialog(context, ZFProgressHUDView(type, title));

		if (autoDismiss == true) {
			Timer(Duration(seconds: 1, milliseconds: 500), () => dismiss(context));
		}
	}
	
	dismiss(BuildContext context) {
		if (Navigator.of(context).canPop()) {
			Navigator.of(context).pop();
		}
	}
}