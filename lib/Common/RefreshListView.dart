import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Utils/ListUtil.dart';
import 'package:flutter_jkxing/Common/RefreshEmptyHeader.dart';

class RefreshListView extends StatelessWidget {
	final Widget child;
	
	// 下拉刷新事件（注意，当onRefresh为null，则会展示空的刷新header）
	final Future<void> Function() onRefresh;
	
	// 上拉加载事件
	final Future<void> Function() onLoad;
	
	// 是否展示首次加载的动画页，默认为true
	final bool firstRefresh;
	
	// 空数据缺省页（注意，当emptyWidget不为null时，则只展示emptyWidget）
	final Widget emptyWidget;
	
	RefreshListView({
		this.onRefresh,
		this.onLoad,
		this.firstRefresh = true,
		this.emptyWidget,
		@required this.child,
	});
	
	@override
	Widget build(BuildContext context) {
		return EasyRefresh(
			child: this.child,
			// 下拉刷新的header
			header: this.onRefresh == null ? RefreshEmptyHeader(): ListUtil().getListHeader(),
			// 上拉加载更多的footer
			footer: ListUtil().getListFooter(),
			// 是否展示 firstRefreshWidget
			firstRefresh: true,
			// 首次加载时的缺省页
			firstRefreshWidget: ListUtil().getFirstRefreshPage(),
			// 数据为空时的缺省页（注意，当emptyWidget不为null时则只展示emptyWidget）
			emptyWidget: null,
			// 下拉刷新（缺陷：只有onRefresh不为null，设置的firstRefreshWidget才会生效）
			onRefresh: this.onRefresh ?? () async {
				await Future.delayed(Duration(milliseconds: 300), () {
				
				});
			},
			// 上拉加载更多
			onLoad: this.onLoad
		);
	}
}