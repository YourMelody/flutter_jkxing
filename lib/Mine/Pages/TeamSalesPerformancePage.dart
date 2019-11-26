import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Mine/Model/TeamSalesDetailModel.dart';
import 'package:flutter_jkxing/Mine/Network/MineRequest.dart';

class TeamSalesPerformancePage extends StatefulWidget {
	final int teamCode;
	TeamSalesPerformancePage(this.teamCode);
	@override
	State<StatefulWidget> createState() {
		return _TeamSalesPerformanceState();
	}
}

class _TeamSalesPerformanceState extends State<TeamSalesPerformancePage> {
	TeamSalesDetailModel detailModel;
	int startTime;
	int endTime;
	String timeStr = '本月';
	
	@override
	void initState() {
		super.initState();
		var now = DateTime.now();
		// 本月开始时间
		this.startTime = DateTime(now.year, now.month).millisecondsSinceEpoch;
		// 当前时间
		this.endTime = now.millisecondsSinceEpoch;
		
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	// 请求数据
	void _initData() {
		MineRequest.getTeamSalesDetail(this.startTime, this.endTime, widget.teamCode, context).then((response) {
			if (response != null) {
				setState(() {
					this.detailModel = response;
				});
			}
		}).catchError((error) {
		
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar('团队业绩', context: context),
			body: ListView.builder(
				itemBuilder: (context, index) => _createItem(index),
				itemCount: (detailModel == null || detailModel?.agentList == null) ? 4 : detailModel.agentList.length + 4
			),
			backgroundColor: Color(0xfff4f6f9)
		);
	}
	
	Widget _createItem(int index) {
		if (index == 0) {
			return _selectTimeItem();
		} else if (index == 1) {
			return _teamBaseInfoItem();
		} else if (index == 2) {
			return _textInfoItem();
		} else if (index == 3) {
			return _dataListHeaderItem();
		} else {
			return _commonItem(isLastItem: index == detailModel.agentList.length + 3);
		}
	}
	
	// 第一行：选择事件
	Widget _selectTimeItem() {
		return null;
	}
	
	// 第二行：团队基本信息
	Widget _teamBaseInfoItem() {
		return null;
	}
	
	// 第三行：说明文字
	Widget _textInfoItem() {
		return null;
	}
	
	// 第四行：姓名/销售业绩/销售指标/代表提成
	Widget _dataListHeaderItem() {
		return null;
	}
	
	Widget _commonItem({bool isLastItem: false}) {
		return null;
	}
}