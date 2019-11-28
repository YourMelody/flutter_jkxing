import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Mine/Model/DoctorReportDataModel.dart';
import 'package:flutter_jkxing/Mine/Network/MineRequest.dart';
import 'package:flutter_picker/flutter_picker.dart';

// 我的-->医生报表
class DoctorReportPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _DoctorReportState();
	}
}

class _DoctorReportState extends State<DoctorReportPage> {
	List<DoctorReportDataModel> dataSource;
	int startTime;    // 默认为当月开始时间
	String startTimeStr;
	
	int endTime;      // 默认为当前时间
	String endTimeStr;
	int selectedIndex = 0;  // 当月：0   上个月：1   近3个月：2  其他：null
	
	@override
	void initState() {
		super.initState();
		var now = DateTime.now();
		// 本月开始时间
		this.startTime = DateTime(now.year, now.month).millisecondsSinceEpoch;
		this.startTimeStr = '${now.year}${_addZero(now.month)}01';
		
		// 当前时间
		this.endTime = now.millisecondsSinceEpoch;
		this.endTimeStr = '${now.year}${now.month}${now.day}';
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	// 获取医生报表数据
	Future<void> _initData() async {
		List<DoctorReportDataModel> response = await MineRequest.getDoctorReportDetailData(startTime, endTime, context);
		if (response != null) {
			// 请求成功
			this.setState(() {
				dataSource = response;
			});
		} else {
			// 请求失败
			
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar('医生报表', context: context),
			body: ListView.builder(
				itemCount: this.dataSource == null ? 2 : this.dataSource.length + 2,
				itemBuilder: (context, index) => _createItem(index)
			)
		);
	}
	
	Widget _createItem(index) {
		if (index == 0) {
			// 选择时间
			return _createTimeHeader();
		} else if (index == 1) {
			// 指标/数量
			return _createDataHeader();
		}
		// data
		return _createCommonItem(this.dataSource[index - 2], index);
	}
	
	// 时间选择头部
	Widget _createTimeHeader() {
		return Container(
			padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
			margin: EdgeInsets.only(bottom: 15),
			decoration: BoxDecoration(
				border: Border(
					bottom: BorderSide(
						width: 0.5,
						color: Color(0xffe5e5e5)
					)
				)
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					// 当月、上个月、近3个月
					Row(children: <Widget>[
						_createDateButton('当月', this.selectedIndex == 0, 0),
						Padding(padding: EdgeInsets.only(right: 15)),
						_createDateButton('上个月', this.selectedIndex == 1, 1),
						Padding(padding: EdgeInsets.only(right: 15)),
						_createDateButton('近3个月', this.selectedIndex == 2, 2)
					]),
					
					Padding(padding: EdgeInsets.only(bottom: 16)),
					
					// 自定义日期
					Row(children: <Widget>[
						_createDateButton(this.startTimeStr, false, 3, customDate: true),
						Container(
							width: 15,
							alignment: Alignment.center,
							child: Text('~', style: TextStyle(fontSize: 14, color: Color(0xff999999)))
						),
						_createDateButton(this.endTimeStr, false, 4, customDate: true),
						Padding(padding: EdgeInsets.only(right: 15)),
						_createDateButton('确定', true, 5)
					])
				]
			)
		);
	}
	
	/*
	* title: button的标题
	* selected：是否选中
	* index：0：当月  1：上个月  2：近3个月  3：自定义开始时间  4：自定义结束时间  5：确定
	* customDate：是否为自定义时间
	* */
	Widget _createDateButton(String title, bool selected, int index, {bool customDate = false}) {
		return Expanded(child: GestureDetector(
			onTap: () {
				_clickTopButton(index, customDate);
			},
			child: Container(
				height: 30,
				alignment: Alignment.center,
				child: customDate ? Row(
					mainAxisAlignment: MainAxisAlignment.end,
					children: <Widget>[
						Text(
							title ?? '',
							style: TextStyle(
								fontSize: 14,
								color: Color(0xff4d4d4d)
							)
						),
						Container(
							width: 30,
							height: 30,
							alignment: Alignment.center,
							child: Image.asset('lib/Images/date_icon_dropdown.png', width: 16, height: 16)
						)
					]
				) : Text(
					title ?? '',
					style: TextStyle(
						fontSize: 14,
						color: selected ? Colors.white : Color(0xff999999)
					)
				),
				decoration: BoxDecoration(
					color: selected ? Color(0xff6bcbd7) : Colors.white,
					borderRadius: BorderRadius.circular(2),
					border: Border.all(
						width: selected ? 0 : 1,
						color: Color(0xffe5e5e5)
					)
				)
			)
		));
	}
	
