import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Mine/Model/TeamSalesDetailModel.dart';
import 'package:flutter_jkxing/Mine/Network/MineRequest.dart';
import 'package:flutter_jkxing/Utils/Util.dart';
import 'SelectDatePage.dart';

class TeamSalesPerformancePage extends StatefulWidget {
	final String teamCode;
	final int startTime;
	final int endTime;
	final String timeStr;
	TeamSalesPerformancePage(this.teamCode, this.startTime, this.endTime, this.timeStr);
	@override
	State<StatefulWidget> createState() {
		return _TeamSalesPerformanceState(startTime, endTime, timeStr);
	}
}

/*
* 展示规则：
* 	1、团队成员返回空，显示0；其他字段返回空，显示'--'
* 	2、agentType为1，且销售指标和完成度接口有返回值，正常显示；其他所有情况都显示'--'
* 	3、若选择的时间区间跨月，则销售指标显示'--'
* */
class _TeamSalesPerformanceState extends State<TeamSalesPerformancePage> {
	TeamSalesDetailModel detailModel;
	int startTime;
	int endTime;
	String timeStr;
	bool crossMonth = false;
	_TeamSalesPerformanceState(this.startTime, this.endTime, this.timeStr);
	int agentType = PPSession.getInstance().userModel.agentType;
	
