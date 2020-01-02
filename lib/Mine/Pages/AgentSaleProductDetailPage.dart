import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Order/Network/DrugConfigRequest.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';

class AgentSaleProductDetailPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _AgentSaleProductDetailState();
	}
}

class _AgentSaleProductDetailState extends State<AgentSaleProductDetailPage> {
	int timeStamp;
	String timeStr;
	int selectedIndex = 1;
	bool sortDown = true;
	DrugConfigModel configModel;
	
	@override
	void initState() {
		super.initState();
		DateTime nowTime = DateTime.now();
		DateTime monthTime = DateTime.parse('${nowTime.year}-${_addZero(nowTime.month)}-01 00:00:00');
		timeStamp = monthTime.millisecondsSinceEpoch;
		timeStr = '${nowTime.year}年${nowTime.month}月';
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initDate();
			_getDrugConfig();
		});
	}
	
	// 获取药品配置信息，药品热度/标签显示需要用到
	void _getDrugConfig() {
		PPSession session = PPSession.getInstance();
		if (session.userModel.agentType == 1 && session.configModel == null) {
			DrugConfigRequest.drugConfigReq().then((response) {
				if (response != null) {
					session.configModel = response;
					setState(() {
						this.configModel = response;
					});
				}
			});
		}
	}
	
	Future<void> _initDate() async {
	
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'药品明细',
				context: context
			),
			body: Column(children: <Widget>[
				// 时间选择header
				_createTimeHeader(),
				
				// 销量/净毛利率
				_createSortTypeHeader(),
				
				Expanded(child: _createContentList())
			], crossAxisAlignment: CrossAxisAlignment.start),
			backgroundColor: Color(0xfff4f6f9)
		);
	}
	
	// 时间选择header
	Widget _createTimeHeader() {
		return GestureDetector(
			onTap: () {
				Picker(
					adapter: DateTimePickerAdapter(
						type: 11,
						isNumberMonth: true,
						yearBegin: 2000,
						yearEnd: DateTime.now().year,
						yearSuffix: '年',
						monthSuffix: '月',
						value: DateTime.fromMillisecondsSinceEpoch(this.timeStamp),
						maxValue: DateTime.now()
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
						this.setState(() {
							this.timeStamp = tempTime.millisecondsSinceEpoch;
							this.timeStr = '${tempTime.year}年${tempTime.month}月';
						});
					}
				).showModal(context);
			},
			child: Container(
				height: 44,
				padding: EdgeInsets.only(left: 15),
				alignment: Alignment.centerLeft,
				child: Row(children: <Widget>[
					Text(
						this.timeStr ?? '',
						style: TextStyle(fontSize: 16, color: Color(0xff3b4243))
					),
					Padding(padding: EdgeInsets.only(left: 1)),
					Image.asset(
						'lib/Images/time_down_icon.png',
						width: 10, height: 10
					)
				])
			)
		);
	}
	
	// 销量/净毛利率
	Widget _createSortTypeHeader() {
		return Container(
			decoration: BoxDecoration(
				color: Colors.white,
				border: Border(bottom: BorderSide(
					width: 0.5,
					color: Color(0xffe5e5e5)
				))
			),
			height: 44,
			child: Row(children: <Widget>[
				Expanded(child: GestureDetector(
					onTap: () {
						if (this.selectedIndex == 1) {
							this.setState(() {
								this.selectedIndex = 0;
							});
						}
					},
					child: Center(child: Text(
						'销量',
						style: TextStyle(
							fontSize: 16,
							color: this.selectedIndex == 0 ? Color(0xff6bcbd6) : Color(0xff3b4243)
						)
					))
				)),
				
				Expanded(child: GestureDetector(
					onTap: () {
						if (this.selectedIndex == 0) {
							this.setState(() {
								this.selectedIndex = 1;
							});
						} else {
							this.setState(() {
								this.sortDown = !this.sortDown;
							});
						}
					},
					child: Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							Text(
								'净毛利率',
								style: TextStyle(
									fontSize: 16,
									color: this.selectedIndex == 1 ? Color(0xff6bcbd6) : Color(0xff3b4243)
								)
							),
							Padding(padding: EdgeInsets.only(right: 5)),
							Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									Image.asset(
										this.sortDown ? 'lib/Images/up_deep_icon.png' : 'lib/Images/up_slight_icon.png',
										width: 9, height: 7
									),
									
									Image.asset(
										this.sortDown ? 'lib/Images/down_light_icon.png' : 'lib/Images/down_deep_icon.png',
										width: 9, height: 7
									)
								]
							)
						]
					)
				))
			])
		);
	}
	
	Widget _createContentList() {
		return Container();
	}
	
	String _addZero(int value) {
		if (value < 10) {
			return '0' + value.toString();
		}
		return value.toString();
	}
}