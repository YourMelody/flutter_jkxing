import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';
import '../Model/MedicineItemModel.dart';
import '../Model/DrugClassModel.dart';
import '../Network/DrugLibRequest.dart';
import 'DrugDetailPage.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class DrugListPage extends StatefulWidget {
	DrugListPage(this.drugClassModel);
	final DrugClassModel drugClassModel;
	@override
	_DrugListState createState() => _DrugListState();
}

class _DrugListState extends State<DrugListPage> {
	List <MedicineItemModel> dataSource = [];
	int currentPage = 1;
	EasyRefreshController controller = EasyRefreshController();
	
	Future<void> _initData() async {
		if (widget.drugClassModel == null) {
			// 名医推荐药品列表（不分页）
			var response = await DrugLibRequest.getRecommendMedicineList();
			if (response != null) {
				// 请求成功
				this.controller.finishLoad(noMore: true);
				this.dataSource = response;
				this.setState(() {});
			} else {
				// 请求失败
				this.controller.finishLoad(success: false);
			}
		} else {
			// 其他根据categoryCode获取药品列表（分页）
			var response = await DrugLibRequest.getMedicineList(
				widget.drugClassModel.categoryCode,
				widget.drugClassModel.hasNode,
				this.currentPage,
				context,
				this.dataSource.length == 0 ? ToastType.ToastTypeNone : ToastType.ToastTypeError
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
					// 展示空数据缺省页
					
				}
				
				this.setState(() {});
				this.currentPage++;
			} else {
				// 请求失败
				this.controller.finishLoad(success: false);
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
								return _initData();
							},
							onLoad: () {
								return _initData();
							}
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
										image: model.productImageUrl ?? '',
										width: 64, height: 64,
										fadeOutDuration: Duration(milliseconds: 50),
										fadeInDuration: Duration(milliseconds: 50)
									)
								),
								Positioned(
									child: Image.asset('lib/Images/rx_label_flag.png', width: 25, height: 25)
								)
							]
						),
						
						Padding(padding: EdgeInsets.only(left: 10)),
						
						Expanded(child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								Text(model?.productName ?? '', style: TextStyle(color: Color(0xff1a191a))),
								Text(model?.manufacturer ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,color: Color(0xff999999))),
								Text(model?.packing ?? '', style: TextStyle(fontSize: 12,color: Color(0xff999999))),
								Text('¥${((model?.ourPrice ?? 0)/100.0).toStringAsFixed(2)}', style: TextStyle(fontSize: 15, color: Color(0xffe56767), fontWeight: FontWeight.bold))
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
}