	// 头部点击事件
	void _clickTopButton(int index, bool customDate) {
		var now = DateTime.now();
		if (customDate) {
			// 选择日期
			_selectDate(index == 3);
		} else if (index == 0) {
			// 当月
			this.selectedIndex = 0;
			this.startTime = DateTime(now.year, now.month).millisecondsSinceEpoch;
			this.startTimeStr = '${now.year}${_addZero(now.month)}01';
			this.endTime = now.millisecondsSinceEpoch;
			this.endTimeStr = '${now.year}${now.month}${now.day}';
			setState(() {});
			_initData();
		} else if (index == 1) {
			// 上个月
			this.selectedIndex = 1;
			// 开始时间
			DateTime tempStart;
			if (now.month == 1) {
				tempStart = DateTime.parse('${now.year - 1}-12-01 00:00:00');
			} else {
				tempStart = DateTime.parse('${now.year}-${_addZero(now.month - 1)}-01 00:00:00');
			}
			this.startTime = tempStart.millisecondsSinceEpoch;
			this.startTimeStr = '${tempStart.year}${_addZero(tempStart.month)}01';
			
			// 结束时间
			this.endTime = DateTime.parse('${now.year}-${_addZero(now.month)}-01 00:00:00').millisecondsSinceEpoch - 1000;
			DateTime tempEnd = DateTime.fromMillisecondsSinceEpoch(this.endTime);
			this.endTimeStr = '${tempEnd.year}${_addZero(tempEnd.month)}${_addZero(tempEnd.day)}';
			setState(() {});
			_initData();
		} else if (index == 2) {
			// 近3个月
			this.selectedIndex = 2;
			// 开始时间
			DateTime tempStart;
			if (now.month >= 3) {
				tempStart = DateTime.parse('${now.year}-${_addZero(now.month - 2)}-01 00:00:00');
			} else {
				tempStart = DateTime.parse('${now.year - 1}-${10 + now.month}-01 00:00:00');
			}
			this.startTime = tempStart.millisecondsSinceEpoch;
			this.startTimeStr = '${tempStart.year}${_addZero(tempStart.month)}01';
			
			// 结束时间
			this.endTime = now.millisecondsSinceEpoch;
			this.endTimeStr = '${now.year}${_addZero(now.month)}${_addZero(now.day)}';
			setState(() {});
			_initData();
		} else if (index == 5) {
			// 确定
			_initData();
		}
	}
	
