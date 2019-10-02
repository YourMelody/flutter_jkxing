import 'package:flutter/material.dart';

class OrderListPage extends StatefulWidget {
	final int status;
	OrderListPage(this.status);
	@override
	State<StatefulWidget> createState() {
		return _OrderListState();
	}
}

class _OrderListState extends State<OrderListPage> {
	@override
	Widget build(BuildContext context) {
		return ListView.builder(
			itemBuilder: (context, index) => _createItem(),
			itemCount: 10
		);
	}
	
	_createItem() {
		
	}
}