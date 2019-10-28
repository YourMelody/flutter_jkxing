import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Common/ZFProgressHUDView.dart';
import 'package:flutter_jkxing/Order/Model/LogisticsInfoModel.dart';
import 'package:flutter_jkxing/Order/Network/OrderRequest.dart';
import 'package:flutter_jkxing/Utils/ProgressUtil.dart';

class OrderLogisticsInfoPage extends StatefulWidget {
	final String orderCode;
	OrderLogisticsInfoPage(this.orderCode);
	
	@override
	State<StatefulWidget> createState() {
		return _OrderLogisticsInfoState();
	}
}

class _OrderLogisticsInfoState extends State<OrderLogisticsInfoPage> {
	List dataSource = [];
	String companeName;
	String logisticsCode;
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	void _initData() {
		OrderRequest.getLogisticsInfo(widget.orderCode, context).then((response) {
			if (response != null) {
				this.dataSource.clear();
				this.dataSource.add(response.orderCode);
				this.dataSource.addAll(response.logisticsList);
				this.companeName = response.companeName;
				this.logisticsCode = response.shippingNo;
				setState(() {});
			}
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar('订单追踪', context: context),
			backgroundColor: Colors.white,
			body: ListView.builder(
				itemBuilder: (context, index) {
					if (index == 0) {
						// 列表头部
						return ItemHeader(widget.orderCode, this.companeName, this.logisticsCode);
					} else {
						return InformationItem(index, this.dataSource[index], this.dataSource.length-1);
					}
				},
				itemCount: this.dataSource.length,
				padding: EdgeInsets.only(bottom: 15)
			)
		);
	}
}

// 列表头部
class ItemHeader extends StatelessWidget {
	final orderCode;
	final String companeName;
	final String logisticsCode;
	String numberCode;
	String name;
	ItemHeader(this.orderCode, this.companeName, this.logisticsCode);
	
	@override
	Widget build(BuildContext context) {
		numberCode = this.logisticsCode ?? '';
		name = this.companeName ?? '';
		return Container(
			padding: EdgeInsets.only(top: 16, left: 15, bottom: 15, right: 15),
			decoration: BoxDecoration(
				border: Border(
					bottom: BorderSide(
						color: Color(0xFFE5E5E5),
						width: 1
					)
				)
			),
			child: Column(
				children: <Widget>[
					new Container(
						child: Row(
							children: <Widget>[
								Text(
									"订单编号：",
									style: TextStyle(color: Color(0xFF999999), fontSize: 14)
								),
								Text(
									this.orderCode,
									style: TextStyle(color: Color(0xFF0A1314), fontSize: 14)
								)
							]
						),
					),
					
					SizedBox(height: numberCode.length == 0 ? 0 :10.0),
					Offstage(
						offstage: numberCode.length == 0,
						child: Container(
							child: Row(
								children: <Widget>[
									Text(
										"物流单号：",
										style: TextStyle(color: Color(0xFF999999), fontSize: 14),
									),
									Text(
										numberCode,
										style: TextStyle(color: Color(0xFF0A1314), fontSize: 14),
										maxLines: 1,
										overflow: TextOverflow.ellipsis,
									),
									GestureDetector(
										onTap: (){
											Clipboard.setData(ClipboardData(text: numberCode));
											ProgressUtil().showWithType(context, ProgressType.ProgressType_Success, title: '复制成功');
										},
										child: Container(
											width: 40,
											height: 20,
											margin: EdgeInsets.only(left: 8),
											decoration: BoxDecoration(
												borderRadius: BorderRadius.circular(4),
												border: Border.all(width: 1,color: Color(0xFF6BCBD7))
											),
											child: Center(
												child: Text(
													'复制',
													style: TextStyle(color: Color(0xFF6BCBD7), fontSize: 12)
												)
											)
										)
									)
								]
							)
						)
					),
					
					SizedBox(height: name.length == 0 ? 0 :10.0),
					Offstage(
						offstage: name.length == 0,
						child: Container(
							child: Row(
								children: <Widget>[
									Text(
										"快递公司：",
										style: TextStyle(color: Color(0xFF999999), fontSize: 14)
									),
									Text(
										name,
										style: TextStyle(color: Color(0xFF0A1314), fontSize: 14)
									)
								]
							)
						)
					)
				]
			)
		);
	}
}

class InformationItem extends StatefulWidget {
	final int currentIndex;
	final LogisticsInfoDesModel infoModel;
	final int lastIndex;
	InformationItem(this.currentIndex, this.infoModel, this.lastIndex);
	@override
	State<StatefulWidget> createState() {
		return _InformationItemState();
	}
}

class _InformationItemState extends State<InformationItem> {
	TapGestureRecognizer _tapGestureRecognizer;
	String numberPhone = '';
	
