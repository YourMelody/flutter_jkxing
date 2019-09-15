import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import '../Model/MedicineItemModel.dart';
import '../Model/DrugClassModel.dart';
import '../Network/DrugLibRequest.dart';
import 'DrugDetailPage.dart';

class DrugListPage extends StatefulWidget {
	DrugListPage(this.drugClassModel);
	final DrugClassModel drugClassModel;
	@override
	_DrugListState createState() => _DrugListState();
}

class _DrugListState extends State<DrugListPage> with AutomaticKeepAliveClientMixin {
	List <MedicineItemModel> dataSource = [];
	
	@override
	void initState() {
		super.initState();
		_initData();
	}
	
	_initData() {
		if (widget.drugClassModel == null) {
			// 名医推荐药品列表
			DrugLibRequest.getRecommendMedicineList().then((response) {
				setState(() {
					dataSource = response;
				});
			});
		} else {
			DrugLibRequest.getMedicineList(widget.drugClassModel.categoryCode, widget.drugClassModel.hasNode, 1).then((response) {
				setState(() {
					dataSource = response;
				});
			});
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
						child: ListView.separated(
							itemBuilder: (context, index) {
								return _itemBuilder(dataSource[index]);
							},
							separatorBuilder: (BuildContext context, int index) {
								return Divider(color: Color(0xffe5e5e5), height: 0.5);
							},
							itemCount: dataSource == null ? 0 : dataSource.length
						),
					)
				],
			),
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
		return GestureDetector(
			child: Container(
				padding: EdgeInsets.all(15.0),
				child: Row(
					children: <Widget>[
						Stack(
							children: <Widget>[
								Positioned(
									child: FadeInImage.assetNetwork(
										placeholder: 'lib/Images/img_default_medicine.png',
										image: model.productImageUrl == null ? '' : 'https://img.jianke.com${model.productImageUrl}',
										width: 64, height: 64,
										fadeOutDuration: Duration(milliseconds: 50),
										fadeInDuration: Duration(milliseconds: 50)
									)
								),
								Positioned(
									child: Image.asset('lib/Images/rx_label_flag.png', width: 25, height: 25)
								)
							],
						),
						
						Padding(padding: EdgeInsets.only(left: 10)),
						
						Expanded(child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								Text(model.productName, style: TextStyle(color: Color(0xff1a191a))),
								Text(model.manufacturer, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,color: Color(0xff999999))),
								Text(model.packing, style: TextStyle(fontSize: 12,color: Color(0xff999999))),
								Text('¥${(model.ourPrice/100.0).toStringAsFixed(2)}', style: TextStyle(fontSize: 15, color: Color(0xffe56767), fontWeight: FontWeight.bold))
							],
						))
					],
				),
				color: Colors.white,
			),
			
			onTap: () {
				Navigator.of(context).push(MaterialPageRoute(
					builder: (_) => DrugDetailPage(model)
				));
			},
		);
	}
	
	@override
	bool get wantKeepAlive => true;
}