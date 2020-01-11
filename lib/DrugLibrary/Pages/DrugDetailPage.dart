import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Common/ZFBaseUrl.dart';
import 'package:flutter_jkxing/Common/ZFProgressHUDView.dart';
import 'package:flutter_jkxing/DrugLibrary/Model/MedicineItemModel.dart';
import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import 'package:flutter_jkxing/Utils/ProgressUtil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Model/MedicineItemModel.dart';
import '../Network/DrugLibRequest.dart';

// 药品库->药品列表->药品详情
// 我的->药品明细->药品详情
class DrugDetailPage extends StatefulWidget {
	DrugDetailPage(this.drugModel, this.configModel);
	final MedicineItemModel drugModel;
	final DrugConfigModel configModel;
	@override
	_DrugDetailState createState() => _DrugDetailState();
}

class _DrugDetailState extends State<DrugDetailPage> {
	int lastCount;    //库存
	TapGestureRecognizer _tapGestureRecognizer;
	String introduction = '';   //药品介绍
	MedicineItemModel model;
	
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	WebViewController _controller;
	double webHeight = 500.0;
	
	@override
	void initState() {
		super.initState();
		_tapGestureRecognizer = TapGestureRecognizer()
			..onTap = () {
				// 请求刷新库存
				_getDrugLastCount(ToastType.ToastTypeNormal);
			};
		
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_getDrugDetailInfo();
		});
	}
	
	// 获取药品详细信息
	Future<void> _getDrugDetailInfo() async {
		var response = await DrugLibRequest.getMedicineDetail(widget.drugModel.productCode);
		if (response != null) {
			int respCode = response['msg']['code'];
			if (respCode == 0) {
				// 请求成功
				Map respMap = response['data']['product'];
				MedicineItemModel respModel = MedicineItemModel.fromJson(respMap);
				respModel.priceCommission = widget.drugModel.priceCommission;
				respModel.ourPrice = widget.drugModel.ourPrice;
				this.setState(() {
					model = respModel;
					introduction = respMap['introduction'];
					type = EmptyWidgetType.None;
				});
				
				_getDrugLastCount(ToastType.ToastTypeError);
			} else {
				// 请求失败
				String respInfo = response['msg']['info'];
				ProgressUtil().showWithType(context, ProgressType.ProgressType_Error, title: respInfo);
				this.setState(() {
					type = EmptyWidgetType.NetError;
				});
			}
		}
	}
	
	// 获取药品库存
	_getDrugLastCount(ToastType showToast) {
		DrugLibRequest.getMedicineLastCount(widget.drugModel.productCode, context, showToast).then((response) {
			int count = response[widget.drugModel.productCode.toString()];
			setState(() {
				lastCount = count;
			});
		}).catchError((e) {
			setState(() {
				lastCount = -1;
			});
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar('药品详情', context: context),
			body: RefreshListView(
				controller: this.controller,
				child: Column(
					children: <Widget>[
						// 头部药品信息
						_drugDetailHeader(this.model),
						// 分割线
						Container(height: 10, color: Colors.grey[100]),
						// 说明书
						Container(
							width: MediaQuery.of(context).size.width,
							height: this.webHeight,
							margin: EdgeInsets.only(top: 10),
							child: WebView(
								initialUrl: this.model?.productCode == null ? '' :
								'${ZFBaseUrl().InstructionsUrl()}/product/instructionBook/${this.model.productCode}',
								javascriptMode: JavascriptMode.unrestricted,
								
								// web创建完成调用
								onWebViewCreated: (controller) {
									_controller = controller;
								},
								// web加载结束调用
								onPageFinished: (url) {
									_controller.evaluateJavascript("document.body.scrollHeight").then((result){
										setState(() {
											webHeight = double.parse(result) + 55;
										});
									});
								},
							)
						)
					]
				),
				onRefresh: () {
					if (type == EmptyWidgetType.NetError) {
						setState(() {
							type = EmptyWidgetType.Loading;
						});
						return _getDrugDetailInfo();
					} else {
						return null;
					}
				},
				type: this.type,
				showRefreshHeader: false
			),
			backgroundColor: Colors.white
		);
	}
	
	_drugDetailHeader(MedicineItemModel model) {
		return Stack(children: <Widget>[
			Padding(
				padding: EdgeInsets.all(15),
				child: Column(crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[
						Padding(padding: EdgeInsets.only(top: 13)),
						// 图片
						Center(child: CachedNetworkImage(
							imageUrl: model?.productImageUrl ?? '',
							placeholder: (context, url) => Image.asset(
								'lib/Images/img_default_medicine.png',
								height: 170,
								fit: BoxFit.fitHeight
							),
							height: 170,
							fit: BoxFit.fitHeight,
							fadeInDuration: Duration(milliseconds: 50),
							fadeOutDuration: Duration(milliseconds: 50)
						)),
						Padding(padding: EdgeInsets.only(top: 12)),
						
						// 药品名字
						Row(children: <Widget>[
							Offstage(
								offstage: model?.prescriptionType != 4 && model?.prescriptionType != 5,
								child: Container(
									margin: EdgeInsets.only(right: 5),
									child: Image.asset('lib/Images/rx_flag.png', width: 32, height: 16),
								)
							),
							Expanded(child: Text(
								model?.productName ?? '',
								style: TextStyle(fontSize: 17, color: Color(0xff444444)),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							))
						]),
						Padding(padding: EdgeInsets.only(top: 5)),
						
						// 规格
						Text(
							'规格：${model?.packing ?? ''}',
							style: TextStyle(fontSize: 13, color: Color(0xff999999)),
							maxLines: 1,
							overflow: TextOverflow.ellipsis
						),
						Padding(padding: EdgeInsets.only(top: 5)),
						
						// 库存
						RichText(text: TextSpan(
							text: '库存：',
							style: TextStyle(fontSize: 13, color: Color(0xff999999)),
							children: <TextSpan>[
								lastCount == null ? TextSpan(text: '加载中...') :
								lastCount == 0 ? TextSpan(text: '采购中，可预订') :
								lastCount > 0 ?
								TextSpan(
									text: '剩余',
									children: <TextSpan>[
										TextSpan(
											text: lastCount <= 299 ? lastCount.toString() : '299+',
											style: TextStyle(color: Color(0xffff781e))
										),
										TextSpan(text: '件')
									]
								) :
								TextSpan(
									text: '库存获取失败，请点击刷新',
									style: TextStyle(color: Color(0xff5aa5ff)),
									recognizer: _tapGestureRecognizer
								)
							]
						)),
						Padding(padding: EdgeInsets.only(top: 5)),
						
						// 药品ID
						Text(
							'药品ID：${model?.productCode ?? ''}',
							style: TextStyle(fontSize: 13, color: Color(0xff999999)),
							maxLines: 1,
							overflow: TextOverflow.ellipsis
						),
						Padding(padding: EdgeInsets.only(top: 5)),
						
						// 价格
						Text(
							'¥${((model?.ourPrice ?? 0)/100.0).toStringAsFixed(2)}',
							style: TextStyle(fontSize: 20, color: Color(0xffe56767), fontWeight: FontWeight.w600)
						),
						Padding(padding: EdgeInsets.only(top: 10)),
						
						// 描述
						Text(
							introduction ?? '',
							maxLines: 10,
							style: TextStyle(fontSize: 13, color: Color(0xff444444))
						)
					]
				)
			),
			
			// 热度标签
			_createHotLabel(model)
		]);
	}
	
	// 热度标签
	Widget _createHotLabel(MedicineItemModel model) {
		if (PPSession.getInstance()?.userModel?.agentType != 1 || widget?.configModel?.firstBit != '1') {
			return Container();
		} else if (widget?.configModel?.thirdBit == '1') {
			return Positioned(
				left: 6, top: 11,
				child: Container(
					width: 57,
					height: 56,
					padding: EdgeInsets.only(left: 8),
					child: Image.network(
						PPSession.getInstance().getHotImgStr(model.ourPrice, model.priceCommission),
						fit: BoxFit.contain
					)
				)
			);
		} else if (widget?.configModel?.secondBit == '1') {
			return Positioned(
				left: -1, top: 5,
				child: Container(
					padding: EdgeInsets.only(right: 5, left: 1),
					child: Text(
						'药品热度：${(model?.priceCommission ?? 0) / 100}',
						style: TextStyle(fontSize: 14, color: Color(0xffff781e))
					),
					decoration: BoxDecoration(
						border: Border.all(color: Color(0xffff781e)),
						borderRadius: BorderRadius.only(
							topRight: Radius.circular(10),
							bottomRight: Radius.circular(10)
						)
					)
				)
			);
		} else {
			return Container();
		}
	}
	
	@override
	void dispose() {
		_tapGestureRecognizer.dispose();
		super.dispose();
	}
}