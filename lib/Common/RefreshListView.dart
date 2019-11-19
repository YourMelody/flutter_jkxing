import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Utils/ListUtil.dart';
import 'package:flutter_jkxing/Common/RefreshEmptyHeader.dart';

enum EmptyWidgetType {
	None,       // 没有缺省页
	NetError,   // 网络异常缺省页
	NoData      // 空数据缺省页
}

class RefreshListView extends StatelessWidget {
	final Widget child;
	
	final EasyRefreshController controller;
	
	// 下拉刷新事件
	final Future<void> Function() onRefresh;
	// 是否展示下拉刷新组建（当只需要首次加载动画，不需要下拉刷新功能时，传false。默认为true）
	final bool showRefreshHeader;
	
	// 上拉加载事件
	final Future<void> Function() onLoad;
	
	// 是否展示首次加载的动画页，默认为true
	final bool firstRefresh;
	
	// 空数据缺省页类型
	final EmptyWidgetType type;
	
	RefreshListView({
		this.onLoad,
		this.firstRefresh = true,
		this.type,
		this.showRefreshHeader = true,
		this.controller,
		@required this.onRefresh,
		@required this.child
	});
	
	@override
	Widget build(BuildContext context) {
		return EasyRefresh(
			controller: this.controller,
			child: this.child,
			// 下拉刷新的header
			header: showRefreshHeader ? ListUtil().getListHeader() : RefreshEmptyHeader(),
			// 上拉加载更多的footer
			footer: ListUtil().getListFooter(),
			// 是否展示 firstRefreshWidget
			firstRefresh: true,
			// 首次加载时的缺省页
			firstRefreshWidget: ListUtil().getFirstRefreshPage(),
			// 数据为空时的缺省页（注意，当emptyWidget不为null时则只展示emptyWidget）
			emptyWidget: type == EmptyWidgetType.None ? null :
						 type == EmptyWidgetType.NetError ? ListUtil().getNetErrorEmptyPage(this.onRefresh) :
						 ListUtil().getNoDataEmptyPage('', ''),
			// 下拉刷新（注意：只有onRefresh不为null，设置的firstRefreshWidget才会生效）
			onRefresh: this.onRefresh,
			// 上拉加载更多
			onLoad: this.onLoad
		);
	}
}