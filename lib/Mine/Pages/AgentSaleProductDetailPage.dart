import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/DrugLibrary/Pages/DrugDetailPage.dart';
import 'package:flutter_jkxing/Mine/Network/MineRequest.dart';
import 'package:flutter_jkxing/Order/Network/DrugConfigRequest.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';
import 'package:flutter_jkxing/DrugLibrary/Model/MedicineItemModel.dart';

class AgentSaleProductDetailPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _AgentSaleProductDetailState();
	}
}

class _AgentSaleProductDetailState extends State<AgentSaleProductDetailPage> {
	int timeStamp;
	String timeStr;
	int sortField = 2;
	bool sortDown = true;
	int currentPage = 1;
	DrugConfigModel configModel;
	List <MedicineItemModel> dataSource = [];
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	
	@override
	void initState() {
		super.initState();
		DateTime nowTime = DateTime.now();
		DateTime monthTime = DateTime.parse('${nowTime.year}-${_addZero(nowTime.month)}-01 00:00:00');
		timeStamp = monthTime.millisecondsSinceEpoch;
		timeStr = '${nowTime.year}年${nowTime.month}月';
		PPSession session = PPSession.getInstance();
		if (session.userModel.agentType == 1 && session.configModel != null) {
			this.configModel = session.configModel;
		}
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
			_getDrugConfig();
		});
	}
	
	// 获取药品配置信息，药品热度/标签显示需要用到
	void _getDrugConfig() {
		if (this.configModel == null) {
			DrugConfigRequest.drugConfigReq().then((response) {
				if (response != null) {
					PPSession.getInstance().configModel = response;
					setState(() {
						this.configModel = response;
					});
				}
			});
		}
	}
	
	Future<void> _initData() async {
		var response = await MineRequest.getAgentSaleProDetail(
			this.timeStamp,
			this.sortField,
			this.sortField == 1 ? 2 : (this.sortDown ? 2 : 1),
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
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'药品明细',
				context: context
			),
			body: Column(children: <Widget>[
				// 时间选择header
				_createTimeHeader(),
				
				// 销量/净毛利率
				_createSortTypeHeader(),
				
				Expanded(child: _createContentList())
			], crossAxisAlignment: CrossAxisAlignment.start),
			backgroundColor: Color(0xfff4f6f9)
		);
	}
	
	// 时间选择header
	Widget _createTimeHeader() {
		return GestureDetector(
			onTap: () {
				Picker(
					adapter: DateTimePickerAdapter(
						type: 11,
						isNumberMonth: true,
						yearBegin: 2000,
						yearEnd: DateTime.now().year,
						yearSuffix: '年',
						monthSuffix: '月',
						value: DateTime.fromMillisecondsSinceEpoch(this.timeStamp),
						maxValue: DateTime.now()
					),
					title: Text('选择日期'),
					textAlign: TextAlign.right,
					selectedTextStyle: TextStyle(color: Color(0xff6bcbd6)),
					cancelText: '取消',
					cancelTextStyle: TextStyle(fontSize: 16, color: Color(0xff999999)),
					confirmText: '确定',
					confirmTextStyle: TextStyle(fontSize: 16, color: Color(0xff6bcbd6)),
					onSelect: (Picker picker, int index, List<int> selected) {
						setState(() {});
					},
					onConfirm: (Picker picker, List<int> selected) {
						DateTime tempTime = (picker.adapter as DateTimePickerAdapter).value;
						this.currentPage = 1;
						this.setState(() {
							this.timeStamp = tempTime.millisecondsSinceEpoch;
							this.timeStr = '${tempTime.year}年${tempTime.month}月';
						});
						_initData();
					}
				).showModal(context);
			},
			child: Container(
				height: 44,
				padding: EdgeInsets.only(left: 15),
				alignment: Alignment.centerLeft,
				child: Row(children: <Widget>[
					Text(
						this.timeStr ?? '',
						style: TextStyle(fontSize: 16, color: Color(0xff3b4243))
					),
					Padding(padding: EdgeInsets.only(left: 1)),
					Image.asset(
						'lib/Images/time_down_icon.png',
						width: 10, height: 10
					)
				])
			)
		);
	}
	
	// 销量/净毛利率
	Widget _createSortTypeHeader() {
		return Container(
			decoration: BoxDecoration(
				color: Colors.white,
				border: Border(bottom: BorderSide(
					width: 0.5,
					color: Color(0xffe5e5e5)
				))
			),
			height: 44,
			child: Row(children: <Widget>[
				Expanded(child: GestureDetector(
					onTap: () {
						if (this.sortField == 2) {
							this.currentPage = 1;
							this.setState(() {
								this.sortField = 1;
							});
						}
						_initData();
					},
					child: Center(child: Text(
						'销量',
						style: TextStyle(
							fontSize: 16,
							color: this.sortField == 1 ? Color(0xff6bcbd6) : Color(0xff3b4243)
						)
					))
				)),
				
				Expanded(child: GestureDetector(
					onTap: () {
						this.currentPage = 1;
						if (this.sortField == 1) {
							this.setState(() {
								this.sortField = 2;
							});
						} else {
							this.setState(() {
								this.sortDown = !this.sortDown;
							});
						}
						_initData();
					},
					child: Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							Text(
								'净毛利率',
								style: TextStyle(
									fontSize: 16,
									color: this.sortField == 2 ? Color(0xff6bcbd6) : Color(0xff3b4243)
								)
							),
							Padding(padding: EdgeInsets.only(right: 5)),
							Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									Image.asset(
										this.sortDown ? 'lib/Images/up_deep_icon.png' : 'lib/Images/up_slight_icon.png',
										width: 9, height: 7
									),
									
									Image.asset(
										this.sortDown ? 'lib/Images/down_light_icon.png' : 'lib/Images/down_deep_icon.png',
										width: 9, height: 7
									)
								]
							)
						]
					)
				))
			])
		);
	}
	
	Widget _createContentList() {
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
			showRefreshHeader: true,
			onRefresh: () {
				this.currentPage = 1;
				return _initData();
			},
			onLoad: () {
				return _initData();
			},
			type: this.type
		);
	}
	
	_itemBuilder(MedicineItemModel model) {
		// 热度标签
		String hotImgStr = '';
		if (this.configModel != null && this.configModel?.firstBit == '1' && this.configModel?.thirdBit == '1') {
			if (this.configModel?.rateArr?.length != null && this.configModel.rateArr.length > 0) {
				double ratio = 0.0;
				if (model?.ourPrice != null && model.ourPrice > 0 && model?.priceCommission != null) {
					ratio = (model.priceCommission / model.ourPrice) * 100.0;
				}
				if (this.configModel.rateArr.last <= ratio) {
					for(int i = 0; i < this.configModel.rateArr.length; i++) {
						double tmpRate = this.configModel.rateArr[i];
						if (tmpRate <= ratio) {
							hotImgStr = this.configModel?.hotSpecialItems[i]?.rateIconUrl ?? '';
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
									child: Container(
										padding: EdgeInsets.all(5),
										child: FadeInImage.assetNetwork(
											placeholder: 'lib/Images/img_default_medicine.png',
											image: model.productImageUrl ?? '',
											width: 70, height: 70,
											fadeOutDuration: Duration(milliseconds: 20),
											fadeInDuration: Duration(milliseconds: 20)
										),
									)
								),
								Positioned(
									// Rx标签：prescriptionType为4（处方药）或5（管制处方药）时才展示
									child: Offstage(
										offstage: model?.prescriptionType != 4 && model?.prescriptionType != 5,
										child: Image.asset('lib/Images/rx_label_flag.png', width: 28, height: 28)
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
										Expanded(child: Text(
											model?.productName ?? '',
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
											style: TextStyle(color: Color(0xff3b4243), fontSize: 16, fontWeight: FontWeight.w500)
										)),
										Padding(padding: EdgeInsets.only(right: 5)),
										Text(
											model?.salesVolume != null && model.salesVolume > 0 ?
												'X${model.salesVolume}' : '',
											style: TextStyle(color: Color(0xff3b4243), fontSize: 16)
										)
									]
								),
								
								Padding(padding: EdgeInsets.only(top: 4)),
								
								// 厂商
								Text(
									model?.manufacturer ?? '',
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: TextStyle(fontSize: 12,color: Color(0xff9da1a1))
								),
								
								Padding(padding: EdgeInsets.only(top: 3)),
								
								// 规格
								Text(
									model?.packing ?? '',
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: TextStyle(fontSize: 12,color: Color(0xff9da1a1))
								),
								
								Padding(padding: EdgeInsets.only(top: 4)),
								
								// 价格和热度标签
								Row(
									children: <Widget>[
										Text(
											'¥${((model?.ourPrice ?? 0)/100.0).toStringAsFixed(2)}',
											style: TextStyle(fontSize: 18, color: Color(0xffe56767), fontWeight: FontWeight.bold),
											maxLines: 1,
											overflow: TextOverflow.ellipsis
										),
										Padding(padding: EdgeInsets.only(right: 8)),
										Offstage(
											offstage: PPSession.getInstance()?.userModel?.agentType != 1 || this?.configModel?.firstBit != '1',
											child:  this?.configModel?.thirdBit == '1' && hotImgStr.length > 0 ?
											Image.network(
												hotImgStr,
												height: 19,
												fit: BoxFit.fitHeight,
											) : this?.configModel?.secondBit == '1' ?
											Text(
												'(药品热度：${(model?.priceCommission ?? 0) / 100})',
												style: TextStyle(fontSize: 15, color: Color(0xff999999)),
												maxLines: 1,
												overflow: TextOverflow.ellipsis
											) : Container()
										),
										Padding(padding: EdgeInsets.only(right: 4)),
										Offstage(
											offstage: model?.grossProfitMarginFlag != 1 && model?.grossProfitMarginFlag != -1,
											child: model?.grossProfitMarginFlag == 1 ? Image.asset('lib/Images/positive_icon.png', width: 18, height: 19) :
												model?.grossProfitMarginFlag == -1 ? Image.asset('lib/Images/negative_icon.png', width: 18, height: 19) : Container()
													
										),
										Expanded(child: Container()),
										GestureDetector(
											onTap: () {
											
											},
											child: Container(
												decoration: BoxDecoration(
													borderRadius: BorderRadius.circular(12),
													border: Border.all(
														color: Color(0xff6bcbd6),
														width: 1
													)
												),
												alignment: Alignment.center,
												width: 64,
												height: 24,
												child: Text(
													'药品分布',
													style: TextStyle(fontSize: 12, color: Color(0xff6bcbd6))
												),
											)
										)
									],
									crossAxisAlignment: CrossAxisAlignment.end
								)
							]
						))
					]
				),
				color: Colors.white
			),
			
			onTap: () {
				Navigator.of(context).push(MaterialPageRoute(
					builder: (_) => DrugDetailPage(model, this.configModel)
				));
			}
		);
	}
	
	String _addZero(int value) {
		if (value < 10) {
			return '0' + value.toString();
		}
		return value.toString();
	}
}