import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';
import '../Model/MedicineItemModel.dart';
import '../Model/DrugClassModel.dart';
import '../Network/DrugLibRequest.dart';
import 'DrugDetailPage.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class DrugListPage extends StatefulWidget {
	DrugListPage(this.drugClassModel, this.configModel);
	final DrugClassModel drugClassModel;
	final DrugConfigModel configModel;
	@override
	_DrugListState createState() => _DrugListState();
}

class _DrugListState extends State<DrugListPage> {
	List <MedicineItemModel> dataSource = [];
	int currentPage = 1;
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	Future<void> _initData() async {
		if (widget.drugClassModel == null) {
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
		} else {
			// 其他根据categoryCode获取药品列表（分页）
			var response = await DrugLibRequest.getMedicineList(
				widget.drugClassModel.categoryCode,
				widget.drugClassModel.hasNode,
				this.currentPage,
				context
			);
			if (response != null) {
				// 请求成功
				if (this.currentPage == 1) {
					this.dataSource = response;
				} else {
					this.dataSource.addAll(response);
				}
				
				// 处理刷新尾状态
				List respArr = response;
				if (respArr.length < 10) {
					controller.finishLoad(noMore: true);
				} else {
					controller.finishLoad(success: true);
				}
				
				if (this.dataSource.length == 0) {
					type = EmptyWidgetType.NoData;
				} else {
					type = EmptyWidgetType.None;
				}
				
				this.setState(() {});
				this.currentPage++;
			} else {
				// 请求失败
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
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				widget.drugClassModel == null ? '名医推荐' : widget.drugClassModel.categoryName,
				context: context
			),
			body: Column(
				children: <Widget>[
					_searchView(),
					Expanded(
						child: RefreshListView(
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
							showRefreshHeader: false,
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
							type: this.type
						)
					)
				]
			)
		);
	}
	
	// 搜索框
	_searchView() {
		return GestureDetector(
			child: Container(
				margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
				height: 30,
				decoration: BoxDecoration(
					borderRadius: BorderRadius.all(Radius.circular(18.0)),
					color: Color(0xfff5f5f5)
				),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[
						Padding(padding: EdgeInsets.only(left: 10)),
						Icon(
							Icons.search,
							color: Colors.grey,
							size: 18,
						),
						Padding(padding: EdgeInsets.only(left: 5)),
						Text(
							'搜索药品',
							style: TextStyle(color: Colors.grey, fontSize: 14),
						)
					],
				),
			),
			onTap: () {
				print('tap search view');
			}
		);
	}
	
	_itemBuilder(MedicineItemModel model) {
		// 热度标签
		String hotImgStr = '';
		if (widget.configModel != null && widget.configModel?.firstBit == '1' && widget.configModel?.thirdBit == '1') {
			if (widget.configModel?.rateArr?.length != null && widget.configModel.rateArr.length > 0) {
				double ratio = 0.0;
				if (model?.ourPrice != null && model.ourPrice > 0 && model?.priceCommission != null) {
					ratio = (model.priceCommission / model.ourPrice) * 100.0;
				}
				if (widget.configModel.rateArr.last <= ratio) {
					for(int i = 0; i < widget.configModel.rateArr.length; i++) {
						double tmpRate = widget.configModel.rateArr[i];
						if (tmpRate <= ratio) {
							hotImgStr = widget.configModel?.hotSpecialItems[i]?.rateIconUrl ?? '';
							break;
						}
					}
				}
			}
		}
		
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
										width: 64, height: 64,
										fadeOutDuration: Duration(milliseconds: 50),
										fadeInDuration: Duration(milliseconds: 50)
									)
								),
								Positioned(
									// Rx标签：prescriptionType为4（处方药）或5（管制处方药）时才展示
									child: Offstage(
										offstage: model?.prescriptionType != 4 && model?.prescriptionType != 5,
										child: Image.asset('lib/Images/rx_label_flag.png', width: 25, height: 25),
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
											offstage: model?.productStatusType != 4,
											child: Container(
												width: 29,
												height: 13,
												margin: EdgeInsets.only(right: 5),
												alignment: Alignment.center,
												child: Text('缺货', style: TextStyle(color: Colors.white, fontSize: 9)),
												decoration: BoxDecoration(
													borderRadius: BorderRadius.circular(6.5),
													color: Color(0xffcccccc)
												),
											),
										),
										Text(
											model?.productName ?? '',
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
											style: TextStyle(color: Color(0xff1a191a), fontSize: 14)
										)
									]
								),
								
								Padding(padding: EdgeInsets.only(top: 5)),
								
								// 厂商
								Text(
									model?.manufacturer ?? '',
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: TextStyle(fontSize: 12,color: Color(0xff999999))
								),
								
								Padding(padding: EdgeInsets.only(top: 3)),
								
								// 规格
								Text(
									model?.packing ?? '',
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: TextStyle(fontSize: 12,color: Color(0xff999999))
								),
								
								Padding(padding: EdgeInsets.only(top: 3)),
								
								// 价格和热度标签
								Row(
									children: <Widget>[
										Text(
											'¥${((model?.ourPrice ?? 0)/100.0).toStringAsFixed(2)}',
											style: TextStyle(fontSize: 15, color: Color(0xffe56767), fontWeight: FontWeight.bold)
										),
										Offstage(
											offstage: PPSession.getInstance()?.userModel?.agentType != 1 || widget?.configModel?.firstBit != '1',
											child:  widget?.configModel?.thirdBit == '1' && hotImgStr.length > 0 ?
												Container(
													width: 46,
													height: 15,
													padding: EdgeInsets.only(left: 8),
													child: Image.network(hotImgStr, fit: BoxFit.contain)
												) : widget?.configModel?.secondBit == '1' ?
												Container(
													padding: EdgeInsets.only(left: 8),
													child: Text(
														'(药品热度：${(model?.priceCommission ?? 0) / 100})',
														style: TextStyle(fontSize: 12, color: Color(0xff999999))
													),
												) : Container()
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
				Navigator.of(context).push(MaterialPageRoute(
					builder: (_) => DrugDetailPage(model, widget.configModel)
				));
			}
		);
	}
}