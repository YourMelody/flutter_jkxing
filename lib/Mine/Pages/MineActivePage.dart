import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/DrugLibrary/Model/MedicineItemModel.dart';
import 'package:flutter_jkxing/DrugLibrary/Network/DrugLibRequest.dart';
import 'package:flutter_jkxing/Mine/Model/ActivePerModel.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;

class MineActivePage extends StatefulWidget {
	final ActivePerModel activeData;
	MineActivePage(this.activeData);
	@override
	State<StatefulWidget> createState() {
		return _MineActiveState();
	}
}

class _MineActiveState extends State<MineActivePage> {
	List <MedicineItemModel> dataSource = [];
	int selectIndex = 0;
	ScrollController _scrollViewController;
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	
	@override
	void initState() {
		super.initState();
		_scrollViewController = ScrollController(initialScrollOffset: 0.0);
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	Future<void> _initData() async {
		// 名医推荐药品列表（不分页）
		var response = await DrugLibRequest.getRecommendMedicineList(context);
		if (response != null) {
			// 请求成功
			this.controller.finishLoad(noMore: true);
			this.dataSource = response;
			if (this.dataSource.length == 0) {
				type = EmptyWidgetType.NoData;
			} else {
				type = EmptyWidgetType.None;
			}
			this.setState(() {});
		} else {
			// 请求失败
			this.controller.finishLoad(success: false);
			if (this.dataSource == null || this.dataSource.length == 0) {
				this.setState(() {
					type = EmptyWidgetType.NetError;
				});
			} else {
				this.setState(() {
					type = EmptyWidgetType.NoData;
				});
			}
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'活跃度',
				context: context
			),
			body: extended.NestedScrollView(
				controller: _scrollViewController,
				headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
					return <Widget>[
						SliverAppBar(
							automaticallyImplyLeading: false,
							pinned: true,
							floating: true,
							expandedHeight: 224,
							backgroundColor: Colors.white,
							flexibleSpace: FlexibleSpaceBar(
								collapseMode: CollapseMode.pin,
								background: _createTopBanner()
							),
							bottom: _createStickyBar(),
							elevation: 0
						)
					];
				},
				body: _createList()
			),
			backgroundColor: Colors.white
		);
	}
	
	// 本期、上期、进度
	Widget _createTopBanner() {
		return Column(children: <Widget>[
			Container(
				height: 164,
				padding: EdgeInsets.only(top: 20),
				color: Colors.white,
				child: Column(children: <Widget>[
					Row(
						children: <Widget>[
							GestureDetector(
								onTap: () {
									// 本期
									if (this.selectIndex == 1) {
										setState(() {
											selectIndex = 0;
										});
									}
								},
								child: Container(
									width: 56, height: 26,
									alignment: Alignment.center,
									decoration: BoxDecoration(
										color: this.selectIndex == 0 ? Color(0xff6bcbd6) : Color(0xfff0f2f5),
										borderRadius: BorderRadius.circular(4)
									),
									child: Text(
										'本期',
										style: TextStyle(
											fontSize: 14,
											color: this.selectIndex == 0 ? Colors.white : Color(0xff909399)
										)
									)
								)
							),
							Padding(padding: EdgeInsets.only(right: 10)),
							GestureDetector(
								onTap: () {
									// 上期
									if (this.selectIndex == 0) {
										setState(() {
											selectIndex = 1;
										});
									}
								},
								child: Container(
									width: 56, height: 26,
									alignment: Alignment.center,
									decoration: BoxDecoration(
										color:  this.selectIndex == 1 ? Color(0xff6bcbd6) : Color(0xfff0f2f5),
										borderRadius: BorderRadius.circular(4)
									),
									child: Text(
										'上期',
										style: TextStyle(
											fontSize: 14,
											color: this.selectIndex == 1 ? Colors.white : Color(0xff909399)
										)
									)
								)
							)
						],
						mainAxisAlignment: MainAxisAlignment.center
					),
					Padding(padding: EdgeInsets.only(top: 24)),
					
					// 进度百分比
					_createPercent(),
					
					// 进度条
					_createProgressBar(),
					
					// 分段百分比
					_createProgressPercent()
				])
			),
			Container(
				height: 10,
				color: Color(0xfff4f6f9)
			)
		]);
	}
	
	// 进度百分比
	Widget _createPercent() {
		double marginLeft = 9;
		if (widget?.activeData?.activePer != null) {
			double deviceW = MediaQuery.of(context).size.width;
			marginLeft = (deviceW - 66) * (widget.activeData.activePer / 100) + 9;
			if (marginLeft > deviceW - 57) {
				marginLeft = deviceW - 57;
			} else if (marginLeft < 9) {
				marginLeft = 9;
			}
		}
		return Container(
			alignment: Alignment.centerLeft,
			padding: EdgeInsets.only(left: marginLeft),
			child: Stack(
				children: <Widget>[
					Image.asset(
						'lib/Images/progress_bubble.png',
						width: 48,
						height: 24
					),
					Container(
						height: 20,
						width: 48,
						alignment: Alignment.center,
						child: Text(
							widget?.activeData?.activePer != null ?
							'${widget.activeData.activePer}%' : '0.0%',
							style: TextStyle(fontSize: 12, color: Colors.white),
							maxLines: 1,
							overflow: TextOverflow.ellipsis
						)
					)
				]
			)
		);
	}
	
	// 进度条
	Widget _createProgressBar() {
		// 达标位置的圆marginLeft
		double marginLeft = 0;
		// 进度条宽度
		double colorWidth = 5;
		if (widget?.activeData?.activeBase != null) {
			double deviceW = MediaQuery.of(context).size.width;
			marginLeft = (deviceW - 48) * (widget.activeData.activeBase / 100);
			if (marginLeft < 0) {
				marginLeft = 0;
			} else if (marginLeft > deviceW - 48) {
				marginLeft = deviceW - 48;
			}
			
			colorWidth = (deviceW - 66) * (widget.activeData.activePer / 100) + 5;
			if (colorWidth < 5) {
				colorWidth = 5;
			} else if (colorWidth >= deviceW - 61) {
				colorWidth = deviceW - 56;
			}
		}
		
		return Container(
			height: 18,
			padding: EdgeInsets.symmetric(horizontal: 15),
			child: Stack(children: <Widget>[
				// 背景色
				Container(
					height: 8,
					margin: EdgeInsets.only(top: 5, left: 13, right: 13),
					color: Color(0xffe6e6e6)
				),
				
				// 进度条的颜色
				Container(
					height: 8,
					width: colorWidth,
					margin: EdgeInsets.only(top: 5, left: 13),
					decoration: BoxDecoration(
						// 设置渐变色
						gradient: LinearGradient(
							colors: [Color(0xffffcf3b), Color(0xffff9920)]
						),
						borderRadius: BorderRadius.circular(9)
					)
				),
				
				// 起始位置的圆
				Container(
					decoration: BoxDecoration(
						border: Border.all(
							width: 5,
							color: widget?.activeData?.activePer != null && widget.activeData.activePer > 0 ?
								   Color(0xffffc637) : Color(0xffe6e6e6)
						),
						borderRadius: BorderRadius.circular(9),
						color: Colors.white
					),
					width: 18,
					height: 18
				),
				
				// 达标位置的圆
				Positioned(
					left: marginLeft,
					child: Container(
						decoration: BoxDecoration(
							border: Border.all(
								width: 5,
								color: widget?.activeData?.activePer != null &&
									widget?.activeData?.activeBase != null &&
									widget.activeData.activePer >= widget.activeData.activeBase ?
									Color(0xffffab29) : Color(0xffe6e6e6)
							),
							borderRadius: BorderRadius.circular(9),
							color: Colors.white
						),
						width: 18,
						height: 18
					)
				),
				
				// 末尾位置的圆
				Positioned(
					right: 0,
					child: Container(
						decoration: BoxDecoration(
							border: Border.all(
								width: 5,
								color: widget?.activeData?.activePer == 100 ? Color(0xffffab29) : Color(0xffe6e6e6)
							),
							borderRadius: BorderRadius.circular(9),
							color: Colors.white
						),
						width: 18,
						height: 18
					)
				)
			])
		);
	}
	
	// 分段百分比
	Widget _createProgressPercent() {
		double marginLeft = 25;
		if (widget?.activeData?.activeBase != null) {
			double deviceW = MediaQuery.of(context).size.width;
			marginLeft = (deviceW - 48) * (widget.activeData.activeBase / 100) - 34;
			if (marginLeft < 22) {
				marginLeft = 22;
			} else if (marginLeft > deviceW - 145) {
				marginLeft = deviceW - 145;
			}
		}
		
		return Container(
			height: 25,
			alignment: Alignment.bottomLeft,
			width: 414,
			padding: EdgeInsets.symmetric(horizontal: 15),
			child: Stack(children: <Widget>[
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					crossAxisAlignment: CrossAxisAlignment.end,
					children: <Widget>[
						Text('0%', style: TextStyle(fontSize: 14, color: Color(0xff6c7172))),
						Text('100%', style: TextStyle(fontSize: 14, color: Color(0xff6c7172))),
					
					],
				),
				Positioned(
					left: marginLeft,
					bottom: 0,
					child: Container(
						alignment: Alignment.center,
						child: Text(
							widget?.activeData?.activeBase == null ? '' :
							'达标 ${widget.activeData.activeBase}%',
							style: TextStyle(fontSize: 14, color: Color(0xff6c7172))
						),
						width: 86
					)
				)
			])
		);
	}
	
	// 未活跃医生
	Widget _createStickyBar() {
		return PreferredSize(
			child: Container(
				height: 50,
				alignment: Alignment.center,
				child: Text(
					'未活跃医生（0）',
					style: TextStyle(color: Color(0xff3b4243), fontSize: 17, fontWeight: FontWeight.w500)
				),
				decoration: BoxDecoration(
					border: Border(
						bottom: BorderSide(
							width: 1,
							color: Color(0xffe5e5e5)
						)
					),
					color: Colors.white
				)
			),
			preferredSize: Size.fromHeight(50)
		);
	}
	
	// 数据列表
	Widget _createList() {
		return RefreshListView(
			controller: this.controller,
			child: ListView.separated(
				itemBuilder: (context, index) {
					return _itemBuilder(dataSource[index]);
				},
				separatorBuilder: (BuildContext context, int index) {
					return Divider(color: Color(0xffe5e5e5), height: 0.5);
				},
				itemCount: dataSource == null ? 0 : dataSource.length
			),
			onRefresh: () {
				if (this.type == EmptyWidgetType.NetError) {
					this.setState(() {
						type = EmptyWidgetType.Loading;
					});
				}
				return _initData();
			},
			onLoad: () {
				return _initData();
			},
			type: this.type
		);
	}
	
	_itemBuilder(MedicineItemModel model) {
		return GestureDetector(
			child: Container(
				padding: EdgeInsets.all(15.0),
				child: Row(
					children: <Widget>[
						// 药品图片和Rx标签
						Stack(
							children: <Widget>[
								Positioned(
									child: FadeInImage.assetNetwork(
										placeholder: 'lib/Images/img_default_medicine.png',
										image: model.productImageUrl ?? '',
										width: 64,
										height: 64,
										fadeOutDuration: Duration(
											milliseconds: 50),
										fadeInDuration: Duration(
											milliseconds: 50)
									)
								),
								Positioned(
									// Rx标签：prescriptionType为4（处方药）或5（管制处方药）时才展示
									child: Offstage(
										offstage: model?.prescriptionType !=
											4 && model?.prescriptionType != 5,
										child: Image.asset(
											'lib/Images/rx_label_flag.png',
											width: 25, height: 25)
									)
								)
							]
						),
						
						Padding(padding: EdgeInsets.only(left: 10)),
						
						Expanded(child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								// 缺货标志（type为4显示）和药品名称
								Row(
									children: <Widget>[
										Offstage(
											offstage: model
												?.productStatusType != 4,
											child: Container(
												width: 29,
												height: 13,
												margin: EdgeInsets.only(
													right: 5),
												alignment: Alignment.center,
												child: Text(
													'缺货', style: TextStyle(
													color: Colors.white,
													fontSize: 9)),
												decoration: BoxDecoration(
													borderRadius: BorderRadius
														.circular(6.5),
													color: Color(0xffcccccc)
												),
											),
										),
										Text(
											model?.productName ?? '',
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
											style: TextStyle(
												color: Color(0xff1a191a),
												fontSize: 14)
										)
									]
								),
								
								Padding(padding: EdgeInsets.only(top: 5)),
								
								// 厂商
								Text(
									model?.manufacturer ?? '',
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: TextStyle(
										fontSize: 12, color: Color(0xff999999))
								),
								
								Padding(padding: EdgeInsets.only(top: 3)),
								
								// 规格
								Text(
									model?.packing ?? '',
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: TextStyle(
										fontSize: 12, color: Color(0xff999999))
								),
								
								Padding(padding: EdgeInsets.only(top: 3)),
								
								// 价格和热度标签
								Row(
									children: <Widget>[
										Text(
											'¥${((model?.ourPrice ?? 0) / 100.0)
												.toStringAsFixed(2)}',
											style: TextStyle(fontSize: 15,
												color: Color(0xffe56767),
												fontWeight: FontWeight.bold)
										)
									]
								)
							]
						))
					]
				),
				color: Colors.white
			),
			
			onTap: () {
			
			}
		);
	}
}