import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Common/ZFProgressHUDView.dart';
import 'package:flutter_jkxing/Redux/ZFAction.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_jkxing/Utils/ProgressUtil.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SelectDatePage extends StatefulWidget {
	final String timeTitle;
	SelectDatePage(this.timeTitle);
	@override
	State<StatefulWidget> createState() {
		return _SelectDateState(this.timeTitle);
	}
}

class _SelectDateState extends State<SelectDatePage> {
	String startTimeStr = '开始时间';
	String endTimeStr = '结束时间';
	String timeTitle;
	int startTime;
	int endTime;
	_SelectDateState(this.timeTitle);
	
	@override
	void initState() {
		super.initState();
		if (this.timeTitle.contains('-')) {
			// 自定义时间
			List<String> timeList = this.timeTitle.split('-');
			if (timeList.length >= 2) {
				startTimeStr = timeList[0];
				startTimeStr = startTimeStr.replaceAll('年', '-');
				startTimeStr = startTimeStr.replaceAll('月', '-');
				startTimeStr = startTimeStr.replaceAll('日', '');
				print('timeList = $timeList, startTimeStr = $startTimeStr');
				startTime = DateTime.parse(startTimeStr).millisecondsSinceEpoch;
				
				endTimeStr = timeList[1];
				endTimeStr = endTimeStr.replaceAll('年', '-');
				endTimeStr = endTimeStr.replaceAll('月', '-');
				endTimeStr = endTimeStr.replaceAll('日', '');
				endTime = DateTime.parse(endTimeStr).millisecondsSinceEpoch;
			}
		} else {
			startTime = endTime = DateTime.now().millisecondsSinceEpoch;
		}
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'选择时间',
				context: context,
				rightBarBtn: GestureDetector(
					onTap: () {
						String tempTimeStr = timeTitle;
						DateTime now = DateTime.now();
						if (this.timeTitle == '昨天') {
							this.endTime = DateTime.parse('${now.year}-${_addZero(now.month)}-${_addZero(now.day)} 00:00:00').millisecondsSinceEpoch - 1000;
							this.startTime = this.endTime - (24 * 60 * 60 - 1) * 1000;
						} else if (this.timeTitle == '近七天') {
							this.endTime = now.millisecondsSinceEpoch;
							int tempTime = DateTime.parse('${now.year}-${_addZero(now.month)}-${_addZero(now.day)} 00:00:00').millisecondsSinceEpoch;
							this.startTime = tempTime - 24 * 60 * 60 * 1000 * 6;
						} else if (this.timeTitle == '本月') {
							this.startTime = DateTime.parse('${now.year}-${_addZero(now.month)}-01 00:00:00').millisecondsSinceEpoch;
							this.endTime = now.millisecondsSinceEpoch;
						} else if (this.timeTitle == '上月') {
							if (now.month == 1) {
								this.startTime = DateTime.parse('${now.year - 1}-12-01 00:00:00').millisecondsSinceEpoch;
							} else {
								this.startTime = DateTime.parse('${now.year}-${_addZero(now.month - 1)}-01 00:00:00').millisecondsSinceEpoch;
							}
							this.endTime = DateTime.parse('${now.year}-${_addZero(now.month)}-01 00:00:00').millisecondsSinceEpoch - 1000;
						} else {
							Store store = StoreProvider.of<ZFAppState>(context);
							if (this.startTimeStr == '开始时间' || this.endTimeStr == '结束时间') {
								ProgressUtil().showWithType(context, ProgressType.ProgressType_Error, title: '请选择时间');
								return;
							}
							
							// 开始时间
							DateTime tempStartT = DateTime.parse('${this.startTimeStr} 00:00:00');
							this.startTime = tempStartT.millisecondsSinceEpoch;
							
							// 结束时间
							DateTime tempEndT = DateTime.parse('${this.endTimeStr}');
							if (tempEndT.year == now.year &&
								tempEndT.month == now.month &&
								tempEndT.day == now.day) {
								this.endTime = now.millisecondsSinceEpoch;
							} else {
								DateTime tempEndT = DateTime.parse('${this.endTimeStr} 23:59:59');
								this.endTime = tempEndT.millisecondsSinceEpoch;
							}
							
							if (this.startTime > this.endTime) {
								ProgressUtil().showWithType(context, ProgressType.ProgressType_Error, title: '结束时间不能比开始时间早');
								return;
							}
							
							if (this.startTime > now.millisecondsSinceEpoch || this.endTime > now.millisecondsSinceEpoch) {
								ProgressUtil().showWithType(context, ProgressType.ProgressType_Error, title: '最早能查看当天数据，请重新选择');
								return;
							}
							
							tempTimeStr = '${tempStartT.year}年${_addZero(tempStartT.month)}月${_addZero(tempStartT.day)}日-${tempEndT.year}年${_addZero(tempEndT.month)}月${_addZero(tempEndT.day)}日';
						}
						Navigator.pop(context, {'timeStr': tempTimeStr, 'startTime': this.startTime, 'endTime': this.endTime});
					},
					child: Text('完成', style: TextStyle(
						fontSize: 16,
						color: Color(0xbf0a1314)
					))
				)
			),
			body: Column(
				children: <Widget>[
					_createCommonItem('昨天'),
					_createCommonItem('近七天'),
					_createCommonItem('本月'),
					_createCommonItem('上月'),
					_createCommonItem('自定义', hideSepLine: true),
					_createInputTimeItem()
				],
			)
		);
	}
	
	//
	Widget _createCommonItem(String title, {bool hideSepLine: false}) {
		return GestureDetector(
			onTap: () {
				if (title == '自定义') {
					setState(() {
						this.timeTitle = '-';
					});
				} else {
					setState(() {
						this.timeTitle = title;
					});
				}
			},
			child: Container(
				height: 53,
				padding: EdgeInsets.symmetric(horizontal: 15),
				decoration: BoxDecoration(
					border: Border(
						bottom: BorderSide(
							color: hideSepLine == true ? Colors.white : Color(0xffe5e5e5),
							width: 0.5
						)
					)
				),
				child: Row(
					children: <Widget>[
						Image.asset(
							(this.timeTitle == title || (title == '自定义' && this.timeTitle.contains('-'))) ?
							'lib/Images/btn_date_select.png' : 
							'lib/Images/btn_date_unselect.png',
							width: 18, height: 18
						),
						Padding(padding: EdgeInsets.only(right: 5)),
						Text(title, style: TextStyle(
							fontSize: 16,
							color: Color(0xff0a1314)
						))
					]
				)
			)
		);
	}
	
	// 自定义时间
	Widget _createInputTimeItem() {
		return Container(
			padding: EdgeInsets.symmetric(horizontal: 15),
			child: Row(
				children: <Widget>[
					_selectTimeItem(true, this.timeTitle.contains('-')),
					
					Container(
						width: 25,
						alignment: Alignment.center,
						child: Text('至', style: TextStyle(
							fontSize: 12,
							color: Color.fromRGBO(0, 0, 0, 0.4)
						))
					),
					
					_selectTimeItem(false, this.timeTitle.contains('-'))
				]
			)
		);
	}
	
	Widget _selectTimeItem(bool isBeginTime, bool isEditable) {
		return Expanded(child: GestureDetector(
			onTap: () {
				if (isEditable == true) {
					Picker(
						adapter: DateTimePickerAdapter(
							type: 7,
							isNumberMonth: true,
							yearBegin: 2000,
							yearSuffix: '年',
							monthSuffix: '月',
							daySuffix: '日',
							value: isBeginTime ?
								DateTime.fromMillisecondsSinceEpoch(this.startTime) :
								DateTime.fromMillisecondsSinceEpoch(this.endTime)
						),
						title: Text('选择日期'),
						textAlign: TextAlign.right,
						selectedTextStyle: TextStyle(color: Color(0xff6bcbd6)),
						cancelText: '取消',
						cancelTextStyle: TextStyle(fontSize: 16, color: Color(0xff999999)),
						confirmText: '确定',
						confirmTextStyle: TextStyle(fontSize: 16, color: Color(0xff6bcbd6)),
						onSelect: (Picker picker, int index, List<int> selecteds) {
							setState(() {});
						},
						onConfirm: (Picker picker, List<int> selected) {
							DateTime tempTime = (picker.adapter as DateTimePickerAdapter).value;
							String tempDateStr = '${tempTime.year}-${_addZero(tempTime.month)}-${_addZero(tempTime.day)}';
							if (isBeginTime) {
								// 开始时间
								setState(() {
									this.startTimeStr = tempDateStr;
								});
							} else {
								// 结束时间
								setState(() {
									this.endTimeStr = tempDateStr;
								});
							}
						}
					).showModal(context);
				}
			},
			child: Container(
				height: 44,
				decoration: BoxDecoration(
					border: Border.all(
						color: Color(0xffe5e5e5),
						width: 0.5
					),
					borderRadius: BorderRadius.circular(2)
				),
				padding: EdgeInsets.only(left: 10, right: 10),
				child: Row(
					children: <Widget>[
						Expanded(child: Text(
							isBeginTime == true ? (this?.startTimeStr ?? '') : (this?.endTimeStr ?? ''),
							style: TextStyle(
								fontSize: 16,
								color: isEditable ? Color(0xFF0A1314) : Color(0xffcccccc)
							)
						)),
						Image.asset('lib/Images/date_icon_dropdown.png', width: 16, height: 16)
					]
				),
			),
		));
	}
	
	String _addZero(int value) {
		if (value < 10) {
			return '0' + value.toString();
		}
		return value.toString();
	}
}