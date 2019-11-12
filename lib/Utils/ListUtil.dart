import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class ListUtil {
	// 下拉刷新的header
	Header getListHeader() {
		return ClassicalHeader(
			enableInfiniteRefresh: false,
			refreshText: '下拉可以刷新',
			refreshReadyText: '松开立即刷新',
			refreshingText: '正在刷新数据中...',
			refreshedText: '刷新完成',
			refreshFailedText: '刷新失败',
			infoText: '最后更新: %T',
			completeDuration: Duration(milliseconds: 500),
			showInfo: true
		);
	}
	
	// 上拉加载更多的footer
	Footer getListFooter() {
		return ClassicalFooter(
			loadText: '上拉可以加载更多',
			loadReadyText: '松开立即加载更多',
			loadingText: '正在加载更多的数据...',
			loadedText: '加载完成',
			noMoreText: '没有更多数据',
			showInfo: false
		);
	}
	
	// 列表为空的缺省页
	Widget getEmptyPage(String imgStr, String title) {
		return Container(
			child: Center(
				child: Text('空数据'),
			),
		);
	}
	
	// 首次加载时的缺省页
	Widget getFirstRefreshPage() {
		return Container(
			color: Colors.white,
			width: double.infinity,
			height: double.infinity,
			child: Column(
				children: <Widget>[
					Expanded(
						child: Container(
							alignment: Alignment.bottomCenter,
							child: Image(
								width: 142,
								height: 152,
								image: new AssetImage('lib/Images/loading.gif')
							)
						)
					),
					Padding(padding: EdgeInsets.only(top: 6)),
					Expanded(
						child: Text("加载中，请稍后...",
							style: TextStyle(
								color: Color(0x660A1314),
								fontSize: 14,
								decoration: TextDecoration.none
							)
						),
						flex: 2,
					)
				]
			)
		);
	}
}