	// 自定义时间选择日期
	void _selectDate(bool isStartTime) {
		Picker(
			adapter: DateTimePickerAdapter(
				type: 7,
				isNumberMonth: true,
				yearBegin: 2000,
				yearEnd: DateTime.now().year,
				yearSuffix: '年',
				monthSuffix: '月',
				daySuffix: '日',
				value: isStartTime ?
					DateTime.fromMillisecondsSinceEpoch(this.startTime) :
					DateTime.fromMillisecondsSinceEpoch(this.endTime),
				maxValue: isStartTime ? DateTime.fromMillisecondsSinceEpoch(this.endTime) : DateTime.now(),
				minValue: !isStartTime ? DateTime.fromMillisecondsSinceEpoch(this.startTime) : DateTime.parse('2000-01-01 00:00:00')
			),
			title: Text('选择日期'),
			textAlign: TextAlign.right,
			selectedTextStyle: TextStyle(color: Color(0xff6bcbd6)),
			cancelText: '取消',
			cancelTextStyle: TextStyle(fontSize: 16, color: Color(0xff999999)),
			confirmText: '确定',
			confirmTextStyle: TextStyle(fontSize: 16, color: Color(0xff6bcbd6)),
			onSelect: (Picker picker, int index, List<int> selected) {
				setState(() {});
			},
			onConfirm: (Picker picker, List<int> selected) {
				DateTime tempTime = (picker.adapter as DateTimePickerAdapter).value;
				String tempDateStr = '${tempTime.year}${_addZero(tempTime.month)}${_addZero(tempTime.day)}';
				if (isStartTime) {
					// 开始时间
					setState(() {
						this.startTimeStr = tempDateStr;
						this.startTime = tempTime.millisecondsSinceEpoch;
						this.selectedIndex = null;
					});
				} else {
					// 结束时间
					setState(() {
						this.endTimeStr = tempDateStr;
						this.endTime = tempTime.millisecondsSinceEpoch;
						this.selectedIndex = null;
					});
				}
			}
		).showModal(context);
	}
	
	// 指标/数量
	Widget _createDataHeader() {
		return Row(
			children: <Widget>[
				Padding(padding: EdgeInsets.only(left: 15)),
				Expanded(child: Container(
					height: 39,
					alignment: Alignment.center,
					decoration: BoxDecoration(
						borderRadius: BorderRadius.only(
							topLeft: Radius.circular(5)
						),
						color: Color(0xff6bcbd6)
					),
					child: Text('指标', style: TextStyle(fontSize: 14, color: Colors.white))
				)),
				
				Padding(padding: EdgeInsets.only(right: 0.5)),
				Expanded(child: Container(
					height: 39,
					alignment: Alignment.center,
					decoration: BoxDecoration(
						borderRadius: BorderRadius.only(
							topRight: Radius.circular(5)
						),
						color: Color(0xff6bcbd6)
					),
					child: Text('数量', style: TextStyle(fontSize: 14, color: Colors.white))
				)),
				Padding(padding: EdgeInsets.only(right: 15))
			]
		);
	}
	
	// 数据item
	Widget _createCommonItem(DoctorReportDataModel model, int index) {
		return Container(
			margin: EdgeInsets.symmetric(horizontal: 15),
			height: 32,
			decoration: BoxDecoration(
				border: Border(
					left: BorderSide(width: 1, color: Color(0xff6bcbd6)),
					right: BorderSide(width: 1, color: Color(0xff6bcbd6)),
					bottom: index == this.dataSource.length ? BorderSide(width: 0, color: Colors.white) : BorderSide(width: 1, color: Color(0xff6bcbd6)),
					top: index == this.dataSource.length + 1 ? BorderSide(width: 1, color: Color(0xff6bcbd6)) : BorderSide(width: 0, color: Colors.white)
				),
				borderRadius: index == this.dataSource.length + 1 ? BorderRadius.only(
					bottomLeft: Radius.circular(5),
					bottomRight: Radius.circular(5)
				) : null
			),
			child: Row(children: <Widget>[
				Expanded(child: Text(
					model.name ?? '',
					style: TextStyle(
						fontSize: 14,
						color: Color(0xcd0a1314)
					),
					maxLines: 1,
					overflow: TextOverflow.ellipsis,
					textAlign: TextAlign.center
				)),
				Container(
					width: 0.5,
					height: 32,
					color: Color(0xff6bcbd6),
				),
				Expanded(child: Text(
					model.num ?? '0',
					style: TextStyle(
						fontSize: 14,
						color: Color(0xcd0a1314)
					),
					maxLines: 1,
					overflow: TextOverflow.ellipsis,
					textAlign: TextAlign.center
				))
			])
		);
	}
	
	String _addZero(int value) {
		if (value < 10) {
			return '0' + value.toString();
		}
		return value.toString();
	}
}