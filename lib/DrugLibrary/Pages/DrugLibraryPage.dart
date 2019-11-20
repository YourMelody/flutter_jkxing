import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/DrugConfiguration.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';
import 'package:flutter_jkxing/Order/Network/DrugConfigRequest.dart';
import '../Model/DrugClassModel.dart';
import '../Network/DrugLibRequest.dart';
import 'DrugListPage.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';

class DrugLibraryPage extends StatefulWidget {
	@override
	_DrugLibraryPageState createState() => _DrugLibraryPageState();
}

class _DrugLibraryPageState extends State<DrugLibraryPage> with AutomaticKeepAliveClientMixin {
	List<DrugClassModel> dataSource;
	int _curIndex = 0;
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	DrugConfigModel configModel;
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
			_getDrugConfig();
		});
	}
	
	@override
	Widget build(BuildContext context) {
		super.build(context);
		MediaQueryData queryData = MediaQuery.of(context);
		return Scaffold(
			appBar: ZFAppBar('药品库', showBackBtn: false),
			body: RefreshListView(
				controller: this.controller,
				child: Container(
					width: queryData.size.width,
					height: queryData.size.height - queryData.padding.top - queryData.padding.bottom - 130,
					child: Column(
						children: <Widget>[
							// 顶部搜索框
							_searchView(),
							
							Expanded(
								child: Container(
									child: Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: <Widget>[
											// 左侧主分类列表
											Container(
												width: 120,
												child: _leftList()
											),
											
											// 右侧主分类下细分类列表
											Expanded(child: Container(
												color: Color(0xfff4f6f9),
												padding: EdgeInsets.only(left: 8),
												child: _rightList()
											))
										]
									)
								)
							)
						]
					)
				),
				onRefresh: () {
					if (type == EmptyWidgetType.NetError) {
						setState(() {
							type = EmptyWidgetType.Loading;
						});
						return _initData();
					} else {
						return null;
					}
				},
				type: this.type
			)
		);
	}
	
	// 请求数据
	Future<void> _initData() async {
		var response = await DrugLibRequest.getDrugClassList('2');
		if (response != null) {
			// 请求成功
			setState(() {
				dataSource = response;
				type = EmptyWidgetType.None;
			});
		} else {
			// 请求失败
			setState(() {
				type = EmptyWidgetType.NetError;
			});
		}
	}
	
	void _getDrugConfig() {
		DrugConfigRequest.drugConfigReq().then((response) {
			if (response != null) {
				DrugConfiguration.getInstance(response);
				setState(() {
					this.configModel = response;
					print('aaa === ${this.configModel.hotSpecialItems[0].toJson()}');
				});
			}
		});
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
	
	// 左侧主分类列表
	_leftList() {
		if (dataSource == null) return null;
		return ListView.separated(
			itemBuilder: (context, index) {
				return _getLeftItem(dataSource[index], index);
			},
			itemCount: dataSource.length,
			separatorBuilder: (BuildContext context, int index) {
				return Divider(color: Color(0xffe5e5e5), height: 0.5);
			}
		);
	}
	
	// 主分类列表item
	_getLeftItem(DrugClassModel model, int index) {
		return GestureDetector(
			onTap: () {
				setState(() {
					_curIndex = index;
				});
			},
			child: Container(
				padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
				color: index == _curIndex ? Color(0xfff4f6f9) : Colors.white,
				child: Text(
					model?.categoryName ?? '',
					style: TextStyle(
						color: index == _curIndex ? Color(0xff6bcbd6) : Color(0xff0a1314),
						fontSize: 14
					),
					textAlign: TextAlign.center,
					maxLines: 2,
				)
			),
		);
	}
	
	// 右侧主分类下细分类列表
	_rightList() {
		if (dataSource == null) return null;
		List<DrugClassModel> data = dataSource[_curIndex].categories;
		return ListView.separated(
			itemBuilder: (context, index) {
				if (_curIndex == 0 && index == 0) {
					return _getRightFirstItem('名医推荐');
				}
				return _getRightItem(data[index]);
			},
			itemCount: _curIndex == 0 ? 1 : data.length,
			separatorBuilder: (BuildContext context, int index) {
				List cateList = data[index].categories;
				if (cateList.length == 0) {
					return Divider(color: Color(0xffe5e5e5), height: 0.5);
				}
				return Padding(padding: EdgeInsets.only());
			}
		);
	}
	
	// 名义推荐
	_getRightFirstItem(String itemName) {
		return GestureDetector(
			child: UnconstrainedBox(
				alignment: Alignment.centerLeft,
				child: Container(
					padding: EdgeInsets.only(left: 5),
					width: 120,
					child: Column(
						children: <Widget>[
							Padding(padding: EdgeInsets.only(top: 20)),
							Image.asset(
								'lib/Images/img_pharmacy_mytj.png',
								width: 110
							),
							Padding(padding: EdgeInsets.only(top: 10)),
							Text(
								itemName,
								textAlign: TextAlign.center,
								style: TextStyle(fontSize: 14, color: Colors.black54)
							)
						],
					)
				)
			),
			
			onTap: () => _gotoProductList(null),
		);
	}
	
	// 细分类item
	_getRightItem(DrugClassModel model) {
		return Column(
			children: <Widget>[
				GestureDetector(
					child: Container(
						padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
						child: Row(
							children: <Widget>[
								Expanded(child: Text(
									model?.categoryName ?? '',
									style: TextStyle(fontSize: 14, color: Colors.black54)
								)),
								Icon(Icons.navigate_next, size: 18)
							],
						),
					),
					
					onTap: () => _gotoProductList(model),
				),
				
				model.categories.length == 0 ? Padding(padding: EdgeInsets.only()) :
				Container(
					margin: EdgeInsets.only(right: 10),
					padding: EdgeInsets.all(15),
					decoration: BoxDecoration(
						color: Colors.white,
						borderRadius: BorderRadius.all(Radius.circular(5))
					),
					child: Wrap(
						runSpacing: 15,
						spacing: 10,
						children: model.categories.map((e) {
							return GestureDetector(
								child: Container(
									color: Color(0xfff4f6f9),
									height: 70,
									padding: EdgeInsets.symmetric(horizontal: 5),
									width: (MediaQuery.of(context).size.width - 178) * 0.5,
									alignment: Alignment.center,
									child: Text(
										e?.categoryName ?? '',
										textAlign: TextAlign.center
									),
								),
								
								onTap: () => _gotoProductList(e),
							);
						}).toList(),
					),
				)
			],
		);
	}
	
	// 跳转到药品列表页
	_gotoProductList(DrugClassModel model) {
		Navigator.of(context).push(MaterialPageRoute(builder: (_) => DrugListPage(model, this.configModel)));
	}

	@override
	bool get wantKeepAlive => true;
}