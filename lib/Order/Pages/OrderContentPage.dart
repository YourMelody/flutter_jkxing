import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'OrderListPage.dart';

class OrderContentPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _OrderContentState();
	}
}

class _OrderContentState extends State<OrderContentPage> with SingleTickerProviderStateMixin {
	TabController _tabController;
	String searchDocName;
	@override
	void initState() {
		super.initState();
		_tabController = TabController(length: 4, vsync: this);
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar('订单', showBackBtn: false,
				rightBarBtn: GestureDetector(
					onTap: () {
						
					},
					child: Icon(Icons.search, size: 24, color: Color(0xff6bcbd6)),
				),
				bottom: PreferredSize(
					preferredSize: Size.fromHeight(47),
					child: TabBar(
						controller: _tabController,
						tabs: <Widget>[
							Tab(text: '全部'),
							Tab(text: '已支付'),
							Tab(text: '已签收'),
							Tab(text: '已取消')
						],
						isScrollable: false,
						indicatorColor: Color(0xff6bcbd6),
						indicatorWeight: 4,
						labelColor: Color(0xff6bcbd6),
						labelStyle: TextStyle(fontSize: 16),
						unselectedLabelColor: Color(0xff484848),
						unselectedLabelStyle: TextStyle(fontSize: 16),
					)
				),
				height: 91
			),
			body: TabBarView(
				controller: _tabController,
				children: [
					OrderListPage(null, this.searchDocName),
					OrderListPage(1, this.searchDocName),
					OrderListPage(2, this.searchDocName),
					OrderListPage(3, this.searchDocName)
				]
			)
		);
	}
	
	// 点击搜索
	void _searchAction() {
		showGeneralDialog(
			context: context,
			pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
				return SafeArea(child: Container(
					color: Color.fromARGB(140, 0, 0, 0),
				));
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