	@override
	void initState() {
		super.initState();
		_tapGestureRecognizer = TapGestureRecognizer()
			..onTap = _callPhone;
	}
	
	@override
	void dispose() {
		_tapGestureRecognizer.dispose();
		super.dispose();
	}
	
	void _callPhone() {
	
	}
	
	@override
	Widget build(BuildContext context) {
		int time = widget.infoModel.time;
		return Padding(
			padding: EdgeInsets.only(left: 22),
			child: IntrinsicHeight(
				child: Row(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							width: 15,
							child: Column(
								children: <Widget>[
									Container(
										width: widget.currentIndex == 1 ? 0 : 2,
										height: 19,
										color: Color(0xFFCBCBCB),
									),
									Container(
										width: widget.currentIndex == 1 ? 15 : 7,
										height: widget.currentIndex == 1 ? 15 : 7,
										decoration: BoxDecoration(
											borderRadius: BorderRadius.all(Radius.circular(8.0)),
											color: Color(0xFFCBCBCB)
										),
									),
									Expanded(
										child: Container(
											color: Color(0xFFCBCBCB),
											width: widget.currentIndex == widget.lastIndex ? 0 : 2,
										)
									)
								]
							)
						),
						
						Padding(padding: new EdgeInsets.only(right: 20)),
						
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									Padding(padding: EdgeInsets.only(bottom: 15)),
									_getRichTextInfo(),
									Offstage(
										offstage: time == null,
										child: Text(
											_getTime(widget.infoModel.time),
											style: TextStyle(fontSize: 14, color: Color(0x660A1314)),
											maxLines: 1
										)
									),
									Padding(padding: new EdgeInsets.only(bottom: 10)),
									Container(
										height: 1,
										color: Color(0xFFE5E5E5)
									)
								]
							)
						)
					]
				)
			)
		);
	}
	
	// 时间戳转时间
	_getTime(timestamp) {
		try {
			var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
			return "${dateTime.year}-${_addZero(dateTime.month)}-${_addZero(dateTime.day)} ${_addZero(dateTime.hour)}:${_addZero(dateTime.minute)}:${_addZero(dateTime.second)}";
		} catch (e) {
			return '';
		}
	}
	
	_addZero(int value) {
		if (value < 1) {
			return '0$value';
		}
		return '$value';
	}
	
	// 快递信息--富文本
	_getRichTextInfo() {
		String textStr = widget?.infoModel?.description ?? '';
		try {
			RegExp exp = new RegExp('1(3|4|5|7|8)\\d{9}');
			List<String> listStr = textStr.split(exp);
			if (listStr.length == 2) {
				numberPhone = textStr.substring(textStr.indexOf(exp), textStr.indexOf(exp) + 11);
				return Container(
					padding: EdgeInsets.only(right: 15),
					child: RichText(
						text: TextSpan(
							text: listStr[0],
							style: TextStyle(fontSize: 14, color: Color(0xCC0A1314)),
							children: <TextSpan>[
								TextSpan(
									text: numberPhone,
									style: TextStyle(fontSize: 14, color: Color(0xFF6BCBD7)),
									recognizer: _tapGestureRecognizer
								),
								TextSpan(
									text: listStr[1],
									style: TextStyle(fontSize: 14, color: Color(0xCC0A1314))
								)
							]
						)
					)
				);
			} else {
				return Container(
					padding: EdgeInsets.only(right: 15),
					child: Text(
						textStr,
						style: TextStyle(fontSize: 14, color: Color(0xCC0A1314)),
						maxLines: 3,
						overflow: TextOverflow.ellipsis
					)
				);
			}
		} catch (e) {
			return Container(
				padding: EdgeInsets.only(right: 15),
				child: Text(
					textStr,
					style: TextStyle(fontSize: 14, color: Color(0xCC0A1314)),
					maxLines: 3,
					overflow: TextOverflow.ellipsis
				)
			);
		}
	}
}