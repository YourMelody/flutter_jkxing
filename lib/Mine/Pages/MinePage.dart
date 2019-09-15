import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _MinePageState();
	}
}

class _MinePageState extends State<MinePage> {
	@override
	Widget build(BuildContext context) {
		return ListView.separated(
			itemCount: 1,
			itemBuilder: (context, index) {
				return FlatButton(
					onPressed: () {
						Navigator.pushNamed(context, 'my_setting_page');
					},
					child: Text('设置')
				);
			},
			separatorBuilder: (context, index) {
				return Container(color: Color(0xfff4f6f9), height: 0.5);
			}
		);
	}
}