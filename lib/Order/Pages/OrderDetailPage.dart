import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jkxing/Common/DrugConfiguration.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Common/ZFProgressHUDView.dart';
import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';
import 'package:flutter_jkxing/Order/Model/OrderDrugModel.dart';
import 'package:flutter_jkxing/Order/Model/OrderModel.dart';
import 'package:flutter_jkxing/Order/Network/DrugConfigRequest.dart';
import 'package:flutter_jkxing/Utils/ProgressUtil.dart';

import 'OrderLogisticsInfoPage.dart';

class OrderDetailPage extends StatefulWidget {
	final OrderModel model;
	OrderDetailPage(this.model);
	@override
	State<StatefulWidget> createState() {
		return _OrderDetailState();
	}
}

class _OrderDetailState extends State<OrderDetailPage> {
	DrugConfigModel configModel;
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	void _initData() {
		if (PPSession.getInstance().userModel.agentType == 1) {
			DrugConfigRequest.drugConfigReq().then((response) {
				if (response != null) {
					DrugConfiguration.getInstance(response);
					setState(() {
						this.configModel = response;
					});
				}
			});
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar('订单详情', context: context),
			body: ListView.builder(
				itemBuilder: (context, index) {
					if (index == 0) {
						return _createHeader();
					} else if (index == widget.model.drugList.length + 1) {
						return _createFooter();
					} else {
						return _createDrugItem(widget.model.drugList[index - 1]);
					}
				},
				itemCount: widget.model.drugList.length + 2
			),
			backgroundColor: Colors.white
		);
	}
	
	// 药品
	Widget _createDrugItem(OrderDrugModel drugModel) {
		// 热度标签
		String hotImgStr = '';
		if (this.configModel != null && this.configModel?.firstBit == '1' && this.configModel?.thirdBit == '1') {
			if (this.configModel?.rateArr?.length != null && this.configModel.rateArr.length > 0) {
				double ratio = 0.0;
				if (drugModel?.salePrice != null && drugModel.salePrice > 0) {
					ratio = (drugModel.doctorPriceCommission / drugModel.salePrice) * 100.0;
				}
				
				if (this.configModel.rateArr.last <= ratio) {
					for(int i = 0; i < this.configModel.rateArr.length; i++) {
						double tmpRate = this.configModel.rateArr[i];
						if (tmpRate < ratio) {
							hotImgStr = this.configModel?.hotSpecialItems[i]?.rateIconUrl ?? '';
							break;
						}
					}
				}
			}
		}

		return Container(
			height: 48,
			padding: EdgeInsets.symmetric(horizontal: 15),
			child: Column(
				children: <Widget>[
					Expanded(child: Padding(padding: EdgeInsets.zero)),
					Row(children: <Widget>[
						// 热度标签
						Offstage(
							offstage: hotImgStr.length == 0,
							child: Container(
								width: 43,
								height: 15,
								padding: EdgeInsets.only(right: 5),
								child: Image.network(hotImgStr, fit: BoxFit.contain)
							)
						),
						
						// 药品名字
						Expanded(child: Text(
							drugModel?.productName ?? '',
							style: TextStyle(
								fontSize: 16,
								color: Color(0xff1a1a1a)
							),
							maxLines: 1,
							overflow: TextOverflow.ellipsis
						)),
						Padding(padding: EdgeInsets.only(right: 15)),
						// 药品价格
						Text(
							_getMoney(drugModel?.salePrice),
							style: TextStyle(
								fontSize: 16,
								color: Color(0xff1a1a1a)
							)
						)
					]),
					
					Row(children: <Widget>[
						Expanded(child: Text(
							drugModel?.packing == null ? '' : '规格：${drugModel.packing}',
							style: TextStyle(
								fontSize: 12,
								color: Color(0xff999999)
							)
						)),
						Padding(padding: EdgeInsets.only(right: 15)),
						Text(
							drugModel?.amount == null ? '' : 'x${drugModel.amount}',
							style: TextStyle(
								fontSize: 12,
								color: Color(0xff999999)
							)
						)
					])
				]
			)
		);
	}
	
	// 订单顶部信息
	Widget _createHeader() {
		String preType;
		if (widget?.model?.prescriptionType == 1) {
			preType = '问诊';
		} else if (widget?.model?.prescriptionType == 2) {
			preType = '扫码';
		} else {
			preType = '分享';
		}
		return Container(
			height: 266,
			child: Column(
				children: <Widget>[
					_createDoctorInfo(),
					Padding(padding: EdgeInsets.only(top: 20)),
					_createHeaderItem('订单状态：', widget?.model?.prescriptionStatusShow ?? '', firstItem: true),
					_createHeaderItem('支付时间：', _getTime(widget?.model?.payTime)),
					_createHeaderItem('订单编号：', widget?.model?.orderCode ?? '', showCopyBtn: true),
					_createHeaderItem('处方笺ID：', widget?.model?.prescriptionCode ?? ''),
					_createHeaderItem('处方分类：', preType),
					_createHeaderItem('处方诊断：', widget?.model?.diagnosis ?? ''),
					// 分割线
					Expanded(child: Padding(padding: EdgeInsets.zero)),
					Container(
						padding: EdgeInsets.symmetric(horizontal: 15),
						margin: EdgeInsets.only(bottom: 10),
						child: Image.asset('lib/Images/order_detail_line.png', height: 1)
					)
				],
				crossAxisAlignment: CrossAxisAlignment.start
			)
		);
	}
	
