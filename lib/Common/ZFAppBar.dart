import 'package:flutter/material.dart';

/*
* title：标题
* rightBarBtn：导航栏右侧按钮
* showBackBtn：是否显示返回按钮
* context：只有当showBackBtn为true才需要传
* */
AppBar ZFAppBar(String title, {List<Widget> rightBarBtn, bool showBackBtn: true, BuildContext context }) {
	return AppBar(
		title: Text(
			title,
			style: TextStyle(fontSize: 18, color: Color(0xff1a1a1a), fontWeight: FontWeight.normal)
		),
		actions: rightBarBtn,
		backgroundColor: Colors.white,
		centerTitle: true,
		elevation: 0.5,
		leading: showBackBtn ? IconButton(
			icon: Icon(Icons.arrow_back_ios, color: Color(0xff000000)),
			onPressed: () {
				if (Navigator.canPop(context)) {
					Navigator.pop(context);
				}
			}
		) : null
	);
}