import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFProgressHUDView.dart';

class ProgressUtil {
	showWithType(BuildContext context, ProgressType type, {String title, bool autoDismiss: true}) {
		showGeneralDialog(
			context: context,
			pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
				return ZFProgressHUDView(type, title);
			},
			barrierColor: Color(0x01000000),
			barrierDismissible: true,
			barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
			transitionDuration: const Duration(milliseconds: 150),
			transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
				return FadeTransition(
					opacity: CurvedAnimation(
						parent: animation,
						curve: Curves.easeOut,
					),
					child: child
				);
			}
		);

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