	// 顶部医生信息
	Widget _createDoctorInfo() {
		return Container(
			height: 72,
			width: double.maxFinite,
			decoration: BoxDecoration(
				border: Border(
					bottom: BorderSide(
						color: Color(0xffe5e5e5),
						width: 0.5
					)
				)
			),
			padding: EdgeInsets.symmetric(horizontal: 15),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					RichText(
						text: TextSpan(
							text: widget?.model?.doctorName ?? '',
							style: TextStyle(fontSize: 18, color: Color(0xff1a1a1a)),
							children: <TextSpan>[
								TextSpan(text: '   '),
								TextSpan(
									text: widget?.model?.titleName ?? '',
									style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d))
								),
								TextSpan(text: ' '),
								TextSpan(
									text: widget?.model?.departmentName ?? '',
									style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d))
								)
							]
						),
						maxLines: 1,
						overflow: TextOverflow.ellipsis
					),
					
					// 医生所在医院
					Text(
						widget?.model?.hospitalName ?? '',
						style: TextStyle(
							fontSize: 12,
							color: Color(0xff999999)
						),
						maxLines: 1,
						overflow: TextOverflow.ellipsis
					)
				]
			)
		);
	}
	
	// 顶部订单信息
	Widget _createHeaderItem(String title, String value, {bool firstItem: false, bool showCopyBtn: false}) {
		return Container(
			child: Row(children: <Widget>[
				Container(
					width: 80,
					child: Text(
						title,
						style: TextStyle(
							fontSize: 14,
							color: Color(0xff999999),
							height: 1.7
						)
					)
				),
				Expanded(child: Text(
					value,
					textAlign: TextAlign.right,
					style: TextStyle(
						fontSize: firstItem ? 16 : 14,
						color: firstItem ? Color(0xffff8d41) : Color(0xff4d4d4d)
					)
				)),
				
				// 复制
				Offstage(
					offstage: showCopyBtn != true,
					child: GestureDetector(
						onTap: () {
							Clipboard.setData(ClipboardData(text: value));
							ProgressUtil().showWithType(context, ProgressType.ProgressType_Success, title: '复制成功');
						},
						child: Container(
							width: 40,
							height: 21,
							margin: EdgeInsets.only(left: 10),
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(4),
								border: Border.all(
									width: 1,
									color: Color(0xff6bcbd7)
								),
								color: Color(0x0a6bcbd7)
							),
							alignment: Alignment.center,
							child: Text('复制', style: TextStyle(
								fontSize: 12,
								color: Color(0xff6bcbd7)
							)),
						)
					)
				)
			]),
			padding: EdgeInsets.symmetric(horizontal: 15),
		);
	}
	
	// 订单底部（药品总价+查看物流）
	Widget _createFooter() {
		return Container(
			padding: EdgeInsets.symmetric(horizontal: 15),
			child: Column(
				children: <Widget>[
					Padding(padding: EdgeInsets.only(top: 12)),
					Row(children: <Widget>[
						Text(
							'药品共计：',
							style: TextStyle(
								fontSize: 16,
								color: Color(0xff999999)
							),
						),
						Expanded(child: Text(
							_getMoney(widget?.model?.price),
							textAlign: TextAlign.right,
							style: TextStyle(
								fontSize: 20,
								color: Color(0xffe56767)
							),
						))
					]),
					Padding(padding: EdgeInsets.only(top: 35)),
					GestureDetector(
						onTap: () {
							Navigator.of(context).push(MaterialPageRoute(
								builder: (context) => OrderLogisticsInfoPage(widget?.model?.orderCode)
							));
						},
						child: Container(
							width: 125,
							height: 36,
							alignment: Alignment.center,
							decoration: BoxDecoration(
								color: Color(0xff6bcbd7),
								borderRadius: BorderRadius.circular(18)
							),
							child: Text(
								'查看物流详情',
								style: TextStyle(
									fontSize: 14,
									color: Colors.white
								)
							)
						)
					)
				]
			)
		);
	}
	
	String _getTime(int time) {
		if (time == null || time == 0) {
			return '';
		}
		DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
		return '${dateTime.year}-${_addZero(dateTime.month)}-${_addZero(dateTime.day)} ${_addZero(dateTime.hour)}:${_addZero(dateTime.minute)}';
	}
	
	String _addZero(int value) {
		if (value < 10) {
			return '0' + value.toString();
		}
		return value.toString();
	}
	
	String _getMoney(int value) {
		if (value == null) {
			return '';
		}
		return '¥' + (value / 100).toStringAsFixed(2);
	}
}