	@override
	void initState() {
		super.initState();
		DateTime startDate = DateTime.fromMillisecondsSinceEpoch(startTime);
		DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endTime);
		if (startDate.year != endDate.year ||
			(startDate.year == endDate.year && startDate.month != endDate.month)) {
			this.crossMonth = true;
		} else {
			this.crossMonth = false;
		}
		
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
			return _commonItem(index);
		}
	}
	
	// 第一行：选择时间
	Widget _selectTimeItem() {
		return Container(
			height: 44,
			padding: EdgeInsets.only(left: 15),
			child: GestureDetector(
				onTap: () {
					Navigator.of(context).push(
						MaterialPageRoute(builder: (_) => SelectDatePage(this.timeStr))
					).then((backValue) {
						if (backValue != null) {
							this.timeStr = backValue['timeStr'];
							this.startTime = backValue['startTime'];
							this.endTime = backValue['endTime'];
							DateTime startDate = DateTime.fromMillisecondsSinceEpoch(this.startTime);
							DateTime endDate = DateTime.fromMillisecondsSinceEpoch(this.endTime);
							if (startDate.year != endDate.year ||
								(startDate.year == endDate.year && startDate.month != endDate.month)) {
								this.crossMonth = true;
							} else {
								this.crossMonth = false;
							}
							setState(() {});
							Timer(Duration(milliseconds: 200), () {
								// 刷新数据
								_initData();
							});
						}
					});
				},
				child: Container(
					height: 44, padding: EdgeInsets.only(top: 10),
					child: Row(children: <Widget>[
						Text(
							this.timeStr ?? '',
							style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d))
						),
						Padding(padding: EdgeInsets.only(right: 4)),
						Image.asset('lib/Images/date_icon_dropdown.png', width: 16, height: 16)
					])
				)
			)
		);
	}
	
	// 第二行：团队基本信息
	Widget _teamBaseInfoItem() {
		return Container(
			height: 185,
			color: Colors.white,
			padding: EdgeInsets.fromLTRB(39, 15, 39, 0),
			child: Column(children: <Widget>[
				// 团队名称
				Text(
					this.detailModel?.teamName ?? '--',
					style: TextStyle(fontSize: 18, color: Color(0xff1a1a1a), fontWeight: FontWeight.w500),
				),
				Padding(padding: EdgeInsets.only(bottom: 14)),
				
				// 销售业绩
				Text('销售业绩(元)', style: TextStyle(fontSize: 12, color: Color(0xff999999))),
				Text(
					this.detailModel?.teamSaleMoney == null ? '--' :
					Util().formatNum((this.detailModel.teamSaleMoney/100.0).toStringAsFixed(2)) ?? '--',
					style: TextStyle(fontSize: 30, color: Color(0xff6bcbd6), fontWeight: FontWeight.w500)
				),
				Padding(padding: EdgeInsets.only(bottom: 25)),
				
				// 其他
				Row(children: <Widget>[
					// 团队成员
					Column(children: <Widget>[
						Text('团队成员', style: TextStyle(fontSize: 12, color: Color(0xff999999))),
						Padding(padding: EdgeInsets.only(bottom: 3)),
						Text(
							this.detailModel?.teamNum == null ? '0' : this.detailModel.teamNum.toString(),
							style: TextStyle(fontSize: 16, color: Color(0xff4d4d4d))
						)
					]),
					
					// 销售指标
					Expanded(child: Column(children: <Widget>[
						Text('销售指标(元)', style: TextStyle(fontSize: 12, color: Color(0xff999999))),
						Padding(padding: EdgeInsets.only(bottom: 3)),
						Text(
							(this.agentType != 1 || this.crossMonth) ? '--' : this.detailModel?.teamTargetMoney == null ? '--' : (this.detailModel.teamTargetMoney/100.0).toStringAsFixed(2),
							style: TextStyle(fontSize: 16, color: Color(0xff4d4d4d))
						)
					])),
					
					// 完成度
					Column(children: <Widget>[
						Text('完成度', style: TextStyle(fontSize: 12, color: Color(0xff999999))),
						Padding(padding: EdgeInsets.only(bottom: 3)),
						Text(
							this.agentType != 1 ? '--' : this.detailModel?.completeRate ?? '--',
							style: TextStyle(fontSize: 16, color: Color(0xff4d4d4d))
						)
					])
				])
			])
		);
	}
	
	// 第三行：说明文字
	Widget _textInfoItem() {
		return Container(
			height: 44,
			padding: EdgeInsets.only(left: 15, top: 17),
			child: Text(
				'${this.detailModel?.teamName ?? ''}各成员业绩',
				style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d))
			)
		);
	}
	
	// 第四行：姓名/销售业绩/销售指标/代表提成
	Widget _dataListHeaderItem() {
		return Container(
			height: 39,
			margin: EdgeInsets.symmetric(horizontal: 15),
			decoration: BoxDecoration(
				color: Color(0xff6bcbd6),
				borderRadius: BorderRadius.only(
					topLeft: Radius.circular(5),
					topRight: Radius.circular(5)
				)
			),
			child: Row(children: <Widget>[
				Expanded(child: Center(
					child: Text('姓名', style: TextStyle(fontSize: 14, color: Colors.white))
				)),
				Container(width: 1, color: Colors.white),
				Expanded(child: Center(
					child: Text('销售业绩', style: TextStyle(fontSize: 14, color: Colors.white))
				)),
				Container(width: 1, color: Colors.white),
				Expanded(child: Center(
					child: Text('销售指标', style: TextStyle(fontSize: 14, color: Colors.white))
				)),
				Container(width: 1, color: Colors.white),
				Expanded(child: Center(
					child: Text('代表提成', style: TextStyle(fontSize: 14, color: Colors.white))
				))
			])
		);
	}
	
	Widget _commonItem(int index) {
		TeamAgentInfoModel agentModel = this.detailModel.agentList[index - 4];
		String agentTarget;
		String agentBonus;
		if (this.agentType == 1) {
			if (this.crossMonth) {
				agentTarget = '--';
			} else {
				agentTarget = agentModel.agentTargetMoney == null ? '--' :
				Util().formatNum((agentModel.agentTargetMoney/100.0).toStringAsFixed(2)) ?? '--';
			}
			agentBonus = agentModel.agentBonusMoney == null ? '--' :
			Util().formatNum((agentModel.agentBonusMoney/100.0).toStringAsFixed(2)) ?? '--';
		} else {
			if (agentModel.agentUserId == PPSession.getInstance().userId && this.crossMonth == false) {
				agentTarget = agentModel.agentTargetMoney == null ? '--' :
				Util().formatNum((agentModel.agentTargetMoney/100.0).toStringAsFixed(2)) ?? '--';
			} else {
				agentTarget = '--';
			}
			agentBonus = '--';
		}
		return Container(
			height: 31,
			margin: EdgeInsets.symmetric(horizontal: 15),
			decoration: BoxDecoration(
				border: Border(
					left: BorderSide(color: Color(0xff6bcbd6), width: 1),
					right: BorderSide(color: Color(0xff6bcbd6), width: 1),
					bottom: index == this.detailModel.agentList.length + 2 ? BorderSide(width: 0, color: Colors.white) : BorderSide(color: Color(0xff6bcbd6), width: 1),
					top: index == this.detailModel.agentList.length + 3 ? BorderSide(color: Color(0xff6bcbd6), width: 1) : BorderSide(width: 0, color: Colors.white)
				),
				borderRadius: index == this.detailModel.agentList.length + 3 ? BorderRadius.only(
					bottomLeft: Radius.circular(5),
					bottomRight: Radius.circular(5)
				) : null,
				color: Colors.white
			),
			child: Row(children: <Widget>[
				// 代表姓名
				Expanded(child: Center(
					child: Text(
						agentModel.agentName ?? '--',
						style: TextStyle(fontSize: 16, color: Color(0xff6bcbd6), fontWeight: FontWeight.w500),
						maxLines: 1,
						overflow: TextOverflow.ellipsis
					)
				)),
				Container(width: 1, color: Color(0xff6bcbd6)),
				
				// 代表销售业绩
				Expanded(child: Center(
					child: Text(
						agentModel.agentSaleMoney == null ? '--' :
						Util().formatNum((agentModel.agentSaleMoney/100.0).toStringAsFixed(2)) ?? '--',
						maxLines: 1,
						overflow: TextOverflow.ellipsis
					)
				)),
				Container(width: 1, color: Color(0xff6bcbd6)),
				
				// 销售指标
				Expanded(child: Center(
					child: Text(
						agentTarget ?? '--',
						style: TextStyle(fontSize: 14, color: Color(0xbf0a1314)),
						maxLines: 1,
						overflow: TextOverflow.ellipsis
					)
				)),
				Container(width: 1, color: Color(0xff6bcbd6)),
				
				// 代表提成
				Expanded(child: Center(
					child: Text(
						agentBonus ?? '--',
						style: TextStyle(fontSize: 14, color: Color(0xbf0a1314)),
						maxLines: 1,
						overflow: TextOverflow.ellipsis
					)
				))
			])
		);
	}
}