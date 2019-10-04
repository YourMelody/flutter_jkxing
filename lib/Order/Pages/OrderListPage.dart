import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Order/Model/OrderModel.dart';
import 'package:flutter_jkxing/Order/Network/OrderRequest.dart';
import 'package:flutter_jkxing/Order/Pages/OrderDetailPage.dart';

class OrderListPage extends StatefulWidget {
	final int status;
	OrderListPage(this.status);
	@override
	State<StatefulWidget> createState() {
		return _OrderListState();
	}
}

class _OrderListState extends State<OrderListPage> with AutomaticKeepAliveClientMixin {
	List <OrderModel> dataSource = [];
	int currentPage = 1;
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData(true);
		});
	}
	
	@override
	bool get wantKeepAlive => true;
	
	_initData(bool showToast) {
		OrderRequest.getOrderList(this.currentPage, context, status: widget.status, showToast: showToast).then((response) {
			if (response != null) {
				if (this.currentPage == 1) {
					setState(() {
						this.dataSource = response;
					});
				} else {
					setState(() {
						this.dataSource.addAll(response);
					});
				}
				this.currentPage++;
			}
		});
	}
	
	@override
	Widget build(BuildContext context) {
		super.build(context);
		return ListView.separated(
			itemBuilder: (context, index) => _createItem(dataSource[index]),
			itemCount: dataSource == null ? 0 : dataSource.length,
			padding: EdgeInsets.fromLTRB(12, 15, 12, 15),
			separatorBuilder: (context, index) {
				return Container(height: 15, color: Color(0xfff4f6f9));
			},
		);
	}
	
	Widget _createItem(OrderModel model) {
		return GestureDetector(
			onTap: () {
				Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailPage(model)));
			},
			child: Container(
				height: 120,
				padding: EdgeInsets.fromLTRB(15, 12, 15, 0),
				decoration: BoxDecoration(
					color: Colors.white,
					borderRadius: BorderRadius.circular(5),
					border: Border.all(
						color: Color(0xffe5e5e5),
						width: 0.5
					)
				),
				child: Column(
					children: <Widget>[
						// 医生姓名  状态
						Row(children: <Widget>[
							Expanded(child: Text(
								model.doctorName,
								style: TextStyle(
									fontSize: 16,
									color: Color(0xff0a1314),
									fontWeight: FontWeight.w500
								),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							)),
							Container(
								width: 65,
								alignment: Alignment.centerRight,
								child: Text(
									model.prescriptionStatusShow,
									style: TextStyle(
										fontSize: 16,
										color: Color(0xffff8d41),
										fontWeight: FontWeight.w500
									)
								)
							)
						]),
						Padding(padding: EdgeInsets.only(top: 2)),
						
						// 医院名字
						Text(
							model.hospitalName,
							style: TextStyle(
								fontSize: 14,
								color: Color(0xff0a1314)
							),
							maxLines: 1,
							overflow: TextOverflow.ellipsis
						),
						Padding(padding: EdgeInsets.only(top: 12)),
						
						// 支付时间
						Row(children: <Widget>[
							Container(
								width: 75,
								child: Text('支付时间：', style: TextStyle(
									fontSize: 12,
									color: Color(0xff999999)
								)),
							),
							Expanded(child: Text(
								_getTime(model.payTime),
								textAlign: TextAlign.right,
								style: TextStyle(
									fontSize: 12,
									color: Color(0xff999999)
								),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							))
						]),
						Padding(padding: EdgeInsets.only(top: 3)),
					
						// 处方金额
						Row(children: <Widget>[
							Container(
								width: 75,
								child: Text('处方金额：', style: TextStyle(
									fontSize: 12,
									color: Color(0xff999999)
								)),
							),
							Expanded(child: Text(
								_getMoney(model.price),
								textAlign: TextAlign.right,
								style: TextStyle(
									fontSize: 16,
									color: Color(0xffe55e5e)
								),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							))
						])
					],
					crossAxisAlignment: CrossAxisAlignment.start
				),
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