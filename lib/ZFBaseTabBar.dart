import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/Home/Pages/HomeContentPage.dart';
import 'package:flutter_jkxing/DrugLibrary/Pages/DrugLibraryPage.dart';
import 'package:flutter_jkxing/Invitation/InvitationPage.dart';
import 'package:flutter_jkxing/Mine/Pages/MinePage.dart';
import 'package:flutter_jkxing/Order/Pages/OrderContentPage.dart';

class ZFBaseTabBar extends StatefulWidget {
	@override
	_ZFBaseTabBarState createState() => _ZFBaseTabBarState();
}

class _ZFBaseTabBarState extends State<ZFBaseTabBar> {
	int _currentIndex = 0;
	List <Widget> _widgetList = List();
	PageController _controller;
	
	@override
	void initState() {
		super.initState();
		_controller = PageController(initialPage: 0);
		
		_widgetList
			..add(HomeContentPage())
			..add(DrugLibraryPage())
			..add(InvitationPage())
			..add(OrderContentPage())
			..add(MinePage());
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			// 底部导航
			bottomNavigationBar: _getCupertinoTabBar(),
			
			body: PageView.builder(
				itemBuilder: (context, index) {
					return _widgetList[index];
				},
				controller: _controller,
				physics: NeverScrollableScrollPhysics(),
				itemCount: _widgetList.length
			)
		);
	}
	
	Widget _getCupertinoTabBar() {
		return CupertinoTabBar(
			items: _getTabBarItem(),
			currentIndex: _currentIndex,
			onTap: (int index) {
				_controller.jumpToPage(index);
				setState(() {
					_currentIndex = index;
				});
			},
			backgroundColor: Colors.white,
			// 图片大小，默认值30
			iconSize: 24,
			activeColor: Color(0xff6bcbd6),
			inactiveColor: Color(0xff999999)
		);
	}
	
	// 底部5个tab
	List<BottomNavigationBarItem> _getTabBarItem() {
		List icons = [
			{'icon': 'lib/Images/tab_home.png', 'selIcon': 'lib/Images/tab_home_sel.png', 'title': '首页'},
			{'icon': 'lib/Images/tab_drug_lib.png', 'selIcon': 'lib/Images/tab_drug_lib_sel.png', 'title': '药品库'},
			{'icon': 'lib/Images/tab_pre.png', 'selIcon': 'lib/Images/tab_pre_sel.png', 'title': '邀请'},
			{'icon': 'lib/Images/tab_order.png', 'selIcon': 'lib/Images/tab_order_sel.png', 'title': '订单'},
			{'icon': 'lib/Images/tab_mine.png', 'selIcon': 'lib/Images/tab_mine_sel.png', 'title': '我的'}
		];
		return icons.map((item) {
			return BottomNavigationBarItem(
				icon: icons.indexOf(item) == this._currentIndex ? Image.asset(item['selIcon']) : Image.asset(item['icon']),
				title: Text(item['title'])
			);
		}).toList();
	}
}