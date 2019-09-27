import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Mine/Network/MineRequest.dart';
import 'package:flutter_jkxing/Mine/Model/MineDetailModel.dart';
import 'package:flutter_jkxing/Mine/Pages/MineSaleDetailWidget.dart';

import 'SelectDatePage.dart';

class MinePage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _MinePageState();
	}
}

class _MinePageState extends State<MinePage> {
	MineDetailModel detailModel;
	Map doctorNumMap;
	@override
	void initState() {
		super.initState();
		// 这么写原因参考 https://www.jianshu.com/p/d1c98b49ab43
		WidgetsBinding.instance.addPostFrameCallback((_) {
			// 接口请求
			_getSaleDetail();
			_getDoctorNum();
		});
	}
	
	// 获取业绩、提成等信息
	_getSaleDetail() {
		MineRequest.getAgentSalesDetail(0, 0, context).then((response) {
			setState(() {
				this.detailModel = response;
			});
		});
	}
	
	// 获取医生数量信息
	_getDoctorNum() {
		MineRequest.getDoctorNumber(0, 0 ,context: context).then((response) {
			setState(() {
				this.doctorNumMap = response;
			});
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Container(
			child: ListView.builder(
				itemCount: 8,
				itemBuilder: (context, index) => _createItem(index)
			),
			color: Color(0xfff4f6f9)
		);
	}
	
	Widget _createItem(int index) {
		PPSession session = PPSession.getInstance();
		if (index == 0) {
			// 用户信息和选择日期
			return _createHeaderInfo();
		} else if (index == 1) {
			// 提成、业绩、指标、医生数等
			return MineSaleDetailWidget(this.detailModel, this.doctorNumMap);
		} else if (index == 2) {
			// 二级（全职和兼职）都不展示
			if (session?.userModel?.agentLevel == 2) {
				return null;
			}
			return _createCommonItem('团队业绩', index, teamM: this?.detailModel?.teamSaleMoney?.toString(), showTopBorder: true);
		} else if (index == 3) {
			// 兼职（一级和二级）都不展示
			if (session?.userModel?.agentType == 2) {
				return null;
			}
			return _createCommonItem('药品明细', index);
		} else if (index == 4) {
			return _createCommonItem('医生报表', index);
		} else if (index == 5) {
			return _createCommonItem('上传执业证，可提现', index);
		} else if (index == 6) {
			return _createCommonItem('医生在线情况', index);
		} else {
			return _createCommonItem('设置', index, showTopBorder: true);
		}
	}
	
	// 头部信息和选择日期
	Widget _createHeaderInfo() {
		return Column(
			children: <Widget>[
				Container(
					width: double.maxFinite,
					alignment: Alignment.topLeft,
					child: Column(children: <Widget>[
						Text(
							PPSession.getInstance()?.userModel?.realName == null ? '' : PPSession.getInstance().userModel.realName,
							style: TextStyle(
								color: Color(0xff0a1314),
								fontSize: 18,
								height: 1
							),
						),
						Padding(padding: EdgeInsets.only(top: 5)),
						Text(
							'医疗经纪人-北京',
							style: TextStyle(
								color: Color(0xff3b4243),
								fontSize: 14,
								height: 1
							)
						)
					], crossAxisAlignment: CrossAxisAlignment.start),
					height: 76,
					color: Colors.white,
					padding: EdgeInsets.fromLTRB(15, 15, 15, 0)
				),
				Container(
					color: Color(0xfff4f6f9),
					height: 44,
					padding: EdgeInsets.only(left: 15),
					child: GestureDetector(
						onTap: () {
							Navigator.of(context).push(MaterialPageRoute(builder: (_) => SelectDatePage('本月', 0, 0)));
						},
						child: Row(children: <Widget>[
							Text('本月', style: TextStyle(
								fontSize: 14,
								color: Color(0xff6c7172)
							)),
							Padding(padding: EdgeInsets.only(right: 4)),
							Image.asset('lib/Images/date_icon_dropdown.png', width: 16, height: 16)
						])
					)
				)
			]
		);
	}
	
	Widget _createCommonItem(String titleStr, int index, {String teamM:'', bool showTopBorder: false}) {
		return GestureDetector(
			onTap: () => _tapItem(index),
			child: Container(
				height: showTopBorder ? 54 : 45,
				decoration: BoxDecoration(
					color: Colors.white,
					border: Border(
						top: BorderSide(
							color: Color(0xfff4f6f9),
							width: showTopBorder ? 10 : 0.5
						)
					)
				),
				padding: EdgeInsets.symmetric(horizontal: 15),
				child: Row(children: <Widget>[
					Expanded(child: Text(
						titleStr,
						style: TextStyle(
							fontSize: 16,
							color: Color(0xff4d4d4d)
						)
					)),
					Offstage(
						offstage: teamM == null,
						child: Text(
							teamM == null ? '' : teamM,
							style: TextStyle(
								fontSize: 16,
								color: Color(0xffe75d5b)
							),
						)
					),
					Image.asset('lib/Images/home_btn_more.png', width: 18, height: 18)
				])
			)
		);
	}
	
	_tapItem(int index) {
		if (index == 2) {
			// 团队业绩
			
		} else if (index == 3) {
			// 药品明细
		} else if (index == 4) {
			// 医生报表
		} else if (index == 5) {
			// 上传执业证，可提现
		} else if (index == 6) {
			// 医生在线情况
		} else if (index == 7) {
			// 设置
			Navigator.pushNamed(context, 'my_setting_page');
		}
	}
}