import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Util {
	// 金额格式化（添加逗号）
	String formatNum(num, {point: 3}) {
		if (num != null) {
			String str = num.toString();
			String preStr = '';
			if (str.length > 1) {
				if (str.substring(0, 1) == '-') {
					preStr = '-';
					str = str.substring(1);
				} else if (str.substring(0, 1) == '+') {
					preStr = '+';
					str = str.substring(1);
				}
			}
			// 分开截取
			List<String> sub = str.split('.');
			// 处理值
			List val = List.from(sub[0].split(''));
			// 处理点
			List<String> points = List.from(sub[1].split(''));
			//处理分割符
			for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
				// 除以三没有余数、不等于零并且不等于1 就加个逗号
				if (index % 3 == 0 && index != 0 && i != 1) val[i] = val[i] + ',';
			}
			// 判断是否有长度
			if (points.length > 0) {
				return '$preStr${val.join('')}.${points.join('')}';
			} else {
				return '$preStr${val.join('')}';
			}
		} else {
			return "";
		}
	}
	
	// dialog
	void showMyGeneralDialog(BuildContext context, Widget child) {
		showGeneralDialog(
			context: context,
			pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
				return child;
			},
			barrierDismissible: true,
			barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
			transitionDuration: const Duration(milliseconds: 150),
			transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
				return FadeTransition(
					opacity: CurvedAnimation(
						parent: animation,
						curve: Curves.easeOut
					),
					child: child
				);
			}
		);
	}
}