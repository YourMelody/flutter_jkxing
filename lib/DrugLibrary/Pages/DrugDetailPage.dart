import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import '../Model/MedicineItemModel.dart';
import '../Network/DrugLibRequest.dart';

class DrugDetailPage extends StatefulWidget {
	DrugDetailPage(this.drugModel);
	final MedicineItemModel drugModel;
	@override
	_DrugDetailState createState() => _DrugDetailState();
}

class _DrugDetailState extends State<DrugDetailPage> {
	int lastCount;    //库存
	TapGestureRecognizer _tapGestureRecognizer;
	String introduction = '';   //药品介绍
	String imgStr = '';         //药品图片
	@override
	void initState() {
		super.initState();
		_tapGestureRecognizer = TapGestureRecognizer()
			..onTap = () {
				// 请求刷新库存
				getDrugLastCount(null);
			};
		
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_getDrugDetailInfo();
		});
	}
	
	// 获取药品详细信息
	_getDrugDetailInfo() {
		DrugLibRequest.getMedicineDetail(widget.drugModel.productCode).then((response) {
			getDrugLastCount(response);
		}).catchError((e) {
		
		});
	}
	
	// 获取药品库存
	getDrugLastCount(Map detailInfo) {
		DrugLibRequest.getMedicineLastCount(widget.drugModel.productCode).then((response) {
			int count = response[widget.drugModel.productCode.toString()];
			if (detailInfo != null) {
				setState(() {
					lastCount = count;
					introduction = detailInfo['product']['introduction'];
					imgStr = 'https://img.jianke.com' + detailInfo['product']['productImageUrl'];
				});
			} else {
				setState(() {
					lastCount = count;
				});
			}
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
			body: Column(children: <Widget>[
				// 头部药品信息
				_drugDetailHeader(widget.drugModel),
				// 分割线
				Container(height: 10, color: Colors.grey[100])
			])
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
						Center(child: FadeInImage.assetNetwork(
							placeholder: 'lib/Images/img_default_medicine.png',
							image: imgStr,
							height: 170,
							fit: BoxFit.fitHeight,
							fadeOutDuration: Duration(milliseconds: 50),
							fadeInDuration: Duration(milliseconds: 50)
						)),
						Padding(padding: EdgeInsets.only(top: 12)),
						
						// 药品名字
						Row(children: <Widget>[
							Image.asset('lib/Images/rx_flag.png', width: 32, height: 16),
							Padding(padding: EdgeInsets.only(right: 5)),
							Text(model.productName,
								style: TextStyle(fontSize: 17, color: Color(0xff444444))
							)
						]),
						Padding(padding: EdgeInsets.only(top: 5)),
						
						// 规格
						Text('规格：${model.packing}',
							style: TextStyle(fontSize: 13, color: Color(0xff999999)),
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
											text: lastCount <= 99 ? lastCount.toString() : '99+',
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
						
						// 价格
						Text(
							'¥${(model.ourPrice/100.0).toStringAsFixed(2)}',
							style: TextStyle(fontSize: 20, color: Color(0xffe56767), fontWeight: FontWeight.w600),
						),
						Padding(padding: EdgeInsets.only(top: 10)),
						
						// 描述
						Text(
							introduction,
							maxLines: 10,
							style: TextStyle(fontSize: 13, color: Color(0xff444444))
						)
					]
				),
			),
			
			// 热度标签
			Positioned(left: -1, top: 5, child: Container(
				padding: EdgeInsets.only(right: 5), height: 17,
				child: Center(child: Text('药品热度：20', style: TextStyle(fontSize: 14, color: Color(0xffff781e), height: 0.84))),
				decoration: BoxDecoration(
					border: Border.all(color: Color(0xffff781e)),
					borderRadius: BorderRadius.only(
						topRight: Radius.circular(10),
						bottomRight: Radius.circular(10)
					)
				),
			)),
		]);
	}
	
	@override
	void dispose() {
		_tapGestureRecognizer.dispose();
		super.dispose();
	}
}