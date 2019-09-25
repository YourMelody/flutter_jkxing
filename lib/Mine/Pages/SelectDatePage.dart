import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';

class SelectDatePage extends StatefulWidget {
	final String timeTitle;
	final int startTime;
	final int endTime;
	SelectDatePage(this.timeTitle, this.startTime, this.endTime);
	@override
	State<StatefulWidget> createState() {
		return _SelectDateState();
	}
}

class _SelectDateState extends State<SelectDatePage> {
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'选择时间',
				context: context,
				rightBarBtn: [
					GestureDetector(
						onTap: () {
						
						},
						child: Container(
							height: 44,
							alignment: Alignment.center,
							padding: EdgeInsets.only(right: 15, left: 5),
							child: Text('完成', style: TextStyle(
								fontSize: 16,
								color: Color(0xbf0a1314)
							))
						)
					)
				]
			),
			body: Column(
				children: <Widget>[
					_createCommonItem('昨日'),
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
		return Container(
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
						widget.timeTitle == title ? 'lib/Images/btn_date_select.png' : 'lib/Images/btn_date_unselect.png',
						width: 18, height: 18
					),
					Padding(padding: EdgeInsets.only(right: 5)),
					Text(title, style: TextStyle(
						fontSize: 16,
						color: Color(0xff0a1314)
					))
				]
			)
		);
	}
	
	// 自定义时间
	Widget _createInputTimeItem() {
		return Container(
			padding: EdgeInsets.symmetric(horizontal: 15),
			child: Row(
				children: <Widget>[
					_selectTimeItem(true, widget.timeTitle == '自定义'),
					
					Container(
						width: 25,
						alignment: Alignment.center,
						child: Text('至', style: TextStyle(
							fontSize: 12,
							color: Color.fromRGBO(0, 0, 0, 0.4)
						))
					),
					
					_selectTimeItem(false, widget.timeTitle == '自定义')
				]
			)
		);
	}
	
	Widget _selectTimeItem(bool isBeginTime, bool isEditable) {
		return Expanded(child: GestureDetector(
			onTap: () {
			
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
							'2029-22-28',
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
}