import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Home/Model/DoctorInfoOfHospitalModel.dart';
import 'package:flutter_jkxing/Home/Pages/DoctorStatisticPage.dart';
import 'package:flutter_jkxing/Mine/Network/MineRequest.dart';
import 'package:flutter_jkxing/Utils/HttpUtil.dart';

// 我的->药品明细->药品分布
class AgentProStatisticPage extends StatefulWidget {
	final int monthTime;
	final int productId;
	AgentProStatisticPage(this.monthTime, this.productId);
	@override
	State<StatefulWidget> createState() {
		return _AgentProStatisticState();
	}
}

class _AgentProStatisticState extends State<AgentProStatisticPage> {
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	List <DoctorInfoOfHospitalModel> dataSource = [];
	int currentPage = 1;
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData(ToastType.ToastTypeNone);
		});
	}
	
	Future<void> _initData(ToastType toastType) async {
		var response = await MineRequest.getAgentSaleProDistributed(
			widget.monthTime,
			widget.productId,
			this.currentPage,
			context,
			toastType
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
			if (respArr.length < 20) {
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
				'药品分布',
				context: context
			),
			body: RefreshListView(
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
					return _initData(ToastType.ToastTypeError);
				},
				onLoad: () {
					return _initData(ToastType.ToastTypeError);
				},
				type: this.type
			)
		);
	}
	
	Widget _itemBuilder(DoctorInfoOfHospitalModel model) {
		return GestureDetector(
			onTap: () {
				Navigator.of(context).push(MaterialPageRoute(
					builder: (_) => DoctorStatisticPage(model)
				));
			},
			child: Container(
				alignment: Alignment.center,
				padding: EdgeInsets.all(15),
				decoration: BoxDecoration(
					border: Border(bottom: BorderSide(color: Color(0xffe5e5e5), width: 0.5))
				),
				child: Row(children: <Widget>[
					// 头像
					ClipRRect(
						child: FadeInImage.assetNetwork(
							placeholder: 'lib/Images/hospital_avatar_default.png',
							image: model?.headImgShowPath ?? '',
							height: 48,
							width: 48,
							fit: BoxFit.cover,
							fadeOutDuration: Duration(milliseconds: 20),
							fadeInDuration: Duration(milliseconds: 20)
						),
						borderRadius: BorderRadius.circular(24)
					),
					Padding(padding: EdgeInsets.only(right: 10)),
					Expanded(child: Column(
						children: <Widget>[
							// 医生姓名
							Text(
								model?.realName ?? '',
								style: TextStyle(fontSize: 18, color: Color(0xff0a1314), fontWeight: FontWeight.w500),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							),
							Padding(padding: EdgeInsets.only(bottom: 1)),
							// 科室和职称
							Text(
								'${model?.departmentName ?? ''}${model.departmentName != null && model.departmentName.length > 0 ? '  ' : ''}${model?.doctorTitle ?? ''}',
								style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d)),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							)
						],
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.start
					)),
					Padding(padding: EdgeInsets.only(right: 10)),
					// 状态
					Text(
						'${model?.salesVolume ?? ''}',
						style: TextStyle(fontSize: 18, color: Color(0xff3b4243))
					),
					Image.asset('lib/Images/btn_doctor_more.png', width: 24, height: 24)
				])
			)
		);
	}
}