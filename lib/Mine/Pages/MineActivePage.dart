import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:flutter_jkxing/Mine/Model/ActivePerModel.dart';
import 'package:flutter_jkxing/Home/Model/DoctorInfoOfHospitalModel.dart';
import 'package:flutter_jkxing/Mine/Network/MineRequest.dart';
import 'package:flutter_jkxing/Home/Pages/DoctorStatisticPage.dart';

// 我的->活跃度
class MineActivePage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _MineActiveState();
	}
}

class _MineActiveState extends State<MineActivePage> {
	ActivePerModel activeData;
	List <DoctorInfoOfHospitalModel> dataSource = [];
	int selectIndex = 1;
	int currentPage = 1;
	int totalCount = 0;
	ScrollController _scrollViewController;
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	bool reqFail = false;
	
	@override
	void initState() {
		super.initState();
		_scrollViewController = ScrollController(initialScrollOffset: 0.0);
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
			_getDoctorActive(1);
		});
	}
	
	Future<void> _initData() async {
		// 名医推荐药品列表（不分页）
		var response = await MineRequest.getNonActiveDoctorList(this.selectIndex, this.currentPage, context);
		if (response != null) {
			if (this.currentPage == 1) {
				this.totalCount = response['nonActiveDoctorCount'];
			}
			// 请求成功
			var respList = (response['nonActiveDoctorList'] as List)?.map((e) {
				return e == null ? null : DoctorInfoOfHospitalModel.fromJson(e);
			})?.toList();
			if (this.currentPage == 1) {
				this.dataSource = respList;
			} else {
				this.dataSource.addAll(respList);
			}
			if (this.dataSource.length == this.totalCount) {
				this.controller.finishLoad(success: true, noMore: true);
			} else {
				this.controller.finishLoad(success: true, noMore: false);
			}
			if (this.dataSource.length == 0) {
				type = EmptyWidgetType.NoData;
			} else {
				type = EmptyWidgetType.None;
			}
			this.reqFail = false;
			this.currentPage++;
			this.setState(() {});
		} else {
			// 请求失败
			this.reqFail = true;
			this.controller.finishLoad(success: false);
			if (this.dataSource == null || this.dataSource.length == 0) {
				this.setState(() {
					type = EmptyWidgetType.NetError;
				});
			} else {
				this.setState(() {
					type = EmptyWidgetType.None;
				});
			}
		}
	}
	
	// 获取医生活跃度
	_getDoctorActive(int period) {
		MineRequest.getDoctorActiveRequest(period).then((response) {
			if (response != null) {
				setState(() {
					this.activeData = response;
					this.reqFail = false;
				});
			} else {
				this.reqFail = true;
			}
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'活跃度',
				rightBarBtnAction: () {
					showDialog(
						context: context,
						builder: (context) {
							return CupertinoAlertDialog(
								content: Padding(
									padding: EdgeInsets.only(top: 5),
									child: Text(
										'2次有效问诊或1次处方发送数视为该医生活跃，每个考核周期为某月1号至次月15号',
										style: TextStyle(fontSize: 16, color: Color(0xff3b4243), height: 1.3),
										textAlign: TextAlign.left
									)
								),
								actions: <Widget>[
									CupertinoButton(
										onPressed: () {
											Navigator.pop(context);
										},
										child: Text('知道了', style: TextStyle(fontSize: 16, color: Color(0xff6bcbd6))),
										pressedOpacity: 0.9
									)
								],
							);
						}
					);
				},
				rightBarBtn: Container(
					height: 44,
					alignment: Alignment.centerRight,
					padding: EdgeInsets.only(left: 15),
					child: Image.asset(
						'lib/Images/icon_system_help.png',
						width: 18, height: 18
					),
				),
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
									if (this.selectIndex == 2 || this.reqFail) {
										this.selectIndex = 1;
										this.currentPage = 1;
										this.type = EmptyWidgetType.Loading;
										_initData();
										_getDoctorActive(1);
										setState(() {});
									}
								},
								child: Container(
									width: 56, height: 26,
									alignment: Alignment.center,
									decoration: BoxDecoration(
										color: this.selectIndex == 1 ? Color(0xff6bcbd6) : Color(0xfff0f2f5),
										borderRadius: BorderRadius.circular(4)
									),
									child: Text(
										'本期',
										style: TextStyle(
											fontSize: 14,
											color: this.selectIndex == 1 ? Colors.white : Color(0xff909399)
										)
									)
								)
							),
							Padding(padding: EdgeInsets.only(right: 10)),
							GestureDetector(
								onTap: () {
									// 上期
									if (this.selectIndex == 1 || this.reqFail) {
										this.selectIndex = 2;
										this.currentPage = 1;
										this.type = EmptyWidgetType.Loading;
										_initData();
										_getDoctorActive(2);
										setState(() {});
									}
								},
								child: Container(
									width: 56, height: 26,
									alignment: Alignment.center,
									decoration: BoxDecoration(
										color:  this.selectIndex == 2 ? Color(0xff6bcbd6) : Color(0xfff0f2f5),
										borderRadius: BorderRadius.circular(4)
									),
									child: Text(
										'上期',
										style: TextStyle(
											fontSize: 14,
											color: this.selectIndex == 2 ? Colors.white : Color(0xff909399)
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
		if (this?.activeData?.activePer != null) {
			double deviceW = MediaQuery.of(context).size.width;
			marginLeft = (deviceW - 66) * (this.activeData.activePer / 100) + 9;
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
							this?.activeData?.activePer != null ?
							'${this.activeData.activePer}%' : '0.0%',
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
		if (this?.activeData?.activeBase != null) {
			double deviceW = MediaQuery.of(context).size.width;
			marginLeft = (deviceW - 48) * (this.activeData.activeBase / 100);
			if (marginLeft < 0) {
				marginLeft = 0;
			} else if (marginLeft > deviceW - 48) {
				marginLeft = deviceW - 48;
			}
			
			colorWidth = (deviceW - 66) * (this.activeData.activePer / 100) + 5;
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
							color: this?.activeData?.activePer != null && this.activeData.activePer > 0 ?
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
								color: this?.activeData?.activePer != null &&
									this?.activeData?.activeBase != null &&
									this.activeData.activePer >= this.activeData.activeBase ?
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
								color: this?.activeData?.activePer == 100 ? Color(0xffffab29) : Color(0xffe6e6e6)
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
		if (this?.activeData?.activeBase != null) {
			double deviceW = MediaQuery.of(context).size.width;
			marginLeft = (deviceW - 48) * (this.activeData.activeBase / 100) - 34;
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
							this?.activeData?.activeBase == null ? '' :
							'达标 ${this.activeData.activeBase}%',
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
					'未活跃医生（${this?.totalCount ?? ''}）',
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
				this.currentPage = 1;
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
			type: this.type,
			emptyImagePath: 'lib/Images/default_pic_doctor.png',
			emptyTitle: '暂无未活跃医生'
		);
	}
	
	_itemBuilder(DoctorInfoOfHospitalModel model) {
		return GestureDetector(
			child: Container(
				height: 80,
				alignment: Alignment.center,
				padding: EdgeInsets.symmetric(horizontal: 15),
				child: Row(
					children: <Widget>[
						ClipRRect(
							child: CachedNetworkImage(
								imageUrl: model?.headImgShowPath ?? '',
								placeholder: (context, url) => Image.asset(
									'lib/Images/img_default_medicine.png',
									width: 48,
									height: 48,
									fit: BoxFit.cover
								),
								width: 48,
								height: 48,
								fit: BoxFit.cover,
								fadeInDuration: Duration(milliseconds: 50),
								fadeOutDuration: Duration(milliseconds: 50)
							),
							borderRadius: BorderRadius.circular(24)
						),
						Padding(padding: EdgeInsets.only(right: 10)),
						Expanded(child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								Text(
									model?.realName ?? '',
									style: TextStyle(fontSize: 18, color: Color(0xff0a1314), fontWeight: FontWeight.w500),
									maxLines: 1,
									overflow: TextOverflow.ellipsis
								),
								Padding(padding: EdgeInsets.only(top: 2)),
								Text(
									'${model?.departmentName ?? ''}${model?.departmentName != null && model.departmentName.length != 0 ? '  ' : ''}${model?.doctorTitle ?? ''}',
									style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d)),
									maxLines: 1,
									overflow: TextOverflow.ellipsis
								)
							]
						)),
						Padding(padding: EdgeInsets.only(right: 10)),
						Image.asset('lib/Images/btn_arrow.png', width: 15, height: 15)
					],
				),
				decoration: BoxDecoration(
					color: Colors.white,
					border: Border(bottom: BorderSide(
						width: 1,
						color: Color(0xffe5e5e5)
					))
				),
			),
			
			onTap: () {
				Navigator.of(context).push(MaterialPageRoute(
					builder: (_) => DoctorStatisticPage(model)
				));
			}
		);
	}
}