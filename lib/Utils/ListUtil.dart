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
			completeDuration: Duration(milliseconds: 200),
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
			noMoreText: '已经全部加载完毕',
			loadFailedText: '加载失败',
			completeDuration: Duration(milliseconds: 200),
			showInfo: false,
			enableInfiniteLoad: false
		);
	}
	
	// 列表为空的缺省页
	Widget getNoDataEmptyPage(String imgStr, String title) {
		return Container(
			alignment: Alignment.center,
			padding: EdgeInsets.symmetric(horizontal: 20),
			child: Column(
				children: <Widget>[
					Expanded(
						child: Container(),
						flex: 5
					),
					
					Image.asset(
						imgStr ?? '',
						width: 143,
						height: 135
					),
					Padding(padding: EdgeInsets.only(top: 14)),
					Text(
						title ?? '',
						style: TextStyle(fontSize: 14, color: Color(0x660a1314)),
						maxLines: 2,
						overflow: TextOverflow.ellipsis
					),
					
					Expanded(
						child: Container(),
						flex: 9
					)
				]
			)
		);
	}
	
	// 请求失败的缺省页
	Widget getNetErrorEmptyPage(VoidCallback refresh) {
		return Container(
			color: Colors.white,
			width: double.infinity,
			height: double.infinity,
			padding: EdgeInsets.only(bottom: 20),
			child: Column(
				children: <Widget>[
					// 上边空白
					Expanded(
						child: Container(),
						flex: 1,
					),
					
					// 缺省图片
					Container(
						child: Image(
							width: 144,
							height: 135,
							image: AssetImage('lib/Images/net_error_img.png')
						),
						padding: EdgeInsets.only(bottom: 15)
					),
					
					// 加载失败
					Text(
						'加载失败',
						style: TextStyle(fontSize: 14, color: Color(0x660a1314))
					),
					
					// 刷新按钮
					GestureDetector(
						onTap: () => refresh(),
						child: Container(
							margin: EdgeInsets.only(top: 20),
							width: 144,
							height: 32,
							alignment: Alignment.center,
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(16),
								color: Color(0xff6bcbd6)
							),
							child: Text(
								'点击重新加载',
								style: TextStyle(fontSize: 14, color: Colors.white)
							)
						)
					),
					
					// 下边空白
					Expanded(
						child: Container(),
						flex: 2
					)
				]
			)
		);
	}
	
	// 首次加载时的动画
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
								image: AssetImage('lib/Images/loading.gif')
							)
						),
						flex: 2
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
						flex: 3
					)
				]
			)
		);
	}
}