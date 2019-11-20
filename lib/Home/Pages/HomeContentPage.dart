import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Home/Network/HomeRequest.dart';
import 'package:flutter_jkxing/Home/Pages/HomeDoctorListPage.dart';

class HomeContentPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _HomeContentPageState();
	}
}

class _HomeContentPageState extends State<HomeContentPage> with SingleTickerProviderStateMixin {
	TabController _tabController;
	Map doctorNumMap;
	
	@override
	void initState() {
		super.initState();
		_tabController = TabController(length: 2, vsync: this);
		_tabController.addListener(() {
			_initDoctorNum();
		});
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initDoctorNum();
		});
	}
	
	// 获取医生数
	_initDoctorNum() {
		HomeRequest.getDoctorNum(context).then((response) {
			if (response != null) {
				// 请求成功
				this.setState(() {
					doctorNumMap = response;
				});
			}
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'首页',
				showBackBtn: false,
				bottom: PreferredSize(
					preferredSize: Size.fromHeight(131),
					child: Column(
						children: <Widget>[
							// 搜索框
							GestureDetector(
								onTap: () {
									// 跳转到搜索页
									
								},
								child: Container(
									height: 30,
									alignment: Alignment.center,
									margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
									padding: EdgeInsets.only(left: 15),
									decoration: BoxDecoration(
										borderRadius: BorderRadius.circular(15),
										color: Color(0xfff4f6f9)
									),
									child: Text(
										'请输入医院/医生姓名',
										style: TextStyle(
											fontSize: 14,
											color: Color(0xffc4c4c4)
										),
									),
								),
							),
							
							Container(
								height: 40,
								padding: EdgeInsets.symmetric(horizontal: 15),
								child: Row(
									children: <Widget>[
										Text(
											'我的医生共计：',
											style: TextStyle(fontSize: 14, color: Color(0x660a1314))
										),
										
										Expanded(child: Text(
											this.doctorNumMap != null ? '${this.doctorNumMap['allDoctors'] ?? 0} 名' : '0名',
											style: TextStyle(fontSize: 14, color: Color(0xff0a1314))
										)),
										
										Text(
											'今日新增：',
											style: TextStyle(fontSize: 14, color: Color(0x660a1314))
										),
										
										Text(
											this.doctorNumMap != null ? '${this.doctorNumMap['todayDoctors'] ?? 0}名' : '0名',
											style: TextStyle(fontSize: 14, color: Color(0xffe55e5e))
										)
									],
								),
							),
							
							Container(
								height: 47,
								child: TabBar(
									controller: _tabController,
									tabs: <Widget>[
										Tab(text: '已通过'),
										Tab(text: '待认证')
									],
									isScrollable: false,
									indicatorColor: Color(0xff6bcbd6),
									indicatorWeight: 4,
									labelColor: Color(0xff6bcbd6),
									labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
									unselectedLabelColor: Color(0xff0a1314),
									unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
								)
							)
						]
					)
				),
				height: 175
			),
			body: TabBarView(
				controller: _tabController,
				children: [
					HomeDoctorListPage(DoctorStatus.Authentication),
					HomeDoctorListPage(DoctorStatus.PendingAuthentication)
				]
			),
			backgroundColor: Colors.white
		);
	}
}