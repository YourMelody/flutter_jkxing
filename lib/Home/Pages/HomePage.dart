import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';

class HomePage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _HomePageState();
	}
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
	@override
	Widget build(BuildContext context) {
		super.build(context);
		return Scaffold(
			appBar: ZFAppBar('首页', showBackBtn: false),
			body: Container(
				child: Center(
					child: Text('首页')
				)
			)
		);
	}
	
	@override
	bool get wantKeepAlive => true;
}