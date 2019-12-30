import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Order/Pages/OrderSearchEvent.dart';
import 'OrderListPage.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_jkxing/Home/Model/DoctorInfoOfHospitalModel.dart';

class OrderContentPage extends StatefulWidget {
	final DoctorInfoOfHospitalModel doctorModel;
	OrderContentPage({this.doctorModel});
	@override
	State<StatefulWidget> createState() {
		return _OrderContentState();
	}
}

class _OrderContentState extends State<OrderContentPage> with SingleTickerProviderStateMixin {
	TabController _tabController;
	String searchDocName = '';
	bool showBackBtn = false;
	EventBus eventBus = EventBus();
	List<String> searchList = ['', '', '', ''];
	int selectIndex = 0;
	@override
	void initState() {
		super.initState();
		_tabController = TabController(length: 4, vsync: this);
		_tabController.addListener(() {
			if (_tabController.indexIsChanging) {
				this.selectIndex = _tabController.index;
				if (this.searchList[this.selectIndex] != this.searchDocName) {
					this.searchList[this.selectIndex] = this.searchDocName;
					eventBus.fire(OrderSearchEvent(this.searchDocName, this.selectIndex));
				}
			}
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'订单',
				showBackBtn: this.showBackBtn || widget?.doctorModel != null,
				leftBarBtnAction: widget?.doctorModel != null ? null : () {
					setState(() {
						showBackBtn = false;
						searchDocName = '';
						this.searchList[this.selectIndex] = '';
						eventBus.fire(OrderSearchEvent('', this.selectIndex));
					});
				},
				rightBarBtn: widget?.doctorModel != null ? null : Icon(Icons.search, size: 24, color: Color(0xff6bcbd6)),
				rightBarBtnAction: () => _searchAction(),
				bottom: PreferredSize(
					preferredSize: widget?.doctorModel != null ? Size.fromHeight(101) : Size.fromHeight(47),
					child: _headerWidget()
				),
				height: widget?.doctorModel != null ? 145 : 91,
				context: context
			),
			body: TabBarView(
				controller: _tabController,
				children: [
					OrderListPage(this.eventBus, searchKey: this.searchDocName, doctorId: widget?.doctorModel?.userId),
					OrderListPage(this.eventBus, status: 1, searchKey: this.searchDocName, doctorId: widget?.doctorModel?.userId),
					OrderListPage(this.eventBus, status: 2, searchKey: this.searchDocName, doctorId: widget?.doctorModel?.userId),
					OrderListPage(this.eventBus, status: 3, searchKey: this.searchDocName, doctorId: widget?.doctorModel?.userId)
				]
			)
		);
	}
	
	Widget _headerWidget() {
		return Container(
			child: Column(
				children: <Widget>[
					Offstage(
						offstage: widget?.doctorModel == null,
						child: Container(
							height: 54,
							color: Color(0xfff4f6f9),
							alignment: Alignment.centerLeft,
							padding: EdgeInsets.symmetric(horizontal: 15),
							child: RichText(
								text: TextSpan(
									text: widget?.doctorModel?.realName ?? '',
									style: TextStyle(fontSize: 18, color: Color(0xff1a1a1a), fontWeight: FontWeight.w500),
									children: <TextSpan>[
										TextSpan(text: widget?.doctorModel?.realName != null && widget.doctorModel.realName.length > 0 ? '  ' : ''),
										TextSpan(
											text: widget?.doctorModel?.hospitalName ?? '',
											style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d))
										)
									]
								),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							)
						)
					),
					
					PreferredSize(
						preferredSize:  Size.fromHeight(47),
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
					)
				]
			)
		);
	}
	
	// 点击搜索
	void _searchAction() {
		if (widget?.doctorModel != null) {
			return;
		}
		TextEditingController _editingController = TextEditingController(text: this.searchDocName ?? '');
		showGeneralDialog(
			context: context,
			pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
				return SafeArea(child: GestureDetector(
					onTap: () {
						if (Navigator.of(context).canPop()) {
							Navigator.of(context).pop();
						}
					},
					child: StatefulBuilder(builder: (context, StateSetter setState) {
						return Container(
							color: Color.fromRGBO(0, 0, 0, 0),
							child: Column(children: <Widget>[
								// 搜索输入框
								Container(
									color: Colors.white,
									height: 40,
									padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
									child: Row(children: <Widget>[
										Expanded(child: CupertinoTextField(
											controller: _editingController,
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
											onSubmitted: (text) => _onSearch(),
											onChanged: (text) {
												setState(() {
													searchDocName = text;
												});
											}
										)),
										Padding(padding: EdgeInsets.only(right: 10)),
										GestureDetector(
											onTap: () => _onSearch(),
											child: Text(
												this.searchDocName != null && this.searchDocName.length > 0 ? '搜索' : '取消',
												style: TextStyle(fontSize: 16, color: Color(0xc00a1314), fontWeight: FontWeight.w400, decoration: TextDecoration.none)
											)
										)
									])
								),
								Expanded(child: Container(color: Color(0x80000000)))
							])
						);
					})
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
	
	void _onSearch() {
		if (Navigator.of(context).canPop()) {
			Navigator.of(context).pop();
		}
		if (this.searchDocName != null && this.searchDocName.length > 0) {
			// 搜索
			this.setState(() {
				showBackBtn = true;
			});
			this.searchList[this.selectIndex] = this.searchDocName;
			eventBus.fire(OrderSearchEvent(this.searchDocName, this.selectIndex));
		}
	}
}