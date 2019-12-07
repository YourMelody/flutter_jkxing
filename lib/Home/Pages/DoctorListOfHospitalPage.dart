import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Common/ZFSearchBar.dart';

class DoctorListOfHospitalPage extends StatefulWidget {
	final String agentName;
	final String agentId;
	final bool showSearch;
	DoctorListOfHospitalPage({this.agentName, this.agentId, this.showSearch = false});
	@override
	State<StatefulWidget> createState() {
		return _DoctorListOfHospitalState();
	}
}

class _DoctorListOfHospitalState extends State<DoctorListOfHospitalPage> {
	
	List dataSource = [];
	int currentPage = 1;
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	Future<void> _initData() async {
	
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				widget.agentName != null && widget.agentName.length > 0 ?
				'${widget.agentName}的医生' : '我的医生',
				rightBarBtn: widget.showSearch ? Icon(Icons.search, size: 24, color: Color(0xff6bcbd6)) : null,
				rightBarBtnAction: () {
					// 搜索
					
				},
				context: context
			),
			body: Column(
				children: <Widget>[
					// 搜索框
					ZFSearchBar(
						placeholder: '医院名称/医生姓名',
						paddingH: 15,
						paddingV: 7,
						height: 44,
						showSearchIcon: false,
						onTapSearchBar: () {
						
						}
					),
					Expanded(child: RefreshListView(
						child: ListView.separated(
							itemBuilder: (context, index) => _createItem(),
							separatorBuilder: (context, index) {
								return Divider(color: Color(0xffe5e5e5), height: 0.5);
							},
							itemCount: 0
						)
					))
				]
			),
			backgroundColor: Colors.white
		);
	}
	
	Widget _createItem() {
		return null;
	}
}