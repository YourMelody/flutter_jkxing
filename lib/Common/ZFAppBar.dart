import 'package:flutter/material.dart';

/*
* title：标题
* rightBarBtn：导航栏右侧按钮
* rightBarBtnAction：导航栏右侧按钮点击事件
* showBackBtn：是否显示返回按钮，默认为true
* context：当showBackBtn为true时必须传
* */
PreferredSizeWidget ZFAppBar(String title, {Widget rightBarBtn, Function rightBarBtnAction, PreferredSizeWidget bottom, double height : 44, bool showBackBtn: true, Function leftBarBtnAction, BuildContext context}) {
	return PreferredSize(
		child: AppBar(
			title: Text(
				title,
				style: TextStyle(fontSize: 18, color: Color(0xff1a1a1a), fontWeight: FontWeight.normal),
				maxLines: 1,
				overflow: TextOverflow.ellipsis
			),
			actions: [
				Offstage(
					offstage: rightBarBtn == null,
					child: GestureDetector(
						onTap: () {
							if (rightBarBtnAction != null) {
								rightBarBtnAction();
							}
						},
						child: Container(
							height: 44,
							alignment: Alignment.center,
							padding: EdgeInsets.only(right: 15, left: 5),
							child: rightBarBtn
						)
					)
				)
			],
			bottom: bottom,
			backgroundColor: Colors.white,
			centerTitle: true,
			elevation: 1,
			leading: showBackBtn ? GestureDetector(
				onTap: () {
					if (leftBarBtnAction != null) {
						leftBarBtnAction();
					} else if (Navigator.canPop(context)) {
						Navigator.pop(context);
					}
				},
				child: Container(
					padding: EdgeInsets.only(left: 6, top: 10, bottom: 10),
					child: Image.asset('lib/Images/nav_btn_back.png', width: 24, height: 24, fit: BoxFit.contain)
				),
			) : null,
			brightness: Brightness.light
		),
		preferredSize: Size.fromHeight(height)
	);
}