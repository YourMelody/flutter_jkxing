import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';

class OrderListPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _OrderListState();
	}
}

class _OrderListState extends State<OrderListPage> with SingleTickerProviderStateMixin {
	TabController _tabController;
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
					Center(child: Text('a')),
					Center(child: Text('b')),
					Center(child: Text('c')),
					Center(child: Text('d'))
				]
			)
		);
	}
}