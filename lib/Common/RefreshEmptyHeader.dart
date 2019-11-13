import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

// 由于 EasyRefresh 设置 firstRefreshWidget时，必须同时保证 onRefresh 不为 null 才能生效，
// 因此当仅需要 firstRefreshWidget 而不需要下拉刷新时，给一个自定义的空 header
class RefreshEmptyHeader extends Header {
	final Key key;
	final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();
	
	RefreshEmptyHeader({
		this.key,
		completeDuration = const Duration(seconds: 0)
	}): super(
		float: false,
		extent: 0.0,
		triggerDistance: 10000.0,
		completeDuration: Duration(seconds: 0),
		enableInfiniteRefresh: false
	);
	
	@override
	Widget contentBuilder(BuildContext context, RefreshMode refreshState,
		double pulledExtent, double refreshTriggerPullDistance,
		double refreshIndicatorExtent, AxisDirection axisDirection,
		bool float, Duration completeDuration, bool enableInfiniteRefresh,
		bool success, bool noMore) {
		linkNotifier.contentBuilder(context, refreshState, pulledExtent,
			refreshTriggerPullDistance, refreshIndicatorExtent, axisDirection,
			float, completeDuration, enableInfiniteRefresh, success, noMore);
		return MaterialHeaderWidget(
			key: key,
			linkNotifier: linkNotifier,
		);
	}
}
class MaterialHeaderWidget extends StatefulWidget {
	final LinkHeaderNotifier linkNotifier;
	
	const MaterialHeaderWidget({
		Key key,
		this.linkNotifier,
	}) : super(key: key);
	
	@override
	MaterialHeaderWidgetState createState() {
		return MaterialHeaderWidgetState();
	}
}
class MaterialHeaderWidgetState extends State<MaterialHeaderWidget>
	with TickerProviderStateMixin<MaterialHeaderWidget>{
	@override
	Widget build(BuildContext context) {
		return Container();
	}
}