import 'package:flutter/cupertino.dart';
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
				rightBarBtn: Icon(Icons.search, size: 24, color: Color(0xff6bcbd6)),
				rightBarBtnAction: () => _searchAction(),
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
						unselectedLabelStyle: TextStyle(fontSize: 16)
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
				return SafeArea(child: GestureDetector(
					onTap: () {
						if (Navigator.of(context).canPop()) {
							Navigator.of(context).pop();
						}
					},
					child: Container(
						color: Color.fromRGBO(0, 0, 0, 0),
						child: Column(children: <Widget>[
							// 搜索输入框
							Container(
								color: Colors.white,
								padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
								child: Row(children: <Widget>[
									Expanded(child: CupertinoTextField(
										maxLines: 1,
										autofocus: true,
										autocorrect: false,
										textAlign: TextAlign.left,
										style: TextStyle(fontSize: 16, color: Color(0xff3b4243)),
										placeholder: '医生姓名',
										clearButtonMode: OverlayVisibilityMode.editing,
										cursorColor: Color(0xff6bcbd6),
										decoration: BoxDecoration(
											border: Border.all(width: 0, color: Colors.white),
											borderRadius: BorderRadius.circular(16),
											color: Color(0xfff4f6f9)
										),
										prefix: Container(
											padding: EdgeInsets.only(left: 6),
											child: Icon(
												Icons.search,
												color: Colors.grey,
												size: 18
											)
										),
										onSubmitted: (text) {
											this.setState(() {
												searchDocName = text;
											});
											if (Navigator.of(context).canPop()) {
												Navigator.of(context).pop();
											}
										},
										onChanged: (text) {
											this.searchDocName = text;
										}
									)),
									Padding(padding: EdgeInsets.only(right: 10)),
									GestureDetector(
										onTap: () {
											this.setState(() {});
											if (Navigator.of(context).canPop()) {
												Navigator.of(context).pop();
											}
										},
										child: Text(
											'搜索',
											style: TextStyle(fontSize: 16, color: Color(0xc00a1314), fontWeight: FontWeight.w400, decoration: TextDecoration.none)
										)
									)
								])
							),
							Expanded(child: Container(color: Color(0x80000000)))
						])
					)
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