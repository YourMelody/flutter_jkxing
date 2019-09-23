import 'package:flutter/material.dart';

/*
* title：标题
* rightBarBtn：导航栏右侧按钮
* showBackBtn：是否显示返回按钮
* context：只有当showBackBtn为true才需要传
* */
PreferredSizeWidget ZFAppBar(String title, {List<Widget> rightBarBtn, bool showBackBtn: true, BuildContext context}) {
	return PreferredSize(
		child: AppBar(
			title: Text(
				title,
				style: TextStyle(fontSize: 18, color: Color(0xff1a1a1a), fontWeight: FontWeight.normal)
			),
			actions: rightBarBtn,
			backgroundColor: Colors.white,
			centerTitle: true,
			elevation: 0.5,
			leading: showBackBtn ? GestureDetector(
				onTap: () {
					if (Navigator.canPop(context)) {
						Navigator.pop(context);
					}
				},
				child: Container(
					padding: EdgeInsets.only(left: 6, top: 10, bottom: 10),
					child: Image.asset('lib/Images/nav_btn_back.png', width: 24, height: 24, fit: BoxFit.contain)
				),
			) : null
		), 
		preferredSize: Size.fromHeight(44)
	);
}