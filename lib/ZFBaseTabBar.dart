import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/DrugLibrary/Pages/DrugLibraryPage.dart';
import 'package:flutter_jkxing/Invitation/InvitationPage.dart';
import 'package:flutter_jkxing/Mine/Pages/MinePage.dart';
import 'Common/ZFAppBar.dart';

class ZFBaseTabBar extends StatefulWidget {
	@override
	_ZFBaseTabBarState createState() => _ZFBaseTabBarState();
}

class _ZFBaseTabBarState extends State<ZFBaseTabBar> {
	List <String> _appBarTitles;
	int _currentIndex = 0;
	List <Widget> _widgetList = List();
	
	@override
	void initState() {
		super.initState();
		_appBarTitles = ['首页', '药品库', '我的邀请', '订单', '我的'];
		
		_widgetList
			..add(Container(child: Center(
				child: Text('首页')
			)))
			..add(DrugLibraryPage())
			..add(InvitationPage())
			..add(Container(child: Center(
				child: Text('订单')
			)))
			..add(MinePage());
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			// 顶部导航栏
			appBar: ZFAppBar(_appBarTitles[_currentIndex], showBackBtn: false),
			
			// 底部导航
			bottomNavigationBar: _getCupertinoTabBar(),
			
			body: IndexedStack(
				index: _currentIndex,
				children: _widgetList
			),
		);
	}
	
	// Cupertino风格的CupertinoTabBar
	Widget _getCupertinoTabBar() {
		return CupertinoTabBar(
			items: _getTabBarItem(),
			currentIndex: _currentIndex,
			onTap: (int index) {
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