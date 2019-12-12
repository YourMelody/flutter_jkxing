import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';

class MineActivePage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _MineActiveState();
	}
}

class _MineActiveState extends State<MineActivePage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'活跃度',
				context: context
			),
			body: CustomScrollView(
				slivers: <Widget>[
					_createTopBanner(),
				]
			),
			backgroundColor: Colors.white
		);
	}
	
	// 本期、上期、进度
	Widget _createTopBanner() {
		return SliverToBoxAdapter(
			child: Container(
				height: 224,
				child: Container(
					height: 174,
					padding: EdgeInsets.only(top: 20),
					child: Column(children: <Widget>[
						Row(
							children: <Widget>[
								GestureDetector(
									onTap: () {
										// 本期
									},
									child: Container(
										width: 56, height: 26,
										alignment: Alignment.center,
										decoration: BoxDecoration(
											color: Color(0xff6bcbd6),
											borderRadius: BorderRadius.circular(4)
										),
										child: Text('本期', style: TextStyle(fontSize: 14, color: Colors.white)),
									)
								),
								Padding(padding: EdgeInsets.only(right: 10)),
								GestureDetector(
									onTap: () {
										// 上期
									},
									child: Container(
										width: 56, height: 26,
										alignment: Alignment.center,
										decoration: BoxDecoration(
											color:  Color(0xfff0f2f5),
											borderRadius: BorderRadius.circular(4)
										),
										child: Text('上期', style: TextStyle(fontSize: 14, color: Color(0xff909399))),
									)
								)
							],
							mainAxisAlignment: MainAxisAlignment.center
						)
					])
				)
			)
		);
	}
}